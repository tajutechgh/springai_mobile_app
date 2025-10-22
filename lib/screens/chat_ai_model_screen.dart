import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatAiModelScreen extends StatefulWidget {
  const ChatAiModelScreen({super.key});

  @override
  State<ChatAiModelScreen> createState() => _ChatAiModelScreenState();
}

class _ChatAiModelScreenState extends State<ChatAiModelScreen> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String question;

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
            Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 50,),
                    TextFormField(
                      onChanged: (value){
                           question = value;
                      },
                      validator: (value){
                        if(value!.isEmpty) {
                          return "Question must not be empty!" ;
                        } else{
                          return null;
                        }
                      },
                      decoration: InputDecoration(
                          label: Text(
                            "Enter your question here",
                            style: GoogleFonts.roboto(
                                textStyle: Theme.of(context).textTheme.displayLarge,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.normal,
                                letterSpacing: 1,
                            ),
                          ),
                          focusColor: Colors.blue,
                          prefixIcon: Icon(
                            Icons.edit,
                          )
                      ),
                    ),
                    SizedBox(height: 30,),
                    InkWell(
                      onTap: (){

                      },
                      child: Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width-20,
                        decoration: BoxDecoration(
                          color: Colors.blueAccent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                            child: Text(
                              "Ask TajuDN",
                              style: GoogleFonts.roboto(
                                  textStyle: Theme.of(context).textTheme.displayLarge,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.normal,
                                  letterSpacing: 1,
                                  color: Colors.white
                              ),
                            )
                        ),
                      ),
                    ),
                    SizedBox(height: 50,),
                    Card(
                      child: SizedBox(
                        height: 200,
                        child: ListTile(
                          leading: Icon(Icons.question_answer),
                          title: Text(
                            'Your answer will appear here!',
                            style: GoogleFonts.roboto(
                                textStyle: Theme.of(context).textTheme.displayLarge,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.normal,
                                letterSpacing: 1,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ]
               )
            ),
        ],
      ),
    );
  }
}
