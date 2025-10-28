import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../services/gen_ai_service.dart';

enum ImageNumber { one, two, three, four }

extension ImageNumberValue on ImageNumber {
  int get value {
    switch (this) {
      case ImageNumber.one:
        return 1;
      case ImageNumber.two:
        return 2;
      case ImageNumber.three:
        return 3;
      case ImageNumber.four:
        return 4;
    }
  }
}

class ImageGenerationModelScreen extends StatefulWidget {
  const ImageGenerationModelScreen({super.key});

  @override
  State<ImageGenerationModelScreen> createState() =>
      _ImageGenerationModelScreenState();
}

class _ImageGenerationModelScreenState
    extends State<ImageGenerationModelScreen> {
  ImageNumber _number = ImageNumber.one;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? imageDescription;
  bool _isLoading = false;
  late Future<List<Uint8List>> getGeneratedImages;
  bool _isDeleted = true;

  @override
  void initState() {
    super.initState();
    _refreshImages();
  }

  void _refreshImages() {
    setState(() {
      try {
        getGeneratedImages = GenAiService.getGeneratedImagesResponse();
      } catch (e, s) {
        if (kDebugMode) {
          print("Error initializing images: $e\n$s");
        }
        getGeneratedImages = Future.value([]);
      }
      _isLoading = false;
    });
  }

  void generateImage() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await GenAiService.getGenerateImageModelResponse(
        imageDescription!,
        _number.value,
      );
    } catch (exception) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error: $exception")));
      }
    } finally {
      if (mounted) {
        _refreshImages();

        setState(() {
          _isDeleted = false;
        });
      }
    }
  }

  // clear the images
  void clearImages() async {
    GenAiService.clearImagesSharedPreferencesStorage();

    _isLoading = true;

    _refreshImages();
  }

  Future<void> downloadImage(Uint8List bytes, String fileName) async {
    try {
      var status = await Permission.storage.request();
      if (!status.isGranted && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Storage permission denied")),
        );
        return;
      }

      Directory directory;

      if (Platform.isAndroid) {
        directory = (await getExternalStorageDirectory())!;
      } else {
        directory = await getApplicationDocumentsDirectory();
      }

      final file = File('${directory.path}/$fileName.png');
      await file.writeAsBytes(bytes);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Image saved to ${file.path}")));
      }
    } catch (exception) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Download failed: $exception")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(height: 15),
                  TextFormField(
                    minLines: 1,
                    maxLines: null,
                    onChanged: (value) => imageDescription = value,
                    validator: (value) => (value == null || value.isEmpty)
                        ? 'Image description must not be empty!'
                        : null,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      label: Text(
                        "Enter image description",
                        style: GoogleFonts.roboto(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      prefixIcon: const Icon(Icons.image),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Select number of images:",
                      style: GoogleFonts.roboto(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Radio buttons in a horizontal row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: ImageNumber.values.map((numberOfImages) {
                      return Expanded(
                        child: RadioGroup<ImageNumber>(
                          groupValue: _number,
                          onChanged: (ImageNumber? value) {
                            setState(() {
                              _number = value!;
                            });
                          },
                          child: ListTile(
                            title: Text(
                              numberOfImages.value.toString(),
                              style: GoogleFonts.roboto(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            leading: Radio<ImageNumber>(value: numberOfImages),
                            visualDensity: VisualDensity.compact,
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 10),
                  InkWell(
                    onTap: _isLoading ? null : generateImage,
                    child: Container(
                      height: 50,
                      constraints: const BoxConstraints(minWidth: 0),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.blueAccent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: _isLoading
                            ? const CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              )
                            : Text(
                                "Generate Image",
                                style: GoogleFonts.roboto(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1,
                                ),
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
            if (_isDeleted == false)
              Row(
                children: [
                  Icon(Icons.delete, size: 25, color: Colors.red),
                  TextButton(
                    onPressed: () {
                      clearImages();
                    },
                    child: Text(
                      "Clear The Images",
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
            FutureBuilder<List<Uint8List>>(
              future: getGeneratedImages,
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Row(
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
                        ),
                        SizedBox(width: 10),
                        Icon(Icons.waving_hand, color: Colors.deepOrange),
                      ],
                    ),
                  );
                }
                final images = snapshot.data!;
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: images.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemBuilder: (context, index) {
                    final bytes = images[index];
                    return Stack(
                      fit: StackFit.expand,
                      children: [
                        Card(
                          clipBehavior: Clip.antiAlias,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Image.memory(bytes, fit: BoxFit.cover),
                        ),
                        Positioned(
                          bottom: 8,
                          right: 8,
                          child: InkWell(
                            onTap: () =>
                                downloadImage(bytes, "image_${index + 1}"),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.black54,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.all(6),
                              child: const Icon(
                                Icons.download,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
