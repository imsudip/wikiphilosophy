import 'dart:convert';
import 'package:http/http.dart' as http;

Future<WikiScrape> getNextNode(String link) async {
  String baseUrl = "https://imsudip-weather.herokuapp.com/wiki?link=";
  print(baseUrl + link);
  var response = await http.get(Uri.parse(baseUrl + link));

  final wikiScrape = wikiScrapeFromJson(response.body);
  return wikiScrape;
}

WikiScrape wikiScrapeFromJson(String str) =>
    WikiScrape.fromJson(json.decode(str));

String wikiScrapeToJson(WikiScrape data) => json.encode(data.toJson());

class WikiScrape {
  WikiScrape({this.link, this.summary, this.title, this.highlight});

  String link;
  String summary;
  String title;
  String highlight;

  factory WikiScrape.fromJson(Map<String, dynamic> json) => WikiScrape(
        link: json["link"].toString(),
        summary: json["summary"].toString(),
        title: json["title"].toString(),
        highlight: json["highlight"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "link": link,
        "summary": summary,
        "title": title,
        "highlight": highlight
      };
}
