import 'package:flutter/material.dart';
import 'package:snack_food/network.dart';
import 'package:snack_food/screens/login_screen.dart';
import 'package:snack_food/utils.dart';

class ProductScreen extends StatefulWidget {
  final String barcode;
  const ProductScreen({super.key, required this.barcode});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  HealthStatus? result;
  Product? product;
  bool notFound = false;
  bool failed = false;

  void healthCheck(Product value) async {
    UserData userData = await UserPreferences.getUser();
    setState(() {
      result = userData.healthCheck(value);
      product = value;
    });
  }

  void searchProduct() async {
    setState(() {
      notFound = false;
      failed = false;
    });
    try {
      Product product = await fetchProduct(widget.barcode);
      healthCheck(product);
    } on NotFound {
      setState(() {
        notFound = true;
      });
    } on Failed {
      setState(() {
        failed = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      // healthCheck();
      searchProduct();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (failed || notFound) {
      return Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  failed
                      ? 'assets/images/connection_lost.png'
                      : 'assets/images/404.png', // Make sure to add this image in your assets
                  height: 240,
                ),
                const SizedBox(height: 24),
                Text(
                  failed
                      ? 'Your connection are lost'
                      : 'Product not available.',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  failed
                      ? 'Please check your internet connection\nand try again'
                      : 'Please scan the barcode wisely\nand try again.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    if (notFound) {
                      Navigator.of(context).pop();
                    } else {
                      searchProduct();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightBlue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 36, vertical: 18),
                  ),
                  child: const Text('Try Again'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (product == null) {
      return Scaffold(
          body: Center(
        child: CircularProgressIndicator(
          color: Colors.lightBlue,
          backgroundColor: Colors.lightBlue.withOpacity(0.2),
        ),
      ));
    }

    return Scaffold(
      appBar: AppBar(
        title: Row(children: [
          Image.network(
            product!.image,
            height: 48,
          ),
          const SizedBox(width: 16),
          Text(product!.name,
              style: const TextStyle(
                  color: Colors.black, fontWeight: FontWeight.bold))
        ]),
        actions: [
          IconButton(
            onPressed: () async {
              await Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const LoginScreen(pop: true)));
              healthCheck(product!);
            },
            icon: const Icon(
              Icons.account_circle_outlined,
              color: Colors.lightBlue,
            ),
          ),
          // const SizedBox(width: 16),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ListView(
          children: [
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: result == HealthStatus.high
                    ? Colors.red[100]
                    : result == HealthStatus.medium
                        ? Colors.yellow[100]
                        : Colors.green[100],
                borderRadius: BorderRadius.circular(32),
              ),
              height: 350,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.network(
                      product!.image,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        }
                        return CircularProgressIndicator(
                          color: Colors.lightBlue,
                          backgroundColor: Colors.lightBlue.withOpacity(0.2),
                        );
                      },
                      width: 240,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Text(
                      result == HealthStatus.high
                          ? 'High Risk'
                          : result == HealthStatus.medium
                              ? 'Medium Risk'
                              : 'Low Risk',
                      style: TextStyle(
                        color: result == HealthStatus.high
                            ? Colors.red
                            : result == HealthStatus.medium
                                ? Colors.orange
                                : Colors.green,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      result == HealthStatus.high
                          ? 'This product is not healthy to eat'
                          : result == HealthStatus.medium
                              ? 'This product is not so healthy to eat'
                              : 'This product is very healthy to eat',
                      style: TextStyle(
                        color: result == HealthStatus.high
                            ? Colors.red
                            : result == HealthStatus.medium
                                ? Colors.orange
                                : Colors.green,
                        fontSize: 16,
                      ),
                    ),
                  ]),
            ),
            const SizedBox(
              height: 16,
            ),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.purple[100],
                borderRadius: BorderRadius.circular(32),
              ),
              child: Column(children: [
                Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          'Nutritions',
                          style: TextStyle(
                            color: Colors.purple,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          product!.nutritions.quantity,
                          style: const TextStyle(
                            color: Colors.purple,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    )),
                ...product!.nutritions.nutrients.entries.map(
                  (e) => Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(e.key,
                              style: const TextStyle(color: Colors.purple)),
                          Text(
                            e.value,
                            style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.purple),
                          ),
                        ],
                      )),
                ),
              ]),
            ),
            const SizedBox(
              height: 16,
            ),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green[100],
                borderRadius: BorderRadius.circular(32),
              ),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                      child: Text(
                        'Benefits',
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ...product!.positive.map(
                      (e) => Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                        child: Text(
                          e,
                          textAlign: TextAlign.start,
                          style: const TextStyle(
                              fontWeight: FontWeight.w400, color: Colors.green),
                        ),
                      ),
                    )
                  ]),
            ),
            const SizedBox(
              height: 16,
            ),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red[100],
                borderRadius: BorderRadius.circular(32),
              ),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                      child: Text(
                        'Drawbacks',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ...product!.negative.map(
                      (e) => Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                        child: Text(
                          e,
                          textAlign: TextAlign.start,
                          style: const TextStyle(
                              fontWeight: FontWeight.w400, color: Colors.red),
                        ),
                      ),
                    )
                  ]),
            ),
            const SizedBox(
              height: 48,
            ),
            // Image.asset(
            //   result == HealthStatus.high
            //       ? 'assets/images/high.png'
            //       : result == HealthStatus.medium
            //           ? 'assets/images/medium.png'
            //           : 'assets/images/low.png',
            //   height: 200,
            // ),
            // const SizedBox(height: 24),
            // Text(
            //   result == HealthStatus.high
            //       ? 'Try avoiding this product'
            //       : result == HealthStatus.medium
            //           ? 'This product is not so healthy to eat'
            //           : 'This product is very healthy to eat',
            //   textAlign: TextAlign.center,
            //   style: const TextStyle(
            //     fontSize: 16,
            //   ),
            // ),
            // const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
