import 'dart:io';
import 'package:flutter/material.dart';
import '../models/detection_result.dart';

class ResultsScreen extends StatelessWidget {
  final File imageFile;
  final List<DetectionResult> results;

  const ResultsScreen({
    Key? key,
    required this.imageFile,
    required this.results,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detection Results'),
        backgroundColor: Colors.green[700],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Display the image
                Image.file(
                  imageFile,
                  fit: BoxFit.contain,
                ),
                // Overlay for bounding boxes
                CustomPaint(
                  painter: BoundingBoxPainter(
                    results: results,
                    imageSize: Size(
                      imageFile.readAsBytesSync().lengthInBytes.toDouble(),
                      imageFile.readAsBytesSync().lengthInBytes.toDouble(),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Detected Items:',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Expanded(
                    child: results.isEmpty
                        ? Center(
                            child: Text(
                              'No leaves detected',
                              style: TextStyle(fontSize: 18),
                            ),
                          )
                        : ListView.builder(
                            itemCount: results.length,
                            itemBuilder: (context, index) {
                              final result = results[index];
                              return Card(
                                elevation: 2,
                                margin: EdgeInsets.symmetric(vertical: 4),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.green[700],
                                    child: Text('${index + 1}'),
                                  ),
                                  title: Text(
                                    result.className,
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(
                                    'Confidence: ${(result.confidence * 100).toStringAsFixed(2)}%',
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.green[700],
                minimumSize: Size(double.infinity, 50),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Take Another Photo'),
            ),
          ),
        ],
      ),
    );
  }
}

class BoundingBoxPainter extends CustomPainter {
  final List<DetectionResult> results;
  final Size imageSize;

  BoundingBoxPainter({
    required this.results,
    required this.imageSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..color = Colors.red;

    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    for (var result in results) {
      // Scale bounding box to canvas size
      final rect = Rect.fromLTRB(
        result.bbox[0] * size.width / imageSize.width,
        result.bbox[1] * size.height / imageSize.height,
        result.bbox[2] * size.width / imageSize.width,
        result.bbox[3] * size.height / imageSize.height,
      );

      // Draw bounding box
      canvas.drawRect(rect, paint);

      // Draw label
      textPainter.text = TextSpan(
        text: '${result.className} ${(result.confidence * 100).toStringAsFixed(0)}%',
        style: TextStyle(
          color: Colors.white,
          fontSize: 12,
          backgroundColor: Colors.red,
        ),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(rect.left, rect.top - textPainter.height),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
