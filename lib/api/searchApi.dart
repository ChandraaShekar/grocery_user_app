import 'package:user_app/api/networking.dart';
import 'package:user_app/services/constants.dart';

var url = Constants.baseUrl + 'user/search-term';

class SearchApiHandler {
  Future<dynamic> searchWithWord(Map body) async {
    ServiceWithHeaderDataPost urlHelper = ServiceWithHeaderDataPost(url, body);
    var urlsData = await urlHelper.data();
    return urlsData;
  }
}
