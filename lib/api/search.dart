import 'dart:convert';

import 'package:http/http.dart' as http;

Future<SearchResults> getSearchResults(String query) async {
  String url = "https://imsudip-weather.herokuapp.com/wikisearch?q=";

  var response = await http.get(Uri.parse(url + query));
  var jsonData = json.decode(response.body);
  print(jsonData);
  List<String> a = List<String>.from(jsonData[1]);
  List<String> b = List<String>.from(jsonData[3]);
  SearchResults searchResults = SearchResults(a, b);
  return searchResults;
}

class SearchResults {
  SearchResults(this.titles, this.links);
  final List<String> titles, links;
}
