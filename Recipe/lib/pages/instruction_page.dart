import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:core';
import '../Classes/Recipe.dart';

//import 'lib/Classes/Recipe';

class InstructionPage extends StatefulWidget {
  const InstructionPage({Key? key});

  @override
  State<InstructionPage> createState() => _InstructionPageState();
}

class _InstructionPageState extends State<InstructionPage> {
  Recipe recipe = Recipe({});

  Future<void> fetchRandomRecipes() async {
    const String apiKey = '91656d4b1aa54efc824aaf5ba4192025';
    //const String apiKey = '560efc17aa5a4eca95183945809e1f6a';
    const String apiUrl = 'https://api.spoonacular.com/recipes/random';
    const int number = 1; // Number of random recipes to retrieve

    try {
      final response = await http.get(
        Uri.parse('$apiUrl?number=$number&include-tags=dinner&apiKey=$apiKey'),
      );
      if (response.statusCode == 200) {
        // Data fetch successful
        final Map<String, dynamic> data = jsonDecode(response.body);
        //print('Random Recipeeeeeees: $data');
        recipe = new Recipe(jsonDecode(response.body));
        //print('Response body: ${response.body}');
      } else {// Error
        print('Error: ${response.statusCode}');
      }
    } catch (e) {// Exception
      print('Exception: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Today's Meal",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: FutureBuilder<void>(
        future: fetchRandomRecipes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else
            if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<Ingredient> ingredientsList = [];
            for (var ingredient in recipe.getIngredients()){
              ingredientsList.add(Ingredient(ingredient[1] + " " + ingredient[2], ingredient[0]));
            }

            return SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    recipe.getTitle(),
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _TimeWidget(icon: Icons.access_time, time: recipe.getPreparationMin()),
                      _TimeWidget(icon: Icons.local_dining, time: recipe.getCookingMin()),
                    ],
                  ),
                  SizedBox(height: 10),
                  Image.network(
                    recipe.getImageUrl(),
                    loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      } else {
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        );
                      }
                    },
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Ingredients:',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  buildIngredientsTable(ingredientsList),
                  SizedBox(height: 10),
                  Text(
                    'Instructions:',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  Column(
                    children: [
                      for (int i = 1; i <= recipe.getSteps().length; i++)
                        _InstructionBlock(title: "Step $i", description: recipe.getSteps()[i - 1]),
                    ],
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
  Widget buildIngredientsTable(List<Ingredient> ingredients) {
    return Table(
      border: TableBorder.all(),
      children: ingredients.map((ingredient) {
        return TableRow(
          children: [
            TableCell(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  ingredient.amount,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            TableCell(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  ingredient.name,
                ),
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
}

class Ingredient {
  final String amount;
  final String name;

  Ingredient(this.amount, this.name);
}

class _TimeWidget extends StatelessWidget {
  final IconData icon;
  final String time;

  const _TimeWidget({Key? key, required this.icon, required this.time})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon),
        SizedBox(width: 5),
        Text(time),
      ],
    );
  }
}

class _InstructionBlock extends StatelessWidget {
  final String title;
  final String description;

  const _InstructionBlock({
    Key? key,
    required this.title,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 5),
        Text(description),
        SizedBox(height: 10),
        Divider(color: Colors.white,), // Add a Divider widget between each step
      ],
    );
  }
}

