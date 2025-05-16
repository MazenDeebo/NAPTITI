import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import '../models/detection_result.dart';

class ApiService {
  // Change this to your actual API endpoint when deployed
  static const String baseUrl = 'http://10.0.2.2:5000'; // For Android emulator
  // Use 'http://localhost:5000' for iOS simulator or web

  // Method to send image to the API for detection
  static Future<List<DetectionResult>> detectLeaves(File imageFile) async {
    try {
      // Create multipart request
      var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/detect'));
      
      // Add the image file to the request
      request.files.add(await http.MultipartFile.fromPath(
        'image',
        imageFile.path,
      ));
      
      // Send the request
      var response = await request.send();
      
      // Get the response
      var responseData = await response.stream.bytesToString();
      var jsonResponse = json.decode(responseData);
      
      if (response.statusCode == 200) {
        if (jsonResponse['success'] == true) {
          // Parse the detections
          List<dynamic> detections = jsonResponse['detections'];
          return detections.map((detection) => DetectionResult.fromJson(detection)).toList();
        } else {
          throw Exception('API returned error: ${jsonResponse['error']}');
        }
      } else {
        throw Exception('Failed to detect leaves: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error detecting leaves: $e');
      rethrow;
    }
  }

  // Method to send base64 encoded image (useful for web)
  static Future<List<DetectionResult>> detectLeavesBase64(String base64Image) async {
    try {
      // Create request
      var response = await http.post(
        Uri.parse('$baseUrl/detect'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'image': base64Image}),
      );
      
      var jsonResponse = json.decode(response.body);
      
      if (response.statusCode == 200) {
        if (jsonResponse['success'] == true) {
          // Parse the detections
          List<dynamic> detections = jsonResponse['detections'];
          return detections.map((detection) => DetectionResult.fromJson(detection)).toList();
        } else {
          throw Exception('API returned error: ${jsonResponse['error']}');
        }
      } else {
        throw Exception('Failed to detect leaves: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error detecting leaves with base64: $e');
      rethrow;
    }
  }
}
