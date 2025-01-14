import 'package:flutter/material.dart';
import 'package:pack_check/screens/product_screen.dart';
import 'package:pack_check/screens/scan_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String barCode = "";

  void scanBarcode() async {
    String barcode = await Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const BarcodeScannerScreen(),
    ));
    //Go to Product Screen
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => ProductScreen(barcode: barcode)));
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 0), () {
      // searchProduct();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Product Scanner'),
      //   backgroundColor: Colors.purple, // AppBar background color
      // ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(
              height: 32,
            ),
            TextField(
              decoration: InputDecoration(
                hintText: 'Search Product',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                    onPressed: () {
                      scanBarcode();
                    },
                    icon: const Icon(
                      Icons.qr_code_scanner_rounded,
                      color: Colors.lightBlue,
                    )),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
            Expanded(
              child: Center(
                child: Image.asset(
                  "assets/images/search.jpg",
                  height: 256,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
