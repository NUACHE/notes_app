
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:st_notes_app/screens/edit.dart';

import '../auth/login.dart';
import '../models/note.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List filteredNotes = [];
  List  sampleNotes = [];
  
  var current;
  bool sorted = false;

  @override
  void initState() {
    super.initState();
    fetchNotes();
    
  }

  fetchNotes()async{
     // Obtain shared preferences.
   
    final SharedPreferences prefs = await SharedPreferences.getInstance();
  //get current id
        current = prefs.getString('current');
        var val ;
try {
  //fetch data associated with current id
    val  = jsonDecode(prefs.getString(current)!);
    
print(val);
print(val.length);

sampleNotes = val ;
filteredNotes = val;
setState(() {
  
});
      } catch (e) {
  print('error is $e');
}

  //        for (var element in val) {
  //    if(element['id'] == current){
  //   for (var i = 0; i < element['notes'].length; i++) {
  //     sampleNotes.add(Note(id:  element['notes'][i]['id'], title: element['notes'][i]['title'], content: element['notes'][i]['content'], modifiedTime: element['notes'][i]['time']));
  //   }

      
  //  setState(() {
     
  //  });
  //  }
  //   }


  
   
 

  }

  List sortNotesByModifiedTime(List notes) {
    if (sorted) {
      notes.sort((a, b) => a.modifiedTime.compareTo(b.modifiedTime));
    } else {
      notes.sort((b, a) => a.modifiedTime.compareTo(b.modifiedTime));
    }

    sorted = !sorted;

    return notes;
  }

  

  void onSearchTextChanged(String searchText) {
    setState(() {
      filteredNotes = sampleNotes
          .where((note) =>
              note['content'].toLowerCase().contains(searchText.toLowerCase()) ||
              note['title'].toLowerCase().contains(searchText.toLowerCase()))
          .toList();
    });
  }

  void deleteNote(int index) {
 
      var note = filteredNotes[index];
      sampleNotes.remove(note);

      // if(filteredNotes.isNotEmpty){
      //  filteredNotes.removeAt(index);
      // }
       setState(() {
    });
    updateNotes();
  }

  updateNotes()async{

    final SharedPreferences prefs = await SharedPreferences.getInstance();

   print(sampleNotes);

    prefs.setString(current,json.encode(sampleNotes));
  
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.grey.shade900,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 40, 16, 0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Notes',
                    style: TextStyle(fontSize: 30, color: Colors.black),
                  ),
                  IconButton(
                      onPressed: () {
                       Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  Login(),
                       ),(Route<dynamic> route) => false);
                      },
                      padding: const EdgeInsets.all(0),
                      icon: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                            color: Colors.grey.shade800,
                            borderRadius: BorderRadius.circular(10)),
                        child: const Icon(
                          Icons.door_back_door_outlined,
                          color: Colors.white,
                        ),
                      ))
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                onChanged: onSearchTextChanged,
                style: const TextStyle(fontSize: 16, color: Colors.black),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  hintText: "Search notes...",
                  hintStyle: const TextStyle(color: Colors.black),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Colors.black,
                  ),
                  fillColor: Colors.white,
                  filled: true,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(color: Colors.black),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(color: Colors.black),
                  ),
                ),
              ),
           const   SizedBox(height: 20,),
              Expanded(
                  child: ListView.builder(
                padding: const EdgeInsets.only(top: 30),
                itemCount: filteredNotes.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.only(bottom: 20),
                    color: Colors.amber[50],
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ListTile(
                        onTap: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  EditScreen(note: filteredNotes[index]),
                            ),
                          );
                          if (result != null) {
                            setState(() {
                              int originalIndex =
                                  sampleNotes.indexOf(filteredNotes[index]);
      
                              sampleNotes[originalIndex] =
                              {
                  'id': sampleNotes[originalIndex]['id'],
                  'title': result[0],
                  'content': result[1],
                  'modifiedTime': DateTime.now().toString()};
                              
                               
                                  
                              filteredNotes[index] =   {
                  'id': sampleNotes[originalIndex]['id'],
                  'title': result[0],
                  'content': result[1],
                  'modifiedTime': DateTime.now().toString()};
                            });
                          }
                        },
                        title: RichText(
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          text: TextSpan(
                              text: '${filteredNotes[index]['title']} \n',
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  height: 1.5),
                              children: [
                                TextSpan(
                                  text: filteredNotes[index]['content'],
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 14,
                                      height: 1.5),
                                )
                              ]),
                        ),
                        // subtitle: Padding(
                        //   padding: const EdgeInsets.only(top: 8.0),
                        //   child: Text(
                        //     'Edited: ${DateFormat('EEE MMM d, yyyy h:mm a').format(DateTime(int.parse(filteredNotes[index].modifiedTime)))}',
                        //     style: TextStyle(
                        //         fontSize: 10,
                        //         fontStyle: FontStyle.italic,
                        //         color: Colors.grey.shade800),
                        //   ),
                        // ),
                        trailing: IconButton(
                          onPressed: () async {
                            final result = await confirmDialog(context);
                            print(result);
                            if (result != null && result) {
                              deleteNote(index);
                            }
                          
                          },
                          icon: const Icon(
                            Icons.delete,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ))
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => const EditScreen(),
            ),
          );

          if (result != null) {
            setState(() {
              sampleNotes.add({
                  'id': (sampleNotes.length+1).toString(),
                  'title': result[0],
                  'content': result[1],
                  'modifiedTime': DateTime.now().toString()});
              filteredNotes = sampleNotes;
             updateNotes();
            });
          }
        },
        elevation: 10,
        backgroundColor: Colors.grey.shade800,
        child: const Icon(
          Icons.add,
          size: 38,
        ),
      ),
    );
  }

  Future<dynamic> confirmDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.grey.shade900,
            icon: const Icon(
              Icons.info,
              color: Colors.grey,
            ),
            title: const Text(
              'Are you sure you want to delete?',
              style: TextStyle(color: Colors.black),
            ),
            content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context, true);
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green),
                      child: const SizedBox(
                        width: 60,
                        child: Text(
                          'Yes',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.black),
                        ),
                      )),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context, false);
                      },
                      style:
                          ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      child: const SizedBox(
                        width: 60,
                        child: Text(
                          'No',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.black),
                        ),
                      )),
                ]),
          );
        });
  }
}
