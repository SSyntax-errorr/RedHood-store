import 'package:flutter/material.dart';
import 'package:store/Model/itemModel.dart';
import 'package:store/Screens/addItem.dart';
import 'package:store/Services/database_helper.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:permission_handler/permission_handler.dart';

List<int> idList = [];
List<DataModel> itemList = [];
List<DataModel> itemListToDisplay = []; //just in case :)
List<DataModel> subItemList = [];

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: NavBar(
          scaffoldKey: _scaffoldKey,
          onItemClicked: () {
            setState(() {});
          }),
      backgroundColor: Color.fromARGB(255, 36, 32, 55),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Color.fromARGB(255, 239, 68, 74),
        title: const Text(
          "REDHOOD STORE",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: ItemList(),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Color.fromARGB(255, 239, 68, 74),
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddItemWidget()),
            ).then((_) {
              setState(() {});
            });
          }),
    );
  }

  Scaffold ItemList() {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 36, 32, 55),
      body: FutureBuilder<List<DataModel>>(
        future: DatabaseHelper.instance.retrieveItems(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            if (!subItemList.isEmpty) {
              itemListToDisplay = subItemList;
            } else {
              itemList = snapshot.data!;
              itemListToDisplay = itemList;
            }

            for (var item in itemList) {
              idList.add(item.itemID);
            }
            if (itemListToDisplay.isEmpty) {
              return const Text('No items.');
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
                          /*onPressed: (BuildContext context) {
                          deleteData(index, itemList[index].itemID);
                        },*/
                        ),
                      ],
                    ),
                    child: Container(
                      color: const Color.fromARGB(255, 56, 52, 85),
                      child: ListTile(
                        leading: Icon(
                          categoryIcon(subItemList.isEmpty
                              ? itemList[index].category
                              : subItemList[index].category),
                          color: Color.fromARGB(255, 243, 97, 100),
                        ),
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
        return Icons.water;
      case "FrozenFood":
        return Icons.icecream;
        break;
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
}

class NavBar extends StatefulWidget {
  //NavBar({super.key});
  final GlobalKey<ScaffoldState> scaffoldKey;
  final VoidCallback onItemClicked;
  const NavBar({
    Key? key,
    required this.scaffoldKey,
    required this.onItemClicked,
  }) : super(key: key);

  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  //GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color.fromARGB(255, 56, 52, 85),
      child: ListView(
        children: [
          AppBar(
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.red,
            title: const Text(
              "Categories",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            leading: Icon(Icons.done_all_sharp),
            title: const Text(
              'All items',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              widget.scaffoldKey.currentState?.closeDrawer();
              categoryFilter('All items', context);
              widget.onItemClicked();
            },
          ),
          ListTile(
            leading: Icon(Icons.smoking_rooms_sharp),
            title: const Text(
              'Cigarettes',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              categoryFilter('Cigarettes', context);
              widget.scaffoldKey.currentState?.closeDrawer();

              widget.onItemClicked();
            },
          ),
          ListTile(
            leading: Icon(Icons.wine_bar),
            title: const Text(
              'Liquor',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              categoryFilter('Liquor', context);
              widget.scaffoldKey.currentState?.closeDrawer();

              widget.onItemClicked();
            },
          ),
          ListTile(
            leading: Icon(Icons.water_drop),
            title: const Text(
              'Soft Drinks',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              categoryFilter('SoftDrinks', context);
              widget.scaffoldKey.currentState?.closeDrawer();

              widget.onItemClicked();
            },
          ),
          ListTile(
            leading: Icon(Icons.cookie),
            title: const Text(
              'Snacks',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              categoryFilter('Snacks', context);
              widget.scaffoldKey.currentState?.closeDrawer();

              widget.onItemClicked();
            },
          ),
          ListTile(
            leading: Icon(Icons.icecream),
            title: const Text(
              'Frozen food',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              categoryFilter('FrozenFood', context);
              widget.scaffoldKey.currentState?.closeDrawer();

              widget.onItemClicked();
            },
          ),
          ListTile(
            leading: Icon(Icons.question_mark),
            title: const Text(
              'Other',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              categoryFilter('Other', context);
              widget.scaffoldKey.currentState?.closeDrawer();

              widget.onItemClicked();
            },
          )
        ],
      ),
    );
  }
}

void categoryFilter(String chosenCategory, BuildContext contesxt) {
  subItemList = [];
  if (chosenCategory == 'All Items') {
    subItemList = itemList;
  }

  for (var item in itemList) {
    if (item.category == chosenCategory) {
      subItemList.add(item);
    }
  }
}
