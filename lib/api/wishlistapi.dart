import 'package:user_app/api/networking.dart';
import 'package:user_app/services/constants.dart';

var addToWishlistUrl = Constants.baseUrl + 'user/add-to-wishlist/';
var removeFromWishlistUrl = Constants.baseUrl + 'user/remove-from-wishlist/';
var getWishlistUrl = Constants.baseUrl + 'user/get-wishlist-products';
var getWishlistIdsUrl = Constants.baseUrl + 'user/get-wishlist-ids';

class WishlistApiHandler {
  final body;

  WishlistApiHandler({this.body});

  Future<dynamic> addToWishList(String productId) async {
    ServiceWithHeader urlHelper =
        ServiceWithHeader(addToWishlistUrl + productId);
    var urlsData = await urlHelper.data();
    return urlsData;
  }

  Future<dynamic> removeFromWishList(String productId) async {
    ServiceWithHeader urlHelper =
        ServiceWithHeader(removeFromWishlistUrl + productId);
    var urlsData = await urlHelper.data();
    return urlsData;
  }

  Future<dynamic> getWishlist() async {
    ServiceWithHeader urlHelper = ServiceWithHeader(getWishlistUrl);
    var urlsData = await urlHelper.data();
    return urlsData;
  }

  Future<dynamic> getWishlistIds() async {
    ServiceWithHeader urlHelper = ServiceWithHeader(getWishlistIdsUrl);
    var urlsData = await urlHelper.data();
    return urlsData;
  }
}
