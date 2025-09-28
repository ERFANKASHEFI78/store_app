import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';
import 'sqlite_helper.dart';
final _formKey = GlobalKey<FormState>( );
class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailController = TextEditingController();
  final _tokenController = TextEditingController();
  final _newPasswordController = TextEditingController();

  bool _isTokenStep = false;
  String _generatedToken = '';

  final SQLiteHelper dbHelper = SQLiteHelper();

  // تولید یک توکن ساده 6 رقمی
  String generateToken() {
    Random rnd = Random();
    return (100000 + rnd.nextInt(900000)).toString();
  }

  // مرحله اول: ارسال توکن
  Future<void> sendToken() async {
    String email = _emailController.text.trim();
    bool exists = await dbHelper.checkEmailExists(email);
    bool isvsible=_newPasswordController.text.isNotEmpty;

    if (!exists) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("!ایمیل خودت رو وارد کن")));
      return;
    }

    _generatedToken = generateToken();

    if (_generatedToken.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("خطا در تولید توکن")));
      return;
    }
    if (isvsible) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("رمزعبور جدید خود را وارد کنید")));
      return;
    }

     final prefs = await SharedPreferences.getInstance();
     await prefs.setString('email', email);
    await dbHelper.setResetToken(email, _generatedToken);

    setState(() {
      _isTokenStep = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("توکن فراموشی رمز عبور: $_generatedToken"),
        duration: Duration(seconds: 35),
      ),
    );
  }

  // مرحله دوم: تغییر رمز عبور
  Future<void> resetPassword() async {
    String token = _tokenController.text.trim();
    String newPassword = _newPasswordController.text.trim();
    String email = _emailController.text.trim();

    if (token != _generatedToken) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("توکن نامعتبر است")));
      return;
    }

    int updated = await dbHelper.resetPassword(token, newPassword);

    if (updated > 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("رمز عبور با موفقیت تغییر کرد")),
      );
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('email', email);
      await prefs.setString('password', newPassword);


      
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      Navigator.popAndPushNamed(context, '/login');
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("خطا در تغییر رمز")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber[100],
        title: const Text("فراموشی رمز عبور", style: TextStyle(fontSize: 35)),
        centerTitle: true,
        leading: CupertinoButton(
          child: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.popAndPushNamed(context, '/login');
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isTokenStep ? tokenStepWidget() : emailStepWidget(),
      ),
    );
  }

  Widget emailStepWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextFormField(
          controller: _emailController,
          decoration: const InputDecoration(
            labelText: "ایمیل",
            prefixIcon: Icon(Icons.email, size: 24, color: Colors.amber),
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.emailAddress,
        ),

        const SizedBox(height: 20),

        ElevatedButton(
          onPressed: sendToken,
          child: const Text(" توکن بازیابی "),
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            backgroundColor: Colors.amber,
          ),
        ),
      ],
    );
  }

  Widget tokenStepWidget() {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextFormField(
            controller: _tokenController,
            decoration: const InputDecoration(
              
              labelText: "توکن جدید",
              helperText: "👇 توکن روی اسنک بار نوشته شده 👇",
              prefixIcon: Icon(
                Icons.generating_tokens_outlined,
                size: 30,
                color: Colors.amber,
              ),
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
            validator: (value) => value!.isEmpty ? "توکن را وارد کنید" : null,
           
          ),
      
          const SizedBox(height: 20),
          TextFormField(
            controller: _newPasswordController,
            validator: (value) => value!.isEmpty ? "رمز عبور را وارد کنید" : null,
            decoration: const InputDecoration(
              labelText: "رمز جدید ",
              prefixIcon: Icon(
                Icons.password_outlined,
                size: 30,
                color: Colors.amber,
              ),
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.visiblePassword,
            obscureText: true,
          ),
      
          const SizedBox(height: 60),
          ElevatedButton(
            onPressed:() {
            if (_formKey.currentState!.validate()) {
              resetPassword();
            }
          },
            child: const Text(" ثبت رمز عبور جدید "),
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              backgroundColor: Colors.amber,
            ),
          ),
        ],
      ),
    );
  }
}
