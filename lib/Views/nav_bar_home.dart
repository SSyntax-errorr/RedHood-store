// ignore: file_names
import 'package:flutter/material.dart';
import 'package:store/Views/home.dart';

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

int drawerIndex =
    0; //*TEMPORARY SOLUTION TO REMEMBERING DRAWER INDEX AFTER CLOSE.
//TODO: CHANGE TO LOCAL WHENEVER POSSIBLE

class _NavBarState extends State<NavBar> {
  //GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();

    _selectedIndex = drawerIndex;
  }

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
            selected: _selectedIndex == 0,
            selectedColor: redColor,
            selectedTileColor: const Color.fromARGB(255, 39, 36, 60),
            leading: const Icon(Icons.done_all_sharp),
            title: const Text(
              'All items',
              style: TextStyle(color: Colors.white),
            ),
            trailing: Text(
              itemList.length.toString(),
              style: const TextStyle(color: Colors.white),
            ),
            onTap: () {
              setState(() {
                _selectedIndex = 0;
                drawerIndex = 0;
              });
              subItemList = [];
              widget.scaffoldKey.currentState?.closeDrawer();
              //categoryFilter('All items', context);
              itemListToDisplay = itemList;
              widget.onItemClicked();
            },
          ),
          ListTile(
            leading: const Icon(Icons.star),
            selected: _selectedIndex == 1,
            selectedColor: redColor,
            selectedTileColor: const Color.fromARGB(255, 39, 36, 60),
            title: const Text(
              'Common Items',
              style: TextStyle(color: Colors.white),
            ),
            trailing: Text(
              itemList.where((item) => item.isCommon == 1).length.toString(),
              style: const TextStyle(color: Colors.white),
            ),
            onTap: () {
              commonItemsFilter();

              widget.scaffoldKey.currentState?.closeDrawer();
              widget.onItemClicked();
              setState(() {
                drawerIndex = 1;
                _selectedIndex = 1;
              });
            },
          ),
          ListTile(
            leading: const Icon(Icons.smoking_rooms_sharp),
            selected: _selectedIndex == 2,
            selectedColor: redColor,
            selectedTileColor: const Color.fromARGB(255, 39, 36, 60),
            title: const Text(
              'Cigarettes',
              style: TextStyle(color: Colors.white),
            ),
            trailing: Text(
              itemList
                  .where((item) => item.category == 'Cigarettes')
                  .length
                  .toString(),
              style: const TextStyle(color: Colors.white),
            ),
            onTap: () {
              setState(() {
                drawerIndex = 2;
                _selectedIndex = 2;
              });
              categoryFilter('Cigarettes', context);
              widget.scaffoldKey.currentState?.closeDrawer();

              widget.onItemClicked();
            },
          ),
          ListTile(
            leading: const Icon(Icons.wine_bar),
            selected: _selectedIndex == 3,
            selectedColor: redColor,
            selectedTileColor: const Color.fromARGB(255, 39, 36, 60),
            title: const Text(
              'Liquor',
              style: TextStyle(color: Colors.white),
            ),
            trailing: Text(
              itemList
                  .where((item) => item.category == 'Liquor')
                  .length
                  .toString(),
              style: const TextStyle(color: Colors.white),
            ),
            onTap: () {
              setState(() {
                drawerIndex = 3;
                _selectedIndex = 3;
              });
              categoryFilter('Liquor', context);
              widget.scaffoldKey.currentState?.closeDrawer();

              widget.onItemClicked();
            },
          ),
          ListTile(
            leading: const Icon(Icons.water_drop),
            selected: _selectedIndex == 4,
            selectedColor: redColor,
            selectedTileColor: const Color.fromARGB(255, 39, 36, 60),
            title: const Text(
              'Non Alcoholic Drinks',
              style: TextStyle(color: Colors.white),
            ),
            trailing: Text(
              itemList
                  .where((item) =>
                      item.category == 'SoftDrinks' ||
                      item.category == 'NonAlcoholic')
                  .length
                  .toString(),
              style: const TextStyle(color: Colors.white),
            ),
            onTap: () {
              setState(() {
                drawerIndex = 4;
                _selectedIndex = 4;
              });
              categoryFilter('NonAlcoholic', context);
              widget.scaffoldKey.currentState?.closeDrawer();

              widget.onItemClicked();
            },
          ),
          ListTile(
            leading: const Icon(Icons.cookie),
            selected: _selectedIndex == 5,
            selectedColor: redColor,
            selectedTileColor: const Color.fromARGB(255, 39, 36, 60),
            title: const Text(
              'Snacks',
              style: TextStyle(color: Colors.white),
            ),
            trailing: Text(
              itemList
                  .where((item) => item.category == 'Snacks')
                  .length
                  .toString(),
              style: const TextStyle(color: Colors.white),
            ),
            onTap: () {
              setState(() {
                drawerIndex = 5;
                _selectedIndex = 5;
              });
              categoryFilter('Snacks', context);
              widget.scaffoldKey.currentState?.closeDrawer();

              widget.onItemClicked();
            },
          ),
          ListTile(
            leading: const Icon(Icons.ramen_dining),
            selected: _selectedIndex == 6,
            selectedColor: redColor,
            selectedTileColor: const Color.fromARGB(255, 39, 36, 60),
            title: const Text(
              'Food',
              style: TextStyle(color: Colors.white),
            ),
            trailing: Text(
              itemList
                  .where((item) => item.category == 'Food')
                  .length
                  .toString(),
              style: const TextStyle(color: Colors.white),
            ),
            onTap: () {
              setState(() {
                drawerIndex = 6;
                _selectedIndex = 6;
              });
              categoryFilter('Food', context);
              widget.scaffoldKey.currentState?.closeDrawer();

              widget.onItemClicked();
            },
          ),
          ListTile(
            leading: const Icon(Icons.question_mark),
            selected: _selectedIndex == 7,
            selectedColor: redColor,
            selectedTileColor: const Color.fromARGB(255, 39, 36, 60),
            title: const Text(
              'Other',
              style: TextStyle(color: Colors.white),
            ),
            trailing: Text(
              itemList
                  .where((item) => item.category == 'Other')
                  .length
                  .toString(),
              style: const TextStyle(color: Colors.white),
            ),
            onTap: () {
              setState(() {
                drawerIndex = 7;
                _selectedIndex = 7;
              });
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

void categoryFilter(String chosenCategory, BuildContext fuckcontext) {
  subItemList = [];
  itemListToDisplay = [];
  for (var item in itemList) {
    if (item.category == chosenCategory) {
      subItemList.add(item);
      itemListToDisplay.add(item);
    }
  }
}

void commonItemsFilter() {
  subItemList = [];
  itemListToDisplay = [];
  for (var item in itemList) {
    if (item.isCommon == 1) {
      subItemList.add(item);
      itemListToDisplay.add(item);
    }
  }
}
