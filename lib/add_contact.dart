import 'package:flutter/material.dart';
import 'contact.dart';
import 'package:flutter/services.dart';

class AddContact extends StatefulWidget {
  @override
  _AddContactState createState() => new _AddContactState();
}

class _AddContactState extends State<AddContact> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  Contact newContact = new Contact();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: const Text('添加联系人'),
        actions: <Widget>[
          new FlatButton(
            onPressed: _submitForm,
            child: new Text(
              '保存',
            ),
          )
        ],
      ),
      body: new SafeArea(
        top: false,
        bottom: false,
        child: getcontactForm(context),
      ),
    );
  }

  void _submitForm() {
    final FormState form = _formKey.currentState;

    if (!form.validate()) {
      showMessage('请重新填写表单');
    } else {
      form.save();
      Navigator.of(context).pop(newContact);
    }
  }

  void showMessage(String message, [MaterialColor color = Colors.red]) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      backgroundColor: color,
      content: new Text(message),
    ));
  }

  Form getcontactForm(BuildContext context) {
    return new Form(
      key: _formKey,
      autovalidate: true,
      child: new ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        children: <Widget>[
          new TextFormField(
            decoration: const InputDecoration(
              icon: const Icon(Icons.person),
              hintText: 'Enter your first and last name',
              labelText: 'Name',
            ),
            validator: (val) => val.isEmpty ? 'Name is required' : null,
            onSaved: (val) => newContact.name = val,
            onFieldSubmitted: (val) {},
          ),
          new TextFormField(
            decoration: const InputDecoration(
              icon: const Icon(Icons.phone),
              hintText: 'Enter a phone number',
              labelText: 'Phone',
            ),
            keyboardType: TextInputType.phone,
            inputFormatters: [
              WhitelistingTextInputFormatter.digitsOnly,
            ],
            onSaved: (val) => newContact.phone = val,
          ),
          new TextFormField(
            decoration: const InputDecoration(
              icon: const Icon(Icons.email),
              hintText: 'Enter a email address',
              labelText: 'Email',
            ),
            keyboardType: TextInputType.emailAddress,
            onSaved: (val) => newContact.email = val,
          ),
        ],
      ),
    );
  }
}
