import 'package:flutter/material.dart';

import '../models/note.dart';

class EditScreen extends StatefulWidget {
  final dynamic note;
  const EditScreen({super.key, this.note});

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _contentController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    if (widget.note != null) {
      _titleController = TextEditingController(text: widget.note!['title']);
      _contentController = TextEditingController(text: widget.note!['content']);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 40, 16, 0),
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    padding: const EdgeInsets.all(0),
                    icon: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                          color: Colors.grey.shade800.withOpacity(.8),
                          borderRadius: BorderRadius.circular(10)),
                      child: const Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.white,
                      ),
                    ))
              ],
            ),
           const SizedBox(height: 40,),
            Expanded(
                child: ListView(
              children: [
                TextField(
                  controller: _titleController,
                  style: const TextStyle(color: Colors.black, fontSize: 30),
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Title',
                      hintStyle: TextStyle(color: Colors.black, fontSize: 30)),
                ),
                TextField(
                  controller: _contentController,
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                  maxLines: null,
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Type something here',
                      hintStyle: TextStyle(
                        color: Colors.black,
                      )),
                ),
              ],
            ))
          ]),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(
              context, [_titleController.text, _contentController.text]);
        },
        elevation: 10,
        backgroundColor: Colors.grey.shade800,
        child: const Icon(Icons.save),
      ),
    );
  }
}
