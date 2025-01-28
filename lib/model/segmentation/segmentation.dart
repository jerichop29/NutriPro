class Segmentation {
  final List<double> box;        // [x1: left, y1: top, x2: right, y2: bottom, class_confidence]
  final String tag;              // Detected class
  final List<Map<String, double>> polygons;  // List of polygons, each polygon is a map with x, y coordinates
  final double confidenceInClass;  // Confidence score for the detected class

  Segmentation({
    required this.box,
    required this.tag,
    required this.polygons,
    required this.confidenceInClass,
  });

  // Factory method to create Segmentation object from a JSON map
  factory Segmentation.fromJson(Map<String, dynamic> json) {
    return Segmentation(
      box: List<double>.from(json['box']),
      tag: json['tag'] as String,
      polygons: List<Map<String, double>>.from(
        json['polygons'].map((polygon) => Map<String, double>.from(polygon)),
      ),
      confidenceInClass: json['box'].last,  // Last element in the 'box' list is class confidence
    );
  }

  // Convert Segmentation object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'box': box,
      'tag': tag,
      'polygons': polygons,
    };
  }

  // Helper methods to access specific box coordinates
  double get left => box[0];
  double get top => box[1];
  double get right => box[2];
  double get bottom => box[3];
  double get classConfidence => box[4];
}
