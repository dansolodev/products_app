import 'package:flutter/material.dart';
import 'package:products_app/models/models.dart';

class ProductsServices extends ChangeNotifier {
  final String _baseUrl = '';
  final List<Product> products = [];
}
