import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PrepareRecipeFormDialog {
  static Future<void> showFormDialog(
      BuildContext context,
      GlobalKey<FormState> formKey,
      TextEditingController ingredients,
      TextEditingController cuisine,
      TextEditingController dietaryRestrictions,
      Future<void> Function() prepareRecipe,
      ) async {

    return showDialog(
      context: context,
      builder: (context) {
        return Form(
          key: formKey,
          child: AlertDialog(
            title: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Enter the requirements",
                  style: GoogleFonts.roboto(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: ingredients,
                    minLines: 1,
                    maxLines: null,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Ingredients must not be empty!";
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Enter ingredients",
                      prefixIcon: Icon(Icons.list),
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: cuisine,
                    minLines: 1,
                    maxLines: null,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Cuisine must not be empty!";
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Enter cuisine",
                      prefixIcon: Icon(Icons.fastfood),
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: dietaryRestrictions,
                    minLines: 1,
                    maxLines: null,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Dietary restrictions must not be empty!";
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Enter dietary restrictions",
                      prefixIcon: Icon(Icons.warning),
                    ),
                  ),
                ],
              )
            ),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    debugPrint("Prepare Recipe button pressed!");
                    await prepareRecipe();
                    if (context.mounted) Navigator.of(context).pop();
                  } else {
                    debugPrint("Validation failed.");
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
                child: const Text("Prepare Recipe"),
              ),
            ],
          ),
        );
      },
    );
  }
}
