class WeightEstimator {
  double estimateVolume(String shapeType, double width, double height) {
    // Print the shape type, width, and height
    print('Shape type used: $shapeType');
    print('Width: $width');
    print('Height: $height');

    switch (shapeType.toLowerCase()) {
      case 'circular':
        return 3.14 * (width / 2) * (width / 2) * height; // Volume for a circular shape
      case 'oblong':
        return width * height * width; // Volume for an oblong shape
      default:
        return (width * height * width) / 4; // Approximation for irregular shapes
    }
  }

  double estimateWeight(String vegetable, double volume, String qualityType) {
    // Define densities for each vegetable and quality type
    Map<String, Map<String, double>> densities = {
      'broccoli': {
        'excellent': 0.15,
        'good': 0.14,
        'fair': 0.10,
        'poor': 0.04,
        'non-edible': 0.01,
      },
      'cabbage': {
        'excellent': 0.4,
        'good': 0.35,
        'fair': 0.3,
        'poor': 0.3,
        'non-edible': 0.2,
      },
      'cauliflower': {
        'excellent': 0.25,
        'good': 0.13,
        'fair': 0.07,
        'poor': 0.06,
        'non-edible': 0.2,
      },
      'napa cabbage': {
        'excellent': 0.035,
        'good': 0.040,
        'fair': 0.035,
        'poor': 0.030,
        'non-edible': 0.15,
      },
      'capsicum': {
        'excellent': 0.30,
        'good': 0.20,
        'fair': 0.15,
        'poor': 0.12,
        'non-edible': 0.01,
      },
    };

    // Retrieve the density for the specific vegetable and quality type
    double density = densities[vegetable.toLowerCase()]?[qualityType.toLowerCase()] ?? 0.3; // Default density if not found

    // Print the vegetable, quality type, and the density used
    print('Vegetable used: $vegetable');
    print('Quality type used: $qualityType');
    print('Density used: $density');

    return volume * density;
  }
}
