import 'dart:convert';
import 'package:blog_app/HelperFunction/SharedPrefHelper.dart';
import 'package:blog_app/Services/NetworkHandler.dart';
import 'package:blog_app/Utils/Utils.dart';
import 'package:flutter/material.dart';
import 'HomePage.dart';

class SignUpPage extends StatefulWidget {
  SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _usernameController = new TextEditingController();
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();

  bool vis = true;
  bool validate = false;
  bool isLoading = false;
  String? errortxt;

  final pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';

  NetworkHandler networkHandler = NetworkHandler();

  checkUsername() async {
    if (_usernameController.text.length == 0) {
      setState(() {
        validate = false;
        errortxt = "Username can't be empty";
      });
    } else {
      var response = await networkHandler.get("/user/checkusername/${_usernameController.text}");
      if (response["Status"]) {
        setState(() {
          validate = false;
          errortxt = "Username already taken.";
        });
      } else {
        setState(() {
          validate = true;
        });
      }
    }
  }

  //sign up button function
  signUpFunc() async {
    setState(() {
      isLoading = true;
    });
    await checkUsername();
    if (_formKey.currentState!.validate() && validate) {
      Map<String, String> userData = {
        "username": _usernameController.text,
        "email": _emailController.text,
        "password": _passwordController.text
      };
      var responseRegister = await networkHandler.post("/user/register", userData);

      // login and token query
      if (responseRegister.statusCode == 200 || responseRegister.statusCode == 201) {
        Map<String, String> data = {
          "username": _usernameController.text,
          "password": _passwordController.text,
        };
        var response = await networkHandler.post("/user/login", data);

        if (response.statusCode == 200 || response.statusCode == 201) {
          Map<String, dynamic> result = json.decode(response.body);
          print(result["token"]);
          await SharedPreferenceHelper().saveToken(result["token"]);

          setState(() {
            validate = true;
            isLoading = false;
          });

          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => HomePage(),
              ),
              (route) => false);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Netwok Error")));
        }
      }
    } else {
      setState(() {
        isLoading = false;
      });
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
                  "Sign up with email",
                  style: TextStyle(
                    fontSize: 30,
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
                          errorText: validate ? null : errortxt,
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
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 5.0),
                  child: Column(
                    children: [
                      Text("Email"),
                      TextFormField(
                        validator: (val) {
                          if (val!.isEmpty) return "Email can't be empty";
                          if (RegExp(pattern).hasMatch(val)) return null;

                          return "Invalid email!";
                        },
                        keyboardType: TextInputType.emailAddress,
                        controller: _emailController,
                        decoration: InputDecoration(
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
                        validator: (val) {
                          if (val!.isEmpty) return "Password can't be empty";
                          if (val.length < 8) return "Password must be greater than 8 characters";
                          return null;
                        },
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: vis,
                        controller: _passwordController,
                        decoration: InputDecoration(
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
                InkWell(
                  onTap: () {
                    signUpFunc();
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
                              "Sign Up",
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
