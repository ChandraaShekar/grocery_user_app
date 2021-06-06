import 'package:user_app/api/networking.dart';
import 'package:user_app/services/constants.dart';

var url = Constants.baseUrl + 'auth/register';
var updateUrl = Constants.baseUrl + 'user/update';
var updateLocationUrl = Constants.baseUrl + 'user/update-location';
var updateAddressUrl = Constants.baseUrl + 'user/update-address';

class RegisterApiHandler {
  final Map<String, dynamic> body;

  RegisterApiHandler(this.body);

  Future<dynamic> register() async {
    ServiceWithDataPost urlHelper = ServiceWithDataPost(url, this.body);
    var urlsData = await urlHelper.data();
    return urlsData;
  }

  Future<dynamic> update() async {
    ServiceWithHeaderDataPost urlHelper =
        ServiceWithHeaderDataPost(updateUrl, this.body);
    var urlsData = await urlHelper.data();
    return urlsData;
  }

  Future<dynamic> updateLocation() async {
    ServiceWithHeaderDataPost urlHelper =
        ServiceWithHeaderDataPost(updateLocationUrl, this.body);
    var urlsData = await urlHelper.data();
    return urlsData;
  }

  Future<dynamic> updateAddress() async {
    ServiceWithHeaderDataPost urlHelper =
        ServiceWithHeaderDataPost(updateAddressUrl, this.body);
    var urlsData = await urlHelper.data();
    return urlsData;
  }
}
