class ItemModel {
  String itemName;
  String imgUrl;
  String unit;
  double price;
  String description;
  String size;
  int    id;

  ItemModel({
    required this.id,
    required this.description,
    required this.imgUrl,
    required this.itemName,
    required this.price,
    required this.unit,
    required this.size,
  });
}
