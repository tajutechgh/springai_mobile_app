import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ImageGenerationModelScreen extends StatefulWidget {
  const ImageGenerationModelScreen({super.key});

  @override
  State<ImageGenerationModelScreen> createState() => _ImageGenerationModelScreenState();
}

class _ImageGenerationModelScreenState extends State<ImageGenerationModelScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String imageType;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                TextFormField(
                  onChanged: (value) {
                    imageType = value;
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Image type must not be empty!";
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                    label: Text(
                      "Enter the image type here",
                      style: GoogleFonts.roboto(
                        textStyle: Theme.of(context).textTheme.displayLarge,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                    focusColor: Colors.blue,
                    prefixIcon: const Icon(Icons.image),
                  ),
                ),
                const SizedBox(height: 30),
                InkWell(
                  onTap: () {},
                  child: Container(
                    height: 50,
                    width: screenWidth - 20,
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        "Generate Image",
                        style: GoogleFonts.roboto(
                          textStyle: Theme.of(context).textTheme.displayLarge,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Card(
                        clipBehavior: Clip.antiAlias,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: AspectRatio(
                          aspectRatio: 1, // Keeps image square
                          child: Image.network(
                            "https://flutter.github.io/assets-for-api-docs/assets/widgets/owl-2.jpg",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Card(
                        clipBehavior: Clip.antiAlias,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: Image.network(
                            "https://flutter.github.io/assets-for-api-docs/assets/widgets/owl-2.jpg",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
