import 'dart:convert';
import 'package:assessment_app/constants/constants.dart';
import 'package:assessment_app/models/category_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CategoryProvider with ChangeNotifier {
  List<CategoryModel> _categoryList = [];

  // Getter for the list of categories
  List<CategoryModel> get categoryList {
    return [..._categoryList];
  }

  // Constructor for initializing the provider with a list of categories
  CategoryProvider(
    this._categoryList,
  );

  // Function to fetch categories from the API
  Future<void> getCategories() async {
    final prefs = await SharedPreferences.getInstance();
    final savedCategories =
        prefs.getString('categories'); // Try to get saved categories
    final savedTimestamp =
        prefs.getInt('categoriesTimestamp'); // Get the saved timestamp

    // Check if categories exist in SharedPreferences and if the data is within 24 hours
    if (savedCategories != null && savedTimestamp != null) {
      final currentTimestamp = DateTime.now().millisecondsSinceEpoch;
      final duration = currentTimestamp - savedTimestamp;

      // If data is less than 24 hours old, use saved data
      if (duration < 24 * 60 * 60 * 1000) {
        List jsonResponse = json.decode(savedCategories);
        List<CategoryModel> dataList = jsonResponse
            .map((data) => CategoryModel.fromJson(data))
            .toList(); // Parse JSON data into list of CategoryModel
        _categoryList = dataList;
        notifyListeners();
        return;
      } else {
        // If data is older than 24 hours, erase the saved data
        prefs.remove('categories');
        prefs.remove('categoriesTimestamp');
      }
    }

    // Fetch data from the API if no valid cached data exists or if it's outdated
    final url = Uri.parse('$baseUrl/categories'); // Construct the API URL
    try {
      final response = await http.get(url); // Send GET request to the server
      if (response.statusCode == 200) {
        // Check if the response is successful
        List jsonResponse = json.decode(response.body);
        List<CategoryModel> dataList = jsonResponse
            .map((data) => CategoryModel.fromJson(data))
            .toList(); // Parse JSON data into list of CategoryModel
        _categoryList = dataList;

        // Save the fetched categories and timestamp to SharedPreferences for offline use
        final categoryJson =
            json.encode(_categoryList.map((e) => e.toJson()).toList());
        await prefs.setString('categories', categoryJson);
        await prefs.setInt(
            'categoriesTimestamp', DateTime.now().millisecondsSinceEpoch);

        notifyListeners(); // Notify listeners of data changes
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (error) {
      rethrow; // Re-throw the error to be handled by the calling function
    }
  }
}
