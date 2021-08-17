import 'package:user_app/api/networking.dart';
import 'package:user_app/services/constants.dart';

var url = Constants.baseUrl + 'user/get-all-packs';
var packInfoUrl = Constants.baseUrl + 'user/get-pack-info/';

class PacksApiHandler {
  Future<dynamic> getPacks(Map<String, dynamic> data) async {
    ServiceWithHeaderDataPost urlHelper = ServiceWithHeaderDataPost(url, data);
    var urlsData = await urlHelper.data();
    return urlsData;
  }

  Future<dynamic> getPackInfo(packId) async {
    ServiceWithHeader urlHelper = ServiceWithHeader(packInfoUrl + packId);
    var urlsData = await urlHelper.data();
    return urlsData;
  }
}
