import 'package:user_app/api/networking.dart';
import 'package:user_app/services/constants.dart';

var placeOrderUrl = Constants.baseUrl + 'user/place-order';
var getCouponsUrl = Constants.baseUrl + 'user/get-coupons';
var paymentStatusUpdateUrl = Constants.baseUrl + 'user/update-payment-status';
var orderHistoryUrl = Constants.baseUrl + 'user/order-history';

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

  Future<dynamic> updatePaymentStatus(body) async {
    ServiceWithHeaderDataPost urlHelper =
        ServiceWithHeaderDataPost(paymentStatusUpdateUrl, body);
    var urlsData = await urlHelper.data();
    return urlsData;
  }

  Future<dynamic> getOrderHistory() async {
    ServiceWithHeader urlHelper = ServiceWithHeader(orderHistoryUrl);
    var urlsData = await urlHelper.data();
    return urlsData;
  }
}
