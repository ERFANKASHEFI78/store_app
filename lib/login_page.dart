import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:store_app/sqlite_helper.dart';
import 'package:store_app/user_model.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final SQLiteHelper _sqliteHelper = SQLiteHelper();
  bool _obscurePassword = true;

@override
void initState() {
  super.initState();
  _loadCredentials();
}

void _loadCredentials() async {
  final prefs = await SharedPreferences.getInstance();
  _emailController.text = prefs.getString('email') ?? '';
  _passwordController.text = prefs.getString('password') ?? '';
}





  void _login() async {
    if (_formKey.currentState!.validate()) {
      User? user = await _sqliteHelper.getUser(
        _emailController.text,
        _passwordController.text,
      );
      if (user != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("! ورود با موفقیت انجام شد")),
        );
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("! ایمیل یا رمز عبور اشتباه است")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final double heightScreen = MediaQuery.of(context).size.height;
    final double widthScreen = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.amber[100],
        title: const Text("ورود به پنل کاربری", style: TextStyle(fontSize: 35)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                Center(child: Text(" 😊 به برنامه فروشگاهی من خوش آمدید  ",style: TextStyle(fontSize: 17),)),
                const SizedBox(height: 40),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: "ایمیل خود را وارد کنید",
                    prefixIcon: Icon(Icons.email, size: 24, color: Colors.amber),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) =>
                      value!.isEmpty ? "ایمیل را وارد کنید" : null,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: "رمز عبور",
                    prefixIcon: const Icon(Icons.lock, size: 24, color: Colors.amber),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                    border: const OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      value!.isEmpty ? "رمز عبور را وارد کنید" : null,
                ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: _login,
                      child: const Text("ورود"),
                      style: ElevatedButton.styleFrom(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        minimumSize: Size(widthScreen * 0.4, heightScreen * 0.05),
                        backgroundColor: Colors.amber,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.popAndPushNamed(context, '/forgotPassword');
                      },
                      child: const Text(
                        "فراموشی رمز عبور",
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/signup');
                  },
                  child: const Text("ثبت نام"),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.amber,
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 25,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
