import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'app_style.dart';

class Edit extends StatefulWidget {
  Edit({super.key,required this.doc});
  QueryDocumentSnapshot doc;

  @override
  State<Edit> createState() => _EditState();
}

class _EditState extends State<Edit> {
  int color_id = Random().nextInt(AppStyle.cardsColor.length);
  String date = DateTime.now().toString();

  @override
  Widget build(BuildContext context) {
    TextEditingController _titleController = TextEditingController(text: widget.doc["note_title"]);
    TextEditingController _mainController = TextEditingController(text: widget.doc["note_content"]);
    return Scaffold(
      backgroundColor: AppStyle.cardsColor[color_id],
      appBar: AppBar(
        backgroundColor: AppStyle.cardsColor[color_id],
        elevation: 0.0,
        centerTitle: true,

        title: Text("Add a new Note",style: TextStyle(color: Colors.black),),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                border:InputBorder.none,
                hintText: 'Note Title',
              ),
              style: AppStyle.mainTitle,
            ),
            SizedBox(height: 8,),
            Text(date,style: AppStyle.dateTitle,),
            SizedBox(height: 28,),

            TextField(
              controller: _mainController,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: const InputDecoration(
                border:InputBorder.none,
                hintText: 'Note Content',
              ),
              style: AppStyle.mainContent,
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: AppStyle.accentColor,
        onPressed: () async{
          widget.doc.reference.update({
            "note_title":_titleController.text,
            "creation_date":date,
            "note_content":_mainController.text,
            "color_id":color_id,
            "id":FirebaseAuth.instance.currentUser!.uid
          }).then((value) => Navigator.pop(context)).then((value) => Navigator.pop(context));
        },
        child: const Icon(Icons.save),

      ),
    );
  }
}