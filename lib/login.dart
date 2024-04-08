import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notes/home.dart';

import 'otp.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController textEditingController = TextEditingController();
  TextEditingController nameEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const Center(
                  child: Text(
                    'Log In',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 34,
                        color: Colors.purple,
                        letterSpacing: 3),
                  )),
              Container(
                margin: EdgeInsets.all(32),
                child: TextFormField(
                  controller: nameEditingController,
                  decoration: InputDecoration(
                    labelText: 'Full Name',
                    hintText: 'Enter your name',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25)),
                    enabledBorder: OutlineInputBorder(
                        borderSide:
                        const BorderSide(color: Colors.purple, width: 1),
                        borderRadius: BorderRadius.circular(25)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Colors.deepPurpleAccent, width: 2),
                        borderRadius: BorderRadius.circular(25)),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.all(32),
                child: TextFormField(
                  controller: textEditingController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: 'Phone No.',
                    hintText: 'Enter your Phone no.',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25)),
                    enabledBorder: OutlineInputBorder(
                        borderSide:
                        const BorderSide(color: Colors.purple, width: 1),
                        borderRadius: BorderRadius.circular(25)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Colors.deepPurpleAccent, width: 2),
                        borderRadius: BorderRadius.circular(25)),
                  ),
                ),
              ),
              Container(
                  width: MediaQuery.sizeOf(context).width * 0.25,
                  height: MediaQuery.sizeOf(context).height * 0.15,
                  child: Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          // int num = textEditingController.text.toString() as int;
                          await FirebaseAuth.instance.verifyPhoneNumber(
                              verificationCompleted:
                                  (PhoneAuthCredential credential) {},
                              verificationFailed: (FirebaseAuthException ex) {},
                              codeSent: (String verificationid, int? resendtoken) {
                                Navigator.push(context, MaterialPageRoute(builder: (context)=> OtpScreen(verificationId: verificationid,phone: textEditingController.text,name: nameEditingController.text,)));
                              },
                              codeAutoRetrievalTimeout: (String verificationId) {},
                              phoneNumber: textEditingController.text.toString());
                        },
                        child: const Text('Verify'),
                      ))),

              SizedBox(height: 28,),
              MaterialButton(onPressed: (){},child: const Text("OR",style: TextStyle(fontSize:25,fontStyle:FontStyle.italic,color: Colors.purple),),),

              ElevatedButton(onPressed: (){
                signInWithGoogle(context);
              }, child: Text('Sign in with google')),

            ],
          ),
        ));
  }

  signInWithGoogle(BuildContext context) async {
    try {
      GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential).then((value) async {
        User user = FirebaseAuth.instance.currentUser!;
        print(user.displayName);

        // Save user data to Firestore
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'displayName': user.displayName,
          'email': user.email,
          'id':user.uid,
          // Add more fields as needed
        });

        Navigator.of(context).push(MaterialPageRoute(builder: (context) => Home()));
      });
    } catch (e) {
      print("Error signing in with Google: $e");
      // Handle error gracefully, e.g., show a snackbar or dialog.
    }
  }


   
  }

