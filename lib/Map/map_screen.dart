import 'package:explore_pc/models/mycolors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:explore_pc/models/mycolors.dart';

class ProfessionalLocationPicker extends StatefulWidget {
  final Function(LatLng)? onLocationSaved;

  const ProfessionalLocationPicker({super.key, this.onLocationSaved});

  @override
  State<ProfessionalLocationPicker> createState() =>
      _ProfessionalLocationPickerState();
}

class _ProfessionalLocationPickerState
    extends State<ProfessionalLocationPicker> {
  late final MapController _mapController;
  LatLng _currentCenter = const LatLng(15.3694, 44.1910); // صنعاء، شارع صخر
  double _currentZoom = 15.0;
  LatLng? _selectedLocation;
  bool _isLocating = false;
  bool _showCoordinates = true;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _loadLastLocation();
  }

  Future<void> _loadLastLocation() async {
    final prefs = await SharedPreferences.getInstance();
    final lat = prefs.getDouble('last_lat');
    final lng = prefs.getDouble('last_lng');

    if (lat != null && lng != null) {
      setState(() {
        _selectedLocation = LatLng(lat, lng);
        _currentCenter = _selectedLocation!;
      });
      _mapController.move(_currentCenter, _currentZoom);
    }
  }

  Future<void> _determinePosition() async {
    setState(() => _isLocating = true);

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _showMessage('الرجاء تفعيل خدمة الموقع');
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _showMessage('تم رفض صلاحيات الموقع');
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _showMessage('صلاحيات الموقع مرفوضة بشكل دائم');
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );

      setState(() {
        _selectedLocation = LatLng(position.latitude, position.longitude);
        _currentCenter = _selectedLocation!;
        _mapController.move(_currentCenter, 16);
      });

      _showMessage('تم تحديد موقعك بنجاح', isSuccess: true);
    } catch (e) {
      _showMessage('فشل في تحديد الموقع: ${e.toString()}');
    } finally {
      setState(() => _isLocating = false);
    }
  }

  void _handleMapTap(TapPosition tapPosition, LatLng latLng) {
    setState(() => _selectedLocation = latLng);
  }

  Future<void> _saveLocation() async {
    if (_selectedLocation == null) {
      _showMessage('الرجاء تحديد موقع أولاً');
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('last_lat', _selectedLocation!.latitude);
    await prefs.setDouble('last_lng', _selectedLocation!.longitude);

    if (widget.onLocationSaved != null) {
      widget.onLocationSaved!(_selectedLocation!);
    }

    _showMessage('تم حفظ الموقع بنجاح', isSuccess: true);
    Navigator.pop(context, _selectedLocation);
  }

  void _showMessage(String message, {bool isSuccess = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isSuccess ? Colors.green : null,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Mycolors().myColorbackgrond,
        title: const Text('تحديد الموقع'),
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location),
            onPressed: _determinePosition,
            tooltip: 'تحديد موقعي الحالي',
          ),
          IconButton(
            icon: Icon(
                _showCoordinates ? Icons.visibility_off : Icons.visibility),
            onPressed: () =>
                setState(() => _showCoordinates = !_showCoordinates),
            tooltip: 'إظهار/إخفاء الإحداثيات',
          ),
        ],
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              center: _currentCenter,
              zoom: _currentZoom,
              onTap: _handleMapTap,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.pro_map',
              ),
              if (_selectedLocation != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: _selectedLocation!,
                      width: 50,
                      height: 50,
                      builder: (ctx) => const Icon(
                        Icons.location_pin,
                        color: Color.fromARGB(255, 0, 255, 115),
                        size: 50,
                      ),
                    ),
                  ],
                ),
            ],
          ),
          if (_isLocating)
            Center(
              child: SpinKitSquareCircle(size: 50.0, color: Mycolors().myColor),
            ),
          if (_showCoordinates)
            Positioned(
              bottom: 20,
              left: 20,
              child: Card(
                color: Colors.white.withOpacity(0.9),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'الإحداثيات الحالية:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        _selectedLocation != null
                            ? '${_selectedLocation!.latitude.toStringAsFixed(6)}\n'
                                '${_selectedLocation!.longitude.toStringAsFixed(6)}'
                            : 'لم يتم التحديد',
                      ),
                    ],
                  ),
                ),
              ),
            ),
          Positioned(
            right: 20,
            bottom: 20,
            child: Column(
              children: [
                FloatingActionButton(
                  backgroundColor: Mycolors().myColor,
                  heroTag: 'zoomIn',
                  mini: true,
                  onPressed: () => _mapController.move(
                    _mapController.center,
                    _mapController.zoom + 1,
                  ),
                  child: const Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                FloatingActionButton(
                  heroTag: 'zoomOut',
                  mini: true,
                  onPressed: () => _mapController.move(
                    _mapController.center,
                    _mapController.zoom - 1,
                  ),
                  child: const Icon(Icons.remove),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Mycolors().myColor,
        onPressed: _saveLocation,
        icon: const Icon(
          Icons.save,
          color: Colors.white,
        ),
        label: const Text(
          'حفظ الموقع',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }
}
