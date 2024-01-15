import 'package:capstone_catatan_keuangan/pages/AddFormPage.dart';
import 'package:capstone_catatan_keuangan/pages/DetailPage.dart';
import 'package:capstone_catatan_keuangan/pages/LoginPage.dart';
import 'package:capstone_catatan_keuangan/pages/RegisterPage.dart';
import 'package:capstone_catatan_keuangan/pages/PageHandler.dart';
import 'package:capstone_catatan_keuangan/pages/Reports.dart';
import 'package:capstone_catatan_keuangan/services/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FlutterNativeSplash.remove();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Laporan Keuangan',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const PageHandler(),
        '/login': (context) => LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/reports': (context) => Reports(),
        '/add': (context) => AddFormPage(),
        '/detail': (context) => DetailPage(),
      },
    );
  }
}
