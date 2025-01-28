class Nutrition {
  final String vegetable;
  final double calories; // per 100g
  final double protein; // per 100g
  final double carbs; // per 100g
  final double fat; // per 100g

  Nutrition({
    required this.vegetable,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
  });

  Map<String, double> calculateNutrition(double weight) {
    return {
      'calories': (calories * weight) / 100,
      'protein': (protein * weight) / 100,
      'carbs': (carbs * weight) / 100,
      'fat': (fat * weight) / 100,
    };
  }
}

final List<Nutrition> nutritionFacts = [
  Nutrition(vegetable: 'broccoli', calories: 34, protein: 2.8, carbs: 6.6, fat: 0.4),
  Nutrition(vegetable: 'cauliflower', calories: 25, protein: 1.9, carbs: 4.97, fat: 0.3),
  Nutrition(vegetable: 'cabbage', calories: 25, protein: 1.3, carbs: 5.8, fat: 0.1),
  Nutrition(vegetable: 'napa cabbage', calories: 13, protein: 1.0, carbs: 2.2, fat: 0.2),
  Nutrition(vegetable: 'capsicum', calories: 20, protein: 0.9, carbs: 4.7, fat: 0.2),
];
