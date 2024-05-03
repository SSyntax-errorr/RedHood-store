import 'package:flutter/material.dart';
import 'package:store/Model/itemModel.dart';
import 'package:store/Screens/addItem.dart';
import 'package:store/Screens/navBar.dart';
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
        //used stack() because column() causes pixel overflow
        Positioned(
          top: 10,
          left: 20,
          right: 20,
          child: TextField(
            //search bar
            style: TextStyle(color: Colors.white),
            cursorColor: redColor,
            decoration: const InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: redColor),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: Colors
                          .red), // Color of the bottom line when the TextField is focused
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
          child: ItemList(),
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
              MaterialPageRoute(builder: (context) => AddItemWidget()),
            ).then((_) {
              setState(() {
                itemListToDisplay = itemList;
              });
            });
          }),
    );
  }

  FutureBuilder<List<DataModel>> ItemList() {
    return FutureBuilder<List<DataModel>>(
      future: DatabaseHelper.instance.retrieveItems(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          if (itemListToDisplay.isEmpty && !appJustOpened) {
            print("x");
          } else if (itemListToDisplay.isNotEmpty && subItemList.isEmpty) {
            itemList = snapshot.data!;
            itemListToDisplay = itemList;
          } else if (itemListToDisplay.isNotEmpty && !appJustOpened) {
          } else {
            itemList = snapshot.data!;
            itemListToDisplay = itemList;
            appJustOpened = false;
            print(itemListToDisplay.isEmpty);
            print(appJustOpened);
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
            padding: EdgeInsets.symmetric(horizontal: 10),
            itemCount: itemListToDisplay.length,
            itemBuilder: (BuildContext context, int index) {
              return Slidable(
                  startActionPane: ActionPane(
                    motion: const StretchMotion(),
                    children: [
                      SlidableAction(
                        backgroundColor: Color.fromARGB(255, 239, 68, 74),
                        icon: Icons.delete,
                        label: 'Delete',
                        onPressed: (BuildContext) {
                          setState(() {});
                          deleteData(index, itemList[index].itemID);
                        },
                      ),
                      SlidableAction(
                        backgroundColor: Color.fromARGB(255, 239, 68, 74),
                        icon: Icons.edit,
                        label: 'Edit',
                        onPressed: (BuildContext context) {
                          setState(() {});
                          editData(index, itemList[index].itemID);
                        },
                      )
                    ],
                  ),
                  child: Container(
                    color: const Color.fromARGB(255, 56, 52, 85),
                    child: ListTile(
                      leading: Icon(
                        categoryIcon(itemListToDisplay.isEmpty
                            ? itemList[index].category
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
      case "SoftDrinks":
        return Icons.water_drop;
      case "FrozenFood":
        return Icons.icecream;

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
    setState(() {});
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
      });
    });
  }
}
