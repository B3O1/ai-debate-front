import '../entities/home_item.dart';

abstract class HomeRepository {
  Future<List<HomeItem>> getHomeItems();
}
