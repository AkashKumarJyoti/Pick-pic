import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gallery/ui.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'greet.dart';
import 'util/hexcolor.dart';
import 'model/userModel.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final Color _cyan = HexColor("#64FFDA");

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async
      {
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          height: MediaQuery
              .of(context)
              .size
              .height,
          width: MediaQuery
              .of(context)
              .size
              .width,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                _cyan.withOpacity(0.2),
                _cyan.withOpacity(0.4),
                _cyan.withOpacity(0.6),
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(
                    top: 80.0, left: 15.0, right: 15.0),
                child: TextButton(
                  onPressed: () => signInWithGoogle(context),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Colors.white),
                    shape: MaterialStateProperty.all<OutlinedBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(45.0),
                        // Border radius
                        side: const BorderSide(color: Colors.black,
                            width: 1.0), // Border color and width
                      ),
                    ),
                  ),
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 23.0),
                        child: Image.asset(
                          "images/google.png", height: 40.0, width: 40.0,),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 18.0),
                        child: Center(
                          child: Text("Continue with Google", style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 20
                          )),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  signInWithGoogle(BuildContext context) async {
    GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    UserCredential userCredential =
    await FirebaseAuth.instance.signInWithCredential(credential);
    String? name = userCredential.user?.displayName;
    if (userCredential.additionalUserInfo?.isNewUser == true) {
      _welcomeToGreeting(context, name?.split(' ')[0]);
    } else {
      _welcomeToPickApp(context, name?.split(' ')[0]);
    }
  }

  void _welcomeToGreeting(BuildContext context, String? name) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => Greeting(name: name ?? ''),
      ),
    );
  }

  void _welcomeToPickApp(BuildContext context, String? name) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => ImageUpload(name: name ?? ''),
      ),
    );
  }
}


