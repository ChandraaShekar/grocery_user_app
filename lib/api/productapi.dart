import 'package:user_app/api/networking.dart';
import 'package:user_app/services/constants.dart';

var getHomeProductsUrl = Constants.baseUrl + 'user/get-home-products';
var getSpecialproductsUrl = Constants.baseUrl + 'user/get-special-products';
var getAllproductsUrl = Constants.baseUrl + 'user/all-products';
var getCategoryproductsUrl = Constants.baseUrl + 'user/get-products/';
var getproductFromIdUrl = Constants.baseUrl + 'user/get-product-info/';
var getAllCategoriesUrl = Constants.baseUrl + 'user/all-categories';
var getBannerProductsUrl = Constants.baseUrl + 'user/get-banner-products';
var checkCartUrl = Constants.baseUrl + 'user/check-location-availability';

class ProductApiHandler {
  final body;

  ProductApiHandler({this.body});

  Future<dynamic> getHomeProducts() async {
    ServiceWithHeaderDataPost urlHelper =
        ServiceWithHeaderDataPost(getHomeProductsUrl, this.body);
    var urlsData = await urlHelper.data();
    return urlsData;
  }

  Future<dynamic> getSpecialProducts() async {
    ServiceWithHeaderDataPost urlHelper =
        ServiceWithHeaderDataPost(getSpecialproductsUrl, this.body);
    var urlsData = await urlHelper.data();
    return urlsData;
  }

  // Future<dynamic> getProducts() async {
  //   ServiceWithHeader urlHelper = ServiceWithHeader(getFeaturedproductsUrl);
  //   var urlsData = await urlHelper.data();
  //   return urlsData;
  // }

  Future<dynamic> getCategoryProducts(String category) async {
    String url = getCategoryproductsUrl + category;
    ServiceWithHeaderDataPost urlHelper =
        ServiceWithHeaderDataPost(url, this.body);
    var urlsData = await urlHelper.data();
    return urlsData;
  }

  Future<dynamic> getProductFromId(String productId) async {
    String url = getproductFromIdUrl + productId;
    ServiceWithHeader urlHelper = ServiceWithHeader(url);
    var urlsData = await urlHelper.data();
    return urlsData;
  }

  Future<dynamic> getAllCategories(Map<String, dynamic> locationData) async {
    ServiceWithHeaderDataPost urlHelper =
        ServiceWithHeaderDataPost(getAllCategoriesUrl, locationData);
    var urlsData = await urlHelper.data();
    return urlsData;
  }

  Future<dynamic> getBannerProducts(Map<String, dynamic> xyz) async {
    ServiceWithHeaderDataPost urlHelper =
        ServiceWithHeaderDataPost(getBannerProductsUrl, xyz);
    var urlsData = await urlHelper.data();
    return urlsData;
  }

  Future<dynamic> checkCart(Map<String, dynamic> data) async {
    ServiceWithHeaderDataPost urlHelper =
        ServiceWithHeaderDataPost(checkCartUrl, data);
    var urlsData = await urlHelper.data();
    return urlsData;
  }
}
