import 'distance_estimator.dart';

class Measurement {
  final DistanceEstimator distanceEstimator;

  Measurement({required this.distanceEstimator});

  Future<Map<String, double>> measureDimensions(
      String vegetable,
      double widthInPixels,
      double heightInPixels,
      double estimatedDistance, // Pass the dynamically estimated distance
      ) async {
    // Use the fixed focal length directly for calculation
    double focalLength = distanceEstimator.fixedFocalLength;

    // Calculate the dimensions in meters using estimated distance
    double widthInMeters = (widthInPixels * estimatedDistance) / focalLength;
    double heightInMeters = (heightInPixels * estimatedDistance) / focalLength;

    // Ensure height is always greater than width
    if (widthInMeters > heightInMeters) {
      // Swap values if width is greater than height
      double temp = widthInMeters;
      widthInMeters = heightInMeters;
      heightInMeters = temp;
    }

    // Convert both width and height to centimeters
    double widthInCm = widthInMeters * 100;
    double heightInCm = heightInMeters * 100;

    // Print the dimensions in centimeters
    print('Width in cm: $widthInCm');
    print('Height in cm: $heightInCm');

    return {
      'width': widthInCm,  // Return width in centimeters
      'height': heightInCm, // Return height in centimeters
    };
  }
}
