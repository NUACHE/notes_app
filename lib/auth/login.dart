// ignore_for_file: non_constant_identifier_names, duplicate_ignore, prefer_final_fields, unnecessary_null_comparison, avoid_print, prefer_const_constructors, unnecessary_new

import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:st_notes_app/auth/sign_up.dart';
import 'package:st_notes_app/models/note.dart';
import 'package:st_notes_app/screens/home.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State createState() => LoginState();
}

class LoginState extends State<Login> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _dateOfBirth = TextEditingController();

  final TextEditingController _pwController = TextEditingController();
  // ignore: unused_field

  var showDialogBox = false;
  // Initially password is obscure

  bool _obscureText = true;
  bool filled = false;
  var device_id = '';

  // ignore: non_constant_identifier_names
  bool email_verify = true;
  // ignore: non_constant_identifier_names
  bool password_verify = true;

  @override
  void initState() {
    super.initState();
  }

  toggle() {
    if (_name.text != '' &&
        _emailController.text != '' &&
        _dateOfBirth.text != '' &&
        _pwController.text != '') {
      setState(() {
        filled = true;
      });
    } else {
      setState(() {
        filled = false;
      });
    }
  }

  fetchUser() async {
    // Obtain shared preferences.
    final SharedPreferences prefs = await SharedPreferences.getInstance();

   var data = prefs.getString('users');
print(data);
if(data != null){
List arrayValue = jsonDecode(data);
if(arrayValue.contains('${_name.text}-${_pwController.text}')){
  print('object already exists');
  await prefs.setString('current','${_name.text}-${_pwController.text}' );
  if(mounted){
   Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => HomeScreen(),
                                ),
                              );
  }
}else{
     showAlertDialog(context, 'User does not exist');  
 print('object doesnt exists');
}
}else{
   showAlertDialog(context, 'User does not exist');  
  print('object doesnt exists');
}

    

   
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  'Login',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  'Login to access your notes.',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  onChanged: (value) {
                    toggle();
                  },
                  cursorColor: Colors.blueAccent,
                  controller: _name,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: Colors.grey.shade300,
                        )),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: Colors.grey.shade300,
                        )),
                    contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                    hintText: 'Enter your username',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  onChanged: (value) {
                    toggle();
                  },
                  cursorColor: Colors.blueAccent,
                  obscureText: _obscureText,
                  controller: _pwController,
                  decoration: InputDecoration(
                 
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: Colors.grey.shade300,
                        )),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: Colors.grey.shade300,
                        )),
                    contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                    hintText: 'Enter your password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 60),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: ElevatedButton(
                    onPressed: () async {
                      await fetchUser();
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(400, 50),
                      backgroundColor: Colors.grey.shade800,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0)),
                    ),
                    child: Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 18.0, bottom: 20),
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: "Don't have an account ? ",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blueAccent,
                          ),
                        ),
                        TextSpan(
                          recognizer: new TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SignUp(),
                                ),
                              );
                            },
                          text: 'Sign Up',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blueAccent,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  showAlertDialog(BuildContext context, message) {  
  // Create button  
  Widget okButton = ElevatedButton(  
    child: Text("OK"),  
    onPressed: () {  
      Navigator.of(context).pop();  
    },  
  );  
  
  // Create AlertDialog  
  AlertDialog alert = AlertDialog(  
    title: Text("Alert"),  
    content: Text("$message"),  
    actions: [  
      okButton,  
    ],  
  );  
  
  // show the dialog  
  showDialog(  
    context: context,  
    builder: (BuildContext context) {  
      return alert;  
    },  
  );  
}  
}
