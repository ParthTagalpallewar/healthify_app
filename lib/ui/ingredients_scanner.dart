import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../services/api_service.dart';
import 'ingredients_summrizer.dart';

class IngredientScannerScreen extends StatefulWidget {
  @override
  _IngredientScannerScreenState createState() =>
      _IngredientScannerScreenState();
}

class _IngredientScannerScreenState extends State<IngredientScannerScreen> {
  final ApiService _apiService = ApiService();
  File? _selectedImage;
  List<String> extractedText = [];
  List<TextEditingController> _controllers = [];
  List<FocusNode> _focusNodes = [];

  @override
  void initState() {
    super.initState();
  }

  /// Initialize controllers and focus nodes
  void _initializeControllers() {
    _controllers =
        extractedText.map((text) => TextEditingController(text: text)).toList();
    _focusNodes = List.generate(extractedText.length, (_) => FocusNode());
  }

  /// Updates controllers when the list changes
  void _updateControllers() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    _initializeControllers();
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  /// Picks an image from the gallery
  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
        extractedText = [];
      });

      _extractText();
    }
  }

  /// Calls OCR API
  Future<void> _extractText() async {
    if (_selectedImage == null) return;

    List<String>? text = await _apiService.extractTextFromImage(_selectedImage!);
    List<String> processedText = text != null
        ? text.expand((element) => element.split(',')).map((e) => e.trim()).toList()
        : [];

    if (processedText.isNotEmpty) {
      setState(() {
        extractedText = processedText;
        print("Extracted text $extractedText");
      });
      _updateControllers();
    } else {
      print("fail to extrack text");
      setState(() {
        extractedText = ["Failed to extract text"];
      });
    }
  }

  /// Removes an item and ensures focus remains on a valid field
  void _removeItem(int index) {
    if (_focusNodes.isNotEmpty && index < _focusNodes.length) {
      _focusNodes[index].unfocus(); // Remove focus from the deleted field
    }

    setState(() {
      extractedText.removeAt(index);
      _controllers[index].dispose();
      _focusNodes[index].dispose();
      _controllers.removeAt(index);
      _focusNodes.removeAt(index);
    });

    // If possible, refocus on the previous field
    if (_focusNodes.isNotEmpty && index > 0) {
      FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ingredient Scanner"),
        backgroundColor: Colors.green,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 220,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.green.shade50,
              ),
              child: _selectedImage != null
                  ? ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.file(_selectedImage!, fit: BoxFit.cover),
              )
                  : const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.image_outlined, size: 80, color: Colors.green),
                  SizedBox(height: 10),
                  Text(
                    "No image selected",
                    style: TextStyle(color: Colors.black54),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _pickImage,
              icon: const Icon(Icons.image, color: Colors.white),
              label: const Text("Pick an Image", style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: extractedText.isNotEmpty
                  ? Card(
                color: Colors.green.shade50,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          key: ValueKey(extractedText.length),
                          itemCount: extractedText.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 3),
                              child: Row(
                                key: ValueKey(extractedText[index]),
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      controller: _controllers[index],
                                      focusNode: _focusNodes[index],
                                      onChanged: (value) {
                                        extractedText[index] = value; // Update text directly
                                      },
                                      style: const TextStyle(fontSize: 14),
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        contentPadding: const EdgeInsets.symmetric(
                                            vertical: 3, horizontal: 6),
                                        filled: true,
                                        fillColor: Colors.white,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.close, color: Colors.red, size: 25),
                                    onPressed: () => _removeItem(index),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton.icon(
                        onPressed: () {

                            List<String> ingredients =
                            _controllers.map((controller) => controller.text).toList();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => IngredientsSummarizerScreen(ingredients: ingredients),
                              ),
                            );

                        },
                        icon: const Icon(Icons.summarize, color: Colors.white, size: 18),
                        label: const Text("Summarize", style: TextStyle(color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              )
                  : const Center(
                child: Text(
                  "Extracted text will appear here",
                  style: TextStyle(color: Colors.black54, fontSize: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
