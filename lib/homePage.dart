import 'dart:math';
import 'package:timeline_widget/timeline_widget.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:highlight_text/highlight_text.dart';
import 'package:wikipedia_hunt/api/wiki.dart';
import 'package:wikipedia_hunt/styles.dart';

class HomePage extends StatefulWidget {
  final String link, title;
  HomePage({Key key, this.link, this.title}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Widget> leftList = [];
  List<Widget> rightList = [Container()];
  _addNode(String title, String summary, String highlight,
      {bool isEnd = false}) {
    leftList.add(_leftListWidget(title));

    rightList.removeLast();
    Map<String, HighlightedWord> words = {
      highlight: HighlightedWord(
        onTap: () {
          print("Flutter");
        },
        textStyle: subtitle2.copyWith(color: brown),
      ),
    };
    rightList.add(TextHighlight(
      enableCaseSensitive: true,
      text: summary,
      words: words,
      textStyle: subtitle2,
      maxLines: context.screenWidth < 700 ? 6 : 12,
      overflow: TextOverflow.ellipsis,
    ));
    if (!isEnd) rightList.add(Container());
    isend = isEnd;
    setState(() {});
    scrollController.animateTo(
        scrollController.position.maxScrollExtent + context.percentWidth * 25,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut);
  }

  Container _leftListWidget(String title) {
    return Container(
      margin: EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
          color: title == "Philosophy" ? yellowLight : Colors.transparent,
          borderRadius: BorderRadius.circular(10)),
      child: Center(
        child: Text(
          title,
          style: subtitle1,
        ),
      ).py12(),
    );
  }

  ScrollController scrollController = ScrollController();
  bool isend = false;
  @override
  void initState() {
    super.initState();
    leftList.add(_leftListWidget(widget.title));
    _fetchWiki(widget.link);
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  _fetchWiki(String link) async {
    if (!mounted) return;
    if (link == "https://en.wikipedia.org/wiki/Philosophy") {
      _addNode("Philosophy", "In the end everything is connected to philosophy",
          "In the end everything is connected to philosophy",
          isEnd: true);
      return;
    }
    WikiScrape scrape = await getNextNode(link);
    _addNode(scrape.title, scrape.summary, scrape.highlight, isEnd: false);
    _fetchWiki(scrape.link);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        backgroundColor: white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.chevron_left,
            color: brown,
            size: 36,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          child: Center(
              child: Column(
            children: [
              Expanded(
                  child: Center(
                      child: Container(
                          child: Scrollbar(
                              controller: scrollController,
                              isAlwaysShown: false,
                              child: timelineview())))),
              isend ? 40.heightBox : 0.heightBox,
              isend
                  ? Container(
                      height: 60,
                      constraints: BoxConstraints(maxWidth: 400, minWidth: 150),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: yellow),
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Center(
                          child: Text(
                            "Try another topic.",
                            style:
                                subtitle1.copyWith(fontSize: 24, color: white),
                          ),
                        ),
                      ),
                    )
                  : Container(),
              isend ? 40.heightBox : 0.heightBox,
            ],
          ))),
    );
  }

  Widget timelineview() {
    return LayoutBuilder(builder: (context, dimen) {
      if (dimen.maxWidth < 600) {
        return TimelineViewCenter(
          scrollController: scrollController,
          scrollDirection: Axis.vertical,
          horizontalAxisAlignment: MainAxisAlignment.start,
          lineWidth: 4,
          lineColor: brown,
          height: context.percentHeight * 25,
          width: context.percentWidth * 80,
          imageBorderColor: yellowLight,
          image: [
            ...List.generate(
                rightList.length - 1,
                (index) => Icon(
                      Icons.article_outlined,
                      color: yellow,
                    ).p16()),
            isend ? Text("🎉").px16() : CircularProgressIndicator().p16()
          ],
          imageHeight: 50,
          rightChildren: rightList,
          leftChildren: leftList,
        );
      }
      return TimelineViewCenter(
        scrollController: scrollController,
        scrollDirection: Axis.horizontal,
        horizontalAxisAlignment: MainAxisAlignment.start,
        lineWidth: 4,
        lineColor: brown,
        height: 650,
        width: context.percentWidth * 25,
        imageBorderColor: yellowLight,
        image: [
          ...List.generate(
              rightList.length - 1,
              (index) => Icon(
                    Icons.article_outlined,
                    color: yellow,
                  ).p16()),
          isend ? Text("🎉").px16() : CircularProgressIndicator().p16()
        ],
        imageHeight: 50,
        rightChildren: rightList,
        leftChildren: leftList,
      );
    });
  }
}
