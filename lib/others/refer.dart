import 'package:draw_graph/draw_graph.dart';
import 'package:draw_graph/models/feature.dart';
import 'package:flutter/material.dart';
import 'package:user_app/main.dart';
import 'package:user_app/services/constants.dart';
import 'package:user_app/utils/header.dart';
import 'package:user_app/widgets/text_widget.dart';
import 'package:share/share.dart';

class Refer extends StatefulWidget {
  @override
  _ReferState createState() => _ReferState();
}

class _ReferState extends State<Refer> {
  @override
  Widget build(BuildContext context) {
    return (MyApp.userInfo['user_type'] == "AFFILIATE")
        ? affiliateWidget()
        : Scaffold(
            appBar: Header.appBar(Constants.referTag, null, true),
            body: SingleChildScrollView(
                child: Container(
                    child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                      child: TextWidget("Refer and Earn", textType: "heading")),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextWidget(
                          "Your referal code: ${MyApp.userInfo['referal_code']}",
                          textType: "title"),
                      IconButton(
                          icon: Icon(Icons.share_rounded),
                          onPressed: () {
                            Share.share(
                                "Hey there! Download Frutte application today to avail exciting offers. Use my referal code \"${MyApp.userInfo['referal_code']}\" to get a wooping 50% offer on your first order.",
                                subject:
                                    'Get 50% off on first order in Frutte');
                          })
                    ],
                  )),
                )
              ],
            ))));
  }

  Widget affiliateWidget() {
    return Scaffold(
      appBar: Header.appBar("Referal Performance", null, true),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              infoCard("Total Redeems", "300"),
              infoCard("Total redeems this week", "30"),
              infoCard("Total redeems last week", "35"),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextWidget("Weekly performance graph",
                    textType: "sub-title"),
              ), //Remove this line after placing the graph
              Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: LineGraph(
  features:[ Feature(
  color: Colors.blue,
  data: [0.3, 0.5, 0.3, 1.9],
),],
  size: Size(MediaQuery.of(context).size.width, 350),
  labelX: ['Week 1', 'Week 2', 'Week 3', 'Week 4'],
  labelY: ['20', '40', '60', '80'],
  graphColor: Colors.black87,
),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget infoCard(String key, String value) {
    return Card(
        child: Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextWidget("$key: ", textType: "title"),
              TextWidget("$value ", textType: "title"),
            ],
          )
        ],
      ),
    ));
  }
}
