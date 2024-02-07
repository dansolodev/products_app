import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:products_app/models/models.dart';

class ProductsServices extends ChangeNotifier {
  final String _baseUrl = '';
  final List<Product> products = [];
  bool isLoading = true;

  ProductsServices() {
    loadProducts();
  }

  // <List<Product>>
  Future loadProducts() async {
    final url = Uri.https(_baseUrl, 'products.json');
    final response = await http.get(url);
    final Map<String, dynamic> productsMap = json.decode(response.body);
    productsMap.forEach((key, value) {
      final tempProduct = Product.fromJson(value);
      tempProduct.id = key;
      products.add(tempProduct);
    });
    print(products[0].name);
  }
}
