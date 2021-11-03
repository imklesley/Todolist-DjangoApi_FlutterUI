import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:todolist_django_flutter/models/note.dart';
import 'package:todolist_django_flutter/url.dart';

class CreateNote extends StatefulWidget {

  const CreateNote({Key? key}) : super(key: key);

  @override
  State<CreateNote> createState() => _CreateNoteState();
}

class _CreateNoteState extends State<CreateNote> {
  final _formKey = GlobalKey<FormState>();
  final  _noteController = TextEditingController();




  Future<dynamic> _createNote() async {
    http.Client client = http.Client();

    http.Response response =
        await client.post(Uri.parse(url + 'notes/create'), body: {'body':_noteController.text});

    // print(response.body);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return Note.fromJson(json);
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Note'),
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
                  child: const Text('Create note'),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final note = _createNote();
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
