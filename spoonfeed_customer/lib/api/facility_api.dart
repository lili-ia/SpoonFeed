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
        "15a Ivan Mazepa Ave.",
        "+3809415968585",
        "https://www.kfc-ukraine.com/",
        3,
      ),
      Facility(
        3,
        "9b Lesya Ukrainka Blvd.",
        "+3809415968585",
        "https://www.kfc-ukraine.com/",
        3,
      ),
      Facility(
        4,
        "22 Mykola Mikhnovsky St.",
        "+3809415968585",
        "https://www.kfc-ukraine.com/",
        3,
      ),
      Facility(
        5,
        "7c Vasyl Stus Lane",
        "+3809415968585",
        "https://www.kfc-ukraine.com/",
        3,
      ),
      Facility(
        6,
        "18 Dmytro Bahalii St.",
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
