import 'dart:io';
import 'package:flutter/material.dart';
import 'package:translator/translator.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class t_to_t extends StatefulWidget {
  const t_to_t({Key? key});

  @override
  State<t_to_t> createState() => _t_to_tState();
}

class _t_to_tState extends State<t_to_t> {
  final stt.SpeechToText _speech = stt.SpeechToText();

  List<String> languages = [
    'English',
    'Hindi',
    'Arabic',
    'German',
    'Russian',
    'Spanish',
    'Urdu',
    'Japanese',
    'Italian'
  ];
  List<String> languagescode = [
    'en',
    'hi',
    'ar',
    'de',
    'ru',
    'es',
    'ur',
    'ja',
    'it'
  ];
  final translator = GoogleTranslator();
  String from = 'en';
  String to = 'hi';
  String data = 'आप कैसे हैं?';
  String selectedValue = 'English';
  String selectedValue2 = 'Hindi';
  String selectedFromValue = 'English';
  TextEditingController controller = TextEditingController(text: 'How are you?');
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool isRecording = false;

  void startRecording() async {
    if (_speech.isListening) {
      setState(() {
        controller.text = ''; // Reset text field if already recording
      });
      return;
    }

    setState(() {
      isRecording = true;
    });

    bool available = await _speech.initialize();
    if (available) {
      _speech.listen(
        onResult: (result) {
          setState(() {
            controller.text = result.recognizedWords;
          });
        },
        onSoundLevelChange: (level) {
          // Use level for displaying a beating animation
        },
        cancelOnError: true, // Set cancelOnError to false
      );
    }
  }

  void stopRecording() {
    if (_speech.isListening) {
      _speech.stop();
      setState(() {
        isRecording = false;
      });
      _speech.initialize(); // Re-initialize speech object
    }
  }

  Future<void> translate() async {
    try {
      if (formKey.currentState!.validate()) {
        await translator
            .translate(controller.text, from: from, to: to)
            .then((value) {
          data = value.text;
          isLoading = false;
          setState(() {});
        });

        await translator
            .translate(data, from: to, to: from)
            .then((value) {
          controller.text = value.text;
        });
      }
    } on SocketException catch (_) {
      isLoading = true;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Internet not Connected'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 5),
        ),
      );
      setState(() {});
    }
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff4f4f4),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 30,
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                width: double.infinity, // Take up 100% width
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        DropdownButton<String>(
                          value: selectedFromValue,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                          onChanged: (String? value) {
                            setState(() {
                              selectedFromValue = value!;
                              from = languagescode[languages.indexOf(value)];
                            });
                          },
                          items: languages.map((String lang) {
                            return DropdownMenuItem<String>(
                              value: lang,
                              child: Text(lang),
                            );
                          }).toList(),
                        ),

                      ],
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white, // White background
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Form(
                        key: formKey,
                        child: TextFormField(
                          controller: controller,
                          maxLines: null,
                          minLines: null,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                          textInputAction: TextInputAction.done,
                          decoration: const InputDecoration(
                            enabledBorder: InputBorder.none,
                            border: InputBorder.none,
                            errorBorder: InputBorder.none,
                            errorStyle: TextStyle(color: Colors.white),
                          ),
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                width: double.infinity, // Take up 100% width
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DropdownButton(
                      value: selectedValue2,
                      focusColor: Colors.transparent,
                      items: languages.map((lang) {
                        return DropdownMenuItem(
                          value: lang,
                          child: Text(lang),
                          onTap: () {
                            if (lang == languages[0]) {
                              to = languagescode[0];
                            } else if (lang == languages[1]) {
                              to = languagescode[1];
                            } else if (lang == languages[2]) {
                              to = languagescode[2];
                            } else if (lang == languages[3]) {
                              to = languagescode[3];
                            } else if (lang == languages[4]) {
                              to = languagescode[4];
                            } else if (lang == languages[5]) {
                              to = languagescode[5];
                            } else if (lang == languages[6]) {
                              to = languagescode[6];
                            } else if (lang == languages[7]) {
                              to = languagescode[7];
                            } else if (lang == languages[8]) {
                              to = languagescode[8];
                            }
                            setState(() {});
                          },
                        );
                      }).toList(),
                      onChanged: (value) {
                        selectedValue2 = value!;
                      },
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white, // White background
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: SelectableText(
                        data,
                        style: const TextStyle(
                          color: Colors.black, // Text color
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),
              ElevatedButton(
                onPressed: translate,
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0), // Adjust the value as needed
                    ),
                  ),
                  backgroundColor:
                  MaterialStateProperty.all(Color(0xffF4B2B2)),
                  fixedSize: MaterialStateProperty.all(const Size(300, 45)),
                ),
                child: isLoading
                    ? const SizedBox.square(
                  dimension: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                )
                    : const Text(
                  'Translate',
                  style: TextStyle(
                      fontFamily: 'Acme'
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: translate,
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0), // Adjust the value as needed
                    ),
                  ),
                  backgroundColor:
                  MaterialStateProperty.all(Color(0xffF4B2B2)),
                  fixedSize: MaterialStateProperty.all(const Size(300, 45)),
                ),
                child: isLoading
                    ? const SizedBox.square(
                  dimension: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                )
                    : const Text(
                  'Speak',
                  style: TextStyle(
                      fontFamily: 'Acme'
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                width: double.infinity, // Take up 100% width
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        DropdownButton<String>(
                          value: selectedFromValue,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                          onChanged: (String? value) {
                            setState(() {
                              selectedFromValue = value!;
                              from = languagescode[languages.indexOf(value)];
                            });
                          },
                          items: languages.map((String lang) {
                            return DropdownMenuItem<String>(
                              value: lang,
                              child: Text(lang),
                            );
                          }).toList(),
                        ),
                        const SizedBox(
                          width: 180,
                        ),
                        Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: IconButton(
                            icon: Icon(
                              isRecording ? Icons.mic_none : Icons.mic,
                              color: Color(0xffF4B2B2),
                            ),
                            onPressed: isRecording ? stopRecording : startRecording,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 25),
                    Padding(
                      padding: EdgeInsets.only(left: 15),
                      child: ElevatedButton(
                        onPressed: translate,
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0), // Adjust the value as needed
                            ),
                          ),
                          backgroundColor:
                          MaterialStateProperty.all(Color(0xffF4B2B2)),
                          fixedSize: MaterialStateProperty.all(const Size(300, 45)),
                        ),
                        child: isLoading
                            ? const SizedBox.square(
                          dimension: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        )
                            : const Text(
                          'Translate',
                          style: TextStyle(
                              fontFamily: 'Acme'
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
