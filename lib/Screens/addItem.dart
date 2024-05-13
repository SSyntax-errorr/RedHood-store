//import 'dart:html';
import 'dart:math';

//import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:store/Model/itemModel.dart';
import 'package:store/Services/database_helper.dart';
import 'package:store/Screens/home.dart';

DateTime currentDate = DateTime.now();
DateTime today = DateTime(currentDate.year, currentDate.month, currentDate.day);
String formattedDate =
    today.toIso8601String().split('T')[0].split('-').reversed.join('-');

class AddItemWidget extends StatefulWidget {
  final int? editItemID;
  AddItemWidget({super.key, this.editItemID});

  @override
  State<AddItemWidget> createState() => _AddItemWidgetState();
}

class _AddItemWidgetState extends State<AddItemWidget> {
  TextEditingController _itemNameController = TextEditingController();
  TextEditingController _itemPriceController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  String itemNameInput = '';
  String itemPriceInput = '0';
  Categories selectedValue = Categories.Other;
  List<Categories> options = [
    Categories.Other,
    Categories.Liquor,
    Categories.Cigarettes,
    Categories.SoftDrinks,
    Categories.Snacks,
    Categories.FrozenFood
  ];
  void categoryInit(String category) {
    switch (category) {
      case "Cigarettes":
        selectedValue = Categories.Cigarettes;
      case "Liquor":
        selectedValue = Categories.Liquor;
      case "Snacks":
        selectedValue = Categories.Snacks;
      case "SoftDrinks":
        selectedValue = Categories.SoftDrinks;
      case "FrozenFood":
        selectedValue = Categories.FrozenFood;

      case "Other":
        selectedValue = Categories.Other;
      default:
        selectedValue = Categories.Other;
    }
  }

  bool isCommonToggle = false;

  @override
  void initState() {
    //_itemNameController.text = editItemID;
    if (widget.editItemID != null) {
      DataModel itemID =
          itemList.firstWhere((item) => item.itemID == widget.editItemID);
      _itemNameController.text = itemID.itemName;
      _itemPriceController.text = itemID.itemPrice.toString();
      categoryInit(itemID.category);
      if (itemID.isCommon == 1) isCommonToggle = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 36, 32, 55),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 239, 68, 74),
        foregroundColor: Colors.white,
        title: const Text("Add Item"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                  ""), //temporary solution to padding problem. Pixels overflow if centered
              TextFormField(
                //item name field
                controller: _itemNameController,
                onChanged: (value) {
                  itemNameInput = value;
                },
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintStyle: TextStyle(color: Color.fromARGB(255, 64, 58, 58)),
                  labelStyle: TextStyle(color: Colors.red),
                  focusColor: Colors.red,
                  labelText: 'Item Name',
                  hintText: 'Enter the item name',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Invalid input";
                  }
                  return null;
                },
              ),
              TextFormField(
                //price field
                controller: _itemPriceController,
                onChanged: (value) {
                  itemPriceInput = value;
                },
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}$')),
                ],
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                    hintStyle:
                        TextStyle(color: Color.fromARGB(255, 64, 55, 55)),
                    labelStyle: TextStyle(color: Colors.red),
                    labelText: "Item Price",
                    hintText: "Enter the item price"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Invalid input";
                  }
                  return null;
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Category: ',
                    style: TextStyle(color: Colors.red, fontSize: 18),
                  ),
                  DropdownButton<Categories>(
                    dropdownColor: const Color.fromARGB(255, 239, 68, 74),
                    value: selectedValue,
                    onChanged: (newValue) {
                      setState(() {
                        selectedValue = newValue!;
                      });
                    },
                    items: options.map<DropdownMenuItem<Categories>>(
                        (Categories category) {
                      return DropdownMenuItem<Categories>(
                        value: category,
                        child: Text(
                          category.name,
                          style: TextStyle(
                            color:
                                category == selectedValue ? Colors.white : null,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Commonly bought item",
                    style: TextStyle(color: redColor, fontSize: 18),
                  ),
                  Switch(
                      activeColor: redColor,
                      activeTrackColor: Colors.white,
                      value: isCommonToggle,
                      onChanged: (value) {
                        setState(() {
                          isCommonToggle = value;
                        });
                      }),
                ],
              ),
              Container(
                margin: const EdgeInsets.only(top: 30),
                child: ElevatedButton(
                  onPressed: () async {
                    if (_itemNameController.text.isEmpty ||
                        _itemPriceController.text.isEmpty) {
                      return;
                    }

                    if (widget.editItemID == null) {
                      int randomId;

                      randomId = Random().nextInt(10000);

                      final DataModel newItem = DataModel(
                          itemID: randomId,
                          itemName: itemNameInput,
                          itemPrice: double.parse(itemPriceInput),
                          category: selectedValue.name,
                          date: formattedDate.toString(),
                          isCommon: isCommonToggle ? 1 : 0);

                      await DatabaseHelper.insertItem(newItem);
                    } else {
                      final DataModel updatedItem = DataModel(
                          itemID: widget.editItemID!.toInt(),
                          itemName: _itemNameController.text,
                          itemPrice: double.parse(_itemPriceController.text),
                          category: selectedValue.name,
                          date: formattedDate.toString(),
                          isCommon: isCommonToggle ? 1 : 0);

                      await DatabaseHelper.updateItem(updatedItem);
                    }

                    if (_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: widget.editItemID == null
                              ? Text("Added $itemNameInput")
                              : Text("Modified ${_itemNameController.text}"),
                        ),
                      );
                    }
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 239, 68, 74),
                      foregroundColor: Colors.white),
                  child: widget.editItemID == null ? Text("Add") : Text("Edit"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
