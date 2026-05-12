// lib/models/recipe.dart
// Modelo de dados para uma Receita

class Recipe {
  final String id;
  String name;
  String category;
  String emoji;
  String time;
  int servings;
  String difficulty;
  String description;
  List<String> ingredients;
  List<String> steps;

  Recipe({
    required this.id,
    required this.name,
    required this.category,
    required this.emoji,
    required this.time,
    required this.servings,
    required this.difficulty,
    required this.description,
    required this.ingredients,
    required this.steps,
  });

  // Cria uma cópia da receita com campos atualizados
  Recipe copyWith({
    String? name,
    String? category,
    String? emoji,
    String? time,
    int? servings,
    String? difficulty,
    String? description,
    List<String>? ingredients,
    List<String>? steps,
  }) {
    return Recipe(
      id: id,
      name: name ?? this.name,
      category: category ?? this.category,
      emoji: emoji ?? this.emoji,
      time: time ?? this.time,
      servings: servings ?? this.servings,
      difficulty: difficulty ?? this.difficulty,
      description: description ?? this.description,
      ingredients: ingredients ?? this.ingredients,
      steps: steps ?? this.steps,
    );
  }
}
