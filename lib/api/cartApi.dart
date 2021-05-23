import 'package:user_app/api/networking.dart';
import 'package:user_app/services/constants.dart';

var addToCarturl = Constants.baseUrl + 'user/add-to-cart';
var removeFromCartUrl = Constants.baseUrl + 'user/remove-from-cart/';
var getFromCartUrl = Constants.baseUrl + 'user/get-from-cart';
var updateCartUrl = Constants.baseUrl + 'user/update-cart';

class CartApiHandler {
  Future<dynamic> getCart() async {
    ServiceWithHeader urlHelper = ServiceWithHeader(getFromCartUrl);
    var urlsData = await urlHelper.data();
    return urlsData;
  }

  Future<dynamic> deleteFromCart(productId) async {
    ServiceWithHeader urlHelper =
        ServiceWithHeader(removeFromCartUrl + productId);
    var urlsData = await urlHelper.data();
    return urlsData;
  }

  Future<dynamic> addToCart(body) async {
    ServiceWithHeaderDataPost urlHelper =
        ServiceWithHeaderDataPost(addToCarturl, body);
    var urlsData = await urlHelper.data();
    return urlsData;
  }

  Future<dynamic> updateCart(body) async {
    ServiceWithHeaderDataPost urlHelper =
        ServiceWithHeaderDataPost(updateCartUrl, body);
    var urlsData = await urlHelper.data();
    return urlsData;
  }
}
