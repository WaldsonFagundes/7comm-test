// Imports
import 'package:flutter_dev_test/features/authentication/data/models/user_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const tUserModel = UserModel(
    userName: 'test_username',
    secret: 'test_totp_secret',
  );

  test('should return a valid UserModel from a Map', () {
    final Map<String, dynamic> map = {
      'username': 'test_username',
      'totp_secret': 'test_totp_secret',
    };

    final result = UserModel.fromMap(map);

    expect(result, tUserModel);
  });

  test('should compare two UserModels correctly', () {
    // arrange
    const anotherUserModel = UserModel(
      userName: 'test_username',
      secret: 'test_totp_secret',
    );

    // assert
    expect(tUserModel, anotherUserModel);
  });
}
