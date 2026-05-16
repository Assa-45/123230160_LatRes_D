import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product_model.dart';

class ApiService {
  static const String _baseUrl = 'https://dummyjson.com';

  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  Future<List<Product>> fetchProducts({int limit = 100}) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/products?limit=$limit'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['products'] as List)
          .map((p) => Product.fromJson(p))
          .toList();
    } else {
      throw Exception('Gagal memuat produk. Status: ${response.statusCode}');
    }
  }

  Future<Product> fetchProductById(int id) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/products/$id'),
    );

    if (response.statusCode == 200) {
      return Product.fromJson(json.decode(response.body));
    } else {
      throw Exception('Produk tidak ditemukan. Status: ${response.statusCode}');
    }
  }

  Future<List<Product>> fetchProductsByCategory(String category) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/products/category/$category'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['products'] as List)
          .map((p) => Product.fromJson(p))
          .toList();
    } else {
      throw Exception('Gagal memuat kategori. Status: ${response.statusCode}');
    }
  }

  // ─── FETCH CATEGORIES 
  Future<List<String>> fetchCategories() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/products/categories'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as List;
      return data.map((e) => e.toString()).toList();
    } else {
      throw Exception('Gagal memuat kategori. Status: ${response.statusCode}');
    }
  }
}