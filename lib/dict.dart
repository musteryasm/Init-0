import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:lottie/lottie.dart';

class dict extends StatefulWidget {
  @override
  _dictState createState() => _dictState();
}

class _dictState extends State<dict> {
  final TextEditingController _searchController = TextEditingController();
  Map<String, dynamic>? _wordData;

  Future<void> _fetchWordData(String word) async {
    final response = await http.get(Uri.parse('https://api.dictionaryapi.dev/api/v2/entries/en/$word'));
    if (response.statusCode == 200) {
      setState(() {
        _wordData = json.decode(response.body)[0];
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  hintText: "Search...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      String searchTerm = _searchController.text;
                      if (searchTerm.isNotEmpty) {
                        _fetchWordData(searchTerm);
                      }
                    },
                  ),
                ),
              ),
              SizedBox(height: 110,),
              if (_wordData != null &&
                  _wordData!['phonetics'] != null)
                Text(
                  'Phonetic: ${_wordData!['phonetics'][0]['text']}',
                  textAlign: TextAlign.justify,
                  style: TextStyle(fontStyle: FontStyle.italic,fontSize: 40),
                ),
              SizedBox(height: 30,),
              if (_wordData != null &&
                  _wordData!['meanings'] != null &&
                  _wordData!['meanings'].length >= 2)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Part of Speech: ${_wordData!['meanings'][0]['partOfSpeech']}',
                      style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Belanosima',fontSize: 30),
                    ),
                    SizedBox(height: 10,),
                    Text(
                        'Definition: ${_wordData!['meanings'][0]['definitions'][0]['definition']}',
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontFamily: 'Acme',
                        fontSize: 20
                      ),
                    ),
                  ],
                ),
              if (_wordData == null)
                Center(
                  child: Lottie.asset(
                    'assets/animation3.json', // Replace with your animation file path
                    width: 350, // Adjust width as needed
                    height: 350, // Adjust height as needed
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

