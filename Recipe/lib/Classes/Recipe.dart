import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:core';

class Recipe {
  Map<String, dynamic> data = {}; // Initialize with an empty Map
  String imageURL = ''; // Initialize with an empty String
  List<List<String>> ingredients = []; // Initialize with an empty List
  List<String> stepsForRecipe = []; // Initialize with an empty List
  String title = "";
  String preparationMin = "";
  String cookingMin = "";

  //Constructor
  Recipe(Map<String, dynamic>? data){
    //print("Dattttttta: $data");
    if (data != null && data['recipes'] != null && data['recipes'].isNotEmpty) {
      // Check if 'recipes' is not null and not empty
      try {
        this.data = data;
        imageURL = data['recipes'][0]['image'] ?? '';
        title = data['recipes'][0]['title'];
        preparationMin = data['recipes'][0]['preparationMinutes'].toString();
        cookingMin = data['recipes'][0]['cookingMinutes'].toString();
        if (preparationMin == "-1"){
          preparationMin = "10";
        }
        if (cookingMin == "-1"){
          cookingMin = "30";
        }
        setIngredients(data);
        setSteps(data);
      } catch (e) {
        print('Exception in Recipe constructor: $e');
      }
    } else {
      print('Data is null or empty');
    }
  }


  void setIngredients(Map<String, dynamic> data) {
    try {
      Map<String, dynamic> firstRecipe = data['recipes'].first;
      List<dynamic> extendedIngredients = firstRecipe['extendedIngredients'];

      //go through each ingredient list
      for (var ingredient in extendedIngredients) {
        //get ingredient name and amount
        String ingredientName = ingredient["name"];
        double ingredientAmount = ingredient["amount"].toDouble();
        String ingredientUnit = ingredient["unit"];
        List<String> oneIngredient = [ingredientName, ingredientAmount.toString(), ingredientUnit];
        ingredients.add(oneIngredient); //add to list of ingredients
      }
    } catch (e) {
      print('Exception in makeIngredientsSet: $e');
    }
  }

  void setSteps(Map<String, dynamic> data) {
    try {
      //List<String> allSteps = data['recipes'][0]['analyzedInstructions'];
      List<dynamic> allSteps = data['recipes'][0]['analyzedInstructions'][0]['steps'];
      // List to store the text of all steps
      List<String> steps = [];
      // Extract the text of each step
      for (var step in allSteps) {
        steps.add(step['step']);
      }
      stepsForRecipe = steps;
    } catch (e) {
      print('Exception in fetchingSteps: $e');
    }
  }

  List<String> getSteps() {
    return this.stepsForRecipe;
  }

  List<List<String>> getIngredients(){
    return this.ingredients;
  }

  String getImageUrl(){
    return this.imageURL;
  }
  String getTitle(){
    return this.title;
  }

  String getPreparationMin(){
    return this.preparationMin;
  }
  String getCookingMin(){
    return this.cookingMin;
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
      ],
    );
  }
}
