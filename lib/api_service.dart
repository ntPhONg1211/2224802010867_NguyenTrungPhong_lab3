import 'package:dio/dio.dart';

class ApiService {
  final Dio dio = Dio();

  final String baseUrl = "https://69dde8ee410caa3d47ba312c.mockapi.io/api/v1";

  // ─── ĐĂNG KÝ ───────────────────────────────────────────────
  Future<bool> register(String username, String email, String password) async {
    try {
      final response = await dio.post(
        "$baseUrl/user",
        data: {
          "username": username,
          "email": email,
          "password": password,
        },
      );
      return response.statusCode == 201;
    } catch (e) {
      return false;
    }
  }

  // ─── ĐĂNG NHẬP ─────────────────────────────────────────────
  Future<bool> login(String email, String password) async {
    try {
      final response = await dio.get("$baseUrl/user");
      final List users = response.data;
      return users.any(
        (u) => u['email'] == email && u['password'] == password,
      );
    } catch (e) {
      return false;
    }
  }

  // ─── RESET PASSWORD ─────────────────────────────────────────
  Future<bool> resetPassword(String email) async {
    try {
      final response = await dio.get("$baseUrl/user");
      final List users = response.data;

      final user = users.firstWhere(
        (u) => u['email'] == email,
        orElse: () => null,
      );

      if (user == null) return false;

      // Dùng PATCH để chỉ cập nhật password, giữ nguyên email & username
      await dio.patch(
        "$baseUrl/user/${user['id']}",
        data: {"password": "resetpass123"},
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  // ─── LẤY DANH SÁCH USERS ───────────────────────────────────
  Future<List> getUsers() async {
    try {
      final response = await dio.get("$baseUrl/user");
      return response.data;
    } catch (e) {
      return [];
    }
  }
}
