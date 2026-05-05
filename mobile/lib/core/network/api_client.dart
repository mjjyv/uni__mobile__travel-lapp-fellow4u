import 'package:dio/dio.dart';

class ApiClient {
  static final Dio _dio = Dio(
    BaseOptions(
      // 10.0.2.2 là địa chỉ IP của localhost dành cho Android Emulator
      baseUrl: 'http://10.0.2.2:3000/api', 
      // Dùng http://localhost:3000/api nếu chạy trên iOS Simulator
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 3),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  static Dio get dio => _dio;
}
