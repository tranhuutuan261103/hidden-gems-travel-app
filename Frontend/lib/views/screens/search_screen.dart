// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import 'package:travel_app/providers/location_provider.dart';
import 'package:travel_app/views/screens/favorite_screen.dart';

import 'coordinates_screen.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  bool isLoading = true;
  String message = '';

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Kiểm tra xem dịch vụ định vị có được bật không.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print('Location services are disabled.');
      await _showLocationServiceDialog();
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      await _showLocationPermissionDialog();
      return;
    }

    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      try {
        Position position = await Geolocator.getCurrentPosition();
        _navigateToCoordinatesScreen(
            '${position.latitude},${position.longitude}');
      } catch (e) {
        print('Error getting location: $e');
        _navigateToCoordinatesScreen('Không thể lấy vị trí hiện tại.');
      }
    }
  }

  Future<void> _showLocationServiceDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Bật Dịch Vụ Định Vị'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Dịch vụ định vị bị tắt, vui lòng bật lại.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Đồng Ý'),
              onPressed: () {
                Navigator.of(context).pop();
                _openLocationSettings();
              },
            ),
            TextButton(
              child: const Text('Từ Chối'),
              onPressed: () {
                Navigator.of(context).pop();
                _navigateToCoordinatesScreen('Bạn đang ở đâu');
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showLocationPermissionDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Cấp Quyền Truy Cập Vị Trí'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Ứng dụng cần quyền truy cập vị trí để tiếp tục.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Đồng Ý'),
              onPressed: () {
                Navigator.of(context).pop();
                Geolocator.requestPermission().then((permission) {
                  if (permission == LocationPermission.whileInUse ||
                      permission == LocationPermission.always) {
                    _determinePosition();
                  } else {
                    _navigateToCoordinatesScreen('Bạn đang ở đâu');
                  }
                });
              },
            ),
            TextButton(
              child: const Text('Từ Chối'),
              onPressed: () {
                Navigator.of(context).pop();
                _navigateToCoordinatesScreen('Bạn đang ở đâu');
              },
            ),
          ],
        );
      },
    );
  }

  void _openLocationSettings() {
    Geolocator.openLocationSettings().then((value) {
      _determinePosition();
    });
  }

  void _navigateToCoordinatesScreen(String message) {
    Provider.of<LocationProvider>(context, listen: false)
        .closeLocationloading();

    setState(() {
      isLoading = false;
      this.message = message;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: isLoading
            ? const LocationLoading()
            : CoordinatesScreen(
                message: message,
              ),
      ),
    );
  }
}

class LocationLoading extends StatelessWidget {
  const LocationLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF222222),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 500,
              child: Lottie.asset(
                  'assets/images/Animation - 1719083614303.json',
                  fit: BoxFit.fill),
            ),
            const Text(
              'Đang định vị',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange),
            )
          ],
        ),
      ),
    );
  }
}
