import 'package:user_app/api/networking.dart';
import 'package:user_app/services/constants.dart';

var url = Constants.baseUrl + 'auth/login';

class LoginApiHandler {
  final Map<String, dynamic> body;

  LoginApiHandler(this.body);

  Future<dynamic> login() async {
    ServiceWithDataPost urlHelper = ServiceWithDataPost(url, this.body);
    var urlsData = await urlHelper.data();
    print(urlsData);
    return urlsData;
  }
}
