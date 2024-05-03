import 'package:flutter/material.dart';
import 'package:store/Screens/home.dart';

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
            leading: const Icon(Icons.done_all_sharp),
            title: const Text(
              'All items',
              style: TextStyle(color: Colors.white),
            ),
            trailing: Text(
              itemList.length.toString(),
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              subItemList = [];
              widget.scaffoldKey.currentState?.closeDrawer();
              //categoryFilter('All items', context);
              itemListToDisplay = itemList;
              widget.onItemClicked();
            },
          ),
          ListTile(
            leading: const Icon(Icons.smoking_rooms_sharp),
            title: const Text(
              'Cigarettes',
              style: TextStyle(color: Colors.white),
            ),
            trailing: Text(
              itemList
                  .where((item) => item.category == 'Cigarettes')
                  .length
                  .toString(),
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              categoryFilter('Cigarettes', context);
              widget.scaffoldKey.currentState?.closeDrawer();

              widget.onItemClicked();
            },
          ),
          ListTile(
            leading: const Icon(Icons.wine_bar),
            title: const Text(
              'Liquor',
              style: TextStyle(color: Colors.white),
            ),
            trailing: Text(
              itemList
                  .where((item) => item.category == 'Liquor')
                  .length
                  .toString(),
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
            trailing: Text(
              itemList
                  .where((item) => item.category == 'SoftDrinks')
                  .length
                  .toString(),
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              categoryFilter('SoftDrinks', context);
              widget.scaffoldKey.currentState?.closeDrawer();

              widget.onItemClicked();
            },
          ),
          ListTile(
            leading: const Icon(Icons.cookie),
            title: const Text(
              'Snacks',
              style: TextStyle(color: Colors.white),
            ),
            trailing: Text(
              itemList
                  .where((item) => item.category == 'Snacks')
                  .length
                  .toString(),
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              categoryFilter('Snacks', context);
              widget.scaffoldKey.currentState?.closeDrawer();

              widget.onItemClicked();
            },
          ),
          ListTile(
            leading: const Icon(Icons.icecream),
            title: const Text(
              'Frozen food',
              style: TextStyle(color: Colors.white),
            ),
            trailing: Text(
              itemList
                  .where((item) => item.category == 'FrozenFood')
                  .length
                  .toString(),
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              categoryFilter('FrozenFood', context);
              widget.scaffoldKey.currentState?.closeDrawer();

              widget.onItemClicked();
            },
          ),
          ListTile(
            leading: const Icon(Icons.question_mark),
            title: const Text(
              'Other',
              style: TextStyle(color: Colors.white),
            ),
            trailing: Text(
              itemList
                  .where((item) => item.category == 'Other')
                  .length
                  .toString(),
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
