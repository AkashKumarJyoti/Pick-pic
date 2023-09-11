import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gallery/gallery/image_show.dart';
import 'package:gallery/util/toast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';

import 'authentication.dart';

class ImageUpload extends StatefulWidget {
  final String name;

  const ImageUpload({
    Key? key,
    required this.name,
  }) : super(key: key);

  @override
  State<ImageUpload> createState() => _ImageUploadState();
}

class _ImageUploadState extends State<ImageUpload> {
  File? image;
  String imageUrl = "";
  String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();
  late FToast fToast;

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
  }

  Future pickImage(ImageSource source) async {
    try {
      final images = await ImagePicker().pickImage(source: source);
      if (images == null) {
        return;
      }
      final imageTemporary = File(images.path);
      setState(() {
        image = imageTemporary;
      });
    } on PlatformException catch (e) {
      print("Failed to pick image: $e");
    }
  }

  Future uploadImage() async {
    if (image != null) {
      String str = DateTime.now().toString();
      Reference referenceRoot = FirebaseStorage.instance.ref();
      Reference referenceDirImages = referenceRoot.child('images');
      Reference referenceImageToUpload = referenceDirImages.child(str);
      try {
        await referenceImageToUpload.putFile(File(image!.path));
        imageUrl = await referenceImageToUpload.getDownloadURL();

        final user = FirebaseAuth.instance.currentUser;
        String? userUID = user?.uid;
        await FirebaseFirestore.instance
            .collection(userUID!)
            .add({'imageUrl': imageUrl, 'name': str});
        showToast("Image Uploaded", Icons.check, context);
        setState(() {
          image = null;
        });
      } catch (error) {
        print(error);
      }
    } else {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    String? photoUrl = FirebaseAuth.instance.currentUser?.photoURL;
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Container(
              height: 100,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(15.0),
                    bottomRight: Radius.circular(15.0)),
                color: Color(0xFF388E3C),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        ClipOval(
                            child: SizedBox(
                                height: 50,
                                width: 50,
                                child: Image.network(photoUrl!))),
                        Text("Hi, ${widget.name}",
                            style: GoogleFonts.sen(
                                textStyle: const TextStyle(
                                    fontSize: 20.0,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700))),
                      ],
                    ),
                  ),
                  const SizedBox(height: 5.0),
                  IconButton(
                      onPressed: () {
                        logout();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const WelcomePage()),
                        );
                      },
                      icon: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.logout, color: Colors.white),
                          Text("Sign Out",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 7.0))
                        ],
                      ))
                ],
              ),
            ),
            const SizedBox(height: 20.0),
            Expanded(
              child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15.0),
                          topRight: Radius.circular(15.0)),
                      gradient: LinearGradient(colors: [
                        Color(0xFF81C784),
                        Color(0xFFC8E6C9),
                        Color(0xFF69F0AE)
                      ], begin: Alignment.topLeft, end: Alignment.bottomRight)),
                  child: ListView(
                    shrinkWrap: true,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          const SizedBox(height: 15.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(right: 12.0),
                                child: Container(
                                  height: 50.0,
                                  width: 50.0,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30.0),
                                    color: const Color(0xFF388E3C),
                                  ),
                                  child: IconButton(
                                      onPressed: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const Gallery())),
                                      icon: const Icon(Icons.image,
                                          size: 30, color: Colors.white)),
                                ),
                              )
                            ],
                          ),
                          Stack(
                            children: <Widget>[
                              if (image != null)
                                ClipOval(
                                  child: Image.file(image!,
                                      width: 160,
                                      height: 160,
                                      fit: BoxFit.cover),
                                ),
                              if (image == null)
                                ClipOval(
                                  child: Container(
                                      width: 160,
                                      height: 160,
                                      color: const Color(0xFFE0E0E0),
                                      child: Icon(Icons.person,
                                          color: Colors.green.shade300,
                                          size: 150)),
                                ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: InkWell(
                                  onTap: () {
                                    if (image == null) {
                                      showToast(
                                          "Select Image", Icons.image, context);
                                    } else {
                                      showToast("Uploading Image...",
                                          Icons.upload, context);
                                      uploadImage();
                                    }
                                  },
                                  child: Container(
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        color: Colors.green.shade200,
                                        boxShadow: const [
                                          BoxShadow(
                                              color: Colors.grey,
                                              blurRadius: 3.0,
                                              offset: Offset(2, 3)),
                                        ]),
                                    child: const Icon(
                                      Icons.upload,
                                      color: Colors.green,
                                      size: 35,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          // const Spacer(),
                          SizedBox(height: 20),
                          Center(
                              child: Text("Pick-picApp",
                                  style: GoogleFonts.josefinSans(
                                    textStyle: const TextStyle(
                                      color: Color(0xFF43A047),
                                      fontSize: 38,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ))),
                          Container(
                            alignment: Alignment.center,
                            height: 300,
                            child: Stack(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(top: 40.0),
                                  child: Card(
                                      color: const Color(0xFF81C784),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            20), // Adjust the radius as needed
                                      ),
                                      child: Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: 250,
                                          decoration: BoxDecoration(
                                              color: Colors.white70,
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              border: Border.all(
                                                  color:
                                                      const Color(0xFF2E7D32),
                                                  width: 1.5)),
                                          child: Column(children: <Widget>[
                                            const Spacer(),
                                            Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 10.0, right: 10.0),
                                                child: Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    // Set the desired width
                                                    height: 55,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                    ),
                                                    child: button(
                                                        ImageSource.gallery,
                                                        "Pick From Gallery",
                                                        Icons.image))),
                                            const Spacer(),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10.0, right: 10.0),
                                              child: Container(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  // Set the desired width
                                                  height: 55,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                  child: button(
                                                      ImageSource.camera,
                                                      "Pick From Camera",
                                                      Icons.camera_alt)),
                                            ),
                                            const Spacer(),
                                          ]))),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 150, top: 16),
                                  child: Container(
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      color: Colors.white,
                                    ),
                                    child: const Icon(
                                      Icons.add_a_photo,
                                      color: Colors.green,
                                      size: 35,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  )),
            )
          ],
        ),
      ),
    );
  }

  Future<void> logout() async {
    await GoogleSignIn().disconnect();
    FirebaseAuth.instance.signOut();
  }

  Widget button(ImageSource source, String text, IconData icon) {
    return ElevatedButton(
      onPressed: () => pickImage(source),
      style: ButtonStyle(
          backgroundColor:
              MaterialStateProperty.all<Color>(const Color(0xFF4CAF50)),
          // Set the background color
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(10.0), // Adjust the radius as needed
            ),
          )),
      child: Row(
        children: <Widget>[
          const SizedBox(width: 5.0),
          Icon(icon),
          const SizedBox(width: 7.0),
          Padding(
            padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
            child: Container(
              width: 0.5,
              height: 50,
              decoration: BoxDecoration(
                  border:
                      Border.all(color: const Color(0xFF388E3C), width: 0.5)),
            ),
          ),
          const SizedBox(width: 7.0),
          Text(
            text,
            style: GoogleFonts.actor(
              textStyle: const TextStyle(
                fontSize: 22.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
