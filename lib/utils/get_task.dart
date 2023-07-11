import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:taskr/utils/task_card.dart';
import 'package:rive/rive.dart';
import 'package:taskr/utils/consts.dart';

class getTasks extends StatefulWidget {
  const getTasks({super.key});

  @override
  _getTasksState createState() => _getTasksState();
}

class _getTasksState extends State<getTasks> {
  final ref = FirebaseFirestore.instance
      .collection("tasks")
      .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: ref.snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          //print(snapshot.error);
          return const Text(AppTexts.wentWrong);
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: SizedBox(
                  width: 150,
                  height: 150,
                  child: RiveAnimation.asset('assets/loading.riv')));
        }
        return ListView(
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data =
                document.data()! as Map<String, dynamic>;
            return Dismissible(
              direction: DismissDirection.endToStart,
              key: Key(document.id),
              onDismissed: (direction) {
                FirebaseFirestore.instance
                    .collection('tasks')
                    .doc(document.id)
                    .delete();
              },
              child: TaskCard(
                title: data['title'],
                description: data['description'],
                done: false,
                date: data['deadline'],
                deadline: data['deadline'],
                priority: data['priority'],
                status: data['status'],
                taskId: document.id,
              ),
              background: Padding(
                padding: const EdgeInsets.only(right: 12.0, top: 12.0),
                child: Container(
                  color: Colors.redAccent,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      SizedBox(),
                      Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Icon(Icons.delete),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
