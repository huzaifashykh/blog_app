import 'dart:convert';
import 'package:blog_app/HelperFunction/SharedPrefHelper.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class NetworkHandler {
  //https is required for secure
  String baseurl = "https://mighty-fortress-63699.herokuapp.com";
  Logger log = Logger();

  Future<dynamic> get(String url) async {
    String? token = await SharedPreferenceHelper().getToken();

    // baseurl/user/register
    url = formatURL(url);
    // convert url to uri
    var response = await http.get(
      Uri.parse(url),
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      // log.i(response.body);
      return json.decode(response.body);
    }

    // log.i(response.body);
    // log.i(response.statusCode);
  }

  Future<http.Response> post(String url, Map<String, String> userData) async {
    String? token = await SharedPreferenceHelper().getToken();

    // baseurl/user/register
    url = formatURL(url);
    // convert url to uri
    var response = await http.post(
      Uri.parse(url),
      headers: {
        "Content-type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: json.encode(userData),
    );

    return response;
  }

  Future<http.Response> post1(String url, var body) async {
    String? token = await SharedPreferenceHelper().getToken();

    url = formatURL(url);
    // log.d(body);
    var response = await http.post(
      Uri.parse(url),
      headers: {"Content-type": "application/json", "Authorization": "Bearer $token"},
      body: json.encode(body),
    );
    return response;
  }

  Future<http.StreamedResponse> patchImage(String url, String filePath) async {
    String? token = await SharedPreferenceHelper().getToken();

    // baseurl/user/register
    url = formatURL(url);

    // convert url to uri
    var request = http.MultipartRequest("PATCH", Uri.parse(url));
    request.files.add(await http.MultipartFile.fromPath("img", filePath));
    request.headers.addAll({
      "Content-type": "multipart/form-data",
      "Authorization": "Bearer $token",
    });

    var response = request.send();

    return response;
  }

  // formate URL
  String formatURL(String url) {
    return baseurl + url;
  }

  String getImage(String imageName) {
    String url = formatURL("/uploads/$imageName.jpg");
    return url;
  }
}
