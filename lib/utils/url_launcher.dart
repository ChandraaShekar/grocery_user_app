
import 'package:url_launcher/url_launcher.dart';

Future<void>  launchURL(url) async {
  print('cameee');
  if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
}
