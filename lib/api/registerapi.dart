import 'package:user_app/api/networking.dart';
import 'package:user_app/services/constants.dart';

var url = Constants.baseUrl + 'auth/register';
var updateUrl = Constants.baseUrl + 'user/update';

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
}
