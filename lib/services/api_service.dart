import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import '../models/recpie.dart';

class ApiService {
  final String baseUrl = "http://192.168.111.44:8000"; // Change if deployed

  Future<List<Recipe>> predictDiet({
    required List<int> nutritionInput,
    required List<String> ingredients,
  }) async {
    final url = Uri.parse('$baseUrl/diet/predict/');
    final headers = {"Content-Type": "application/json"};

    final body = jsonEncode({
      "nutrition_input": nutritionInput,
      "ingredients": ingredients,
      "params": {"n_neighbors": 5, "return_distance": false}
    });

    try {
      final response = await http.post(url, headers: headers, body: body);
      print(jsonDecode(response.body).toString());
      if (response.statusCode == 200) {
        final decodedJson = jsonDecode(response.body);

        if (decodedJson["output"] != null && decodedJson["output"] is List) {
          return (decodedJson["output"] as List)
              .map((recipeJson) => Recipe.fromJson(recipeJson))
              .toList();
        } else {
          print("Error: Invalid response format");
          return [];
        }
      } else {
        print("Error: Failed to fetch data. Status: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("Exception: ${e.toString()}");
      return [];
    }
  }



  /// Uploads image & extracts text
  Future<List<String>?> extractTextFromImage(File imageFile) async {
    final url = Uri.parse('$baseUrl/ocr/extract-text/');
    final request = http.MultipartRequest("POST", url);
    request.files.add(await http.MultipartFile.fromPath('image', imageFile.path));
    print('making Api call ----------------------');
    try {
      final response = await request.send();

      print("Got response extracktextImage ${response.statusCode}");

      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        final decodedData = jsonDecode(responseData);
        print("output:");
        print(decodedData['text']);
        return List<String>.from(decodedData['text']);

      } else {
        return null;
      }
    } catch (e) {
      print("Error: $e");
      return null;
    }
  }

  /// Sends ingredients & gets summarized facts
  Future<String?> getIngredientSummary(List<String> ingredients) async {
    final url = Uri.parse('$baseUrl/ingredients_summary/summarize/');
    final headers = {"Content-Type": "application/json"};
    final body = jsonEncode({"ingredients": ingredients});

    print("make api call ---- getIngredintsSummery");

    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        final decodedData = jsonDecode(response.body);
        return decodedData['facts'];
      } else {
        return "Error: Failed to fetch summary.";
      }
    } catch (e) {
      print("Error: $e");
      return "Error: $e";
    }
  }

}
