import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../network/dio_client.dart';
import '../../features/data/datasources/debate_remote_data_source.dart';
import '../../features/data/datasources/home_remote_data_source.dart';
import '../../features/data/repositories/debate_repository_impl.dart';
import '../../features/data/repositories/home_repository_impl.dart';
import '../../features/domain/repositories/debate_repository.dart';
import '../../features/domain/repositories/home_repository.dart';
import '../../features/domain/usecases/evaluate_debate.dart';
import '../../features/domain/usecases/get_home_items.dart';
import '../../features/domain/usecases/reset_debate.dart';
import '../../features/domain/usecases/send_chat_message.dart';
import '../../features/presentation/bloc/chat_bloc.dart';
import '../../features/presentation/bloc/home_bloc.dart';

final GetIt sl = GetIt.instance;

Future<void> configureDependencies() async {
  sl.registerLazySingleton<Dio>(() => DioClient.create());

  sl.registerLazySingleton<HomeRemoteDataSource>(
    () => HomeRemoteDataSourceImpl(sl<Dio>()),
  );

  sl.registerLazySingleton<DebateRemoteDataSource>(
    () => DebateRemoteDataSourceImpl(sl<Dio>()),
  );

  sl.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(sl<HomeRemoteDataSource>()),
  );

  sl.registerLazySingleton<DebateRepository>(
    () => DebateRepositoryImpl(sl<DebateRemoteDataSource>()),
  );

  sl.registerLazySingleton<GetHomeItems>(
    () => GetHomeItems(sl<HomeRepository>()),
  );

  sl.registerLazySingleton<SendChatMessage>(
    () => SendChatMessage(sl<DebateRepository>()),
  );

  sl.registerLazySingleton<EvaluateDebate>(
    () => EvaluateDebate(sl<DebateRepository>()),
  );

  sl.registerLazySingleton<ResetDebate>(
    () => ResetDebate(sl<DebateRepository>()),
  );

  sl.registerFactory<HomeBloc>(() => HomeBloc(sl<GetHomeItems>()));

  sl.registerFactory<ChatBloc>(
    () => ChatBloc(
      sendChatMessage: sl<SendChatMessage>(),
      evaluateDebate: sl<EvaluateDebate>(),
      resetDebate: sl<ResetDebate>(),
    ),
  );
}
