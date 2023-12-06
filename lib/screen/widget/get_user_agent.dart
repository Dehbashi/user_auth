import 'package:flutter/material.dart';
import 'package:fk_user_agent/fk_user_agent.dart';
import 'dart:async';
import 'package:flutter/services.dart';

class UserAgent extends StatefulWidget {
  const UserAgent({super.key});

  @override
  State<UserAgent> createState() => _UserAgentState();
}

class _UserAgentState extends State<UserAgent> {
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) async {
      await FkUserAgent.init();
      initPlatformState();
    });
  }

  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = FkUserAgent.userAgent!;
      print(platformVersion);
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Text('User Agent: $_platformVersion');
  }
}
