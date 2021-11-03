import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:todolist_django_flutter/models/note.dart';
import 'package:http/http.dart' as http;
import 'package:todolist_django_flutter/pages/create_note.dart';
import 'package:todolist_django_flutter/pages/update_note.dart';
import 'package:todolist_django_flutter/url.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  http.Client client = http.Client();
  List<Note> notes = [];

  @override
  void initState() {
    _getAllNotes();
    super.initState();
  }

  Future<void> _getAllNotes() async {
    http.Response response = await client.get(Uri.parse(url + 'notes/'));
    final data = jsonDecode(response.body);
    setState(() {
      notes = data.map<Note>((note) {
        return Note.fromJson(note);
      }).toList();
    });
  }

  Future<void> _deleteNote(int id) async {
    http.Response response =
        await client.delete(Uri.parse(url + 'notes/$id/delete'));
    // print(response.statusCode);
    if (response.statusCode == 200) {
      setState(() {
        notes.removeWhere((element) => element.id == id);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueAccent,
          title: const Text('Consuming Django Api'),
          centerTitle: true,
          actions: [
            IconButton(onPressed: _getAllNotes, icon: const Icon(Icons.refresh))
          ],
        ),
        backgroundColor: Colors.white,
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () async {
            var note = await Navigator.push(context,
                MaterialPageRoute(builder: (context) => const CreateNote()));

            if (note != null) {
              setState(() {
                notes.add(note);
              });
            }
          },
          tooltip: 'Create new note',
        ),
        body: RefreshIndicator(
          onRefresh: _getAllNotes,
          color: Colors.blue,
          child: ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Text("${notes[index].id}"),
                  title: Text(
                    notes[index].body,
                    style: const TextStyle(color: Colors.black),
                  ),
                  trailing: IconButton(
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    onPressed: () {
                      _deleteNote(notes[index].id);
                    },
                  ),
                  onTap: () async {
                    var note = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                UpdateNote(note: notes[index])));
                    // print(note);
                    if (note != null) {
                      setState(() {
                        for (Note n in notes) {
                          if (n.id == note.id) {
                            n.body = note.body;
                          }
                        }
                      });
                    }
                  },
                );
              }),
        ));
  }
}
