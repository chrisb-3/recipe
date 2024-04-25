import 'package:flutter/material.dart';
import 'package:learn/main.dart';

class ShoppingList extends StatefulWidget {
  const ShoppingList({Key? key});

  @override
  _ShoppingListState createState() => _ShoppingListState();
}

class _ShoppingListState extends State<ShoppingList> {

  List<String> _items = [
    'Apples',
    'Bananas',
    'Milk',
    'Bread',
    'Eggs',
    'Cheese',
    'Yogurt',
  ];

  List<bool> _checkedItems = List.generate(7, (index) => false);

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
    );
  }
}
