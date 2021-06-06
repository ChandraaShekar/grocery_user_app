import 'package:user_app/api/networking.dart';
import 'package:user_app/services/constants.dart';

var placeOrderUrl = Constants.baseUrl + 'user/place-order';
var getCouponsUrl = Constants.baseUrl + 'user/get-coupons';
// var razorpayUrl =

class OrderApiHandler {
  Future<dynamic> placeOrder(body) async {
    ServiceWithHeaderDataPost urlHelper =
        ServiceWithHeaderDataPost(placeOrderUrl, body);
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
