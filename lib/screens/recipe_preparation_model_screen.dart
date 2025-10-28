import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:springai_mobile_app/form_dialogs/prepare_recipe_form_dialog.dart';

import '../services/gen_ai_service.dart';

class RecipePreparationModelScreen extends StatefulWidget {
  const RecipePreparationModelScreen({super.key});

  @override
  State<RecipePreparationModelScreen> createState() =>
      _RecipePreparationModelScreenState();
}

class _RecipePreparationModelScreenState
    extends State<RecipePreparationModelScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController ingredientsController = TextEditingController();
  final TextEditingController cuisineController = TextEditingController();
  final TextEditingController dietaryRestrictionsController =
      TextEditingController();

  bool _isLoading = false;
  late Future<String?> futurePrepareRecipeInput;
  late Future<String?> getPrepareRecipeResponse;

  @override
  void initState() {
    super.initState();
    _refreshRecipePreparationModelScreen();
  }

  void _refreshRecipePreparationModelScreen() {
    setState(() {
      getPrepareRecipeResponse = GenAiService.getPreparedRecipe();
      _isLoading = false;
    });
  }

  Future<void> prepareRecipe() async {
    if (kDebugMode) print("prepareRecipe() called");

    if (!formKey.currentState!.validate()) return;

    final ingredientsText = ingredientsController.text.trim();
    final cuisineText = cuisineController.text.trim();
    final dietaryRestrictionsText = dietaryRestrictionsController.text.trim();

    if (ingredientsText.isEmpty ||
        cuisineText.isEmpty ||
        dietaryRestrictionsText.isEmpty) {
      return;
    }

    setState(() {
      _isLoading = true;
      futurePrepareRecipeInput = GenAiService.getPrepareRecipeModelResponse(
        ingredientsText,
        cuisineText,
        dietaryRestrictionsText,
      );
    });

    try {
      await futurePrepareRecipeInput;

      // Clear input after successful submission
      ingredientsController.clear();
      cuisineController.clear();
      dietaryRestrictionsController.clear();
    } catch (exception) {
      throw ("An error occurred while processing your form");
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
        _refreshRecipePreparationModelScreen();
      }
    }
  }

  void clearPreparedRecipe() async {
    GenAiService.clearPreparedRecipePreferencesStorage();
    _refreshRecipePreparationModelScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<String?>(
          future: getPrepareRecipeResponse,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Error: ${snapshot.error}',
                  style: GoogleFonts.roboto(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              );
            }
            // no recipe
            if (snapshot.data == null || snapshot.data!.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Hello Taju Here!',
                      style: GoogleFonts.roboto(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                        color: Colors.deepOrange,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    const Icon(
                      Icons.waving_hand,
                      color: Colors.deepOrange,
                      size: 30,
                    ),
                  ],
                ),
              );
            }
            // recipe data exists
            final response = snapshot.data!;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.delete, size: 25, color: Colors.red),
                      TextButton(
                        onPressed: clearPreparedRecipe,
                        child: Text(
                          "Clear The Prepared Recipe",
                          style: GoogleFonts.roboto(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        response,
                        style: GoogleFonts.roboto(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 80),
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          _isLoading == true
              ? const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                )
              : await PrepareRecipeFormDialog.showFormDialog(
                  context,
                  formKey,
                  ingredientsController,
                  cuisineController,
                  dietaryRestrictionsController,
                  prepareRecipe,
                );
        },
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
