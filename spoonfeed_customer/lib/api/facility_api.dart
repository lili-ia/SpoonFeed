import 'package:spoonfeed_customer/models/facility.dart';

class FacilityApi {
  Future<List<Facility>> getFacilities(int restaurantId) async {
    await Future.delayed(Duration(seconds: 1));
    return [
      Facility(
        1,
        "2a Hryhorii Skovoroda St.",
        "+3809415968585",
        "https://www.kfc-ukraine.com/",
        3,
      ),
      Facility(
        2,
        "3a Hryhorii Skovoroda St.",
        "+3809415968585",
        "https://www.kfc-ukraine.com/",
        3,
      ),
      Facility(
        3,
        "4a Hryhorii Skovoroda St.",
        "+3809415968585",
        "https://www.kfc-ukraine.com/",
        3,
      ),
      Facility(
        4,
        "5a Hryhorii Skovoroda St.",
        "+3809415968585",
        "https://www.kfc-ukraine.com/",
        3,
      ),
      Facility(
        5,
        "6a Hryhorii Skovoroda St.",
        "+3809415968585",
        "https://www.kfc-ukraine.com/",
        3,
      ),
      Facility(
        6,
        "7a Hryhorii Skovoroda St.",
        "+3809415968585",
        "https://www.kfc-ukraine.com/",
        3,
      ),
      Facility(
        7,
        "8a Hryhorii Skovoroda St.",
        "+3809415968585",
        "https://www.kfc-ukraine.com/",
        3,
      ),
    ];
  }

  Future<Facility> getFacility() async {
    return Facility(
      1,
      "2a Hryhorii Skovoroda St.",
      "+3809415968585",
      "https://www.kfc-ukraine.com/",
      3,
    );
  }
}
