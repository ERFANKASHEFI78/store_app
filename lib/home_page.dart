import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:store_app/hive_helper.dart';
import 'package:store_app/item_model.dart';
import 'add_edit_item_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HiveHelper _hiveHelper = HiveHelper();
  final TextEditingController _searchController = TextEditingController();
  ValueNotifier<List<Item>> itemsNotifier = ValueNotifier([]);

  @override
  void initState() {
    super.initState();
    _hiveHelper.initHive().then((_) {
      _loadItems();
    });
  }

  void _loadItems() {
    itemsNotifier.value = _hiveHelper.getAllItems();
  }

  void _searchItems(String query) {
    if (query.isEmpty) {
      _loadItems();
    } else {
      itemsNotifier.value = _hiveHelper.searchItems(query);
    }
  }

  void _deleteItem(int index) async {
    await _hiveHelper.deleteItem(index);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text(" ! حذف شد Hive آیتم از دیتابیس ")),
    );
    _loadItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("لیست خریدها"),
        leading: CupertinoButton(child: Icon(Icons.arrow_back), onPressed: (){
          
          Navigator.popAndPushNamed(context, '/login');
           
        }),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
           Material(
            elevation: 3,
             child: TextFormField(
                   
                  controller: _searchController,
                  decoration: const InputDecoration(
                    
                    labelText: "جستجوی آیتم",
                    prefixIcon: Icon(Icons.search, size: 24, color: Colors.amber),
                    border: OutlineInputBorder(
                      
                      borderSide: BorderSide(width: 2)
                    ),
                  ),
                  keyboardType: TextInputType.name,
                  onChanged: _searchItems,
                     ),
           ),
            const SizedBox(height: 10),
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: itemsNotifier,
                builder: (context, List<Item> items, _) {
                  if (items.isEmpty) {
                    return const Center(child: Text("هیچ آیتمی وجود ندارد"));
                  }
                  return ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return Card(
                        child: ListTile(
                          title: Text(item.name),
                          subtitle: Text("قیمت: ${item.price}, تعداد: ${item.quantity}"),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => AddEditItemPage(
                                        item: item,
                                        index: index,
                                      ),
                                    ),
                                  );
                                  _loadItems();
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () => _deleteItem(index),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddEditItemPage()),
          );
          _loadItems();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
