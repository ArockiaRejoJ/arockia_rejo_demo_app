import 'dart:convert';
import 'package:assessment_app/constants/constants.dart';
import 'package:assessment_app/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProductsProvider with ChangeNotifier {
  List<ProductModel> _productsList = [];

  // Getter for products list
  List<ProductModel> get productsList {
    return [..._productsList];
  }

  // Constructor to initialize the products list
  ProductsProvider(
      this._productsList,
      );

  // Function to fetch products from the API
  Future<void> getProducts() async {
    final prefs = await SharedPreferences.getInstance();
    final savedProducts = prefs.getString('products'); // Try to get saved products
    final savedTimestamp = prefs.getInt('productsTimestamp'); // Get the saved timestamp

    // Check if products exist in SharedPreferences and if the data is within 24 hours
    if (savedProducts != null && savedTimestamp != null) {
      final currentTimestamp = DateTime.now().millisecondsSinceEpoch;
      final duration = currentTimestamp - savedTimestamp;

      // If data is less than 24 hours old, use saved data
      if (duration < 24 * 60 * 60 * 1000) {
        List jsonResponse = json.decode(savedProducts);
        List<ProductModel> dataList = jsonResponse
            .map((data) => ProductModel.fromJson(data))
            .toList(); // Parse JSON data into list of ProductModel
        _productsList = dataList;
        notifyListeners();
        return;
      } else {
        // If data is older than 24 hours, erase the saved data
        prefs.remove('products');
        prefs.remove('productsTimestamp');
      }
    }

    // Fetch data from the API if no valid cached data exists or if it's outdated
    final url = Uri.parse('$baseUrl/products'); // Construct the API URL
    try {
      final response = await http.get(url); // Send GET request to the server
      if (response.statusCode == 200) {
        // Check if the response is successful
        List jsonResponse = json.decode(response.body);
        List<ProductModel> dataList = jsonResponse
            .map((data) => ProductModel.fromJson(data))
            .toList(); // Parse JSON data into list of ProductModel
        _productsList = dataList;

        // Save the fetched products and timestamp to SharedPreferences for offline use
        final productJson = json.encode(_productsList.map((e) => e.toJson()).toList());
        await prefs.setString('products', productJson);
        await prefs.setInt('productsTimestamp', DateTime.now().millisecondsSinceEpoch);

        notifyListeners(); // Notify listeners of data changes
      } else {
        throw Exception('Failed to load products');
      }
    } catch (error) {
      rethrow; // Re-throw the error to be handled by the calling function
    }
  }
}
