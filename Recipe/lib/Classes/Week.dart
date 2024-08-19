import 'package:learn/Classes/DayRecipe.dart';
import 'package:learn/Classes/Ingredient.dart';
import 'package:learn/Classes/Amount.dart';

class Week {

  int id;
  late List<DayRecipe> recipes;
  late Map<Ingredient, Amount> ingredientsList;

  Week({
    required this.id,
    //required Function() makeRecipes
  }) {
    makeRecipes(); //make recipes when week object is created
  }

  /**
   * get 7 random recipes from DB.
   * @assures that no recipe is repeated in 5 weeks
   */
  void makeRecipes(){
    recipes = [];
    // Logic to get 7 recipes
    storeRecipes(recipes);

  }

  /**
   * get all the ingredients needed for the week and the corresponding amount.
   * @assures that ingrediens that are double are added together
   */
  void makeIngredientsList(){
    ingredientsList = {};
  }

  /**
   * stores the recipes in the DB for this week
   */
  void storeRecipes(List<DayRecipe> recipes){

  }




}