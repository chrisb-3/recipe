import 'package:learn/Classes/Ingredient.dart';

class DayRecipe {
  int id;
  String title;
  int preparation_time;
  int cooking_time;
  String imgURL;
  late List<Ingredient> ingredient_list;
  late List<String> step_list;

  DayRecipe({
    required this.id,
    required this.title,
    required this.preparation_time,
    required this.cooking_time,
    required this.imgURL
});

  /** make a list of all needed ingredients */
  Future<List<Ingredient>>? getIngredients(){
    return null;
  }

  /** get the coresponding amount of the ingredient for this recipe */
  Future<int> getAmount(Ingredient ingredient) async {
    return -1;
  }

  /** get the list of all steps for this recipe */
  Future<List<String>?> getSteps() async {
    return null;
  }

  /** claculate the calories of a recipe
   * @requires ingredients list
   * @requires amount per ingredient
   */
  int calcKcla(){
    return -1;
  }


  // Convert DayRecipe object into a Map / Json
  Map<String, dynamic> toJson() => {
    'id_recipe': id,
    'title': title,
    'prepare_time': preparation_time,
    'cook_time': cooking_time,
    'imgURL': imgURL
  };

  // Create DayRecipe object from a Map / Json
  static DayRecipe fromJson(Map<String, dynamic> json) => DayRecipe(
    id: json['id_recipe'] as int,
    title: json['title'] as String,
    preparation_time: json['prepare_time'] as int,
    cooking_time: json['cook_time'] as int,
    imgURL: json['imgURL'] as String
  );
}