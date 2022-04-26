import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'homepage.dart';

class UpdateTodo extends StatefulWidget {
  final String title, messege, docId, edate, etime, sdate, stime;

  const UpdateTodo({
    Key? key,
    required this.title,
    required this.messege,
    required this.docId,
    required this.edate,
    required this.etime,
    required this.sdate,
    required this.stime,
  });

  @override
  State<UpdateTodo> createState() => _UpdateTodoState();
}

class _UpdateTodoState extends State<UpdateTodo> {
  final TextEditingController _title = TextEditingController();
  final TextEditingController _messege = TextEditingController();

  late DateTime sdate;
  late DateTime edate;
  late TimeOfDay stime = TimeOfDay.now();
  late TimeOfDay etime = TimeOfDay.now();
  late TimeOfDay spicked;
  late TimeOfDay epicked;

  @override
  void initState() {
    super.initState();
    stime = TimeOfDay.now();
    etime = TimeOfDay.now();
  }

  Future<Null> sselectTime(BuildContext context) async {
    spicked = (await showTimePicker(context: context, initialTime: stime))!;

    setState(() {
      stime = spicked;
    });
  }

  Future<Null> eselectTime(BuildContext context) async {
    epicked = (await showTimePicker(context: context, initialTime: etime))!;

    setState(() {
      etime = epicked;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Notes'),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(15.0),
              child: TextField(
                controller: _title,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: widget.title,
                ),
              ),
            ),
            _buildTextField(),
            SizedBox(
              height: 20.0,
            ),
            ListTile(
              title: Text("Start TIme"),
              subtitle: Text(widget.stime),
            ),
            ListTile(
              title: Text("Start TIme"),
              subtitle: Text(widget.etime),
            ),
            SizedBox(
              height: 10.0,
            ),
            _startDate(),
            SizedBox(
              height: 20.0,
            ),
            _endtDate(),
            Padding(
              padding: const EdgeInsets.fromLTRB(80, 0, 80, 0),
              child: Row(
                children: [
                  _buttonSave(),
                  SizedBox(
                    width: 20,
                  ),
                  _buttonDelete()
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTextField() {
    final maxLines = 5;

    return Container(
      margin: EdgeInsets.all(12),
      height: maxLines * 24.0,
      child: TextField(
        controller: _messege,
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: widget.messege,
          filled: true,
        ),
      ),
    );
  }

  Widget _buttonSave() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
      child: Container(
        height: 50,
        width: 100,
        decoration: BoxDecoration(
            color: Colors.blue, borderRadius: BorderRadius.circular(10)),
        child: TextButton(
          onPressed: () async {
            // final firebaseUser = FirebaseAuth.instance.currentUser!;

            if (_title == "") {
              await FirebaseFirestore.instance
                  .collection('notes')
                  .doc(widget.docId)
                  .update({
                "title": widget.title,
                "messege": _messege.text,
                "sdate": sdate.toString(),
                "edate": edate.toString(),
                "stime": stime.toString(),
                "etime": etime.toString()
              });
            } else if (_messege == "") {
              await FirebaseFirestore.instance
                  .collection('notes')
                  .doc(widget.docId)
                  .update({
                "title": _title.text,
                "messege": widget.messege,
                "sdate": sdate.toString(),
                "edate": edate.toString(),
                "stime": stime.toString(),
                "etime": etime.toString()
              });
            } else {
              await FirebaseFirestore.instance
                  .collection('notes')
                  .doc(widget.docId)
                  .update({
                "title": _title.text,
                "messege": _messege.text,
                "sdate": sdate.toString(),
                "edate": edate.toString(),
                "stime": stime.toString(),
                "etime": etime.toString()
              });
            }

            Navigator.push(
                context, MaterialPageRoute(builder: (context) => HomePage()));
          },
          child: Text(
            'Update',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _buttonDelete() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
      child: Container(
        height: 50,
        width: 100,
        decoration: BoxDecoration(
            color: Colors.red, borderRadius: BorderRadius.circular(10)),
        child: TextButton(
          onPressed: () async {
            // final firebaseUser = FirebaseAuth.instance.currentUser!;
            await FirebaseFirestore.instance
                .collection('notes')
                .doc(widget.docId)
                .delete();

            Navigator.push(
                context, MaterialPageRoute(builder: (context) => HomePage()));
          },
          child: Text(
            'Delete',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _startDate() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
      child: Column(
        children: [
          Text("Start Date & Time"),
          Row(
            children: [
              Container(
                child: FlatButton(
                  onPressed: () {
                    showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2050))
                        .then((value) {
                      setState(() {
                        sdate = value!;
                      });
                    });
                  },
                  child: Text(' Date'),
                  color: Colors.amber,
                  minWidth: 150,
                ),
              ),
              SizedBox(
                width: 10.0,
              ),
              Container(
                child: FlatButton(
                  onPressed: () {
                    sselectTime(context);
                    print(stime);
                  },
                  child: Text('Time'),
                  color: Colors.amber,
                  minWidth: 150,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _endtDate() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
      child: Column(
        children: [
          Text("End Date & Time"),
          Row(
            children: [
              Container(
                child: FlatButton(
                  onPressed: () {
                    showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2050))
                        .then((value) {
                      setState(() {
                        edate = value!;
                      });
                    });
                  },
                  child: Text('Date'),
                  color: Colors.pink,
                  minWidth: 150,
                ),
              ),
              SizedBox(
                width: 10.0,
              ),
              Container(
                child: FlatButton(
                  onPressed: () {
                    eselectTime(context);
                    print(etime);
                  },
                  child: Text('Time'),
                  color: Colors.pink,
                  minWidth: 150,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
