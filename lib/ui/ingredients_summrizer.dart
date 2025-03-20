import 'package:flutter/material.dart';
import '../services/api_service.dart';

class IngredientsSummarizerScreen extends StatefulWidget {
  final List<String> ingredients;

  IngredientsSummarizerScreen({required this.ingredients});

  @override
  _IngredientsSummarizerScreenState createState() =>
      _IngredientsSummarizerScreenState();
}

class _IngredientsSummarizerScreenState extends State<IngredientsSummarizerScreen> {
  final ApiService _apiService = ApiService();
  String _summary = "Loading...";
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchSummaryInBatches();
  }

  /// Splits ingredients list into batches of size `batchSize`
  List<List<String>> _splitIntoBatches(List<String> ingredients, int batchSize) {
    List<List<String>> batches = [];
    for (int i = 0; i < ingredients.length; i += batchSize) {
      batches.add(ingredients.sublist(i,
          (i + batchSize) > ingredients.length ? ingredients.length : i + batchSize));
    }
    return batches;
  }

  /// Sends batched API requests and combines all results
  Future<void> _fetchSummaryInBatches() async {
    List<List<String>> batches = _splitIntoBatches(widget.ingredients, 4);
    List<Future<String?>> requests = [];

    for (var batch in batches) {
      requests.add(_apiService.getIngredientSummary(batch));
    }

    List<String?> responses = await Future.wait(requests);
    setState(() {
      _summary = responses.where((r) => r != null).join("\n\n"); // Merging all responses
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ingredient Summary"),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
          child: Text(
            _summary,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}
