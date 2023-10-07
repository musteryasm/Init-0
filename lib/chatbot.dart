import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String userMessage = '';
  bool isLoading = false;
  List<String> chatHistory = [];

  void addUserMessage(String message) {
    setState(() {
      chatHistory.add('You: $message');
    });
  }

  void addChatbotMessage(String message) {
    setState(() {
      chatHistory.add('Chatbot: $message');
    });
  }

  Future<void> handleUserMessage() async {
    if (userMessage.trim() == '') return;

    addUserMessage(userMessage);

    setState(() {
      isLoading = true;
    });

    try {
      // Simulate an API call delay (you can remove this in production)
      await Future.delayed(Duration(seconds: 1));

      // Replace with your actual API endpoint to send user messages to the server
      final response = await http.post(
        Uri.parse('http://localhost:5000/api/chat'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'message': userMessage}),
      );

      if (response.statusCode != 200) {
        throw Exception('Network response was not ok');
      }

      final data = jsonDecode(response.body);

      await Future.delayed(Duration(seconds: 1));
      print(data['reply']);
      addChatbotMessage(data['reply']);
    } catch (error) {
      print('Error sending/receiving messages: $error');
      addChatbotMessage('Oops! Something went wrong.');
    } finally {
      setState(() {
        isLoading = false;
        userMessage = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat App'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: chatHistory.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(chatHistory[index]),
                );
              },
            ),
          ),
          isLoading
              ? CircularProgressIndicator()
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          onChanged: (value) {
                            setState(() {
                              userMessage = value;
                            });
                          },
                          decoration: InputDecoration(
                            hintText: 'Type your message...',
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.send),
                        onPressed: handleUserMessage,
                      ),
                    ],
                  ),
                ),
        ],
      ),
    );
  }
}
