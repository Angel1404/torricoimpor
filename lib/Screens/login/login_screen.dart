import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:torrico_import/Screens/homepage_screen.dart';
import 'package:torrico_import/rounded_button.dart';
import 'package:torrico_import/services/auth_services.dart';
import 'package:torrico_import/services/globals.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _name = '';
  String _password = '';
  loginPressed() async {
    if (_name.isNotEmpty && _password.isNotEmpty) {
      http.Response response = await AuthServices.login(_name, _password);
      Map responseMap = jsonDecode(response.body);
      if (response.statusCode == 200) {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => const HomePage(),
            ));
      } else {
        errorSnackBar(context, responseMap.values.first);
      }
    } else {
      errorSnackBar(context, 'Ingrese todos los campos requeridos');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 280,
                ),
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: 'Ingrese Nombre de Usuario',
                    ),
                    onChanged: (value) {
                      _name = value;
                    },
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: TextField(
                    obscureText: true,
                    decoration: const InputDecoration(
                      hintText: 'Ingrese Contraseña',
                    ),
                    onChanged: (value) {
                      _password = value;
                    },
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                RoundedButton(
                  btntext: 'Ingresar',
                  onBtnPressed: () => loginPressed(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
