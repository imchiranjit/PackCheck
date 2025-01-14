import 'package:flutter/material.dart';
import 'package:pack_check/network.dart';
import 'package:pack_check/screens/login_screen.dart';
import 'package:pack_check/utils.dart';

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
      body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    product!.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Icon(
                    Icons.check,
                    color: Colors.green[600],
                    size: 24,
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Info cards row
              Row(
                children: [
                  Expanded(
                    child: _buildInfoCard(
                      context: context,
                      color: result == HealthStatus.high
                          ? Colors.redAccent.withOpacity(.2)
                          : result == HealthStatus.medium
                              ? Colors.orangeAccent.withOpacity(.2)
                              : Colors.greenAccent.withOpacity(.2),
                      iconColor: result == HealthStatus.high
                          ? Colors.redAccent
                          : result == HealthStatus.medium
                              ? Colors.orangeAccent
                              : Colors.greenAccent,
                      icon: result == HealthStatus.high
                          ? Icons.dangerous_rounded
                          : result == HealthStatus.medium
                              ? Icons.warning_amber_rounded
                              : Icons.check_circle_outline_rounded,
                      text: result == HealthStatus.high
                          ? 'Avoid Consumption'
                          : result == HealthStatus.medium
                              ? 'Consume Moderately'
                              : 'Consume Freely',
                      hasShadow: true,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildInfoCard(
                      context: context,
                      color: const Color(0xFFE3F2FD),
                      iconColor: Colors.blue,
                      icon: Icons.food_bank,
                      text: '25g',
                      textAlign: TextAlign.center,
                      hasShadow: true,
                      extraText: "Recommended Serving",
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Health Concerns Section
              _buildSection(
                title: 'Health Concerns',
                backgroundColor: const Color(0xFFFFEBEE),
                textColor: Colors.red[700]!,
                items: product!.negative,
                borderColor: Colors.red[200]!,
              ),
              const SizedBox(height: 16),

              // Benefits Section
              _buildSection(
                title: 'Benefits',
                backgroundColor: const Color(0xFFE8F5E9),
                textColor: Colors.green[700]!,
                items: product!.positive,
                borderColor: Colors.green[200]!,
              ),
              const SizedBox(height: 24),

              // Nutrition Facts Section
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 2,
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Nutrition Facts',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildNutritionTable(
                        nutritionData: product!.nutritions.nutrients),
                  ],
                ),
              ),
            ],
          )),
    );
  }

  Widget _buildInfoCard({
    required BuildContext context,
    required Color color,
    required Color iconColor,
    required IconData icon,
    required String text,
    String? extraText,
    TextAlign textAlign = TextAlign.left,
    bool hasShadow = false,
  }) {
    return Container(
      height: 144,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: hasShadow
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 2,
                ),
              ]
            : null,
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 60, // Width of the circle
              height: 60, // Height of the circle
              decoration: BoxDecoration(
                color: color, // Background color
                shape: BoxShape.circle, // Circular shape
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 32,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              text,
              textAlign: textAlign,
              style: TextStyle(
                color: iconColor,
                fontSize: 14 + (extraText != null ? 4 : 0),
                fontWeight:
                    (extraText != null ? FontWeight.w900 : FontWeight.w500),
              ),
            ),
            extraText != null
                ? Text(
                    extraText,
                    textAlign: textAlign,
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required Color backgroundColor,
    required Color textColor,
    required List<String> items,
    required Color borderColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        // color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: borderColor,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: textColor,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          ...items.map((item) => Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '• ',
                      style: TextStyle(
                        color: textColor,
                        fontSize: 14,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        item,
                        style: TextStyle(
                          color: textColor,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildNutritionTable({required Map<String, String> nutritionData}) {
    return Column(
      children: nutritionData.entries.map((entry) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Colors.black12,
                width: 1,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                entry.key,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
              Text(
                entry.value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
