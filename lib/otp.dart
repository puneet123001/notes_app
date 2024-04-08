import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'home.dart';

class OtpScreen extends StatefulWidget {
  String verificationId;
  String name;
  String phone;
  OtpScreen({super.key,required this.verificationId,required this.name,required this.phone});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  TextEditingController otpController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Otp Screen"),
        centerTitle: true,
      ),

      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(20),
            child: TextField(
              controller: otpController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                  hintText: "Enter the OTP",
                  suffixIcon: Icon(Icons.phone),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                  )
              ),
            ),
          ),
          SizedBox(height: 30,),
          ElevatedButton(onPressed: () async {
            try{
              PhoneAuthCredential credential = await PhoneAuthProvider.credential(verificationId:widget.verificationId, smsCode: otpController.text.toString());
              FirebaseAuth.instance.signInWithCredential(credential).then((value) async {
                User user = FirebaseAuth.instance.currentUser!;
                await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
                  'displayName': widget.name,
                  'email': widget.phone,
                  'id':user.uid,
                  // Add more fields as needed
                });
                Navigator.push(context, MaterialPageRoute(builder: (context)=> Home()));
              });
            }
            catch(ex){
              log(ex.toString());
            }
          }, child: Text("OTP")),
        ],
      ),
    );
  }
}
