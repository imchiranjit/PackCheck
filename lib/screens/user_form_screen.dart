import 'package:flutter/material.dart';
import 'package:snack_food/components/custom_checkbox_card.dart';
import 'package:snack_food/components/custom_dob.dart';
import 'package:snack_food/components/custom_gender.dart';
import 'package:snack_food/network.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';
import 'package:snack_food/screens/result_screen.dart';

class UserFormScreen extends StatefulWidget {
  const UserFormScreen({super.key});
  @override
  State<UserFormScreen> createState() => _UserFormScreenState();
}

class _UserFormScreenState extends State<UserFormScreen> {
  final _formKey = GlobalKey<FormState>();
  int age = 0;
  Gender _selectedGender = Gender.male;
  bool _isPregnant = false;
  bool _isLactating = false;
  bool _isObese = false;
  bool _isDiabetic = false;
  bool _isHyperTension = false;

  Product? product;
  bool notFound = false;
  bool failed = false;

  String barCode = "";

  String checkProduct() {
    var params = [];

    if (age < 12) {
      params.add(product!.child);
    } else if (age < 24) {
      params.add(product!.young);
    } else if (age < 60) {
      params.add(product!.adult);
    } else {
      params.add(product!.old);
    }

    if (_selectedGender == Gender.female) {
      if (_isPregnant) {
        params.add(product!.pregnant);
      }
      if (_isLactating) {
        params.add(product!.lactating);
      }
    }

    if (_isObese) {
      params.add(product!.obese);
    }
    if (_isDiabetic) {
      params.add(product!.diabetic);
    }
    if (_isHyperTension) {
      params.add(product!.hypertention);
    }

    bool high = false, medium = false;
    for (var element in params) {
      if (element == "High") {
        high = true;
        break;
      } else if (element == "Medium") {
        medium = true;
      }
    }

    if (high) {
      return "High";
    } else if (medium) {
      return "Medium";
    }

    return "Low";
  }

  void _searchProduct(String res) async {
    setState(() {
      notFound = false;
      failed = false;
      product = null;
    });
    try {
      var value = await fetchProduct(res);
      setState(() {
        product = value;
      });
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

  void searchProduct() async {
    setState(() {
      product = null;
    });
    var res = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const SimpleBarcodeScannerPage(),
        ));
    setState(() {
      barCode = res.toString();
    });
    _searchProduct(res.toString());
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 0), () {
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
                      searchProduct();
                    } else {
                      _searchProduct(barCode);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightBlue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 36, vertical: 20),
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
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          product!.name,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
              onPressed: searchProduct,
              icon: const Icon(Icons.qr_code_scanner_rounded)),
          const SizedBox(width: 16.0)
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(32.0),
          // crossAxisAlignment: CrossAxisAlignment.start,
          // mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'About ',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'you',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            CustomGender(
              selectedGender: _selectedGender,
              onSelection: (gender) => {
                setState(() {
                  _selectedGender = gender;
                })
              },
            ),
            const SizedBox(height: 24),
            DateOfBirthInput(
              onChange: (value) => {
                setState(() {
                  age = value;
                })
              },
            ),
            const SizedBox(height: 24),
            const Text(
              'Health Conditions',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (_selectedGender == Gender.female)
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const SizedBox(height: 16.0),
                CustomCheckboxCard(
                    isSelected: _isPregnant,
                    icon: const AssetImage('assets/images/pregnant.png'),
                    title: "Pregnant",
                    subtitle:
                        "Pregnancy is the time during which one or more offspring develops (gestates) inside a woman's uterus (womb).",
                    onTap: () {
                      setState(() {
                        _isPregnant = !_isPregnant;
                      });
                    }),
                const SizedBox(height: 16.0),
                CustomCheckboxCard(
                    isSelected: _isLactating,
                    icon: const AssetImage('assets/images/lactating.png'),
                    title: "Lactating",
                    subtitle:
                        "Lactation is the process of milk production and secretion from the mammary glands of a mother after childbirth.",
                    onTap: () {
                      setState(() {
                        _isLactating = !_isLactating;
                      });
                    }),
              ]),
            const SizedBox(height: 16.0),
            CustomCheckboxCard(
                isSelected: _isObese,
                icon: const AssetImage('assets/images/obese.png'),
                title: "Obese",
                subtitle:
                    "A disorder involving excessive body fat that increases the risk of health problems.",
                onTap: () {
                  setState(() {
                    _isObese = !_isObese;
                  });
                }),
            const SizedBox(height: 16.0),
            CustomCheckboxCard(
                isSelected: _isDiabetic,
                icon: const AssetImage('assets/images/diabetic.png'),
                title: "Diabetic",
                subtitle:
                    "A chronic condition that affects the way the body processes blood sugar (glucose).",
                onTap: () {
                  setState(() {
                    _isDiabetic = !_isDiabetic;
                  });
                }),
            const SizedBox(height: 16.0),
            CustomCheckboxCard(
                isSelected: _isHyperTension,
                icon: const AssetImage('assets/images/hypertention.png'),
                title: "Hypertension",
                subtitle:
                    "A condition in which the force of the blood against the artery walls is too high.",
                onTap: () {
                  setState(() {
                    _isHyperTension = !_isHyperTension;
                  });
                }),
            const SizedBox(height: 64.0),
          ],
        ),
      ),
      floatingActionButton: ElevatedButton(
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            var value = checkProduct();
            await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ResultScreen(result: value.toLowerCase()),
                ));
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.lightBlue,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 20),
        ),
        child: const Text('Check'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
