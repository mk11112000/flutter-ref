import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert' show json, base64, ascii;

const SERVER_IP = 'http://192.168.225.244:3000';
final storage = FlutterSecureStorage();

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  //
  Future<String> get jwtOrEmpty async {
    var jwt = await storage.read(key: "jwt");
    if (jwt == null) return "";
    return jwt;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      // home: FutureBuilder(
      //   future: jwtOrEmpty,
      //   builder: (context, snapshot) {
      //     if (!snapshot.hasData) return CircularProgressIndicator();

      //     if (snapshot.data != "") {
      //       var str = snapshot.data;

      //       var jwt = str.split(".");

      //       if (jwt.length != 3) {
      //         return LoginPage();
      //       } else {
      //         var payload = json.decode(
      //             ascii.decode(base64.decode(base64.normalize(jwt[1]))));

      //         if (DateTime.fromMillisecondsSinceEpoch(payload["exp"] * 1000)
      //             .isAfter(DateTime.now())) {
      //           return HomePage(str, payload);
      //         } else {
      //           return LoginPage();
      //         }
      //       }
      //     } else {
      //       return LoginPage();
      //     }
      //   },
      // ),

      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String jwt =
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6ImJpbGxhbCIsImlhdCI6MTU5NzUxNDU5MiwiZXhwIjoxNTk3NTE0NjA3fQ.CVLG2Ir8w5GS3DZglzvIU2y7-0Cm7NVL_-PLFbJabRo";
    Map<String, dynamic> payload = json.decode(
        ascii.decode(base64.decode(base64.normalize(jwt.split(".")[1]))));

    return Scaffold(
      appBar: AppBar(title: Text("Secret Data Screen")),
      body: Center(
        child: FutureBuilder(
            future:
                http.read('$SERVER_IP/data', headers: {"Authorization": jwt}),
            builder: (context, snapshot) => snapshot.hasData
                ? Column(
                    children: <Widget>[
                      Text("${payload['username']}, here's the data:"),
                      Text(snapshot.data,
                          style: Theme.of(context).textTheme.display1)
                    ],
                  )
                : snapshot.hasError
                    ? Text(snapshot.error.toString())
                    : CircularProgressIndicator()),
      ),
    );
  }
}

class LoginPage extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void displayDialog(context, title, text) => showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(title: Text(title), content: Text(text)),
      );

  Future<String> attemptLogIn(String username, String password) async {
    var res = await http.post("$SERVER_IP/login",
        body: {"username": username, "password": password});

    print(res.body);
    if (res.statusCode == 200) return res.body;
    return null;
  }

  Future<int> attemptSignUp(String username, String password) async {
    var res = await http.post('$SERVER_IP/signup',
        body: {"username": username, "password": password});
    print(res.body);

    return res.statusCode;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("LOGIN"),
      ),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Password'),
            ),
            // FlatButton(
            //     onPressed: () async {
            //       var username = _usernameController.text;
            //       var password = _passwordController.text;
            //       var jwt = await attemptLogIn(username, password);
            //       if (jwt != null) {
            //         storage.write(key: "jwt", value: jwt);
            //         Navigator.push(
            //             context,
            //             MaterialPageRoute(
            //                 builder: (context) => HomePage.fromBase64(jwt)));
            //       } else {
            //         displayDialog(context, "An Error Occurred",
            //             "No account was found matching that username and password");
            //       }
            //     },
            //     child: Text("Log In")),
            FlatButton(
                onPressed: () async {
                  var username = _usernameController.text;
                  var password = _passwordController.text;

                  if (username.length < 4)
                    displayDialog(context, "Invalid Username",
                        "The username should be at least 4 characters long");
                  else if (password.length < 4)
                    displayDialog(context, "Invalid Password",
                        "The password should be at least 4 characters long");
                  else {
                    var res = await attemptSignUp(username, password);
                    if (res == 201)
                      displayDialog(context, "Success",
                          "The user was created. Log in now.");
                    else if (res == 409)
                      displayDialog(
                          context,
                          "That username is already registered",
                          "Please try to sign up using another username or log in if you already have an account.");
                    else {
                      displayDialog(
                          context, "Error", "An unknown error occurred.");
                    }
                  }
                },
                child: Text("Sign Up"))
          ],
        ),
      ),
    );
  }
}
