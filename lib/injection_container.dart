// Package imports:
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

// Project imports:
import 'package:flutter_dev_test/features/authentication/data/datasources/user_remote_data_source.dart';
import 'package:flutter_dev_test/features/authentication/data/repositories/user_repository_impl.dart';
import 'package:flutter_dev_test/features/authentication/domain/repositories/user_repository.dart';
import 'package:flutter_dev_test/features/authentication/domain/usecases/login.dart';
import 'package:flutter_dev_test/features/authentication/domain/usecases/recovery_secret.dart';
import 'package:flutter_dev_test/features/authentication/presentation/bloc/user_bloc.dart';
import 'features/authentication/data/datasources/user_remote_data_source_impl.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //Blocs
  sl.registerFactory(() => UserBloc(
        login: sl(),
        recoverySecret: sl(),
      ));

  // Usecases
  sl.registerLazySingleton(() => LogIn(repository: sl()));
  sl.registerLazySingleton(() => RecoverySecret(repository: sl()));

  // Repositories
  sl.registerLazySingleton<UserRepository>(
      () => UserRepositoryImpl(remoteDataSource: sl()));

  // Data sources

  sl.registerLazySingleton<UserRemoteDataSource>(
      () => UserRemoteDataSourceImpl(client: sl()));

  // External
  sl.registerLazySingleton(() => http.Client());
}
