import 'dart:convert';
import 'package:explore_pc/constant/linkapi.dart';
import 'package:explore_pc/models/computer.dart';
import 'package:explore_pc/models/review.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "$LinkServerName/api";

  Future<List<Computer>> getProducts({String? category}) async {
    final url = category != null
        ? Uri.parse('$baseUrl/products?category=$category')
        : Uri.parse('$baseUrl/products');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      // تحقق إذا كانت الاستجابة تحتوي على data أو message
      if (data is Map && data.containsKey('data')) {
        final List<dynamic> productsJson = data['data'];
        return productsJson.map((json) => Computer.fromJson(json)).toList();
      } else if (data is Map && data.containsKey('message')) {
        return []; // لا توجد منتجات
      } else {
        throw Exception('Invalid response format');
      }
    } else {
      throw Exception('Failed to load products');
    }
  }
}

class ReviewService {
  // static const String baseUrl = 'http://your-domain.com/api';

  static Future<List<Review>> getReviewsByProductId(int productId) async {
    final response = await http.get(
      Uri.parse('$LinkServerName/api/reviews/product/$productId'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body)['data'];
      return jsonData.map((json) => Review.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load reviews');
    }
  }

  static Future<Review> addReview({
    required int productId,
    required int userId,
    required double rating,
    required String comment,
  }) async {
    final response = await http.post(
      Uri.parse('$LinkServerName/reviews'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'productId': productId,
        'UserId': userId,
        'rating': rating,
        'comment': comment,
      }),
    );

    if (response.statusCode == 201) {
      return Review.fromJson(json.decode(response.body)['data']);
    } else {
      throw Exception('Failed to add review');
    }
  }
}
