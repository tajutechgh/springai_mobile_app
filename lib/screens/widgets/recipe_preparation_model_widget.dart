import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../navigation/navigation_screen.dart';

class RecipePreparationModelWidget extends StatelessWidget {
  const RecipePreparationModelWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: InkWell(
        onTap: (){
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return NavigationScreen();
              },
            ),
          );
        },
        child: Container(
          height: 150,
          constraints: const BoxConstraints(minWidth: 0),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.blueAccent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("assets/images/recipe.png", width: 60,),
                  SizedBox(width: 10,),
                  Text(
                    "Prepare Recipe",
                    style: GoogleFonts.roboto(
                        textStyle: Theme.of(context).textTheme.displayLarge,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.normal,
                        letterSpacing: 1,
                        color: Colors.white
                    ),
                  ),
                ],
              )
          ),
        ),
      ),
    );
  }
}
