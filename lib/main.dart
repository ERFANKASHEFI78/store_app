import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:store_app/ForgotPasswordPage.dart';
import 'package:store_app/home_page.dart';
import 'package:store_app/item_model.dart';
import 'package:store_app/signup_page.dart';
import 'package:store_app/login_page.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  
  await Hive.initFlutter();
  Hive.registerAdapter(ItemAdapter());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(



     initialRoute: '/login',
      routes: {
    '/login': (context) => LoginPage(),
    '/signup': (context) => SignUpPage(),
    '/home': (context) => HomePage(),
    '/forgotPassword' :(context)=>ForgotPasswordPage()
        },
      debugShowCheckedModeBanner: false,
      title: 'Store App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
     
    );
  }
}
