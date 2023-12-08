import 'package:flutter/material.dart';
import 'package:login_app3/screen/enter_cellphone.dart';
import 'package:login_app3/screen/homescreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './location_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'location_service.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import './logout_page.dart';
// import 'package:check_vpn_connection/check_vpn_connection.dart';

class AdminPage extends StatefulWidget {
  // const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  @override
  late String _cellNumber;
  late String _userAgent;
  late String _ip;
  // late bool _checkVpn;
  late Timer _timer;
  late String? _lat;
  late String? _long;

  void initState() {
    _getDeviceInformation();
    _startTimer();
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 30), (_) {
      _getCurrentPosition();
    });
  }

  void _getDeviceInformation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _cellNumber = prefs.getString('cellNumber') ?? '';
      _userAgent = prefs.getString('userAgent') ?? '';
      _ip = prefs.getString('ip') ?? '';
    });
  }

  Future<void> _getCurrentPosition() async {
    try {
      Position position = await LocationService.getCurrentPosition();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('lat', position.latitude.toString());
      prefs.setString('long', position.longitude.toString());

      setState(() {
        _lat = prefs.getString('lat');
        _long = prefs.getString('long');
        // sendInformationtToNeshan(35.7016401, 51.3931059);
      });

      sendInformationtToNeshan();

      print('$_lat and $_long');
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> sendInformationtToNeshan() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final _ip = prefs.getString('ip');
    final _userAgent = prefs.getString('userAgent');
    final _token = prefs.getString('token');
    final url = Uri.parse(
      'https://api.neshan.org/v5/reverse?lat=$_lat&lng=$_long',
    );

    final headers = {
      'Api-Key': 'service.9f856e37ea1e423ba937aa6d0f5e099d',
      // 'Content-Type': 'application/json',
    };

    final body = {
      'userAgent': _userAgent,
      'cellNumber': _cellNumber,
      'ip': _ip,
      'token': _token,
    };

    print(body);

    final response = await http.get(
      url,
      headers: headers,
      // body: body,
    );
    print(response.body);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print('your data is $data');
      // setState(() {
      //   mainOtpCode = data['otp'];
      // });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to get data with code ${response.statusCode}'),
        ),
      );
    }
  }

  Future<void> _clearSharedPreferences() async {
    await clearSharedPreferences(
        context); // Call the method from admin_utils.dart
  }

  Future<void> _showConfirmationDialog() async {
    bool confirmed = await showConfirmationDialog(
        context); // Call the method from admin_utils.dart

    if (confirmed == true) {
      _clearSharedPreferences();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'صفحه مدیریت سرویسکار',
          ),
        ),
        body: Column(
          children: [
            GestureDetector(
              onTap: () {},
              child: Container(
                margin: EdgeInsets.all(15),
                padding: EdgeInsets.all(15),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.amber[600],
                ),
                child: Text(
                  'ارسلان دهباشی $_cellNumber',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                _showConfirmationDialog();
              },
              child: Text('خروج از سامانه'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                fixedSize: Size(170, 50),
              ),
            )
          ],
        ),
      ),
    );
  }
}
