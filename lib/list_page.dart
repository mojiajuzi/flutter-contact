import 'package:flutter/material.dart';
import 'contact.dart';
import 'add_contact.dart';
import 'dart:async';
import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Contact> _contactList = [];

  ContactProvider contactProvider;

  // 数据存放目录
  Directory directory;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }

  Future init() async {
    contactProvider = new ContactProvider();
    directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, "contact.db");
    await contactProvider.open(path);

    List<Contact> contacts = await contactProvider.getContacts();

    // 获取到数据以后,更新状态
    setState(() {
      _contactList.addAll(contacts);
    });
  }

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
        onPressed: () => _openContactAdd(context),
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

  Future _openContactAdd(BuildContext context) async {
    Contact data =
        await Navigator.of(context).push(new MaterialPageRoute<Contact>(
            builder: (BuildContext context) {
              return new AddContact();
            },
            fullscreenDialog: true));
    if (data != null) {
      // 添加联系人
      contactProvider.insertContact(data);
      setState(() {
        _contactList.add(data);
      });
    }
  }
}
