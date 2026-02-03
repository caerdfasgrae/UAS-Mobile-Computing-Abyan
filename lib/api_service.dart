import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "https://abyan.tifaw.my.id/api-abyan/";

  static Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final res = await http.post(
      Uri.parse("${baseUrl}auth/register.php"),
      body: {"name": name, "email": email, "password": password},
    ).timeout(const Duration(seconds: 10));

    final decoded = json.decode(res.body);
    if (decoded is Map<String, dynamic>) return decoded;
    return {"success": false, "message": "Invalid response"};
  }

  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final res = await http.post(
      Uri.parse("${baseUrl}auth/login.php"),
      body: {"email": email, "password": password},
    ).timeout(const Duration(seconds: 10));

    final decoded = json.decode(res.body);
    if (decoded is Map<String, dynamic>) return decoded;
    return {"success": false, "message": "Invalid response"};
  }

  static Future<List<dynamic>> getLessons() async {
    final res = await http
        .get(Uri.parse("${baseUrl}lessons/list.php"))
        .timeout(const Duration(seconds: 10));

    final decoded = json.decode(res.body);
    if (decoded is Map && decoded["success"] == true && decoded["data"] is List) {
      return decoded["data"];
    }
    return [];
  }

  static Future<List<dynamic>> getVocabByLesson(int lessonId) async {
    final res = await http
        .get(Uri.parse("${baseUrl}vocab/by_lesson.php?lesson_id=$lessonId"))
        .timeout(const Duration(seconds: 10));

    final decoded = json.decode(res.body);
    if (decoded is Map && decoded["success"] == true && decoded["data"] is List) {
      return decoded["data"];
    }
    return [];
  }

  static Future<List<dynamic>> getProgress(int userId) async {
    final res = await http
        .get(Uri.parse("${baseUrl}progress/get.php?user_id=$userId"))
        .timeout(const Duration(seconds: 10));

    final decoded = json.decode(res.body);
    if (decoded is Map && decoded["success"] == true && decoded["data"] is List) {
      return decoded["data"];
    }
    return [];
  }

  static Future<bool> saveProgress({
    required int userId,
    required int lessonId,
    required int points,
  }) async {
    final res = await http.post(
      Uri.parse("${baseUrl}progress/save.php"),
      body: {
        "user_id": userId.toString(),
        "lesson_id": lessonId.toString(),
        "points": points.toString(),
      },
    ).timeout(const Duration(seconds: 10));

    final decoded = json.decode(res.body);
    return decoded is Map && decoded["success"] == true;
  }
}