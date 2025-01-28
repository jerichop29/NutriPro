import 'dart:ui'; // For Rect

class Recognition {
  final double confidenceInClass;
  final String detectedClass;
  final Rect rect;

  Recognition({
    required this.detectedClass,
    required this.confidenceInClass,
    required this.rect,
  });

  factory Recognition.fromJson(Map<String, dynamic> json) {
    if (json['box'] is! List) {
      throw ArgumentError('Expected a List for the "box" field.');
    }

    List<dynamic> box = json['box'] as List<dynamic>;

    if (box.length != 5) {
      throw ArgumentError('Expected 5 elements in the "box" list.');
    }

    double x1 = box[0].toDouble();
    double y1 = box[1].toDouble();
    double x2 = box[2].toDouble();
    double y2 = box[3].toDouble();
    double classConfidence = box[4].toDouble();

    if (json['tag'] is! String) {
      throw ArgumentError('Expected a String value for the "tag" field.');
    }

    String detectedClass = json['tag'];

    return Recognition(
      detectedClass: detectedClass,
      confidenceInClass: classConfidence,
      rect: Rect.fromLTRB(x1, y1, x2, y2),
    );
  }

  Recognition copyWith({
    double? confidenceInClass,
    String? detectedClass,
    Rect? rect,
  }) {
    return Recognition(
      confidenceInClass: confidenceInClass ?? this.confidenceInClass,
      detectedClass: detectedClass ?? this.detectedClass,
      rect: rect ?? this.rect,
    );
  }
}
