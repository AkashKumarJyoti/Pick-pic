import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gallery/gallery/image_details.dart';
import 'package:google_fonts/google_fonts.dart';
import 'image.dart';

class Gallery extends StatefulWidget {
  const Gallery({Key? key}) : super(key: key);

  @override
  State<Gallery> createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  List<ImagePick> imageUrls = [];
  bool flag = true;
  @override
  void initState() {
    super.initState();
    loadImages();
  }
  Future<void> loadImages() async {
    List<ImagePick> urls = await getImageUrls();
    setState(() {
      imageUrls = urls;
    });
  }

  Future<List<ImagePick>> getImageUrls() async {
    List<ImagePick> imageUrls = [];
    User? user = FirebaseAuth.instance.currentUser;
    String? userUId = user?.uid;
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
    await FirebaseFirestore.instance.collection(userUId!).get();
    for (QueryDocumentSnapshot<Map<String, dynamic>> doc in querySnapshot.docs) {
      var data = doc.data();
      if (data.containsKey('imageUrl')) {
        ImagePick image = ImagePick(data['name'], data['imageUrl']);
        imageUrls.add(image);
      }
    }
    setState(() {
      flag = false;
    });
    return imageUrls;
  }

  Future<void> deleteImage(String imageName,int index) async {
    User? user = FirebaseAuth.instance.currentUser;
    String? userUid = user?.uid;
    await FirebaseFirestore.instance
        .collection(userUid!)
        .where('name', isEqualTo: imageName)
        .get()
        .then((querySnapshot) {
      for (var doc in querySnapshot.docs) {
        doc.reference.delete();
      }
    });
    final storageReference = FirebaseStorage.instance.ref().child("images/$imageName");
    await storageReference.delete();

    setState(() {
      imageUrls.removeAt(index);
    });

  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color(0xFF81C784),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back_ios_new_outlined)),
            Center(
              child: Text(
                "Gallery",
                style: GoogleFonts.sen(
                    textStyle: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w600,
                        color: Colors.white)),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 40.0),
            Expanded(
                child: Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30.0),
                          topRight: Radius.circular(30.0)),
                    ),
                    child: imageGrid(w)
                ))
          ],
        ),
      ),
    );
  }
  Widget imageGrid(var w)
  {
    return (flag) ? const Center(child: SizedBox(height: 100, width: 100.0,child: CircularProgressIndicator()),) : GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 10.0,
          crossAxisSpacing: 10.0,
        ),
        itemCount: imageUrls.length,
        itemBuilder: (context, index) {
          return RawMaterialButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DetailsPage(
                            imagePath: imageUrls[index].imageurl)));
              },
              child: Stack(
                children: <Widget>[
                  Container(
                    width: (w - 60) / 3,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15.0),
                      child: CachedNetworkImage(
                        imageUrl: imageUrls[index].imageurl,
                        fit: BoxFit.fitWidth,
                        placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator(), // Show CircularProgressIndicator while loading
                        ),
                        errorWidget: (context, url, error) => Icon(Icons.error), // Display an error icon if loading fails
                      ),
                    ),
                  ),
                  Positioned(
                      top: -15,
                      right: -15,
                      child: IconButton(onPressed: () => deleteImage(imageUrls[index].name,index),
                        icon: const Icon(Icons.remove_circle, color: Colors.red,),)
                  )
                ],
              ));
        });
  }
}
