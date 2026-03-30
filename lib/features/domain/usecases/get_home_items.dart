import '../entities/home_item.dart';
import '../repositories/home_repository.dart';

class GetHomeItems {
  final HomeRepository repository;

  const GetHomeItems(this.repository);

  Future<List<HomeItem>> call() {
    return repository.getHomeItems();
  }
}
