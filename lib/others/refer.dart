import 'package:flutter/material.dart';
import 'package:user_app/api/settingsApi.dart';
import 'package:user_app/main.dart';
import 'package:user_app/services/constants.dart';
import 'package:user_app/utils/header.dart';
import 'package:user_app/widgets/text_widget.dart';
import 'package:share/share.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Refer extends StatefulWidget {
  @override
  _ReferState createState() => _ReferState();
}

class _ReferState extends State<Refer> {
  var referData;

  @override
  void initState() {
    _load();
    super.initState();
  }

  void _load() async {
    SettingsApiHandler settingsHandler = new SettingsApiHandler({});
    List referResp = await settingsHandler.refer();
    if (referResp[0] == 200) {
      referData = referResp[1];
      print(referData['weekly_graph'].toString());
      setState(() {});
      print(referResp);
    }
  }

  @override
  Widget build(BuildContext context) {
    return (MyApp.userInfo['user_type'] == "AFFILIATE")
        ? affiliateWidget()
        : Scaffold(
            appBar:
                Header.appBar(Constants.referTag, null, true, context, true),
            body: SingleChildScrollView(
                child: Container(
                    child: Column(
              children: [
                // Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: Center(
                //       child: TextWidget("Refer and Earn", textType: "heading")),
                // ),
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
      appBar: Header.appBar("Referal Performance", null, true, context, true),
      body: referData != null
          ? SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    infoCard("Total Redeems", referData['total_count']),
                    infoCard("Total redeems this week",
                        referData['this_week_count']),
                    infoCard("Total redeems last week",
                        referData['last_week_count']),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: TextWidget("Weekly performance graph",
                          textType: "sub-title"),
                    ), //Remove this line after placing the graph
                    Padding(
                        padding: const EdgeInsets.only(top: 15.0),
                        child: SfCartesianChart(
                            // Initialize category axis
                            primaryXAxis: CategoryAxis(),
                            series: <ChartSeries>[
                              // Initialize line series
                              LineSeries<SalesData, String>(
                                  dataSource: [
                                    // Bind data source
                                    SalesData(
                                        '28days ago',
                                        double.parse(referData['weekly_graph']
                                                ['Last 28 days']
                                            .toString())),
                                    SalesData(
                                        '21days  ago',
                                        double.parse(referData['weekly_graph']
                                                ['Last 21 days']
                                            .toString())),
                                    SalesData(
                                        '14days  ago',
                                        double.parse(referData['weekly_graph']
                                                ['Last 14 days']
                                            .toString())),
                                    SalesData(
                                        '7days  ago',
                                        double.parse(referData['weekly_graph']
                                                ['Last 7 days']
                                            .toString())),
                                    SalesData(
                                        'Current',
                                        double.parse(referData['weekly_graph']
                                                ['Current Week']
                                            .toString()))
                                  ],
                                  xValueMapper: (SalesData sales, _) =>
                                      sales.year,
                                  yValueMapper: (SalesData sales, _) =>
                                      sales.sales)
                            ])
                        //  LineGraph(
                        //   features: [
                        //     Feature(
                        //       color: Colors.blue,
                        //       data: [0.3, 0.5, 0.3, 1.9],
                        //     ),
                        //   ],
                        //   size: Size(MediaQuery.of(context).size.width, 350),
                        //   labelX: ['21days ago', '14days  ago', '7days  ago', 'Current'],
                        //   labelY: [
                        //     referData['weekly_graph']['Last 21 days'].toString(),
                        //     referData['weekly_graph']['Last 14 days'].toString(),
                        //     referData['weekly_graph']['Last 7 days'].toString(),
                        //     referData['weekly_graph']['Current Week'].toString()
                        //     ],
                        //   graphColor: Colors.black87,
                        // ),
                        )
                  ],
                ),
              ),
            )
          : Container(),
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

class SalesData {
  SalesData(this.year, this.sales);
  final String year;
  final double sales;
}
