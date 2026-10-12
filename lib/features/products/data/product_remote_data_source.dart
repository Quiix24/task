import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../../../../core/network/api_client.dart';
import 'models/product_model.dart';

class ProductRemoteDataSource {
  final ApiClient _apiClient;

  const ProductRemoteDataSource(this._apiClient);

  Future<List<ProductModel>> getProducts() async {
    final response = await _apiClient.get('/products');
    return _parseProducts(response.data);
  }

  Future<List<String>> getCategories() async {
    final response = await _apiClient.get('/products/categories');
    return List<String>.from(response.data as List);
  }

  Future<List<ProductModel>> getProductsByCategory(String name) async {
    final response = await _apiClient.get(
      '/products/category/${Uri.encodeComponent(name)}',
    );
    return _parseProducts(response.data);
  }

  Future<ProductModel> getProductById(int id) async {
    final response = await _apiClient.get('/products/$id');
    debugPrint(
      'ProductRemoteDataSource: product $id JSON: ${jsonEncode(response.data)}',
    );
    return ProductModel.fromJson(
      Map<String, dynamic>.from(response.data as Map),
    );
  }

  Future<void> addToCart(int productId) async {
    final response = await _apiClient.post(
      '/carts',
      data: {
        'userId': 1,
        'products': [
          {'productId': productId, 'quantity': 1},
        ],
      },
    );
    debugPrint(
      'ProductRemoteDataSource: cart response: ${jsonEncode(response.data)}',
    );
  }

  List<ProductModel> _parseProducts(dynamic data) {
    return (data as List)
        .map(
          (item) =>
              ProductModel.fromJson(Map<String, dynamic>.from(item as Map)),
        )
        .toList();
  }
}
