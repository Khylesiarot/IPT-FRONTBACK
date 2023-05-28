// ignore_for_file: use_build_context_synchronously

import 'package:airlogin/components/botNavBar.dart';
import 'package:airlogin/loginAndSetup/register.dart';
import 'package:airlogin/models/booked_flights.dart';
import 'package:airlogin/provider/timmy_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constant.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/flights.dart';
import '../models/user.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<bool> loginUser(String email, String password) async {
    final response = await http.post(
      Uri.parse('http://127.0.0.1:8000/login/'),
      body: {
        'email': email,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      // Login successful
      final data = jsonDecode(response.body);
      print('Login successful');
      return true;
    } else {
      // Login failed
      final data = jsonDecode(response.body);
      print('Login failed: ${data['status']}');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 0),
                child: Image.asset(
                  'assets/images/airlogo.png',
                  height: 200,
                  width: 450,
                ),
              ),
              const SizedBox(
                height: 0,
              ),
              TextFormField(
                controller: emailController,
                style: const TextStyle(fontSize: 10),
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: "Enter email",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              TextFormField(
                controller: passwordController,
                style: const TextStyle(fontSize: 10),
                keyboardType: TextInputType.visiblePassword,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Enter Password",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                  suffixIcon: Icon(Icons.remove_red_eye),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                      onPressed: () {},
                      child: const Text(
                        "Forget Password?",
                        style: TextStyle(fontSize: 10),
                      ))
                ],
              ),
              const SizedBox(
                height: 25,
              ),
              Container(
                height: 30,
                width: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  gradient:
                      const LinearGradient(colors: [tgradbut1, tgradbut2]),
                ),
                child: MaterialButton(
                  onPressed: () async {
                    final bool istrue = await loginUser(
                        emailController.text, passwordController.text);
                    if (istrue) {

                      final Users users = await fetchUsersByEmail(emailController.text);
                      print(users.userId);
                      context.read<TimsProvider>().addUser(users);
                      final List<Flights> list = await getFlights();
                       context.read<TimsProvider>().addFlights(list);
                    

                       final List<BookedFlights> bookedflights = await fetchBookedFlights(users.userId);
                      context.read<TimsProvider>().addAllBookedFlight(bookedflights);

                      final List<Flights?> bookedlist = await fetchUserBookedFlights(users.userId);
                       context.read<TimsProvider>().flightsBooked(bookedlist);
                                            Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Tabbar(),
                        ),
                      );
                    }
                  },
                  child: const Text(
                    "LOGIN",
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              const Icon(
                Icons.fingerprint,
                size: 60,
                color: tmainBlue,
              ),
              const SizedBox(
                height: 10,
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an Account?",
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.7),
                      fontSize: 10,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const Register()));
                    },
                    child: const Text(
                      "Register Account",
                      style: TextStyle(
                        fontSize: 10,
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                children: [Container()],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
