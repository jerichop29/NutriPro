
class DistanceEstimator {
  final Map<String, double> realWidths; // Real-world widths of vegetables in meters.
  final Map<String, double> realDistances; // Real-world distances in meters.
  final double fixedFocalLength; // Fixed focal length in pixels.

  // Constructor now includes fixed focal length.
  DistanceEstimator({
    required this.realWidths,
    required this.realDistances,
    required this.fixedFocalLength,
  });

  // Function to estimate the distance to the detected vegetable using the fixed focal length.
  Future<double> estimateDistance(String vegetableLabel, double widthInPixels) async {
    // Extract the vegetable type from the label (ignoring the quality).
    String vegetableType = vegetableLabel;

    // Get the real-world object width for the vegetable type.
    double realObjectWidth = realWidths[vegetableType.toLowerCase()] ?? 0.2;

    // Estimate and return the distance to the object using the fixed focal length and width in pixels.
    return (realObjectWidth * fixedFocalLength) / widthInPixels;
  }
}
