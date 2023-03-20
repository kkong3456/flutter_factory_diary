import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_factory_calendar_scheduler/firebase_options.dart';
import 'package:flutter_factory_calendar_scheduler/screens/home_screen.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
// import 'package:intl/date_symbol_data_file.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await MobileAds.instance.initialize();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MaterialApp(
      home: HomeScreen(),
    ),
  );
}
