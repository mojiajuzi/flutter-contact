import 'dart:async';

import 'package:sqflite/sqflite.dart';

String tableName = "contacts";

class Contact {
  int id;
  String name; //用户名
  String nickName; //用户英文名
  String phone = ''; //电话
  String email = ''; // 邮箱
  String company; //公司
  String department; // 部门
  String designation; //职位
  String address; //公司地址
  String logo; //企业logo

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "name": name,
      "nickName": nickName,
      "phone": phone,
      "email": email,
      "company": company,
      "department": department,
      "designation": designation,
      "address": address,
      "logo": logo
    };

    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  Contact();

  Contact.fromMap(Map<String, dynamic> map) {
    map.forEach((k, item) {
      item = item;
    });

    // name = map["name"];
    // nickName = map["nickName"];
    // phone = map["phone"];
    // email = map["email"];
    // company = map["company"];
    // department = map["department"];
    // designation = map["designation"];
    // address = map["address"];
    // logo = map["logo"];
  }
}

class ContactProvider {
  Database db;

  Future open(String path) async {
    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''
        create table contacts(

          id integer not null primary key autoincrement,
          
          name text  not null,
          
          nickname text  null,
          
          phone text not null,
          
          email text not null,
          
          company text null,
          
          department text  null,
          
          designation text  null,
          
          address text  null,
          
          logo text  null
        )
      ''');
    });
  }

  Future<Contact> insertContact(Contact contact) async {
    contact.id = await db.insert(tableName, contact.toMap());
    return contact;
  }

  Future<Contact> getContact(int id) async {
    List<Map> maps =
        await db.query(tableName, where: "id = ?", whereArgs: [id]);

    if (maps.length > 0) {
      return new Contact.fromMap(maps.first);
    }
    return null;
  }

  Future<List<Contact>> getContacts() async {
    List<Map> maps = await db.query(tableName);

    List<Contact> list = [];

    if (maps.length > 0) {
      for (var item in maps) {
        list.add(Contact.fromMap(item));
      }
    }
    return list;
  }

  Future<int> updateContact(Contact contact) async {
    return await db.update(tableName, contact.toMap(),
        where: "id = ?", whereArgs: [contact.id]);
  }

  Future<int> deleteContact(int id) async {
    return await db.delete(tableName, where: "id = ?", whereArgs: [id]);
  }

  Future close() => db.close();
}
