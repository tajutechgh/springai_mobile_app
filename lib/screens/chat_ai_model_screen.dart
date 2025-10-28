import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../services/gen_ai_service.dart';

class ChatAiModelScreen extends StatefulWidget {
  const ChatAiModelScreen({super.key});

  @override
  State<ChatAiModelScreen> createState() => _ChatAiModelScreenState();
}

class _ChatAiModelScreenState extends State<ChatAiModelScreen> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _questionController = TextEditingController();
  bool _isLoading = false;
  late Future<String?> futureAskTajuDNChatModelAnswer;
  late Future<String?> getTajuDNAnswer;

  @override
  void initState() {
    super.initState();
    _refreshChatAiModelScreen();
  }

  void _refreshChatAiModelScreen() {
    setState(() {
      getTajuDNAnswer = GenAiService.getAskTajuDNResponse();
      _isLoading = false;
    });
  }

  void askQuestion() async {

    if (!_formKey.currentState!.validate()) return;

    final askQuestionText = _questionController.text.trim();

    if (askQuestionText.isEmpty) return;

    setState(() {
      _isLoading = true;
      futureAskTajuDNChatModelAnswer =
          GenAiService.getTajuDNChatModelAnswer(askQuestionText);
    });

    try {
      await futureAskTajuDNChatModelAnswer;

      // Clear input after successful submission
      _questionController.clear();

      // Close keyboard
      if (mounted) {
        FocusScope.of(context).unfocus();
      }

    } catch (exception) {

      throw ("An error occurred while processing your form");

    } finally {

      if (mounted) {
        _refreshChatAiModelScreen();
      }

    }
  }

  void clearAnswer() async {
    GenAiService.clearChatSharedPreferencesStorage();
    _refreshChatAiModelScreen();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                TextFormField(
                  controller: _questionController,
                  minLines: 1,
                  maxLines: null,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Question must not be empty!";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    label: Text(
                      "Enter your question here",
                      style: GoogleFonts.roboto(
                        textStyle: Theme.of(context).textTheme.displayLarge,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                    prefixIcon: const Icon(Icons.question_answer),
                    // Add clear icon to manually reset text
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () => _questionController.clear(),
                    ),
                  ),
                  onFieldSubmitted: (_) => askQuestion(), // Press Enter to submit
                ),
                const SizedBox(height: 30),
                InkWell(
                  onTap: _isLoading ? null : askQuestion,
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
                        valueColor:
                        AlwaysStoppedAnimation<Color>(Colors.white),
                      )
                          : Text(
                        "Ask Taju",
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
                if (getTajuDNAnswer.isBlank == true)
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.question_answer_outlined),
                      title: Text(
                        'Your answer will appear here!',
                        style: GoogleFonts.roboto(
                          fontSize: 15,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  )
                else
                  FutureBuilder<String?>(
                    future: getTajuDNAnswer,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(
                            child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(
                            child: Text('Error: ${snapshot.error}'));
                      } else if (snapshot.data == null ||
                          snapshot.data!.isEmpty) {
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
                              const SizedBox(width: 10),
                              const Icon(
                                Icons.waving_hand,
                                color: Colors.deepOrange,
                              ),
                            ],
                          ),
                        );
                      } else {
                        final response = snapshot.data!;
                        return Column(
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.delete,
                                    size: 25, color: Colors.red),
                                TextButton(
                                  onPressed: clearAnswer,
                                  child: Text(
                                    "Clear The Answer",
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
                            Card(
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Text(
                                  response,
                                  style: GoogleFonts.roboto(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                    },
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
