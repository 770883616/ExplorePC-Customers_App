import 'package:explore_pc/constant/linkapi.dart';
import 'package:explore_pc/models/computer.dart';
import 'package:explore_pc/models/mycolors.dart';
import 'package:explore_pc/widgets/screenprodect.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:like_button/like_button.dart';
import 'package:flutter/material.dart';

class MyCustomSearch extends SearchDelegate<Computer?> {
  final List<Computer> allComputers;
  final List<Computer> likedComputers;

  MyCustomSearch({
    required this.allComputers,
    required this.likedComputers,
    required InputDecoration searchFieldDecoration,
  });

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear, color: Mycolors().myColor),
        onPressed: () {
          query = '';
          showSuggestions(context);
        },
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back, color: Mycolors().myColor),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults();
  }

  Widget _buildSearchResults() {
    final results = _getFilteredResults();

    if (results.isEmpty) {
      return _buildEmptyState(query.isEmpty
          ? 'ابدأ بكتابة اسم المنتج للبحث'
          : 'لا توجد نتائج لـ "$query"');
    }

    return _buildProductsGrid(results);
  }

  List<Computer> _getFilteredResults() {
    if (query.isEmpty) return [];

    final queryLower = query.toLowerCase();
    return allComputers.where((computer) {
      return computer.name.toLowerCase().contains(queryLower) ||
          computer.category.toLowerCase().contains(queryLower);
    }).toList();
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search, size: 60, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontFamily: 'Tajawal',
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildProductsGrid(List<Computer> products) {
    // حساب ارتفاع ثابت لكل عنصر بناءً على الشاشة
    // final itemHeight = MediaQuery.of().size.height / 2.5;

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8, // تعديل النسبة لتحسين الشكل
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final computer = products[index];
        final isLiked =
            likedComputers.any((item) => item.productId == computer.productId);
        void Function()? pree = () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ScreenProduct(
                computerindex: index,
                computer: computer,
              ),
            ),
          );
        };

        return _buildProductCard(computer, isLiked, pree);
      },
    );
  }

  Widget _buildProductCard(
      Computer computer, bool isLiked, void Function()? pree) {
    return InkWell(
      onTap: pree,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // صورة المنتج
            Expanded(
              flex: 3,
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(12)),
                child: _buildProductImage(computer.image),
              ),
            ),

            // تفاصيل المنتج
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      computer.name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      computer.category,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${computer.price.toStringAsFixed(2)} \$',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                        // LikeButton(
                        //   size: 20,
                        //   isLiked: isLiked,
                        //   onTap: (isLiked) async => !isLiked,
                        // ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductImage(String? imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty) {
      return Container(
        color: Colors.grey[200],
        child: const Center(child: Icon(Icons.computer)),
      );
    }

    return Image.network(
      '$LinkServerName/storage/$imageUrl',
      // fit: BoxFit.cover,
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return Center(
            child: CircularProgressIndicator(
          value: progress.expectedTotalBytes != null
              ? progress.cumulativeBytesLoaded / progress.expectedTotalBytes!
              : null,
        ));
      },
      errorBuilder: (_, __, ___) => Container(
        color: Colors.grey[200],
        child: const Icon(Icons.broken_image),
      ),
    );
  }
}
