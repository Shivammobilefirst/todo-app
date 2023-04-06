import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Addtask extends StatefulWidget {
  const Addtask({super.key});

  @override
  State<Addtask> createState() => _AddtaskState();
}

class _AddtaskState extends State<Addtask> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descripController = TextEditingController();

  addTaskToFirebase() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    final User user = await auth.currentUser!;
    final uid = user.uid;
    var time = DateTime.now();
    await FirebaseFirestore.instance
        .collection("tasks")
        .doc(uid)
        .collection("mytask")
        .doc(time.toString())
        .set({
      "title": titleController.text,
      "description": descripController.text,
      "time": time.toString(),
      "timestamp": time,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Task"),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              child: TextField(
                controller: titleController,
                decoration: InputDecoration(
                    labelText: "Enter title", border: OutlineInputBorder()),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              child: TextField(
                controller: descripController,
                decoration: InputDecoration(
                    labelText: "Enter description",
                    border: OutlineInputBorder()),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () {
                      addTaskToFirebase();
                      Navigator.pop(context);
                    },
                    child: Text("Add task")))
          ],
        ),
      ),
    );
  }
}
