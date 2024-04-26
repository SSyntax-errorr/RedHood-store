import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:store/Model/itemModel.dart';
import 'package:store/Services/database_helper.dart';

class AddItemWidget extends StatefulWidget {
  const AddItemWidget({super.key});

  @override
  State<AddItemWidget> createState() => _AddItemWidgetState();
}

class _AddItemWidgetState extends State<AddItemWidget> {
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
        padding: const EdgeInsets.all(50.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
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
              Container(
                margin: const EdgeInsets.only(top: 30),
                child: ElevatedButton(
                  onPressed: () async {
                    if (itemNameInput.isEmpty || itemPriceInput.isEmpty) {
                      return;
                    }

                    if (_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Added"),
                        ),
                      );
                    }

                    int randomId;

                    randomId = Random().nextInt(10000);

                    final DataModel newItem = DataModel(
                        itemID: randomId,
                        itemName: itemNameInput,
                        itemPrice: double.parse(itemPriceInput),
                        category: selectedValue.name);

                    await DatabaseHelper.insertItem(newItem);

                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 239, 68, 74),
                      foregroundColor: Colors.white),
                  child: const Text("Confirm"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
