import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import 'package:products_app/models/models.dart';

class ProductsServices extends ChangeNotifier {
  final String _baseUrl = '';
  final List<Product> products = [];
  late Product selectedProduct;
  bool isLoading = true;
  bool isSaving = false;
  File? newPictureFile;

  // Create storage
  final storage = const FlutterSecureStorage();

  ProductsServices() {
    loadProducts();
  }

  Future<List<Product>> loadProducts() async {
    isLoading = true;
    notifyListeners();
    final url = Uri.https(
      _baseUrl,
      'products.json',
      {'auth': await storage.read(key: 'token') ?? ''},
    );
    final response = await http.get(url);
    final Map<String, dynamic> productsMap = json.decode(response.body);
    productsMap.forEach((key, value) {
      final tempProduct = Product.fromJson(value);
      tempProduct.id = key;
      products.add(tempProduct);
    });
    isLoading = false;
    notifyListeners();
    return products;
  }

  Future saveOrCreateProduct(Product product) async {
    isSaving = true;
    notifyListeners();

    if (product.id == null) {
      //Create
      await createProduct(product);
    } else {
      // Update
      await updateProduct(product);
    }

    isSaving = false;
    notifyListeners();
  }

  Future<String> updateProduct(Product product) async {
    final url = Uri.https(
      _baseUrl,
      'products/${product.id}.json',
      {'auth': await storage.read(key: 'token') ?? ''},
    );
    final _ = await http.put(url, body: product.toRawJson());

    final index = products.indexWhere((element) => element.id == product.id);
    products[index] = product;

    return product.id ?? '';
  }

  Future<String> createProduct(Product product) async {
    final url = Uri.https(
      _baseUrl,
      'products.json',
      {'auth': await storage.read(key: 'token') ?? ''},
    );
    final response = await http.post(url, body: product.toRawJson());
    final decodedData = json.decode(response.body);
    product.id = decodedData['name'];
    products.add(product);

    return product.id ?? '';
  }

  void updateSelectedProductImage(String imagePath) {
    selectedProduct.image = imagePath;
    newPictureFile = File.fromUri(Uri(path: imagePath));
    notifyListeners();
  }

  Future<String?> uploadImage() async {
    if (newPictureFile == null) return null;
    isSaving = true;
    notifyListeners();
    final url = Uri.parse('');
    final imageUploadRequest = http.MultipartRequest('POST', url);
    final file =
        await http.MultipartFile.fromPath('file', newPictureFile!.path);

    imageUploadRequest.files.add(file);
    final streamResponse = await imageUploadRequest.send();
    final response = await http.Response.fromStream(streamResponse);
    if (response.statusCode != 200 && response.statusCode != 201) {
      return null;
    }
    newPictureFile = null;
    final decodedData = json.decode(response.body);
    return decodedData['secure_url'];
  }
}
