import 'package:blog_app/Blog/Blogs.dart';
import 'package:blog_app/Models/ProfileModel.dart';
import 'package:blog_app/Services/NetworkHandler.dart';
import 'package:flutter/material.dart';

class MainProfileScreen extends StatefulWidget {
  MainProfileScreen({Key? key}) : super(key: key);

  @override
  _MainProfileScreenState createState() => _MainProfileScreenState();
}

class _MainProfileScreenState extends State<MainProfileScreen> {
  final networkHandler = NetworkHandler();
  bool circular = false;
  String profileImg = "";
  ProfileModel profileModel = ProfileModel(
      DOB: "",
      about: "",
      name: "",
      profession: "",
      titleline: "",
      username: "");

  @override
  void initState() {
    super.initState();

    fetchData();
  }

  fetchData() async {
    var response = await networkHandler.get("/profile/getdata");

    setState(() {
      profileModel = ProfileModel.fromJson(response["data"]);
      profileImg = networkHandler.getImage(profileModel.username);
      circular = false;
    });

    // print();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color(0xffEEEEFF),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white10,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {},
            color: Colors.black,
          ),
        ],
      ),
      body: circular
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView(
              children: [
                head(),
                Divider(
                  thickness: 0.8,
                ),
                otherDetails("About", profileModel.about),
                otherDetails("Name", profileModel.name),
                otherDetails("Profession", profileModel.profession),
                otherDetails("DOB", profileModel.DOB),
                Divider(
                  thickness: 0.8,
                ),
                SizedBox(height: 20),
                Blogs(
                  url: "/blogpost/getownblog",
                ),
              ],
            ),
    );
  }

  Widget head() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Center(
            child: CircleAvatar(
              radius: 50,
              backgroundImage:
                  profileImg == "" ? null : NetworkImage(profileImg),
            ),
          ),
          Text(
            profileModel.username,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 10,
          ),
          Text(profileModel.titleline),
        ],
      ),
    );
  }

  Widget otherDetails(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "$label :",
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            value,
            style: TextStyle(fontSize: 15),
          )
        ],
      ),
    );
  }
}
