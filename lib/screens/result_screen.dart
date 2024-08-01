import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  final String result;

  const ResultScreen({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              result == 'high'
                  ? 'assets/images/high.png'
                  : result == 'medium'
                      ? 'assets/images/medium.png'
                      : 'assets/images/low.png',
              height: 200,
            ),
            const SizedBox(height: 24),
            Text(
              result == 'high'
                  ? 'Try avoiding this product'
                  : result == 'medium'
                      ? 'This product is not so healthy to eat'
                      : 'This product is very healthy to eat',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightBlue,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 36, vertical: 18),
              ),
              child: const Text('Back Home'),
            ),
          ],
        ),
      ),
    );
  }
}
