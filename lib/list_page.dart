import 'package:flutter/material.dart';
import 'contact.dart';
import 'add_contact.dart';
import 'dart:async';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Contact> _contactList = [];

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new ListView.builder(
        itemCount: _contactList.length,
        itemBuilder: (BuildContext context, int index) {
          return getRow(index);
        },
      ),
      floatingActionButton: new FloatingActionButton(
        tooltip: '新增',
        child: new Icon(Icons.add),
        onPressed: () => _openContactAdd(),
      ),
    );
  }

  Widget getRow(int index) {
    return new FlatButton(
      child: new ListTile(
        title: new Text(_contactList[index].name),
        trailing: new Text(_contactList[index].email),
      ),
      onPressed: () {
        setState(() {
          _contactList.removeAt(index);
        });
      },
    );
  }

  Future _openContactAdd() async {
    Contact data =
        await Navigator.of(context).push(new MaterialPageRoute<Contact>(
            builder: (BuildContext context) {
              return new AddContact();
            },
            fullscreenDialog: true));
    setState(() {
      _contactList.add(data);
    });
  }
}
