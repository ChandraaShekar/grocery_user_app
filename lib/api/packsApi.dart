import 'package:user_app/api/networking.dart';
import 'package:user_app/services/constants.dart';

var url = Constants.baseUrl + 'user/get-all-packs';
var packInfoUrl = Constants.baseUrl + 'user/get-pack-info/';

class PacksApiHandler {
  Future<dynamic> getPacks() async {
    ServiceWithHeader urlHelper = ServiceWithHeader(url);
    var urlsData = await urlHelper.data();
    return urlsData;
  }

  Future<dynamic> getPackInfo(packId) async {
    ServiceWithHeader urlHelper = ServiceWithHeader(packInfoUrl + packId);
    var urlsData = await urlHelper.data();
    return urlsData;
  }
}
