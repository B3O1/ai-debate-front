import '../../domain/entities/home_item.dart';

class HomeItemModel {
  final String id;
  final String category;
  final String title;
  final String iconKey;
  final bool isCustomInput;

  const HomeItemModel({
    required this.id,
    required this.category,
    required this.title,
    required this.iconKey,
    required this.isCustomInput,
  });

  factory HomeItemModel.fromJson(Map<String, dynamic> json) {
    return HomeItemModel(
      id: json['id'] as String,
      category: json['category'] as String,
      title: json['title'] as String,
      iconKey: json['iconKey'] as String,
      isCustomInput: json['isCustomInput'] as bool? ?? false,
    );
  }

  HomeItem toEntity() {
    return HomeItem(
      id: id,
      category: category,
      title: title,
      iconKey: iconKey,
      isCustomInput: isCustomInput,
    );
  }
}
