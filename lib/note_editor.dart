import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notes/app_style.dart';

class NoteEditor extends StatefulWidget {
  const NoteEditor({super.key});

  @override
  State<NoteEditor> createState() => _NoteEditorState();
}

class _NoteEditorState extends State<NoteEditor> {
  int color_id = Random().nextInt(AppStyle.cardsColor.length);
  String date = DateTime.now().toString();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _mainController = TextEditingController();
  @override
  Widget build(BuildContext context) {
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
          FirebaseFirestore.instance.collection("Notes").add({
            "note_title":_titleController.text,
            "creation_date":date,
            "note_content":_mainController.text,
            "color_id":color_id,
            "id":FirebaseAuth.instance.currentUser!.uid
          }).then((value) => {
             Navigator.pop(context)
          }).catchError((error)=>print(error));
        },
        child: const Icon(Icons.save),

      ),
    );
  }
}
