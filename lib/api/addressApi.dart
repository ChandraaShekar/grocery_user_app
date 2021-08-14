import 'package:user_app/api/networking.dart';
import 'package:user_app/services/constants.dart';

var addAddressUrl = Constants.baseUrl + 'user/add-addresses';
var getAddressUrl = Constants.baseUrl + 'user/get-addresses';
var deleteAddressUrl = Constants.baseUrl + 'user/delete-address/';

class AddressApiHandler {
  Future<dynamic> addAddress(Map<String, dynamic> data) async {
    ServiceWithHeaderDataPost urlHelper =
        ServiceWithHeaderDataPost(addAddressUrl, data);
    var urlsData = await urlHelper.data();
    return urlsData;
  }

  Future<dynamic> getAddresses() async {
    ServiceWithHeader urlHelper = ServiceWithHeader(getAddressUrl);
    var urlsData = await urlHelper.data();
    return urlsData;
  }

  Future<dynamic> deleteAddress(addressId) async {
    ServiceWithHeader urlHelper =
        ServiceWithHeader(deleteAddressUrl + addressId);
    var urlsData = await urlHelper.data();
    return urlsData;
  }
}
