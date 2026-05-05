import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final _storage = const FlutterSecureStorage();
  
  bool _isLoading = false;
  String? _token;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get token => _token;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _token != null;

  Future<void> login(String email, String password) async {
    _setLoading(true);
    _errorMessage = null;
    try {
      final response = await _authService.login(email, password);
      _token = response.data['token'];
      await _storage.write(key: 'jwt_token', value: _token);
      notifyListeners();
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout || 
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.connectionError) {
        _errorMessage = 'Server is unreachable. Please check your connection.';
      } else {
        _errorMessage = e.response?.data['message'] ?? 'Login failed';
      }
    } catch (e) {
      _errorMessage = 'An unexpected error occurred';
    } finally {
      _setLoading(false);
    }
  }

  Future<void> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String roleType,
  }) async {
    _setLoading(true);
    _errorMessage = null;
    try {
      await _authService.register(
        firstName: firstName,
        lastName: lastName,
        email: email,
        password: password,
        roleType: roleType,
      );
      // Optional: Auto login after register or navigate to login
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout || 
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.connectionError) {
        _errorMessage = 'Server is unreachable. Please check your connection.';
      } else {
        _errorMessage = e.response?.data['message'] ?? 'Registration failed';
      }
    } catch (e) {
      _errorMessage = 'An unexpected error occurred';
    } finally {
      _setLoading(false);
    }
  }

  Future<void> tryAutoLogin() async {
    _token = await _storage.read(key: 'jwt_token');
    notifyListeners();
  }

  Future<void> logout() async {
    _token = null;
    await _storage.delete(key: 'jwt_token');
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
