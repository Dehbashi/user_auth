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
// import 'package:check_vpn_connection/check_vpn_connection.dart';

class AdminPage extends StatefulWidget {
  // const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  @override
  late String _cellNumber;
  late bool _checkVpn;
  late Timer _timer;
  late dynamic _lat;
  late dynamic _long;

  void initState() {
    _getCellNumber();
    _startTimer();
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 5), (_) {
      _getCurrentPosition();
    });
  }

  void _getCellNumber() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _cellNumber = prefs.getString('cellNumber') ?? '';
    });
  }

  Future<void> _getCurrentPosition() async {
    try {
      Position position = await LocationService.getCurrentPosition();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('lat', position.latitude.toString());
      prefs.setString('long', position.longitude.toString());

      setState(() {
        _lat = prefs.get('lat');
        _long = prefs.get('long');
        sendInformationtToNeshan(_lat, _long);
      });

      print('$_lat and $_long');
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> sendInformationtToNeshan(_lat, _long) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final _ip = prefs.get('ip');
    final _userAgent = prefs.get('userAgent');
    final _token = prefs.get('token');
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

    final response = await http.post(
      url,
      headers: headers,
      body: body,
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
          content:
              Text('Failed to send phone number with ${response.statusCode}'),
        ),
      );
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
          body: ListView(
            children: [
              GestureDetector(
                onTap: () {},
                child: Container(
                  margin: EdgeInsets.all(15),
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.amber[600],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'ارسلان دهباشی $_cellNumber',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        onPressed: () {},
                        tooltip: 'خروج',
                        icon: Icon(
                          Icons.logout_rounded,
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
