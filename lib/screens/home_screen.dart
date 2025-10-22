import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:springai_mobile_app/screens/widgets/chat_ai_model_widget.dart';
import 'package:springai_mobile_app/screens/widgets/image_generation_model_widget.dart';
import 'package:springai_mobile_app/screens/widgets/recipe_preparation_model_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0),
        child: AppBar(
          backgroundColor: Colors.lightBlue,
          elevation: 4.0,
          title: Center(
              child: Text(
                "TajuDN AI App",
                style: GoogleFonts.bungeeSpice(
                  textStyle: Theme.of(context).textTheme.displayLarge,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.normal,
                  letterSpacing: 1
                )
              )
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(14),
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 40,),
              ChatAiModelWidget(),
              SizedBox(height: 15,),
              ImageGenerationModelWidget(),
              SizedBox(height: 15,),
              RecipePreparationModelWidget(),
              SizedBox(height: 30,),
              Text(
                  "Powered By @TajutechGH",
                  style: GoogleFonts.roboto(
                    textStyle: Theme.of(context).textTheme.displayLarge,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.normal,
                    letterSpacing: 1,
                    color: Colors.blueAccent
                  )
              )
            ],
          ),
        ),
      ),
    );
  }
}
