import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:travel_app/providers/location_provider.dart';
import 'package:travel_app/views/screens/add_screen.dart';
import 'package:travel_app/views/screens/search_screen.dart';
import 'package:travel_app/views/screens/user_screen.dart';

import '../widgets/custom_floating_action_button_location.dart';
import 'home_screen_detail.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List<Widget> listStack = [
    HomeScreenDetail(),
    LocationScreen(),
    Center(),
    LocationScreen(),
    UserScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<LocationProvider>(
      builder: (context, value, child) {
        return Scaffold(
          body: IndexedStack(
            index: _selectedIndex,
            children: listStack,
          ),
          bottomNavigationBar: !value.isLoading
              ? Stack(
                  children: [
                    BottomAppBar(
                      color: const Color(0xFF222222),
                      elevation: 0,
                      child: Container(
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.grey[850],
                          borderRadius: const BorderRadius.all(
                            Radius.circular(50),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                                icon: Icon(Icons.home,
                                    color: _selectedIndex == 0
                                        ? Color.fromARGB(255, 255, 87, 51)
                                        : Colors.grey),
                                onPressed: () {
                                  setState(() {
                                    listStack[1] = const Center();
                                  });
                                  _onItemTapped(0);
                                },
                                tooltip: "Trang chủ"),
                            IconButton(
                                icon: Icon(Icons.search,
                                    color: _selectedIndex == 1
                                        ? Color.fromARGB(255, 255, 87, 51)
                                        : Colors.grey),
                                onPressed: () async {
                                  setState(() {
                                    listStack[1] =
                                        LocationScreen(key: UniqueKey());
                                  });
                                  value.openLocationloading();
                                  _onItemTapped(1);
                                },
                                tooltip: "Tìm kiếm"),
                            const SizedBox(width: 40),
                            IconButton(
                                icon: Icon(Icons.favorite,
                                    color: _selectedIndex == 3
                                        ? Color.fromARGB(255, 255, 87, 51)
                                        : Colors.grey),
                                onPressed: () {
                                  setState(() {
                                    listStack[1] = const Center();
                                  });
                                  _onItemTapped(3);
                                },
                                tooltip: "Yêu thích"),
                            IconButton(
                                icon: Icon(Icons.person,
                                    color: _selectedIndex == 4
                                        ? Color.fromARGB(255, 255, 87, 51)
                                        : Colors.grey),
                                onPressed: () {
                                  setState(() {
                                    listStack[1] = const Center();
                                  });
                                  _onItemTapped(4);
                                },
                                tooltip: "Thông tin"),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 20,
                      left: MediaQuery.of(context).size.width / 2 - 30,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            listStack[1] = const Center();
                          });
                          _onItemTapped(2);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddScreen()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          shape: CircleBorder(),
                          backgroundColor: Color.fromARGB(255, 255, 87, 51),
                          padding: EdgeInsets.all(16),
                        ),
                        child: const Icon(Icons.maps_ugc, color: Colors.white),
                      ),
                    ),
                  ],
                )
              : null,
        );
      },
    );
  }
}
