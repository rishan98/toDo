import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'addTodo.dart';
import 'updateTodo.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TODO APP'),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [_titleBar()],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddTodo()));
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _titleBar() {
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection("notes").snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            return Column(
              children: snapshot.data!.docs.map((e) {
                var docId = e.id.toString();
                return Padding(
                  padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UpdateTodo(
                                    docId: docId,
                                    title: e['title'],
                                    messege: e['messege'],
                                    sdate: e['sdate'],
                                    edate: e["edate"],
                                    stime: e['stime'],
                                    etime: e['etime'],
                                  )));
                    },
                    child: Container(
                      height: 180,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Colors.lightGreen[100],
                          borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: ListView(
                            children: [
                              Text(
                                e["title"],
                                style: TextStyle(fontSize: 20),
                              ),
                              ListTile(
                                title: Text("Start Date"),
                                subtitle: Text(e["sdate"]),
                              ),
                              ListTile(
                                title: Text("Start Date"),
                                subtitle: Text(e["sdate"]),
                              )
                            ],
                          )),
                    ),
                  ),
                );
              }).toList(),
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}
