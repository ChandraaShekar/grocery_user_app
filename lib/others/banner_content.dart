import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:user_app/utils/header.dart';
import 'package:url_launcher/url_launcher.dart';

class BannerContent extends StatefulWidget {
  final Map content;
  BannerContent({Key key, this.content}) : super(key: key);

  @override
  _BannerContentState createState() => _BannerContentState();
}

class _BannerContentState extends State<BannerContent> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header.appBar("${widget.content['banner_name']}", null, true),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: HtmlWidget('''${widget.content['content']}''',
              onTapUrl: (_url) async => await canLaunch(_url)
                  ? await launch(_url)
                  : throw 'Could not launch $_url'),
        ),
      ),
    );
  }
}
