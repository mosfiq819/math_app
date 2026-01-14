import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:8000'; // Android emulator
  // For real device: use your computer's IP address
  
  Future<Map<String, dynamic>> solveMathProblem(
      String problem, String problemType) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/solve'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'problem_text': problem,
          'problem_type': problemType,
          'language': 'bn',
        }),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return {
          'success': false,
          'error': 'সার্ভার ত্রুটি: ${response.statusCode}',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': 'সংযোগ ত্রুটি: $e',
      };
    }
  }

  Future<Map<String, dynamic>> uploadImage(List<int> imageBytes) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/upload/image'),
      );

      request.files.add(
        http.MultipartFile.fromBytes(
          'file',
          imageBytes,
          filename: 'math_problem.jpg',
        ),
      );

      var response = await request.send();
      final responseData = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        return json.decode(responseData);
      } else {
        return {
          'success': false,
          'error': 'আপলোড ব্যর্থ: ${response.statusCode}',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': 'সংযোগ ত্রুটি: $e',
      };
    }
  }
}