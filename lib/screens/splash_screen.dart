import 'package:flutter/material.dart';
import 'package:snack_food/screens/login_screen.dart';
import 'package:snack_food/screens/search_screen.dart';
import 'package:snack_food/utils.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    checkUser();
  }

  void checkUser() async {
    await Future.delayed(const Duration(seconds: 5));

    if (!mounted) return;

    if (await UserPreferences.hasUser()) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const SearchScreen()),
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
              child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
                image: const DecorationImage(
                    image: AssetImage(
                      'assets/images/logo.jpeg',
                    ),
                    fit: BoxFit.cover),
                borderRadius: BorderRadius.circular(60),
                boxShadow: [
                  BoxShadow(
                      color: Theme.of(context).shadowColor.withOpacity(0.2),
                      offset: const Offset(0, 1),
                      blurRadius: 2,
                      spreadRadius: 1)
                ]),
          )),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 50),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                        width: 160,
                        child: LinearProgressIndicator(
                          color: Colors.lightBlue,
                          backgroundColor: Colors.lightBlue.withOpacity(0.2),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(2)),
                        )),
                    const SizedBox(height: 10),
                    const Text('Powered by Chiranjit',
                        style: TextStyle(
                            fontSize: 10, fontWeight: FontWeight.w600)),
                  ]),
            ),
          ),
        ],
      ),
    );
  }
}
