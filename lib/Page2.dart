import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class Page2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Results',
          style: GoogleFonts.openSans(
            fontWeight: FontWeight.bold,
          ),),
      ),
      body: Center(
        child: Text('This is Page 2 content.'),
      ),
    );
  }
}
