import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../../features/data/datasources/home_remote_data_source.dart';
import '../../features/data/repositories/home_repository_impl.dart';
import '../../features/domain/repositories/home_repository.dart';
import '../../features/domain/usecases/get_home_items.dart';
import '../../features/presentation/bloc/home_bloc.dart';

final GetIt sl = GetIt.instance;

Future<void> configureDependencies() async {
  sl.registerLazySingleton<Dio>(() => Dio());

  sl.registerLazySingleton<HomeRemoteDataSource>(
    () => HomeRemoteDataSourceImpl(sl<Dio>()),
  );

  sl.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(sl<HomeRemoteDataSource>()),
  );

  sl.registerLazySingleton<GetHomeItems>(
    () => GetHomeItems(sl<HomeRepository>()),
  );

  sl.registerFactory<HomeBloc>(() => HomeBloc(sl<GetHomeItems>()));
}
