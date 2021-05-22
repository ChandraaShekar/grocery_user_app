import 'package:user_app/api/networking.dart';
import 'package:user_app/services/constants.dart';

var url = Constants.baseUrl + 'store/update-order-settings';
var getSettingsUrl = Constants.baseUrl + 'store/get-store-settings';
var updateWorkingDaysUrl = Constants.baseUrl + 'store/update-working-days';

class OrderSettingsApiHandler {
  final body;

  OrderSettingsApiHandler({this.body});

  Future<dynamic> updateSettings() async {
    ServiceWithHeaderDataPost urlHelper =
        ServiceWithHeaderDataPost(url, this.body);
    var urlsData = await urlHelper.data();
    return urlsData;
  }

  Future<dynamic> getSettings() async {
    ServiceWithHeader urlHelper = ServiceWithHeader(getSettingsUrl);
    var urlsData = await urlHelper.data();
    return urlsData;
  }

  Future<dynamic> updateWorkingDays() async {
    ServiceWithHeaderDataPost urlHelper =
        ServiceWithHeaderDataPost(updateWorkingDaysUrl, this.body);
    var urlsData = await urlHelper.data();
    return urlsData;
  }
}
