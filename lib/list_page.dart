import 'package:flutter/material.dart';
import 'contact.dart';
import 'add_contact.dart';
import 'dart:async';
import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'detail_contact.dart';


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
          return getRow(context, index);
        },
      ),
      floatingActionButton: new FloatingActionButton(
        tooltip: '新增',
        child: new Icon(Icons.add),
        onPressed: () => _openContactAdd(context),
      ),
    );
  }

  Widget getRow(BuildContext context, int index) {
    return new Card(
      child: new Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          new ListTile(
            leading: new FlutterLogo(size: 50.0,),
            title: new Text(
              _contactList[index].name,
              style: new TextStyle(fontSize:22.0, fontWeight: FontWeight.bold),
              ),
            subtitle: new Text(_contactList[index].phone),
          ),
          new Divider(),
          new ButtonTheme.bar(
            // make buttons use the appropriate styles for cards
            child: new ButtonBar(
              alignment: MainAxisAlignment.start,
              children: <Widget>[
                new FlatButton(
                  child: const Text('详情'),
                  onPressed:() => _showContactDetail(context, index),
                ),
              ],
            ),
          ),
        ],
      ),
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

  Future _showContactDetail(BuildContext context, int index) async {
    Contact data =
        await Navigator.of(context).push(new MaterialPageRoute<Contact>(
            builder: (BuildContext context) {
              return new DetailContact(contact: _contactList[index]);
            },
            fullscreenDialog: true));
    if (data != null) {
      // 添加联系人
      contactProvider.updateContact(data);
      setState(() {
        _contactList[index] = data;
      });
    }
  }
}
