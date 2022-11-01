import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import "package:velocity_x/velocity_x.dart";
import 'package:wikipedia_hunt/homePage.dart';
import 'package:wikipedia_hunt/styles.dart';
import 'api/random.dart';
import 'api/search.dart';

class SearchPage extends StatefulWidget {
  SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _controller = TextEditingController();
  ScrollController scrollController = ScrollController();
  bool isLoading = false;
  SearchResults? results;
  _fetchResults(String query) async {
    setState(() {
      isLoading = true;
    });
    results = await getSearchResults(query);

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: SafeArea(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              20.heightBox,
              Text("WikiPhilosphy",
                  style: heading.copyWith(color: black, fontSize: context.screenWidth < 600 ? 48 : 60)),
              10.heightBox,
              Text(
                "Every wikipedia article related to 'Philosophy'",
                style: headline2,
              ),
              20.heightBox,
              Container(
                  height: 55,
                  constraints: BoxConstraints(maxWidth: 600, minWidth: 200),
                  child: CupertinoTextField(
                    style: TextStyle(fontSize: 20),
                    textAlignVertical: TextAlignVertical.center,
                    placeholder: "Search any random topic...",
                    prefix: Icon(EvaIcons.search).pOnly(left: 24),
                    suffix: IconButton(
                      onPressed: () {
                        setState(() {
                          isLoading = true;
                        });
                        getRandomTopic(context);
                        setState(() {
                          isLoading = false;
                        });
                      },
                      icon: Icon(EvaIcons.bulbOutline, color: black),
                    ).pOnly(right: 20),
                    padding: EdgeInsets.symmetric(
                      horizontal: 6,
                    ),
                    cursorColor: black,
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: yellow.withOpacity(0.1), spreadRadius: 5.0, blurRadius: 20, offset: Offset(10, 3))
                        ],
                        border: Border.all(color: yellowLight.withOpacity(0.5)),
                        color: yellowLight.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(50)),
                    controller: _controller,
                    onSubmitted: (val) {
                      _fetchResults(val);
                    },
                  ).px(40)),
              40.heightBox,
              Expanded(
                  child: isLoading
                      ? Center(
                          child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(brown)),
                        )
                      : results == null
                          ? _buildInfocontainer()
                          : _buildResults())
            ],
          ),
        ),
      ),
    );
  }

  _buildInfocontainer() {
    return Container(
      constraints: BoxConstraints(maxWidth: 500, minWidth: 200),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Card(
            color: yellowLight,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Column(
              children: [
                Icon(
                  EvaIcons.info,
                  color: brown,
                  size: 42,
                ),
                Text(
                  "Apparently if we click on the first link in any wikipedia article and continue doing that, we will end up on 'Philosophy' article page. This website just visualize the whole process.",
                  style: subtitle3,
                ),
              ],
            ).p(12),
          ),
          Card(
            color: yellowLight,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Row(
              children: [
                Icon(
                  EvaIcons.bulbOutline,
                  color: brown,
                  size: 32,
                ),
                Text(
                  "    Tap on the dice to search a random article.",
                  style: subtitle3,
                ),
              ],
            ).p(12),
          ),
        ],
      ),
    );
  }

  _buildResults() {
    return Container(
      constraints: BoxConstraints(maxWidth: 600, minWidth: 200),
      child: Scrollbar(
        controller: scrollController,
        child: ListView.separated(
            controller: scrollController,
            itemCount: results!.links.length,
            separatorBuilder: (context, i) => Divider(
                  color: brown.withOpacity(0.3),
                ),
            itemBuilder: (context, i) {
              return ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => HomePage(
                                title: results!.titles[i],
                                link: results!.links[i],
                              )));
                },
                title: Text(
                  results!.titles[i],
                  style: subtitle1,
                ),
                subtitle: Text(
                  results!.links[i],
                  style: subtitle2,
                ),
                trailing: Icon(
                  EvaIcons.arrowForward,
                  color: brown,
                ),
              );
            }).px(40),
      ),
    );
  }
}
