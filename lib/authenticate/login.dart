import 'dart:convert';
import 'package:first_app/models/login_response_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../global/widgets/error_dialog.dart';
import '../global/global.dart';
import '../main_screen/home_screen.dart';
import '../models/login_model.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  formValidation() {
    if (usernameController.text.isNotEmpty &&
        passwordController.text.isNotEmpty) {
      loginNow();
    } else {
      showDialog(
          context: context,
          builder: (c) {
            return const ErrorDialog(
              message: "Please write email/password",
            );
          });
    }
  }

  Future loginNow() async {
    LoginModel user = LoginModel(username: '', password: '');
    setState(() {
      user.username = usernameController.text;
      // String base64password = passwordController.text;
      // Codec<String, String> stringToBase64 = utf8.fuse(base64);
      // String encoded = stringToBase64.encode(base64password);
      user.password = passwordController.text;
    });
    var response = await http.post(
        Uri.parse("http://api.ssgroupm.com/Api/Auth/Authenticate"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(user));

    if (response.statusCode == 200) {
      // var s = response.body.toString();
      LoginResponseModel userDetails = LoginResponseModel.fromJson(jsonDecode(response.body));
      await sharedPreferences?.setString("token", userDetails.tokenString);
      await sharedPreferences?.setString("username", userDetails.username);
      await sharedPreferences?.setString("firstName", userDetails.firstName);
      await sharedPreferences?.setString("role", userDetails.role);
      //await sharedPreferences?.setString("permission", userDetails.permission ?? "unspecified");


      Route newRoute = MaterialPageRoute(builder: (_) => const HomeScreen());
      Navigator.pushReplacement(context, newRoute);
    } else {
      showDialog(
          context: context,
          builder: (c) {
            return const ErrorDialog(
              message: "Login Failed",
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Login"),
      ),
      body: Container(
        padding: const EdgeInsets.all(30),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), hintText: 'User Name'),
                controller: usernameController,
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Password',
                ),
                controller: passwordController,
                obscureText: true,
              ),
              ElevatedButton(
                  onPressed: () {
                    formValidation();
                  },
                  child: const Text("Summit")),
            ],
          ),
        ),
      ),
    );
  }
}
