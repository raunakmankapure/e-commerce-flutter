import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_ecommerce/models/product.dart';

class ApiService {
  static const String baseUrl = 'https://fakestoreapi.com';

  Future<List<Product>> getProducts({int limit = 10, int offset = 0}) async {
    final response = await http.get(Uri.parse('$baseUrl/products'));
    
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data
          .skip(offset)
          .take(limit)
          .map((json) => Product.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<Product> getProduct(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/products/$id'));
    
    if (response.statusCode == 200) {
      return Product.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load product');
    }
  }

  Future<List<Product>> searchProducts(String query) async {
    final response = await http.get(Uri.parse('$baseUrl/products'));
    
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data
          .map((json) => Product.fromJson(json))
          .where((product) =>
              product.title.toLowerCase().contains(query.toLowerCase()))
          .toList();
    } else {
      throw Exception('Failed to search products');
    }
  }
}