import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_toggle_tab/flutter_toggle_tab.dart';
import 'package:intl/intl.dart';

import '../utils/consts.dart';

class TaskUpdate extends StatefulWidget {
  final String docId;
  final String title;
  final String description;
  final String deadline;
  final int priority;
  final int status;
  const TaskUpdate(
      {Key? key,
      required this.docId,
      required this.title,
      required this.description,
      required this.deadline,
      required this.priority,
      required this.status})
      : super(key: key);

  @override
  State<TaskUpdate> createState() => _TaskUpdateState();
}

class _TaskUpdateState extends State<TaskUpdate> {
  var titleTEC = TextEditingController();
  var descriptionTEC = TextEditingController();
  late final String _docId = widget.docId;

  FocusScopeNode? currentFocus;
  var _selectedPriority = 1;
  var _selectedStatus = 1;
  var _selectedDeadline = DateFormat('dd.MM.yyyy').format(DateTime.now());
  final _togglePriorityItems = ["Low", "Medium", "High"];
  final _toggleStatusItems = ["Waiting", "Working", "Suspended", "Completed"];

  @override
  void initState() {
    super.initState();
    titleTEC.text = widget.title;
    descriptionTEC.text = widget.description;
    _selectedDeadline = widget.deadline;
    _selectedPriority = widget.priority;
    _selectedStatus = widget.status;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 42,
        backgroundColor: Colors.transparent,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarBrightness: Brightness.light,
        ),
        iconTheme: const IconThemeData(color: AppColors.secondary),
        elevation: 0,
        title: const Text(
          "Taskr",
          style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.secondary),
        ),
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(18.0, 10.0, 18.0, 5.0),
            child: Align(
              child: Text(
                "Add New Task",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              alignment: Alignment.centerLeft,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: titleTEC,
              cursorColor: AppColors.secondary,
              decoration: const InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.secondary),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.secondary),
                ),
                labelText: 'Title*',
                labelStyle: TextStyle(color: AppColors.secondary, fontSize: 14),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: descriptionTEC,
              maxLines: 3,
              cursorColor: AppColors.secondary,
              decoration: const InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.secondary),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.secondary),
                ),
                labelText: 'Description*',
                labelStyle: TextStyle(color: AppColors.secondary, fontSize: 14),
                alignLabelWithHint: true,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(14.0, 8.0, 14.0, 0.0),
            child: Align(
              child: Text("Select Priority*"),
              alignment: Alignment.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14.0, 12.0, 14.0, 12.0),
            child: FlutterToggleTab(
              width: 90,
              borderRadius: 30,
              height: 40,
              selectedIndex: _selectedPriority,
              selectedBackgroundColors: const [AppColors.secondary],
              selectedTextStyle: const TextStyle(
                  color: AppColors.primary,
                  fontSize: 14,
                  fontWeight: FontWeight.w700),
              unSelectedTextStyle: const TextStyle(
                  color: AppColors.secondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w500),
              labels: _togglePriorityItems,
              selectedLabelIndex: (index) {
                setState(() {
                  _selectedPriority = index;
                });
              },
              isScroll: false,
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(14.0, 12.0, 14.0, 0.0),
            child: Align(
              child: Text("Select Status*"),
              alignment: Alignment.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14.0, 12.0, 14.0, 12.0),
            child: FlutterToggleTab(
              width: 90,
              borderRadius: 30,
              height: 40,
              selectedIndex: _selectedStatus,
              selectedBackgroundColors: const [AppColors.secondary],
              selectedTextStyle: const TextStyle(
                  color: AppColors.primary,
                  fontSize: 14,
                  fontWeight: FontWeight.w700),
              unSelectedTextStyle: const TextStyle(
                  color: AppColors.secondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w500),
              labels: _toggleStatusItems,
              selectedLabelIndex: (index) {
                setState(() {
                  _selectedStatus = index;
                });
              },
              isScroll: false,
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(14.0, 12.0, 14.0, 0.0),
            child: Align(
              child: Text("Pick Deadline*"),
              alignment: Alignment.center,
            ),
          ),
          Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 8.0, 20.0, 12.0),
              child: FilledButton(
                style:
                    TextButton.styleFrom(backgroundColor: AppColors.secondary),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.calendar_month,
                      color: AppColors.primary,
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Text(
                      _selectedDeadline,
                      style: const TextStyle(
                          fontSize: 20, color: AppColors.primary),
                    ),
                  ],
                ),
                onPressed: () async {
                  currentFocus = FocusScope.of(context);
                  currentFocus?.unfocus();
                  final value = await showCalendarDatePicker2Dialog(
                    context: context,
                    config: CalendarDatePicker2WithActionButtonsConfig(
                        selectedDayHighlightColor: AppColors.secondary),
                    dialogSize: const Size(325, 400),
                  );
                  if (value != null) {
                    setState(() {
                      _selectedDeadline = DateFormat('dd.MM.yyyy')
                          .format(value.single as DateTime);
                    });
                  }
                },
              )),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.fromLTRB(22.0, 0, 22.0, 36.0),
            child: MaterialButton(
              height: 50,
              child: const Text("Confirm"),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              textColor: AppColors.primary,
              onPressed: () async {
                final FirebaseAuth auth = FirebaseAuth.instance;
                final User? user = auth.currentUser;
                final uid = user!.uid;
                var title = titleTEC.text.trim();
                var description = descriptionTEC.text.trim();
                await FirebaseFirestore.instance
                    .collection('tasks')
                    .doc(_docId)
                    .update({
                  'title': title,
                  'uid': uid,
                  'description': description,
                  'deadline': _selectedDeadline,
                  'priority': _selectedPriority,
                  'status': _selectedStatus
                });
                Navigator.pop(context);
              },
              color: AppColors.secondary,
              disabledColor: AppColors.secondary,
              minWidth: double.infinity,
            ),
          ),
        ],
      ),
    );
  }
}
