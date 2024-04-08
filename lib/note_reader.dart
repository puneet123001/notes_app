

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:notes/app_style.dart';

import 'edit.dart';

class NotesReaderScreen extends StatefulWidget {
   NotesReaderScreen(this.doc,{super.key});
  QueryDocumentSnapshot doc;

  @override
  State<NotesReaderScreen> createState() => _NotesReaderScreenState();
}

class _NotesReaderScreenState extends State<NotesReaderScreen> {
  @override
  Widget build(BuildContext context) {
    int color_id = widget.doc['color_id'];
    return Scaffold(
      backgroundColor: AppStyle.cardsColor[color_id],
      appBar: AppBar(
        backgroundColor:AppStyle.cardsColor[color_id],
        elevation: 0.0,
      ),
      body:  Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              widget.doc["note_title"],
              style: AppStyle.mainTitle,
            ),
            SizedBox(
              height: 4,
            ),
            Text(
              widget.doc["creation_date"],
              style: AppStyle.dateTitle,
            ),
            SizedBox(
              height: 28,
            ),
            Text(
              widget.doc["note_content"],
              style: AppStyle.mainContent,
              overflow: TextOverflow.ellipsis,
            )
          ],
        ),
      ),

      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: FloatingActionButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => Edit(doc: widget.doc,)));

              },
              child: Icon(Icons.edit),
            ),
          ),
          FloatingActionButton(
            onPressed: () async{
              try{
                await widget.doc.reference.delete().then((value) => Navigator.pop(context));
              }
              catch(error){
                print(error);
              }

            },
            child: Icon(Icons.delete),
          ),
        ],
      ),
    );
  }
}
