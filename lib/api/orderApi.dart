import 'package:user_app/api/networking.dart';
import 'package:user_app/services/constants.dart';

var placeOrderUrl = Constants.baseUrl + 'user/get-all-packs';
var getCouponsUrl = Constants.baseUrl + 'user/get-coupons';

class OrderApiHandler {
  Future<dynamic> placeOrder() async {
    ServiceWithHeader urlHelper = ServiceWithHeader(placeOrderUrl);
    var urlsData = await urlHelper.data();
    return urlsData;
  }

  Future<dynamic> getCoupons() async {
    ServiceWithHeader urlHelper = ServiceWithHeader(getCouponsUrl);
    var urlsData = await urlHelper.data();
    return urlsData;
  }

  // Future<dynamic> getPackInfo(packId) async {
  //   ServiceWithHeader urlHelper = ServiceWithHeader(packInfoUrl + packId);
  //   var urlsData = await urlHelper.data();
  //   return urlsData;
  // }
}
