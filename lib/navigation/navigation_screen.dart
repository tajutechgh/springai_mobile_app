import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:springai_mobile_app/screens/chat_ai_model_screen.dart';
import 'package:springai_mobile_app/screens/image_generation_model_screen.dart';
import 'package:springai_mobile_app/screens/recipe_preparation_model_screen.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  int currentPageIndex = 0;

  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return const ChatAiModelScreen();
      case 1:
        return const ImageGenerationModelScreen();
      case 2:
        return const RecipePreparationModelScreen();
      default:
        return const ChatAiModelScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80.0),
        child: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: Colors.blueAccent,
          elevation: 5.0,
          title: Padding(
            padding: const EdgeInsets.all(40),
            child: Text(
              "Taju Ai App",
              style: GoogleFonts.roboto(
                textStyle: Theme.of(context).textTheme.displayLarge,
                fontSize: 30,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.normal,
                letterSpacing: 1,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        backgroundColor: Colors.blueAccent,
        height: 120,
        elevation: 10.0,
        labelTextStyle: WidgetStateProperty.all(
          const TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: Colors.orangeAccent,
        selectedIndex: currentPageIndex,
        destinations: [
          NavigationDestination(
            icon: Image.asset("assets/images/chat.png", width: 35,),
            label: 'Ask Taju',
          ),
          NavigationDestination(
            icon: Image.asset("assets/images/picture.png", width: 35,),
            label: 'Generate Image',
          ),
          NavigationDestination(
            icon: Image.asset("assets/images/recipe.png", width: 35,),
            label: 'Prepare Recipe',
          ),
        ],
      ),
      body: _getPage(currentPageIndex),
    );
  }
}
