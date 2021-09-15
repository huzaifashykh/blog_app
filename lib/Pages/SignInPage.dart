import 'dart:convert';
import 'package:blog_app/HelperFunction/SharedPrefHelper.dart';
import 'package:blog_app/Pages/HomePage.dart';
import 'package:blog_app/Pages/SignUpPage.dart';
import 'package:blog_app/Services/NetworkHandler.dart';
import 'package:blog_app/Utils/Utils.dart';
import 'package:flutter/material.dart';

class SignInPage extends StatefulWidget {
  SignInPage({Key? key}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _usernameController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();

  bool vis = true;
  bool usernameValidate = false;
  bool passValidate = false;
  bool isLoading = false;
  String? usernameErrorTxt;
  String? passwordErrorTxt;

  NetworkHandler networkHandler = NetworkHandler();

  //sign in button function
  signInFunc() async {
    if (_usernameController.text.length == 0) {
      setState(() {
        usernameErrorTxt = "Username can't be empty";
        usernameValidate = false;
      });
    } else if (_passwordController.text.length == 0) {
      setState(() {
        passwordErrorTxt = "Password can't be empty";
        passValidate = false;
      });
    } else {
      setState(() {
        isLoading = true;
        passValidate = true;
        usernameValidate = true;
      });

      Map<String, String> userData = {
        "username": _usernameController.text,
        "password": _passwordController.text,
      };

      var response = await networkHandler.post("/user/login", userData);

      if (response.statusCode == 200 || response.statusCode == 201) {
        Map<String, dynamic> result = json.decode(response.body);
        await SharedPreferenceHelper().saveToken(result["token"]);
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => HomePage()), (route) => false);
        print(result["token"]);
        setState(() {
          usernameValidate = true;
          passValidate = true;
          isLoading = false;
        });
      } else {
        String result = json.decode(response.body);
        setState(() {
          isLoading = false;
        });

        if (result.contains("Username")) {
          setState(() {
            usernameErrorTxt = "Username doesn't exist";
            usernameValidate = false;
          });
        } else if (result.contains("Password")) {
          setState(() {
            usernameErrorTxt = null;
            passwordErrorTxt = "Invalid Password";
            passValidate = false;
          });
        }
        print(result);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: bgDecoration,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Sign In with Username",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10.0),
                  child: Column(
                    children: [
                      Text("Username"),
                      TextFormField(
                        keyboardType: TextInputType.name,
                        controller: _usernameController,
                        decoration: InputDecoration(
                          errorText: usernameValidate ? null : usernameErrorTxt,
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.black,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10.0),
                  child: Column(
                    children: [
                      Text("Password"),
                      TextFormField(
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: vis,
                        controller: _passwordController,
                        decoration: InputDecoration(
                          errorText: passValidate ? null : passwordErrorTxt,
                          suffixIcon: IconButton(
                            icon: Icon(
                              vis ? Icons.visibility_off : Icons.visibility,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              setState(() {
                                vis = !vis;
                              });
                            },
                          ),
                          helperText: "Password must be greater than 8 characters",
                          helperStyle: TextStyle(
                            fontSize: 14,
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.black,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {},
                        child: Text(
                          "Forget Password?",
                          style: TextStyle(
                            color: Color(0xff00A86B),
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SignUpPage(),
                            ),
                          );
                        },
                        child: Text(
                          "New User?",
                          style: TextStyle(
                            color: Color(0xff00A86B),
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () {
                    signInFunc();
                  },
                  child: isLoading
                      ? CircularProgressIndicator()
                      : Container(
                          width: 150,
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Color(0xff00A86B),
                          ),
                          child: Center(
                            child: Text(
                              "Sign In",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
