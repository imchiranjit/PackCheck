import 'package:flutter/material.dart';
import 'package:pack_check/screens/product_screen.dart';
import 'package:pack_check/screens/scan_screen.dart';
import 'package:pack_check/network.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String barCode = "";
  String query = "";

  List<ProductItem> products = [];

  final TextEditingController _controller = TextEditingController();

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
    _controller.addListener(() {
      setState(() {
        query = _controller.text;
      });
      searchProduct(_controller.text).then((value) => {
            setState(() {
              products = value;
            })
          });
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
              controller: _controller,
            ),
            if (products.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 0,
                      margin: const EdgeInsets.symmetric(
                          vertical: 6, horizontal: 4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side:
                            BorderSide(color: Colors.grey.shade300, width: 1.0),
                      ),
                      child: ListTile(
                        dense: true,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            products[index].image,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(Icons.image_not_supported,
                                    color: Colors.grey, size: 24),
                              );
                            },
                          ),
                        ),
                        title: Text(
                          products[index].name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        trailing: Icon(Icons.chevron_right,
                            size: 18, color: Colors.grey[600]),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ProductScreen(
                                    barcode: products[index].code,
                                  )));
                        },
                      ),
                    );
                  },
                ),
              ),
            if (products.isEmpty)
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

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
