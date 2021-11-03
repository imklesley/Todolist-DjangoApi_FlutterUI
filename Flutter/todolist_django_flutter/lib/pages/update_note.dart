import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:todolist_django_flutter/models/note.dart';
import 'package:todolist_django_flutter/url.dart';

class UpdateNote extends StatefulWidget {
  final Note note;

  const UpdateNote({Key? key, required this.note}) : super(key: key);

  @override
  State<UpdateNote> createState() => _UpdateNoteState();
}

class _UpdateNoteState extends State<UpdateNote> {
  final _formKey = GlobalKey<FormState>();
  final _noteController = TextEditingController();

  @override
  void initState() {
    _noteController.text = widget.note.body;
    super.initState();
  }

  Future<dynamic> _updateNote() async {
    String urlUpdate = url + 'notes/${widget.note.id}/update';
    // print(urlUpdate);
    http.Client client = http.Client();

    http.Response response = await client
        .put(Uri.parse(urlUpdate), body: {'body': _noteController.text});

    if (response.statusCode == 200) {
      Note noteUpdated = Note.fromJson(jsonDecode(response.body));
      return noteUpdated;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Note'),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: TextFormField(
                  maxLines: 10,
                  controller: _noteController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Enter your note'),
                  validator: (inputedText) {
                    if (inputedText!.isEmpty) {
                      return 'Insert something before trying to create a note!';
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: ElevatedButton(
                  child: const Text('Update Note'),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final note = _updateNote();
                      Navigator.pop(context, note);
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
