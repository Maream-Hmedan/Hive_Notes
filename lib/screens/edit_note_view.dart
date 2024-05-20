import 'package:flutter/material.dart';
import 'package:hive_notes/screens/notes_controller.dart';
import 'package:hive_notes/utils/common_views.dart';
import 'package:sizer/sizer.dart';

import 'notes_view.dart';

class EditNote extends StatefulWidget {
  final String title;
  final String description;
  final int keyNote;

  const EditNote(
      {super.key,
      required this.title,
      required this.description,
      required this.keyNote});

  @override
  State<EditNote> createState() => _EditNoteState();
}

class _EditNoteState extends State<EditNote> {
  final TextEditingController _titleController = TextEditingController();
  final FocusNode _titleFocusNode = FocusNode();

  final TextEditingController _descController = TextEditingController();
  final FocusNode _descFocusNode = FocusNode();

  bool bottomSheetOpened = false;

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  HiveNotes hiveNotes = HiveNotes();

  @override
  Widget build(BuildContext context) {
    _descController.text = widget.description;
    _titleController.text = widget.title;
    return Scaffold(
        key: scaffoldKey,
        appBar: CommonViews().customAppBar(
          title: "Edit Note",
          searchBar: false,
        ),
        body: Column(
          children: [
            SizedBox(height: 10.h),
            Container(
              height: 20.h,
              width: 100.w,
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade300, width: 2),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 3.h,
                  ),
                  SizedBox(
                    width: 90.w,
                    child: CommonViews().createTextFormField(
                        controller: _titleController,
                        focusNode: _titleFocusNode,
                        prefixIcon: Icons.note_alt_sharp,
                        onSubmitted: (v) {
                          _descFocusNode.requestFocus();
                        },
                        label: "Note Title",
                        hint: "Type Here Title"),
                  ),
                  SizedBox(
                    height: 3.h,
                  ),
                  SizedBox(
                    width: 90.w,
                    child: CommonViews().createTextFormField(
                      controller: _descController,
                      focusNode: _descFocusNode,
                      prefixIcon: Icons.multiline_chart,
                      label: "Note Description",
                      hint: "Type Here Description",
                      onSubmitted: (v) {
                        FocusManager.instance.primaryFocus!.unfocus();
                      },
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.deepPurpleAccent,
          onPressed: () {
            if (_titleController.text != widget.title ||
                _descController.text != widget.description) {
              hiveNotes.editNote(
                  title: _titleController.text,
                  description: _descController.text,
                  noteKey: widget.keyNote);
              Navigator.of(context, rootNavigator: false).pushAndRemoveUntil(
                PageRouteBuilder(
                  pageBuilder: (_, __, ___) =>const NotesScreen(),
                  transitionDuration: const Duration(milliseconds: 500),
                  transitionsBuilder: (_, a, __, c) =>
                      FadeTransition(opacity: a, child: c),
                ),
                    (route) => false,
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  backgroundColor: Colors.red,
                  content: Text("There is no change on data")));
            }
          },
          child: const Icon(Icons.edit),
        ));
  }
}
