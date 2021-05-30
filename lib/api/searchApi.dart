import 'package:user_app/api/networking.dart';
import 'package:user_app/services/constants.dart';

var url = Constants.baseUrl + 'user/search-term/';

class SearchApiHandler {
  Future<dynamic> searchWithWord(searchTerm) async {
    ServiceWithHeader urlHelper = ServiceWithHeader(url + searchTerm);
    var urlsData = await urlHelper.data();
    return urlsData;
  }
}
