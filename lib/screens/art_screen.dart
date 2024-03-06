import 'dart:io';
import 'package:flutter/material.dart';

class ArtScreen extends StatelessWidget {
  final Map<String, dynamic>? artworkData;
  final File artworkImage;

  const ArtScreen({super.key, required this.artworkData, required this.artworkImage});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Opacity(
            opacity: 0.3,
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/kunst.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Container(
            color: Colors.white.withOpacity(0.7),
          ),
          SafeArea(
            child: Center(
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Text(artworkData != null ? 'Found artwork: ${artworkData!['name']}' : 'Onbekend kunstwerk', 
                      style: const TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold,fontFamily: 'TimesNewRoman',)),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(18,0,18,0),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                          width: 4.0,
                        ),
                      ),
                      child: Image.file(
                        artworkImage,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  if (artworkData != null) 
                  Padding(
                    padding: const EdgeInsets.fromLTRB(18,18,18,0),
                    child: Text('Artist: ${artworkData!['artist']}', 
                      style: const TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold,fontFamily: 'TimesNewRoman',)),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(18,0,18,0),
                    child: Text('Title: ${artworkData!['title']}, ${artworkData!['creationDate']}', 
                      style: const TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic,fontFamily: 'TimesNewRoman',)),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(18,0,18,0),
                    child: Text('${artworkData!['medium']}', 
                      style: const TextStyle(fontSize: 20, color: Colors.black, fontFamily: 'TimesNewRoman',)),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(18,0,18,0),
                    child: Text('${artworkData!['dimensions']}', 
                      style: const TextStyle(fontSize: 20, color: Colors.black, fontFamily: 'TimesNewRoman',)),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(18,18,18,0),
                    child: Text('${artworkData!['description']}', 
                      style: const TextStyle(fontSize: 20, color: Colors.black, fontFamily: 'TimesNewRoman',)),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(18,18,18,0),
                    child: Text('Location: ${artworkData!['currentLocation']}', 
                      style: const TextStyle(fontSize: 20, color: Colors.black, fontFamily: 'TimesNewRoman',)),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(18,18,18,18),
                    child: Text('Collection: ${artworkData!['collection']}', 
                      style: const TextStyle(fontSize: 20, color: Colors.black, fontFamily: 'TimesNewRoman',)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
