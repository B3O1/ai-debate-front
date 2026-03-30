import '../../domain/entities/home_item.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/home_remote_data_source.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;

  const HomeRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<HomeItem>> getHomeItems() async {
    final models = await remoteDataSource.getHomeItems();
    return models.map((model) => model.toEntity()).toList();
  }
}
