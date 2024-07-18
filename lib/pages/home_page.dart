import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud_tutorial/services/firebase.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  //firestore connection
  final FirestoreService firestoreService = FirestoreService();

  //text controller
  final TextEditingController textController = TextEditingController();

  //open a dialog box to add a note
  void openNoteBox({String? docID}) {
    showDialog(context: context, builder: (context) => AlertDialog(
      content: TextField(
        controller: textController,
      ),
      actions: [
        ElevatedButton(
            onPressed: () {
              //add new note
              if (docID == null) {
                firestoreService.addNote(textController.text);
              }
              else {
                firestoreService.updateNote(docID, textController.text);
              }

              //clear the text controller
              textController.clear();

              //close the box
              Navigator.pop(context);
            },
            child: Text("Dodaj"))
      ]
    ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Notes"),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: openNoteBox,
        child: Icon(Icons.add),

      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestoreService.getNotesStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List notesList = snapshot.data!.docs;

            // display as a list
            return ListView.builder(
              itemCount: notesList.length,
              itemBuilder: (context, index) {
                // get each doc individually
                DocumentSnapshot document = notesList[index];
                String docID = document.id;

                // get note from each doc
                Map<String, dynamic> data = document.data() as Map<String, dynamic>;
            String noteText = data['note'];

                //display as a list tile
                return Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                  color: Colors.white70,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.25),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: Offset(0, 0), // changes position of shadow
                      ),
                    ],
                  ),
                  margin: const EdgeInsets.only(
                    top: 12,
                    left: 24,
                    right: 24,
                  ),
                  child: ListTile(
                  title: Text(noteText),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      //update button
                      IconButton(
                      onPressed: () => openNoteBox(docID: docID),
                      icon: const Icon(Icons.settings),
                     ),

                      //delete button
                      IconButton(
                      onPressed: () => firestoreService.deleteNote(docID),
                      icon: const Icon(Icons.delete),
                      ),
                   ],
                  ),
                 ),
                );
              },
            );
          }
          //if there is no data return nothing
          else {
            return const Text("Brak notatek...");
          }
        },

      )
    );
  }
}