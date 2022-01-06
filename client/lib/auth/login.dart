import 'package:flutter/material.dart';
import 'package:client/lobby/lobby.dart';
import 'package:client/auth/signUp.dart';

class LogIn extends StatefulWidget {
  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  
  TextEditingController controller1 = TextEditingController();
  TextEditingController controller2 = TextEditingController();

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
      body: Builder(
        builder: (context) {
          return SingleChildScrollView(
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
                            controller: controller1,
                            decoration: InputDecoration(
                              labelText: 'ID'
                            ),
                            keyboardType: TextInputType.emailAddress,
                          ),
                          TextField(
                            controller: controller2,
                            decoration: InputDecoration(
                              labelText: 'PASSWORD'
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
                                  onPressed: (){
        
                                    if(controller1.text == 'test' && controller2.text == '1234'){
                                      Navigator.push(context, 
                                        MaterialPageRoute(builder: (BuildContext context) => Lobby()));
                                    } else{
                                      showSnackBar(context);
                                    }
        
                                  },
                              )
                          ),
                          ButtonTheme(
                            minWidth: 100.0,
                              height: 50.0,
                              child: RaisedButton(
                                color: Colors.orange,
                                  child: Text(
                                    "회원가입"
                                  ),
                                  onPressed: (){
        
                                    if(controller1.text == 'test' && controller2.text == '1234'){
                                      Navigator.push(context, 
                                        MaterialPageRoute(builder: (BuildContext context) => SignUp()));
                                    } else{
                                      showSnackBar(context);
                                    }
        
                                  },
                              )
                          )
                        ]
                      )
                    )
                  )
                )
              ]
            ),
          );
        }
      )
    );
  }
}

void showSnackBar(BuildContext context){
  Scaffold.of(context).showSnackBar(
    SnackBar(content: 
      Text('로그인 확인 하세욧',
      textAlign: TextAlign.center,),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.blue,
    )
  );
}