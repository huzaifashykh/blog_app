import 'package:blog_app/Blog/BlogBody.dart';
import 'package:blog_app/Models/SuperModel.dart';
import 'package:blog_app/Models/addBlogModels.dart';
import 'package:blog_app/Services/NetworkHandler.dart';
import 'package:blog_app/Utils/BlogCard.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Blogs extends StatefulWidget {
  Blogs({
    Key? key,
    this.url,
  }) : super(key: key);
  String? url;

  @override
  _BlogsState createState() => _BlogsState();
}

class _BlogsState extends State<Blogs> {
  final networkHandler = NetworkHandler();
  SuperModel superModel = SuperModel();
  List<AddBlogModel> data = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    var response = await networkHandler.get(widget.url!);

    superModel = SuperModel.fromJson(response);

    setState(() {
      data = superModel.data!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return data.length > 0
        ? Column(
            children: data
                .map((item) => Column(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BlogBody(
                                  addBlogModel: item,
                                  networkHandler: networkHandler,
                                ),
                              ),
                            );
                          },
                          child: BlogCard(
                            addBlogModel: item,
                            networkHandler: networkHandler,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        )
                      ],
                    ))
                .toList(),
          )
        : Center(child: Text("No Post Available yet"));
  }
}
