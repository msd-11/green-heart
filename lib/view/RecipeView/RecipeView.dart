import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:green_heart/controllers/RecipeController.dart';
import 'package:green_heart/models/Ingredients.dart';
import 'package:green_heart/models/Instructions.dart';
import 'package:green_heart/view/RecipeView/components/Ingredient.dart';

import 'components/Instruction.dart';

class RecipeView extends StatefulWidget {
  RecipeView(this.meal);

  final LinkedHashMap<String, dynamic> meal;

  @override
  _RecipeViewState createState() => _RecipeViewState();
}

class _RecipeViewState extends State<RecipeView> {
  RecipeController c = Get.put(RecipeController());

  @override
  void initState() {
    c.initFuture(
        widget.meal.entries.firstWhere((element) => element.key == "id").value);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
          centerTitle: true,
          title: Text(
              widget.meal.entries
                  .firstWhere((element) => element.key == "title")
                  .value,
              style: TextStyle(color: Colors.black)),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () => Get.back(),
          ),
          actions: [
            IconButton(
                icon: Obx(
                  () => Icon(
                    c.isFavorite.value == true
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color:
                        c.isFavorite.value == true ? Colors.red : Colors.black,
                  ),
                ),
                onPressed: () => c.addFavorite(widget.meal)),
            IconButton(
              icon: Icon(Icons.send, color: Colors.black87),
              onPressed: () => c.sendEmail(widget.meal),
            ),
          ],
        ),
        body: SafeArea(
            child: SingleChildScrollView(
          child: Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: Image.network(
                    widget.meal.entries
                        .firstWhere((element) => element.key == "image")
                        .value,
                    filterQuality: FilterQuality.high,
                  ),
                ),
                OutlinedButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0))),
                      foregroundColor: MaterialStateProperty.all(Colors.white),
                      backgroundColor:
                          MaterialStateProperty.all(Color(0xFF36DC55)),
                    ),
                    onPressed: () => c.eatMeal(widget.meal),
                    child: Text("Eat this meal")),
                SizedBox(height: 5.0),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    child: Text("Ingredients",
                        style: TextStyle(
                          color: Colors.green[600],
                          fontSize: 25.0,
                        )),
                    alignment: Alignment.centerLeft,
                  ),
                ),
                SizedBox(height: 15.0),
                Container(
                  height: 120.0,
                  child: FutureBuilder<Ingredients>(
                    future: c.futureIngredients,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final List<dynamic> documents =
                            snapshot.data.ingredients;
                        return ListView.separated(
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return SizedBox(width: 3);
                            },
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: false,
                            itemCount: documents.length,
                            itemBuilder: (context, index) {
                              return Ingredient(documents, index);
                            });
                      } else if (snapshot.hasError) {
                        return SafeArea(child: Text("${snapshot.error}"));
                      }

                      // By default, show a loading spinner.
                      return CircularProgressIndicator();
                    },
                  ),
                ),
                SizedBox(height: 25.0),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Instructions",
                        style: TextStyle(
                          color: Colors.green[600],
                          fontSize: 25.0,
                        )),
                  ),
                ),
                SizedBox(height: 25.0),
                FutureBuilder<Instructions>(
                  future: c.futureInstructions,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final List<dynamic> documents =
                          snapshot.data.instructions;
                      return ListView.separated(
                          separatorBuilder: (BuildContext context, int index) {
                            return SizedBox(height: 25);
                          },
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: documents.length,
                          itemBuilder: (context, index) {
                            return Instruction(documents, index);
                          });
                    } else if (snapshot.hasError) {
                      return SafeArea(child: Text("${snapshot.error}"));
                    }

                    // By default, show a loading spinner.
                    return CircularProgressIndicator();
                  },
                ),
              ],
            ),
          ),
        )));
  }
}
