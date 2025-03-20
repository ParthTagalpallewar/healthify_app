class Recipe {
  final int recipeId;
  final String name;
  final int cookTime;
  final int prepTime;
  final int totalTime;
  final List<String> ingredients;
  final double calories;
  final double fatContent;
  final double saturatedFatContent;
  final double cholesterolContent;
  final double sodiumContent;
  final double carbohydrateContent;
  final double fiberContent;
  final double sugarContent;
  final double proteinContent;
  final List<String> instructions;

  Recipe({
    required this.recipeId,
    required this.name,
    required this.cookTime,
    required this.prepTime,
    required this.totalTime,
    required this.ingredients,
    required this.calories,
    required this.fatContent,
    required this.saturatedFatContent,
    required this.cholesterolContent,
    required this.sodiumContent,
    required this.carbohydrateContent,
    required this.fiberContent,
    required this.sugarContent,
    required this.proteinContent,
    required this.instructions,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      recipeId: json['RecipeId'],
      name: json['Name'],
      cookTime: json['CookTime'],
      prepTime: json['PrepTime'],
      totalTime: json['TotalTime'],
      ingredients: List<String>.from(json['RecipeIngredientParts']),
      calories: json['Calories'].toDouble(),
      fatContent: json['FatContent'].toDouble(),
      saturatedFatContent: json['SaturatedFatContent'].toDouble(),
      cholesterolContent: json['CholesterolContent'].toDouble(),
      sodiumContent: json['SodiumContent'].toDouble(),
      carbohydrateContent: json['CarbohydrateContent'].toDouble(),
      fiberContent: json['FiberContent'].toDouble(),
      sugarContent: json['SugarContent'].toDouble(),
      proteinContent: json['ProteinContent'].toDouble(),
      instructions: List<String>.from(json['RecipeInstructions']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'RecipeId': recipeId,
      'Name': name,
      'CookTime': cookTime,
      'PrepTime': prepTime,
      'TotalTime': totalTime,
      'RecipeIngredientParts': ingredients,
      'Calories': calories,
      'FatContent': fatContent,
      'SaturatedFatContent': saturatedFatContent,
      'CholesterolContent': cholesterolContent,
      'SodiumContent': sodiumContent,
      'CarbohydrateContent': carbohydrateContent,
      'FiberContent': fiberContent,
      'SugarContent': sugarContent,
      'ProteinContent': proteinContent,
      'RecipeInstructions': instructions,
    };
  }
}
