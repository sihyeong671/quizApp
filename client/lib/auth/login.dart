import 'package:flutter/material.dart';

class LogIn extends StatefulWidget {
  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Log in'),
        backgroundColor: Colors.redAccent,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: (){}
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: (){}
          )
        ]
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(padding: EdgeInsets.only(top: 50)),
            Form(
              child: Theme(
                data: ThemeData(
                  primaryColor: Colors.teal,
                  inputDecorationTheme: InputDecorationTheme(
                    labelStyle: TextStyle(
                      color: Colors.teal,
                      fontSize: 15.0
                    )
                  )
                ),
                child: Container(
                  padding: EdgeInsets.all(40.0),
                  child: Column(
                    children: <Widget>[
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Enter "ID"'
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Enter "PW"'
                        ),
                        keyboardType: TextInputType.text,
                        obscureText: true,
                      ),
                      SizedBox(
                        height: 40.0,
                      ),
                      ButtonTheme(
                        minWidth: 100.0,
                          height: 50.0,
                          child: RaisedButton(
                            color: Colors.orangeAccent,
                              child: Icon(
                                Icons.arrow_forward,
                              color: Colors.white,
                              size: 35.0,
                              ),
                              onPressed: (){},
                          )
                      )
                    ]
                  )
                )
              )
            )
          ]
        ),
      )
    );
  }
}