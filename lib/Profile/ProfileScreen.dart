import 'package:blog_app/Profile/MainProfileScreen.dart';
import 'package:blog_app/Services/NetworkHandler.dart';
import 'package:flutter/material.dart';
import 'package:blog_app/Profile/CreateProfileScreen.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final networkHandler = NetworkHandler();

  Widget page = Center(
    child: CircularProgressIndicator(),
  );

  @override
  void initState() {
    super.initState();
    checkProfile();
  }

  void checkProfile() async {
    var response = await networkHandler.get("/profile/checkprofile");

    print(response["status"]);

    if (response["status"] == true) {
      setState(() {
        page = MainProfileScreen();
      });
    } else {
      setState(() {
        page = showAddProfile();
      });
    }
  }

  Widget showAddProfile() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Tap to button to add profile data",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.deepOrange,
              fontSize: 18,
            ),
          ),
          SizedBox(
            height: 30,
          ),
          GestureDetector(
            onTap: () => {Navigator.push(context, MaterialPageRoute(builder: (context) => CreateProfileScreen()))},
            child: Container(
              height: 60,
              width: 150,
              decoration: BoxDecoration(
                color: Colors.blueGrey,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(
                  "Add Profile",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: page,
    );
  }
}
