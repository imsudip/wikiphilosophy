import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../homePage.dart';

Future<void> getRandomTopic(BuildContext context) async {
  String url = "https://en.wikipedia.org/api/rest_v1/page/random/summary";

  var response = await http.get(Uri.parse(url));
  var jsonData = json.decode(response.body);
  String link = jsonData['content_urls']['desktop']['page'];
  String title = jsonData['title'];
  Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => HomePage(
                link: link,
                title: title,
              )));
}
