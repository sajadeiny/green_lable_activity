import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'Page1.dart';
import 'Page2.dart';
import 'Page3.dart';
import 'Page4.dart';
import 'package:tflite_flutter/tflite_flutter.dart';



void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Different Pages Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Green Human Activity App',
          style: GoogleFonts.openSans(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        color: Colors.black12.withOpacity(0.1),

        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'image/logo_1.png',
                height: 150,
                width: 150,
                fit: BoxFit.cover,
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildBox('Human Activity', context, ImageClassifierPage()),
                  _buildBox('Results', context, Page2()),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildBox('Events', context, Page3()),
                  _buildBox('Upload', context, Page4()), // Example: Navigate to Page1 when Box 4 is tapped
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBox(String label, BuildContext context, Widget pageToNavigate) {
    late String imagePath;

    if (label == 'Human Activity') {
      imagePath = 'image/page_1.jpg'; // Replace with the path to your image for Box 1
    } else if (label == 'Results') {
      imagePath = 'image/results_1.jpg'; // Replace with the path to your image for Box 2
    } else if (label == 'Events') {
      imagePath = 'image/events.jpg'; // Replace with the path to your image for Box 3
    } else if (label == 'Upload') {
      imagePath = 'image/upload.jpg'; // Replace with the path to your image for Box 4
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => pageToNavigate),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.3), // Adjust the alpha value for transparency
          borderRadius: BorderRadius.circular(15.0), // Adjust the radius as needed
        ),
        width: 170,
        height: 170,

        child: Center(
          child: Stack(
            children: [
              if (imagePath != null)
                Image.asset(
                  imagePath,
                  height: 150,
                  width: 150,
                  fit: BoxFit.cover,
                )
              else
                Container(), // or a default widget if no image is specified
              Positioned(
                bottom: 8,
                left: 8,
                child: Text(
                  label,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



