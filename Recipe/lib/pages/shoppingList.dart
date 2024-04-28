import 'package:flutter/material.dart';
import 'package:learn/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:sqflite/sqflite.dart';

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
    'Cheese',
    'Yogurt',
  ];

  // Initialize the checked items list with the saved state
  late List<bool> _checkedItems;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadCheckedState();
  }

  @override
  void initState() {
    super.initState();
    // Initialize the checked items list with all false values
    _checkedItems = List<bool>.filled(_items.length, false);
    // Load the saved checked state from shared preferences
    _loadCheckedState();
  }

  // Load the saved checked state from shared preferences
  void _loadCheckedState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedCheckedItemsJson = prefs.getString(_checkedItemsKey);
    if (savedCheckedItemsJson != null) {
      List<dynamic> savedCheckedItemsList = jsonDecode(savedCheckedItemsJson);
      setState(() {
        _checkedItems = savedCheckedItemsList.map((item) => item as bool).toList();
      });
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
    if (_selectedIndex == 0) {
      _saveCheckedState();
      print("heeeere ee");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MyHomePage(title: "Weekly Overview")),
      );
    } else if (_selectedIndex == 1) {
      // Save the checked state before navigating back to the shopping list
      _saveCheckedState();
      //Navigator.pop(context); // Navigate back
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
            title: Text(_items[index]),
            trailing: Checkbox(
              value: _checkedItems[index],
              onChanged: (value) {
                setState(() {
                  _checkedItems[index] = value!;
                });
              },
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
