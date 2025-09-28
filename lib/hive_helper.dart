import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'item_model.dart';

class HiveHelper {
  static const String boxName = 'itemsBox';
  static final HiveHelper _instance = HiveHelper._internal();
  factory HiveHelper() => _instance;
  HiveHelper._internal();

  Future<void> initHive() async {
    await Hive.openBox<Item>(boxName);
  }

  // افزودن آیتم
  Future<void> addItem(Item item) async {
    var box = Hive.box<Item>(boxName);
    await box.add(item);
  }

  // ویرایش آیتم
  Future<void> editItem(int index, Item item) async {
    var box = Hive.box<Item>(boxName);
    await box.putAt(index, item);
  }

  // حذف آیتم
  Future<void> deleteItem(int index) async {
    var box = Hive.box<Item>(boxName);
    await box.deleteAt(index);
  }

  // لیست تمام آیتم‌ها
  List<Item> getAllItems() {
    var box = Hive.box<Item>(boxName);
    return box.values.toList();
  }

  // جستجو بر اساس نام
  List<Item> searchItems(String query) {
    var box = Hive.box<Item>(boxName);
    return box.values
        .where((item) => item.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
}
