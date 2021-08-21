import 'package:user_app/api/networking.dart';
import 'package:user_app/services/constants.dart';

var url = Constants.baseUrl + 'store/update-store-settings';

var referUrl=Constants.baseUrl +'user/get-referal-analytics';

class SettingsApiHandler {
  final Map<String, dynamic> body;

  SettingsApiHandler(this.body);

  Future<dynamic> update() async {
    ServiceWithHeaderDataPost urlHelper =
        ServiceWithHeaderDataPost(url, this.body);
    var urlsData = await urlHelper.data();
    return urlsData;
  }


  Future<dynamic> refer() async {
    ServiceWithHeader urlHelper =
        ServiceWithHeader(referUrl);
    var urlData = await urlHelper.data();
    return urlData;
  }
}
