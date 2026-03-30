class HomeItem {
  final String id;
  final String category;
  final String title;
  final String iconKey;
  final bool isCustomInput;

  const HomeItem({
    required this.id,
    required this.category,
    required this.title,
    required this.iconKey,
    this.isCustomInput = false,
  });
}
