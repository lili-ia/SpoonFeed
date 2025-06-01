import 'package:shared_preferences/shared_preferences.dart';

class CityService {
  Future<String> getCity() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? city = sharedPreferences.getString("city");
    if (city == null) {
      return getCities()[0];
    }
    return city;
  }

  List<String> getCities() {
    return ["Kyiv", "Kharkiv"];
  }
}
