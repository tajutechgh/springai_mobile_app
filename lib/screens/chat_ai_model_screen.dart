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
  late String askQuestionText;
  bool _isLoading = false;

  late Future<String?> futureAskTajuDNChatModelAnswer;
  late Future<String?>  getTajuDNAnswer;

  @override
  void initState() {
    super.initState();
    _refreshChatAiModelScreen();
  }

  void _refreshChatAiModelScreen(){
    setState(() {
      getTajuDNAnswer = GenAiService.getAskTajuDNResponse();
      _isLoading = false;
    });
  }

  void askQuestion() async {

    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      futureAskTajuDNChatModelAnswer =  GenAiService.getTajuDNChatModelAnswer(askQuestionText);
    });

    try {
      // Await so loading indicator can reflect the request state.
      await futureAskTajuDNChatModelAnswer;

    } catch (exception) {

      // Handle error if needed
      throw("An error occurred while processing your form");

    } finally {

      if (mounted) {
        _refreshChatAiModelScreen();
      }
    }
  }

  // clear the answer
  void clearAnswer( ) async{
    GenAiService.clearSharedPreferencesStorage();
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
                SizedBox(height: 20,),
                TextFormField(
                  minLines: 1,
                  maxLines: null,
                  onChanged: (value) {
                    askQuestionText = value;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Question must not be empty!";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
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
                  ),
                ),
                const SizedBox(height: 30),
                InkWell(
                  onTap: _isLoading ? null : askQuestion,
                  child: Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width - 20,
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: _isLoading
                          ? const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      )
                          : Text(
                        "Ask Taju",
                        style: GoogleFonts.roboto(
                          textStyle: Theme.of(context).textTheme.displayLarge,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                if (getTajuDNAnswer.isBlank == true)
                  Card(
                    child: SizedBox(
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
                    ),
                  )
                else
                  FutureBuilder<String?>(
                    future: getTajuDNAnswer,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (snapshot.data == null || snapshot.data!.isEmpty) {
                        return Center(
                            child: Text(
                              'Hello i am Taju, write your question!',
                              style: GoogleFonts.roboto(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1,
                                color: Colors.deepOrange
                              ),
                            )
                        );
                      } else {
                        final response = snapshot.data!;
                        return Column(
                          children: [
                            Row(
                              children: [
                                  Icon(Icons.delete, size: 25, color: Colors.red,),
                                  TextButton(
                                      onPressed: (){
                                          clearAnswer();
                                      },
                                      child: Text(
                                          "Clear The Answer",
                                          style: GoogleFonts.roboto(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 1,
                                              color: Colors.red
                                          ),
                                      ),
                                  ),
                              ],
                            ),
                            Card(
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Text(
                                  // answer
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
