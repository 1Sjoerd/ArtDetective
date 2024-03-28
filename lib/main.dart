import 'dart:convert';
import 'dart:io';
import 'package:artdetective/screens/art_screen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData( scaffoldBackgroundColor: const Color.fromARGB(255, 255, 255, 255),),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  File? _image;
  final picker = ImagePicker();
  final String apiKey = key;
  Map<String, dynamic>? recognizedArtwork;


  List<Map<String, dynamic>> artworks = [
    {
      "name": "Mona Lisa",
      "artist": "Leonardo da Vinci",
      "title": "Mona Lisa",
      "creationDate": "c. 1503-1506, perhaps continuing until c. 1517",
      "medium": "Oil on poplar wood",
      "dimensions": "77 cm × 53 cm",
      "collection": "Permanent collection of the Louvre",
      "description": "Portrait of a woman believed to be Lisa Gherardini, known for her enigmatic expression.",
      "currentLocation": "Louvre Museum, Paris",
      "labels": [ 
        "Art", "Painting", "Portrait"
      ],
    },
    {
      "name": "De Sterrennacht",
      "artist": "Vincent van Gogh",
      "title": "De Sterrennacht",
      "creationDate": "1889",
      "medium": "Oil on canvas",
      "dimensions": "73.7 cm × 92.1 cm",
      "collection": "Permanent collection of the Museum of Modern Art",
      "description": "Depicts the view from the east-facing window of his asylum room at Saint-Rémy-de-Provence, with a village.",
      "currentLocation": "Museum of Modern Art, New York",
      "labels": [
        "Painting", "Art", "Landscape", "Wood",
      ],
    },
    {
      "name": "De Schreeuw",
      "artist": "Edvard Munch",
      "title": "De Schreeuw",
      "creationDate": "1893",
      "medium": "Oil, tempera, and pastel on cardboard",
      "dimensions": "91 cm × 73.5 cm",
      "collection": "Several versions exist, held by various collections",
      "description": "Symbolizes the existential angst and despair of the modern human condition.",
      "currentLocation": "Various, including the National Gallery, Oslo",
      "labels": [
        "Painting", "Art", "Watercolor paint", "Gesture", "Electric blue",
      ],
    },
  ];

  Future getImage(bool isCamera) async {
    final pickedFile = await picker.pickImage(
      source: isCamera ? ImageSource.camera : ImageSource.gallery,
    );

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        analyzeImage(_image!);
      } else {
        print('Geen afbeelding geselecteerd.');
      }
    });
  }

  Future<void> analyzeImage(File image) async {
    final bytes = await image.readAsBytes();
    String base64Image = base64Encode(bytes);
    String url = 'https://vision.googleapis.com/v1/images:annotate?key=$apiKey';
    Map<String, dynamic> payload = {
      "requests": [
        {
          "image": {"content": base64Image},
          "features": [{"type": "LABEL_DETECTION", "maxResults": 10}],
        }
      ]
    };

    try {
      final response = await http.post(Uri.parse(url),
          headers: {"Content-Type": "application/json"},
          body: json.encode(payload));

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        var labels = jsonResponse['responses'][0]['labelAnnotations'] as List;
        print('Ontvangen labels: $labels');

        int highestScore = 0;
        Map<String, dynamic>? bestMatchArtwork;

        for (var artwork in artworks) {
          int currentScore = 0;

          for (var label in labels) {
            var labelDesc = label['description'].toString().toLowerCase();
            for (var artLabel in artwork['labels']) {
              if (labelDesc.contains(artLabel.toLowerCase())) {
                currentScore++;
              }
            }
          }

          if (currentScore > highestScore) {
            highestScore = currentScore;
            bestMatchArtwork = artwork;
          }
        }

        if (bestMatchArtwork == null) {
          print("Geen overeenkomend kunstwerk gevonden.");
          return;
        }

        setState(() {
          recognizedArtwork = bestMatchArtwork;
        });

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ArtScreen(
              artworkData: recognizedArtwork,
              artworkImage: _image!,
            ),
          ),
        );
      } else {
        print('Google Cloud Vision API fout: ${response.body}');
      }
    } catch (e) {
      print('Er is een fout opgetreden bij het communiceren met Google Cloud Vision API: $e');
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Opacity(
            opacity: 0.5,
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
            color: Colors.white.withOpacity(0.4),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.all(0.0),
                  child: Text(
                    'ART DETECTIVE',
                    style: TextStyle(fontSize: 36, color: Colors.black, fontWeight: FontWeight.bold, fontFamily: 'TimesNewRoman',),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Text(
                    'Take or choose a picture to get more information about the artwork',
                    style: TextStyle(fontSize: 18, color: Colors.black, fontFamily: 'TimesNewRoman',),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: ElevatedButton(
                            onPressed: () => getImage(true),
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 100),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                              backgroundColor: Colors.black),
                            child: const Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                Icon(Icons.camera_alt, color: Colors.white, size: 64.0),
                              ],
                            )
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: ElevatedButton(
                            onPressed: () => getImage(false),
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 100), 
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                              backgroundColor: Colors.black),
                            child: const Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                Icon(Icons.photo_library, color: Colors.white, size: 64.0),
                              ],
                            )
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
