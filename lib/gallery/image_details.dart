import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class DetailsPage extends StatelessWidget {
  final String imagePath;
  const DetailsPage({Key? key, required this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
        child: Column(
          children: <Widget>[
            const SizedBox(height: 40.0),
            Text("Gallery", style: GoogleFonts.sen(
                textStyle: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w600,
                    color: Colors.white
                )),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40.0),
            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
                  ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  child: Image.network(imagePath, fit: BoxFit.fitWidth),
                ),
              ),
            ),
          ],
        ),
      )
    );
  }
}
