import 'package:flutter/material.dart';
import 'package:healthify_app/services/api_service.dart';


import '../models/recpie.dart';

class PredictDietScreen extends StatefulWidget {
  @override
  _PredictDietScreenState createState() => _PredictDietScreenState();
}

class _PredictDietScreenState extends State<PredictDietScreen> {
  final TextEditingController _nutritionController = TextEditingController();
  final TextEditingController _ingredientController = TextEditingController();
  List<Recipe> _recipes = [];
  bool _isLoading = false;
  final ApiService _service = ApiService();

  Future<void> _predictDiet() async {
    setState(() {
      _isLoading = true;
    });

    List<int> nutritionInput = _nutritionController.text
        .split(',')
        .map((e) => int.tryParse(e.trim()) ?? 0)
        .toList();

    List<String> ingredients = _ingredientController.text
        .split(',')
        .map((e) => e.trim())
        .toList();

    List<Recipe> recipes = await _service.predictDiet(
      nutritionInput: nutritionInput,
      ingredients: ingredients,
    );

    setState(() {
      _recipes = recipes;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Predict Diet"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nutritionController,
              decoration: InputDecoration(
                labelText: "Enter Nutrition Values (comma-separated)",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _ingredientController,
              decoration: InputDecoration(
                labelText: "Enter Ingredients (comma-separated)",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _predictDiet,
              child: Text("Predict"),
            ),
            SizedBox(height: 20),
            _isLoading
                ? CircularProgressIndicator()
                : _recipes.isEmpty
                ? Text("No results found")
                : Expanded(
              child: ListView.builder(
                itemCount: _recipes.length,
                itemBuilder: (context, index) {
                  final recipe = _recipes[index];
                  return Card(
                    child: ListTile(
                      title: Text(recipe.name),
                      subtitle: Text(
                          "Calories: ${recipe.calories.toStringAsFixed(2)}"),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
