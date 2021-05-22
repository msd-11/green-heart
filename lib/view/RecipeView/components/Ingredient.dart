import 'package:flutter/material.dart';

Container Ingredient(List documents, int index) {
  return Container(
      width: 150.0,
      color: Colors.green[600],
      child: Column(
        children: [
          Text(documents[index]["name"]),
          Text(documents[index]["amount"]["metric"]["value"].toString() +
              " " +
              documents[index]["amount"]["metric"]["unit"].toString())
        ],
      ));
}
