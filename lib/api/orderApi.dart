import 'package:user_app/api/networking.dart';
import 'package:user_app/services/constants.dart';

var placeOrderUrl = Constants.baseUrl + 'user/place-order';
var getCouponsUrl = Constants.baseUrl + 'user/get-coupons';
var getPromoUrl = Constants.baseUrl + 'user/get-promo/';
var paymentStatusUpdateUrl = Constants.baseUrl + 'user/update-payment-status';
var orderHistoryUrl = Constants.baseUrl + 'user/order-history';
var orderInfoUrl = Constants.baseUrl + 'user/order-history-info';
var paymentMethodUpdateUrl = Constants.baseUrl + 'user/update-payment-method';

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

  Future<dynamic> getPromo(String code) async {
    var _getPromoUrl = getPromoUrl + code;
    ServiceWithHeader urlHelper = ServiceWithHeader(_getPromoUrl);
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

  Future<dynamic> getOrderInfo(String orderId) async {
    ServiceWithHeader urlHelper = ServiceWithHeader(orderInfoUrl + "/$orderId");
    var urlsData = await urlHelper.data();
    return urlsData;
  }

  Future<dynamic> updatePaymentMethod(String orderId) async {
    ServiceWithHeader urlHelper =
        ServiceWithHeader(paymentMethodUpdateUrl + "/$orderId");
    var urlsData = await urlHelper.data();
    return urlsData;
  }
}
