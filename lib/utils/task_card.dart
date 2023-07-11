import 'package:flutter/material.dart';
import 'package:taskr/pages/task_update.dart';
import 'package:taskr/utils/consts.dart';

class TaskCard extends StatelessWidget {
  final String title;
  final String description;
  final bool done;
  final String date;
  final String deadline;
  final int status;
  final int priority;
  final String taskId;

  const TaskCard({
    Key? key,
    required this.title,
    required this.description,
    required this.done,
    required this.date,
    required this.deadline,
    required this.status,
    required this.priority,
    required this.taskId,
  }) : super(key: key);

  String priorityToString(int priority) {
    if (priority == 0) {
      return 'Low';
    } else if (priority == 1) {
      return 'Medium';
    } else if (priority == 2) {
      return 'High';
    } else {
      return 'Unknown';
    }
  }

  String statusToString(int status) {
    if (status == 0) {
      return 'Waiting';
    } else if (status == 1) {
      return 'Working';
    } else if (status == 2) {
      return 'Suspended';
    } else if (status == 3) {
      return 'Completed';
    } else {
      return 'Unknown';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return TaskUpdate(
              docId: taskId,
              title: title,
              description: description,
              priority: priority,
              deadline: deadline,
              status: status);
        }));
        /*
        Navigator.push(context, MaterialPageRoute(builder: (context) => TaskForm(
          title:title,
          description:description,
          priority: priority,
          status: status,
          deadline: deadline,
        ),));
        */
      },
      child: Container(
        padding: const EdgeInsets.only(right: 12.0, left: 12.0, top: 12.0),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
                color: status == 3
                    ? AppColors.grey
                    : priority == 2
                        ? AppColors.pinkish
                        : priority == 1
                            ? AppColors.blue
                            : priority == 0
                                ? AppColors.yellow
                                : AppColors.yellow,
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                    right: 6.0, top: 6.0, left: 18.0, bottom: 14.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.0),
                            border: Border.all(color: AppColors.secondary),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 14.0, right: 14.0, top: 5.0, bottom: 5.0),
                            child: Text(
                              statusToString(status),
                              style: const TextStyle(
                                color: AppColors.secondary,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16.0),
                              border: Border.all(color: AppColors.secondary),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 14.0,
                                  right: 14.0,
                                  top: 5.0,
                                  bottom: 5.0),
                              child: Text(
                                priorityToString(priority),
                                style: const TextStyle(
                                  color: AppColors.secondary,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const Spacer(),
                        const IconButton(
                            onPressed: null,
                            icon: Icon(Icons.edit,
                                color: AppColors.secondary, size: 20.0)),
                      ],
                    ),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text(title,
                            style: const TextStyle(
                                color: AppColors.secondary,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold))),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(description,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  color: AppColors.secondary, fontSize: 14.0))),
                    ),
                    Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(right: 4.0),
                          child: Icon(
                            Icons.calendar_month,
                            size: 20,
                            color: AppColors.secondary,
                          ),
                        ),
                        Text(deadline),
                        const SizedBox(
                          width: 10,
                        ),
                        const Icon(
                          Icons.watch_later_outlined,
                          size: 20,
                          color: AppColors.secondary,
                        ),
                        const Text(" 16:30"),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
