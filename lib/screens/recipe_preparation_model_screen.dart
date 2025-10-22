import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RecipePreparationModelScreen extends StatefulWidget {
  const RecipePreparationModelScreen({super.key});

  @override
  State<RecipePreparationModelScreen> createState() => _RecipePreparationModelScreenState();
}

class _RecipePreparationModelScreenState extends State<RecipePreparationModelScreen> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Padding(
          padding: EdgeInsets.all(10),
          child: Card(
            child: SizedBox(
              height: 200,
              child: ListTile(
                leading: Icon(Icons.fastfood),
                title: Text(
                  'Your recipe preparation will appear here!',
                  style: GoogleFonts.roboto(
                    textStyle: Theme.of(context).textTheme.displayLarge,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.normal,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),
          ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
        },
        backgroundColor: Colors.blueAccent,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
