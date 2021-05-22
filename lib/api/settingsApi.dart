import 'package:user_app/api/networking.dart';
import 'package:user_app/services/constants.dart';

var url = Constants.baseUrl + 'store/update-store-settings';

class SettingsApiHandler {
  final Map<String, dynamic> body;

  SettingsApiHandler(this.body);

  Future<dynamic> update() async {
    ServiceWithHeaderDataPost urlHelper =
        ServiceWithHeaderDataPost(url, this.body);
    var urlsData = await urlHelper.data();
    return urlsData;
  }
}
