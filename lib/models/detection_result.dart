class DetectionResult {
  final String className;
  final double confidence;
  final List<double> bbox; // [x1, y1, x2, y2]

  DetectionResult({
    required this.className,
    required this.confidence,
    required this.bbox,
  });

  factory DetectionResult.fromJson(Map<String, dynamic> json) {
    return DetectionResult(
      className: json['class_name'] ?? 'Unknown',
      confidence: (json['confidence'] as num).toDouble(),
      bbox: (json['bbox'] as List).map((e) => (e as num).toDouble()).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'class_name': className,
      'confidence': confidence,
      'bbox': bbox,
    };
  }
}
