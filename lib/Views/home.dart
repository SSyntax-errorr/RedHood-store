import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:store/Model/item_model.dart';
import 'package:store/Views/add_item_screen.dart';
import 'package:store/Views/nav_bar_home.dart';
import 'package:store/Services/database_helper.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:permission_handler/permission_handler.dart';

const Color redColor = Color.fromARGB(255, 239, 68, 74);

List<int> idList = [];
List<DataModel> itemList = [];
List<DataModel> itemListToDisplay = [];
List<DataModel> subItemList = [];
bool appJustOpened = true;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _searchFilter(String enteredKeyword) {
    subItemList = [];
    if (enteredKeyword.isEmpty) {
      setState(() {
        itemListToDisplay = itemList;
      });
      return;
    }

    subItemList = itemList
        .where((item) => (item.itemName.toLowerCase())
            .contains(enteredKeyword.toLowerCase()))
        .toList();

    setState(() {
      itemListToDisplay = subItemList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: NavBar(
          scaffoldKey: _scaffoldKey,
          onItemClicked: () {
            setState(() {});
          }),
      backgroundColor: const Color.fromARGB(255, 36, 32, 55),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: const Color.fromARGB(255, 239, 68, 74),
        title: const Text(
          "REDHOOD STORE",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Stack(children: [
        //?used stack() because column() causes pixel overflow
        Positioned(
          top: 10,
          left: 20,
          right: 20,
          child: TextField(
            //search bar
            style: const TextStyle(color: Colors.white),
            cursorColor: redColor,
            decoration: const InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: redColor),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: Colors
                          .red), //? Color of the bottom line when the TextField is focused
                ),
                hintText: "Search",
                hintStyle: TextStyle(color: Color.fromARGB(58, 255, 255, 255)),
                focusColor: redColor,
                hoverColor: redColor,
                suffixIcon: Icon(
                  Icons.search,
                  color: Color.fromARGB(255, 239, 68, 74),
                )),
            onChanged: (value) => _searchFilter(value),
          ),
        ),
        Positioned(
          top: 70,
          left: 0,
          right: 0,
          bottom: 0,
          child: itemListBuilder(),
        ),
      ]),
      floatingActionButton: FloatingActionButton(
          backgroundColor: const Color.fromARGB(255, 239, 68, 74),
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddItemWidget()),
            ).then((_) {
              if (!newItemAdded) return;

              newItemAdded = false;
              setState(() {
                itemListToDisplay = itemList;
                drawerIndex = 0;
              });
            });
          }),
    );
  }

  FutureBuilder<List<DataModel>> itemListBuilder() {
    return FutureBuilder<List<DataModel>>(
      future: DatabaseHelper.instance.retrieveItems(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          if (itemListToDisplay.isEmpty && !appJustOpened) {
          } else if (itemListToDisplay.isNotEmpty && subItemList.isEmpty) {
            itemList = snapshot.data!;
            itemListToDisplay = itemList;
          } else if (itemListToDisplay.isNotEmpty && !appJustOpened) {
          } else {
            itemList = snapshot.data!;
            itemListToDisplay = itemList;
            appJustOpened = false;
          }
          //itemList = snapshot.data!;
          //itemListToDisplay = itemList;

          for (var item in itemList) {
            idList.add(item.itemID);
          }
          if (itemListToDisplay.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    color: Color.fromARGB(145, 158, 158, 158),
                    size: 30,
                  ),
                  Text(
                    "No items",
                    style: TextStyle(color: Color.fromARGB(145, 158, 158, 158)),
                  )
                ],
              ),
            );
          }
          //requestPermission();

          return ListView.builder(
            itemExtent: 80,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            itemCount: itemListToDisplay.length,
            itemBuilder: (BuildContext context, int index) {
              return Slidable(
                  startActionPane: ActionPane(
                    motion: const StretchMotion(),
                    children: [
                      SlidableAction(
                        backgroundColor: const Color.fromARGB(255, 239, 68, 74),
                        icon: Icons.delete,
                        label: 'Delete',
                        onPressed: (BuildContext context) {
                          setState(() {});
                          deleteData(index, itemListToDisplay[index].itemID);
                        },
                      ),
                      SlidableAction(
                        backgroundColor: redColor,
                        icon: Icons.edit,
                        label: 'Edit',
                        onPressed: (BuildContext context) {
                          setState(() {});
                          editData(index, itemListToDisplay[index].itemID);
                        },
                      ),
                    ],
                  ),
                  endActionPane:
                      ActionPane(motion: const BehindMotion(), children: [
                    SlidableAction(
                        icon: itemListToDisplay[index].isCommon == 1
                            ? Icons.star
                            : Icons.star_outline,
                        foregroundColor: itemListToDisplay[index].isCommon == 1
                            ? redColor
                            : Colors.white,
                        label: 'Common Item',
                        backgroundColor: const Color.fromARGB(
                            255, 36, 33, 54), //255, 120, 117, 117),
                        onPressed: (BuildContext context) {
                          editCommon(itemListToDisplay[index].itemID,
                              itemListToDisplay[index].isCommon);
                          Fluttertoast.showToast(
                              msg: itemListToDisplay[index].isCommon == 0
                                  ? "${itemListToDisplay[index].itemName} Added to common items"
                                  : "${itemListToDisplay[index].itemName} Removed from common items");
                          setState(() {});
                        })
                  ]),
                  child: Container(
                    color: const Color.fromARGB(255, 56, 52, 85),
                    child: ListTile(
                      leading: Icon(
                        categoryIcon(
                            itemListToDisplay.isEmpty //?need to refactor
                                ? itemListToDisplay[index].category
                                : itemListToDisplay[index].category),
                        color: const Color.fromARGB(255, 243, 97, 100),
                      ),
                      trailing: Text(itemListToDisplay[index].date),
                      title: Text(itemListToDisplay[index].itemName),
                      subtitle:
                          Text('Rs: ${itemListToDisplay[index].itemPrice}'),
                      textColor: Colors.white,
                    ),
                  ));
            },
          );
        }
      },
    );
  }

  Center noItemsDisplay() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            color: Color.fromARGB(145, 158, 158, 158),
            size: 30,
          ),
          Text(
            "No items",
            style: TextStyle(color: Color.fromARGB(145, 158, 158, 158)),
          )
        ],
      ),
    );
  }

  IconData categoryIcon(String category) {
    switch (category) {
      case "Cigarettes":
        return Icons.smoking_rooms_sharp;
      case "Liquor":
        return Icons.wine_bar;
      case "Snacks":
        return Icons.cookie;

      case "NonAlcoholic":
        return Icons.water_drop;
      case "Food":
        return Icons.ramen_dining;

      case "Other":
        return Icons.question_mark;
      default:
        return Icons.all_inclusive;
    }
  }

  void requestPermission() async {
    var status = await Permission.storage.status;
    if (status.isDenied) {
      await Permission.storage.request();
    }
  }

  void deleteData(int itemIndex, int itemID) {
    DatabaseHelper dbHelper = DatabaseHelper.instance;
    dbHelper.deleteItem(itemID);
    setState(() {
      drawerIndex = 0;
    });
  }

  void editData(int index, int itemID) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => AddItemWidget(
                editItemID: itemID,
              )),
    ).then((_) {
      setState(() {
        itemListToDisplay = itemList;
        drawerIndex = 0;
      });
    });
  }

  Future<void> editCommon(int itemID, int isCommon) async {
    await DatabaseHelper.makeItemCommon(itemID, isCommon);
  }
}
