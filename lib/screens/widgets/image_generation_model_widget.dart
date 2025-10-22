import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ImageGenerationModelWidget extends StatelessWidget {
  const ImageGenerationModelWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: InkWell(
        onTap: (){

        },
        child: Container(
          height: 150,
          width: MediaQuery.of(context).size.width-20,
          decoration: BoxDecoration(
            color: Colors.blueAccent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("assets/icons/picture.png", width: 50,),
                  SizedBox(width: 10,),
                  Text(
                    "Generate Image",
                    style: GoogleFonts.roboto(
                        textStyle: Theme.of(context).textTheme.displayLarge,
                        fontSize: 30,
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
