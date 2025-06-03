import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spoonfeed_customer/api/restaurant_api.dart';
import 'package:spoonfeed_customer/api/facility_api.dart';
import 'package:spoonfeed_customer/custom_text.dart';
import 'package:spoonfeed_customer/models/restaurant.dart';
import 'package:spoonfeed_customer/models/facility.dart';
import 'package:spoonfeed_customer/restaurant_button.dart';
import 'widgets/address_picker_dialog.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({
    super.key, 
    required this.currentCity,
    this.isRestaurantsPage,  // Make this optional
  });

  final String currentCity;
  final bool? isRestaurantsPage;  // Make this nullable

  @override
  State<StatefulWidget> createState() {
    return _MainScreenState();
  }

  final int restaurantCountInRow = 6;

  List<List<Restaurant>> convertRestaurants(List<Restaurant> r) {
    List<List<Restaurant>> restaurants = [];
    for (var i = 0; i < r.length / restaurantCountInRow; i++) {
      restaurants.add([]);
      for (var j = 0; j < restaurantCountInRow; j++) {
        restaurants[i].add(r[i * restaurantCountInRow + j]);
      }
    }
    return restaurants;
  }
}

class _MainScreenState extends State<MainScreen> {
  late Future<List<Restaurant>> restaurants;
  String selectedAddress = "What's your address?";
  List<String> recentAddresses = [];
  bool showSearchBar = false;
  TextEditingController searchController = TextEditingController();
  List<Restaurant> filteredRestaurants = [];
  List<Restaurant> allRestaurants = [];
  
  // Auto-detect if we're on the restaurants page
  bool get isRestaurantsPage {
    if (widget.isRestaurantsPage != null) {
      return widget.isRestaurantsPage!;
    }
    // Auto-detect based on current route
    final location = GoRouterState.of(context).uri.path;
    return location.contains('/restaurants');
  }

  @override
  void initState() {
    super.initState();
    restaurants = RestaurantApi().getRestaurants(widget.currentCity);
    _loadRecentAddresses();
    _loadRestaurants();
  }

  Future<void> _loadRestaurants() async {
    try {
      allRestaurants = await RestaurantApi().getRestaurants(widget.currentCity);
      filteredRestaurants = allRestaurants;
    } catch (e) {
      print('Error loading restaurants: $e');
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> _loadRecentAddresses() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      recentAddresses = prefs.getStringList('recent_addresses') ?? [];
      selectedAddress =
          prefs.getString('selected_address') ?? "What's your address?";
    });
  }

  Future<void> _saveRecentAddress(String address) async {
    final prefs = await SharedPreferences.getInstance();

    recentAddresses.remove(address);
    recentAddresses.insert(0, address);
    if (recentAddresses.length > 5) {
      recentAddresses = recentAddresses.take(5).toList();
    }

    await prefs.setStringList('recent_addresses', recentAddresses);
    await prefs.setString('selected_address', address);
    setState(() {});
  }

  Future<List<String>> _searchAddresses(String query) async {
    final List<String> predefinedAddresses = [
      'вул. Хрещатик, 22, Київ',
      'просп. Свободи, 16, Львів',
      'вул. Дерибасівська, 5, Одеса',
      'вул. Сумська, 25, Харків',
      'вул. Катерининська, 12, Дніпро',
    ];

    return predefinedAddresses
        .where((address) =>
            address.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  void _showAddressPicker() {
    showDialog(
      context: context,
      builder: (context) => AddressPickerDialog(
        onAddressSelected: (address) {
          setState(() {
            selectedAddress = address;
          });
          _saveRecentAddress(address);
        },
        recentAddresses: recentAddresses,
        onSearchAddresses: _searchAddresses,
      ),
    );
  }

  void _filterRestaurants(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredRestaurants = allRestaurants;
      } else {
        filteredRestaurants = allRestaurants
            .where((restaurant) =>
                restaurant.restaurant.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  void _toggleSearchBar() {
    setState(() {
      showSearchBar = !showSearchBar;
      if (!showSearchBar) {
        searchController.clear();
        filteredRestaurants = allRestaurants;
      }
    });
  }

  Future<void> _selectRestaurant(Restaurant restaurant) async {
    try {
      // Get facilities for the selected restaurant (for demo purposes)
      List<Facility> facilities = await FacilityApi().getFacilities(restaurant.restaurantId);
      
      // For this implementation, we'll redirect to the first facility
      // or you can show a facility picker dialog
      if (facilities.isNotEmpty) {
        // Navigate to the facility screen with the first facility's ID
        //context.go("/facilities/${restaurant.restaurantId}/facility/${facilities.first.facilityId}");
        context.go("/facilities/${restaurant.restaurantId}");
      } else {
        // Fallback: navigate to restaurant facilities list
        context.go("/facilities/${restaurant.restaurantId}");
      }
    } catch (e) {
      print('Error selecting restaurant: $e');
      // Fallback navigation
      context.go("/facilities/${restaurant.restaurantId}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomText(
          text: "Food delivery right to your door!\nThe best food chains!",
        ),
        
        // Address Picker and Search Button Row
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              // Address Picker Button
              Expanded(
                child: ElevatedButton(
                  onPressed: _showAddressPicker,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.location_on, color: Colors.white),
                      const SizedBox(width: 8),
                      Flexible(
                        child: CustomText(
                          text: selectedAddress.length > 25
                              ? "${selectedAddress.substring(0, 25)}..."
                              : selectedAddress,
                        ),
                      ),
                      if (selectedAddress != "What's your address?") ...[
                        const SizedBox(width: 8),
                        const Icon(Icons.check_circle, color: Colors.black, size: 18),
                      ],
                    ],
                  ),
                ),
              ),
              
              // Search Button - Only show on restaurants page (now auto-detected)
              if (isRestaurantsPage) ...[
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _toggleSearchBar,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: showSearchBar ? Colors.red : Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.all(12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Icon(
                    showSearchBar ? Icons.close : Icons.search,
                    size: 24,
                  ),
                ),
              ],
            ],
          ),
        ),

        // Search Bar - Only show on restaurants page when search is active
        if (isRestaurantsPage && showSearchBar)
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller: searchController,
              onChanged: _filterRestaurants,
              decoration: InputDecoration(
                hintText: 'Search restaurants...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          searchController.clear();
                          _filterRestaurants('');
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
            ),
          ),

        // Selected Address Display
        if (selectedAddress != "What's your address?")
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.black.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.white, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "Selected address: $selectedAddress",
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: _showAddressPicker,
                    child: const Text(
                      "Change",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
          ),

        // Restaurants Display
        Expanded(
          child: SingleChildScrollView(
            child: (isRestaurantsPage && showSearchBar)
                ? _buildSearchResults()
                : _buildRestaurantGrid(),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchResults() {
    if (filteredRestaurants.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(32),
        child: Center(
          child: Text(
            'No restaurants found',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: filteredRestaurants.length,
      itemBuilder: (context, index) {
        final restaurant = filteredRestaurants[index];
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Card(
            child: ListTile(
              leading: const Icon(Icons.restaurant, color: Colors.orange),
              title: Text(restaurant.restaurant),
              subtitle: Text('Tap to view facilities'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => _selectRestaurant(restaurant),
            ),
          ),
        );
      },
    );
  }

  Widget _buildRestaurantGrid() {
    return FutureBuilder<List<Restaurant>>(
      future: restaurants,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        List<List<Restaurant>> rest = widget.convertRestaurants(snapshot.data);
        return Column(
          children: rest.map((List<Restaurant> restaurants) {
            return Container(
              padding: const EdgeInsets.all(15),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: restaurants.map((Restaurant restaurant) {
                    return RestaurantButton(
                      restaurant: restaurant,
                      onClick: () => _selectRestaurant(restaurant),
                    );
                  }).toList(),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}