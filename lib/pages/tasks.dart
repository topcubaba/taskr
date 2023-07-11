import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:taskr/utils/consts.dart';
import 'package:taskr/pages/task_add.dart';

import '../utils/get_task.dart';

class Tasks extends StatefulWidget {
  const Tasks({super.key});

  @override
  State<Tasks> createState() => _TasksState();
}

//TODO: Get rid of unnecessery constants
class _TasksState extends State<Tasks> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TaskAdd()),
          );
        },
        child: const Icon(Icons.add),
        backgroundColor: AppColors.secondary,
      ),
      appBar: AppBar(
        toolbarHeight: 42,
        backgroundColor: Colors.transparent,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarBrightness: Brightness.light,
        ),
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RotatedBox(
              quarterTurns: 2,
              child: IconButton(
                icon: const Icon(Icons.logout_outlined),
                constraints: const BoxConstraints(),
                padding: EdgeInsets.zero,
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                },
                color: AppColors.secondary,
              ),
            ),
            const Text(
              "Taskr",
              style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.secondary),
            ),
            const Icon(Icons.notifications, color: AppColors.secondary),
          ],
        ),
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(18.0, 10.0, 18.0, 0.0),
            child:
                Align(alignment: Alignment.centerLeft, child: Text("Welcome!")),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Padding(
                padding: EdgeInsets.fromLTRB(18.0, 5.0, 18.0, 0.0),
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Here are your tasks:",
                      style: TextStyle(
                          color: AppColors.secondary,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    )),
              ),
              IconButton(
                onPressed: null,
                icon: Icon(
                  Icons.search,
                  color: AppColors.secondary,
                  size: 30,
                ),
                constraints: BoxConstraints(),
                padding: EdgeInsets.only(right: 20.0, bottom: 10),
              ),
            ],
          ),
          const Expanded(child: getTasks()),
        ],
      ),
    );
  }
}
