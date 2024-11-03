import 'dart:convert';
import 'package:flutter_dev_test/features/authentication/infra/services/generate_totp.dart';
import 'package:otp/otp.dart';
import '../../../../core/error/execeptions.dart';
import '../models/user_model.dart';
import 'user_remote_data_source.dart';
import 'package:http/http.dart' as http;

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final http.Client client;

  UserRemoteDataSourceImpl({required this.client});

  static const String _baseUrl = 'http://127.0.0.1:5000/auth';
  static const Map<String, String> _headers = {
    'Content-Type': 'application/json',
  };

  @override
  Future<UserModel> logIn(
      {required String userName,
      required String password,
      String? secret}) async {
    if (secret == null) {
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
      throw UnauthorizedException(message: response.toString());
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
      throw UnauthorizedException(message: response.toString());
    } else if (response.statusCode == 404) {
      throw UserNotFoundException();
    } else {
      throw UnknownErrorException();
    }
  }
}
