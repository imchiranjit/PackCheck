import 'package:flutter/material.dart';
import 'package:pack_check/screens/login_screen.dart';
import 'package:pack_check/screens/search_screen.dart';
import 'package:pack_check/utils.dart';

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
    await Future.delayed(const Duration(seconds: 3));

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
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(
                    'assets/images/logo.png',
                  ),
                  fit: BoxFit.cover),
            ),
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
