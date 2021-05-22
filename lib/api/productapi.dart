import 'package:user_app/api/networking.dart';
import 'package:user_app/services/constants.dart';

var getHomeProductsUrl = Constants.baseUrl + 'user/get-home-products';
var getFeaturedproductsUrl = Constants.baseUrl + 'user/get-featured-products';
var getSaleproductsUrl = Constants.baseUrl + 'user/get-sale-products';
var getAllproductsUrl = Constants.baseUrl + 'user/all-products';
var getCategoryproductsUrl = Constants.baseUrl + 'user/get-products/';

class ProductApiHandler {
  final body;

  ProductApiHandler({this.body});

  Future<dynamic> getHomeProducts() async {
    ServiceWithHeader urlHelper = ServiceWithHeader(getHomeProductsUrl);
    var urlsData = await urlHelper.data();
    return urlsData;
  }

  Future<dynamic> getFeaturedProducts() async {
    ServiceWithHeader urlHelper = ServiceWithHeader(getFeaturedproductsUrl);
    var urlsData = await urlHelper.data();
    return urlsData;
  }

  Future<dynamic> getSaleProducts() async {
    ServiceWithHeader urlHelper = ServiceWithHeader(getSaleproductsUrl);
    var urlsData = await urlHelper.data();
    return urlsData;
  }

  Future<dynamic> getProducts() async {
    ServiceWithHeader urlHelper = ServiceWithHeader(getFeaturedproductsUrl);
    var urlsData = await urlHelper.data();
    return urlsData;
  }

  Future<dynamic> getCategoryProducts(String category) async {
    String url = getCategoryproductsUrl + category;
    print(url);
    ServiceWithHeader urlHelper = ServiceWithHeader(url);
    var urlsData = await urlHelper.data();
    return urlsData;
  }
}
