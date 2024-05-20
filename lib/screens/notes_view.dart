import 'package:flutter/material.dart';
import 'package:hive_notes/screens/edit_note_view.dart';
import 'package:hive_notes/utils/common_views.dart';
import 'package:sizer/sizer.dart';

import 'notes_controller.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  final TextEditingController _titleController = TextEditingController();
  final FocusNode _titleFocusNode = FocusNode();

  final TextEditingController _descController = TextEditingController();
  final FocusNode _descFocusNode = FocusNode();

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  bool bottomSheetOpened = false;

  HiveNotes hiveNotes = HiveNotes();
  List<Map<String, dynamic>> notesFiltered = [];
  List<Map<String, dynamic>> notesNoMatch = [
    {"AA": "BB"}
  ];

  void filterNotes({required String input}) {
    setState(() {
      notesFiltered = hiveNotes.notesData
          .where((element) => element['title']
              .toString()
              .toLowerCase()
              .startsWith(input.toLowerCase()))
          .toList();
    });
  }

  @override
  void initState() {
    hiveNotes.getNotes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        appBar: CommonViews().customAppBar(
            title: "Note",
            controller: _searchController,
            focusNode: _searchFocusNode,
            searchBar: true,
            onChange: (input) {
              notesNoMatch.clear();
              filterNotes(input: input);
              notesNoMatch = notesFiltered;
            }),
        body: notesNoMatch.isNotEmpty
            ? ListView.builder(
                itemBuilder: (context, index) {
                  return Container(
                      height: 8.h,
                      width: 60.w,
                      margin: const EdgeInsets.all(10),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(10),
                        border:
                            Border.all(color: Colors.grey.shade300, width: 2),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                notesFiltered.isEmpty
                                    ? hiveNotes.notesData[index]["title"]
                                    : notesFiltered[index]["title"],
                                style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                notesFiltered.isEmpty
                                    ? hiveNotes.notesData[index]["description"]
                                    : notesFiltered[index]["description"],
                                style: TextStyle(
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                            ],
                          ),
                          const Spacer(),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              IconButton(
                                onPressed: () {
                                  hiveNotes.deleteNote(
                                      noteKey: hiveNotes.notesData[index]
                                          ["key"]);
                                  setState(() {
                                    hiveNotes.getNotes();
                                  });
                                },
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                              ),
                              IconButton(
                                onPressed: () {
                                  Navigator.of(context, rootNavigator: false)
                                      .push(
                                    MaterialPageRoute(
                                      builder: (_) => EditNote(
                                        title: hiveNotes.notesData[index]
                                            ["title"],
                                        description: hiveNotes.notesData[index]
                                            ["description"],
                                        keyNote: hiveNotes.notesData[index]
                                            ["key"],
                                      ),
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.edit),
                              ),
                            ],
                          )
                        ],
                      ));
                },
                itemCount: notesFiltered.isEmpty
                    ? hiveNotes.notesData.length
                    : notesFiltered.length)
            : Align(
                alignment: Alignment.topCenter,
                child: Column(
                  children: [
                    const SizedBox(height: 60),
                    Text(
                      "No matching results",
                      style: TextStyle(
                          fontSize: 15.sp,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.deepPurpleAccent,
          onPressed: () {
            if (bottomSheetOpened == false) {
              scaffoldKey.currentState!
                  .showBottomSheet((context) {
                    return Column(
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
                        ),
                        Align(
                          alignment: AlignmentDirectional.topEnd,
                          child: MaterialButton(
                            color: Colors.deepPurple,
                            textColor: Colors.white,
                            onPressed: () {
                              if (_titleController.text.isNotEmpty &&
                                  _descController.text.isNotEmpty) {
                                hiveNotes.addNote(
                                    title: _titleController.text,
                                    description: _descController.text);
                                setState(() {
                                  hiveNotes.getNotes();
                                  bottomSheetOpened = false;
                                });

                                Navigator.pop(context);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        backgroundColor: Colors.red,
                                        content: Text(
                                            "Please, fill Text Form Field, try again!")));
                              }
                            },
                            child: const Text("Add Note"),
                          ),
                        )
                      ],
                    );
                  })
                  .closed
                  .then((value) {
                    _descController.clear();
                    _titleController.clear();
                  });

              setState(() {
                bottomSheetOpened = true;
              });
            } else {
              setState(() {
                bottomSheetOpened = false;
              });
              Navigator.pop(context);
            }
          },
          child: bottomSheetOpened
              ? const Icon(Icons.clear)
              : const Icon(Icons.add),
        ));
  }
}
