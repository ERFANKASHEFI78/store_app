import 'package:flutter/material.dart';
import 'package:store_app/hive_helper.dart';
import 'package:store_app/item_model.dart';

class AddEditItemPage extends StatefulWidget {
  final Item? item;
  final int? index;

  const AddEditItemPage({super.key, this.item, this.index});

  @override
  State<AddEditItemPage> createState() => _AddEditItemPageState();
}

class _AddEditItemPageState extends State<AddEditItemPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();

  final HiveHelper _hiveHelper = HiveHelper();

  @override
  void initState() {
    super.initState();
    if (widget.item != null) {
      _nameController.text = widget.item!.name;
      _priceController.text = widget.item!.price.toString();
      _quantityController.text = widget.item!.quantity.toString();
    }
  }

  void _saveItem() async {
    if (_formKey.currentState!.validate()) {
      Item item = Item(
        name: _nameController.text,
        price: double.parse(_priceController.text),
        quantity: int.parse(_quantityController.text),
      );

      if (widget.item == null) {
        await _hiveHelper.addItem(item);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("! اضافه شد Hive آیتم به دیتابیس ")),
        );
      } else {
        await _hiveHelper.editItem(widget.index!, item);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("! ویرایش شد Hive آیتم در دیتابیس ")),
        );
      }
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.item == null ? "اضافه کردن آیتم" : "ویرایش آیتم"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                   
                  controller: _nameController,
                  decoration: const InputDecoration(
                    
                    labelText: " نام محصول ",
                    prefixIcon: Icon(Icons.search, size: 24, color: Colors.amber),
                    border: OutlineInputBorder(
                      
                      borderSide: BorderSide(width: 2)
                    ),
                  ),
                  keyboardType: TextInputType.name,
                 
                     
                validator: (value) => value!.isEmpty ? "نام محصول را وارد کنید" : null,
              ),

              const SizedBox(height: 10),

              TextFormField(
                   
                  controller: _priceController,
                  decoration: const InputDecoration(
                    
                    labelText: "  قیمت محصول   ",
                    prefixIcon: Icon(Icons.monetization_on_outlined, size: 24, color: Colors.amber),
                    border: OutlineInputBorder(
                      
                      borderSide: BorderSide(width: 2)
                    ),
                  ),
                  keyboardType: TextInputType.number,
                 
                     
                validator: (value) => value!.isEmpty ? " قیمت محصول را وارد کنید" : null,
              ),
              const SizedBox(height: 10),

              
              TextFormField(
                   
                  controller: _quantityController,
                  decoration: const InputDecoration(
                    
                    labelText: " تعداد محصول ",
                    prefixIcon: Icon(Icons.production_quantity_limits_outlined, size: 24, color: Colors.amber),
                    border: OutlineInputBorder(
                      
                      borderSide: BorderSide(width: 2)
                    ),
                  ),
                  keyboardType: TextInputType.number,
                 
                     
                validator: (value) => value!.isEmpty ? "تعداد آیتم   را وارد کنید" : null,
              ),


              const SizedBox(height: 20),



              ElevatedButton(
                    onPressed: _saveItem,
                    child: const Text(" اضافه کرد محصول جدید ",style: TextStyle(color: Colors.grey),),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                      backgroundColor: Colors.amber,
                    ),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
