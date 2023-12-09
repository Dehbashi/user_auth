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
import 'package:persian/persian.dart';
import './header.dart';
import '../constants.dart';
import './services/order_service.dart';

class AdminPage extends StatefulWidget {
  // const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  @override
  String text = "Stop Service";
  late String _cellNumber;
  late String _userAgent;
  late String _ip;
  // late bool _checkVpn;
  late Timer _timer;
  late String? _lat;
  late String? _long;
  List<Order> orders = [
    Order(
      id: 1,
      name: 'Order 1',
      details: 'سرویسکار: مهدی فولادی\n'
          'تاریخ درخواست سرویس: 22 مهرماه 1402\n'
          'نحوه آشنایی: گوگل\n'
          'آدرس: علامه طباطبایی، خیابان آستانه، کوچه پنجم شرقی، پلاک 7، واحد 3',
    ),
    Order(
      id: 2,
      name: 'Order 2',
      details: 'سرویسکار: مهدی فولادی\n'
          'تاریخ درخواست سرویس: 22 مهرماه 1402\n'
          'نحوه آشنایی: گوگل\n'
          'آدرس: علامه طباطبایی، خیابان آستانه، کوچه پنجم شرقی، پلاک 7، واحد 3',
    ),
    Order(
      id: 3,
      name: 'Order 3',
      details: 'سرویسکار: مهدی فولادی\n'
          'تاریخ درخواست سرویس: 22 مهرماه 1402\n'
          'نحوه آشنایی: گوگل\n'
          'آدرس: علامه طباطبایی، خیابان آستانه، کوچه پنجم شرقی، پلاک 7، واحد 3',
    ),
    Order(
      id: 4,
      name: 'Order 4',
      details: 'سرویسکار: مهدی فولادی\n'
          'تاریخ درخواست سرویس: 22 مهرماه 1402\n'
          'نحوه آشنایی: گوگل\n'
          'آدرس: علامه طباطبایی، خیابان آستانه، کوچه پنجم شرقی، پلاک 7، واحد 3',
    ),
    Order(
      id: 5,
      name: 'Order 5',
      details: 'سرویسکار: مهدی فولادی\n'
          'تاریخ درخواست سرویس: 22 مهرماه 1402\n'
          'نحوه آشنایی: گوگل\n'
          'آدرس: علامه طباطبایی، خیابان آستانه، کوچه پنجم شرقی، پلاک 7، واحد 3',
    ),
    Order(
      id: 6,
      name: 'Order 6',
      details: 'سرویسکار: مهدی فولادی\n'
          'تاریخ درخواست سرویس: 22 مهرماه 1402\n'
          'نحوه آشنایی: گوگل\n'
          'آدرس: علامه طباطبایی، خیابان آستانه، کوچه پنجم شرقی، پلاک 7، واحد 3',
    ),
  ];
  bool expanded = false;

  void initState() {
    _getDeviceInformation();
    _startTimer();
    // fetchOrders();
    super.initState();
  }

  // void fetchOrders() async {
  //   try {
  //     final orderService = OrderService();
  //     final fetchedOrders = await orderService.getOrders();
  //     setState(() {
  //       orders = fetchedOrders;
  //     });
  //   } catch (e) {
  //     print('Failed to fetch orders: $e');
  //   }
  // }

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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: AppBarTheme(backgroundColor: Colors.white),
      ),
      home: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: Header(),
        ),
        body: Directionality(
          textDirection: TextDirection.rtl,
          child: Column(
            children: [
              GestureDetector(
                onTap: () {},
                child: Container(
                  margin: EdgeInsets.all(15),
                  padding: EdgeInsets.all(10),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color(0xFF9BDCE0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${_cellNumber.withPersianNumbers()}',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: Constants.textFont,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.logout_outlined),
                        onPressed: () {
                          _showConfirmationDialog();
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.all(10),
                width: double.infinity,
                height: 500,
                child: ListView.builder(
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    final order = orders[index];
                    return Container(
                      margin: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 181, 243, 222),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black
                                .withOpacity(0.2), // Set the shadow color
                            spreadRadius: 2, // Set the spread radius
                            blurRadius: 3, // Set the blur radius
                            offset: Offset(0, 2), // Set the offset
                          ),
                        ],
                      ),
                      child: ExpansionTile(
                        title: Text(
                          'سفارش شماره ${order.id.toString().withPersianNumbers()}',
                          style: TextStyle(
                            fontFamily: Constants.textFont,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        children: [
                          ListTile(
                            title: Text(
                              'نام سفارش: ${order.name}',
                              style: TextStyle(
                                fontFamily: Constants.textFont,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                            ),
                            child: ListTile(
                              title: Text(
                                '${order.details}',
                                style: TextStyle(
                                  fontFamily: Constants.textFont,
                                  height: 2.5,
                                ),
                              ),
                            ),
                          ),
                          // Add more details as needed
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
