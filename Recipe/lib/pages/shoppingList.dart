import 'package:flutter/material.dart';
import 'package:learn/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:learn/DB/database.dart';


class ShoppingList extends StatefulWidget {
  const ShoppingList({Key? key});

  @override
  _ShoppingListState createState() => _ShoppingListState();
}

class _ShoppingListState extends State with WidgetsBindingObserver {
  int _selectedIndex = 1; // Default to Shopping List page

  // Define a key for storing the checked items in shared preferences
  static const String _checkedItemsKey = 'checked_items';

  List<String> _items = [
    'Apples',
    'Bananas',
    'Milk',
    'Bread',
    'Eggs',
    'Bread',
    'Eggs'
  ];

  late List<bool> _checkedItems; // list of checkboxes
  late Database _database;



  //method to get the correct ingredients and the amount that has to be bought for the week
  void setItemsList(){
    //get data from database

    //put items in _items
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadCheckedState();
  }

  @override
  void initState() {
    super.initState();
    // Initialize the checked items list with all false values
    _checkedItems = List<bool>.filled(_items.length, false); //make them all false at first
    // Load the saved checked state from shared preferences
    _loadCheckedState();
    _openDatabase();
  }

  Future<void> _openDatabase() async {
    _database = await DBHelper.database;
  }

  // Load the saved checked state from shared preferences
  void _loadCheckedState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedCheckedItemsJson = prefs.getString(_checkedItemsKey); //savedCheckedItemsJson is a list of booleans
    print("PREF: " + savedCheckedItemsJson.toString());
    if(savedCheckedItemsJson != null) {
      List<dynamic> savedCheckedItemsList = jsonDecode(savedCheckedItemsJson);
      if(savedCheckedItemsList.length != _items.length){
        print("HERE: " + savedCheckedItemsList.length.toString() + "     "  + savedCheckedItemsJson.length.toString() + "      "+ _items.length.toString());
        _saveCheckedState();
        //_checkedItems = savedCheckedItemsList.map((item) => item as bool).toList();
      }
      else if (savedCheckedItemsList.length == _items.length) {
        print("ARRIVED Here");
        List<dynamic> savedCheckedItemsList = jsonDecode(savedCheckedItemsJson);
        setState(() {
          _checkedItems = savedCheckedItemsList.map((item) => item as bool).toList();
        });
      }
    }
  }

  // Save the checked state to shared preferences for page navigation
  Future<void> _saveCheckedState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String checkedItemsJson = jsonEncode(_checkedItems);
    await prefs.setString(_checkedItemsKey, checkedItemsJson);
  }

  // Handle navigation to different pages
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _saveCheckedState();
    if (_selectedIndex == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MyHomePage(title: "Weekly Overview")),
      );
    }
  }

  void _updateCheckedItems() {
    setState(() {
      _checkedItems = List<bool>.filled(_items.length, false);
    });
    _saveCheckedState(); // Save the updated checked state
  }


  @override
  void didUpdateWidget(covariant ShoppingList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if ((oldWidget.key as GlobalKey<_ShoppingListState>).currentState!._items.length != _items.length) {
      _updateCheckedItems();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping List'),
      ),
      body: ListView.builder(
        itemCount: _items.length,
        itemBuilder: (context, index) {
          return ListTile(
            onTap: () {
              setState(() {
                _checkedItems[index] = !_checkedItems[index];
              });
            },
            title: Text(_items[index]),
            trailing: Checkbox(
              value: _checkedItems[index], //the checkbox is either checked or not
              onChanged: (value) {
                setState(() {
                  _checkedItems[index] = value!;
                });
              },
              activeColor: Colors.green,
            ),
            tileColor: _checkedItems[index] ? Colors.grey.shade300 : null,
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month_sharp),
            label: 'Weekly Overview',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.checklist_rtl),
            label: 'List',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: _selectedIndex == 0 ? Colors.blue : null, // Update color based on selectedIndex
        onTap: _onItemTapped,
      ),
    );
  }

}
