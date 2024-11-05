// Dart imports:
import 'dart:convert';

// Package imports:
import 'package:http/http.dart' as http;

// Project imports:
import '../../../../core/error/execeptions.dart';
import '../../infra/services/generate_totp.dart';
import '../models/user_model.dart';
import 'user_remote_data_source.dart';

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final http.Client client;

  UserRemoteDataSourceImpl({required this.client});

  //emulador android
  static const String _baseUrl = 'http://10.0.2.2:5000/auth';

  //static const String _baseUrl = 'http://127.0.0.1:5000/auth';

  static const Map<String, String> _headers = {
    'Content-Type': 'application/json',
  };

  @override
  Future<UserModel> logIn(
      {required String userName,
      required String password,
      required String secret}) async {
    if (secret.isEmpty) {
      throw SecretNotFoundException();
    }

    final totpCode = generateTOTP(secret);

    const url = '$_baseUrl/login';

    final response = await client.post(
      Uri.parse(url),
      headers: _headers,
      body: jsonEncode({
        'username': userName,
        'password': password,
        'totp_code': totpCode,
      }),
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return UserModel.fromMap(jsonResponse);
    } else if (response.statusCode == 401) {
      throw UnauthorizedException();
    } else {
      throw UnknownErrorException();
    }
  }

  @override
  Future<String> recoverySecret(
      {required String userName,
      required String password,
      required String code}) async {
    const url = '$_baseUrl/recovery-secret';

    final response = await client.post(
      Uri.parse(url),
      headers: _headers,
      body: jsonEncode({
        'username': userName,
        'password': password,
        'code': code,
      }),
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);

      return jsonResponse['totp_secret'].toString();
    } else if (response.statusCode == 401) {
      final message = json.decode(response.body)['message'] ?? 'Unauthorized';
      throw UnauthorizedException(message: message);
    } else if (response.statusCode == 404) {
      throw UserNotFoundException();
    } else {
      throw UnknownErrorException();
    }
  }
}
