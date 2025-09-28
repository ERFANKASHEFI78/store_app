import 'package:hive/hive.dart';
part 'item_model.g.dart';

@HiveType(typeId: 0)
class Item extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  double price;

  @HiveField(2)
  int quantity;

  Item({required this.name, required this.price, required this.quantity});
}
