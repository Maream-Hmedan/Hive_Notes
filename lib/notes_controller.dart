import 'package:hive_flutter/hive_flutter.dart';

class HiveNotes {
  final noteRef = Hive.box("Notes");
  List<Map<String, dynamic>> notesData = [];

  void addNote({required String title, required String description}) async {
    await noteRef.add({
      "title": title,
      "description": description,
    });
    getNotes();
  }

  void getNotes() {
    notesData = noteRef.keys.map((e) {
      final currentNote = noteRef.get(e);
      return {
        "key": e,
        "title": currentNote["title"],
        "description": currentNote["description"],
      };
    }).toList();
  }

  void editNote({required String title, required String description,required int noteKey}) async {
    await noteRef.put(noteKey,{
      "title": title,
      "description": description,
    });
    getNotes();
  }

  void deleteNote({required int noteKey}) async {
    await noteRef.delete(noteKey);
    getNotes();
  }
}
