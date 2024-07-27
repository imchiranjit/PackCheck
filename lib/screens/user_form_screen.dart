import 'package:flutter/material.dart';
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
  final TextEditingController _ageController = TextEditingController();
  String _selectedGender = 'Male';
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

    var age = int.parse(_ageController.value.text);

    if (age < 12) {
      params.add(product!.child);
    } else if (age < 24) {
      params.add(product!.young);
    } else if (age < 60) {
      params.add(product!.adult);
    } else {
      params.add(product!.old);
    }

    if (_selectedGender == 'Female') {
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
    if (res is String) {
      setState(() {
        barCode = res;
      });
      _searchProduct(res);
    }
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
                    backgroundColor: Colors.black,
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
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(product!.name),
        actions: [
          IconButton(
              onPressed: searchProduct,
              icon: const Icon(Icons.qr_code_scanner_rounded)),
          const SizedBox(width: 16.0)
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Age Input Field
              TextFormField(
                controller: _ageController,
                decoration:
                    const InputDecoration(labelText: 'Age', filled: false),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your age';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              // Gender Input Field
              DropdownButtonFormField<String>(
                value: _selectedGender,
                decoration: const InputDecoration(labelText: 'Gender'),
                items: <String>['Male', 'Female'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedGender = newValue!;
                  });
                },
              ),
              if (_selectedGender == 'Female')
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const SizedBox(height: 16.0),
                  // Pregnant Checkbox
                  CheckboxListTile(
                    title: const Text('Pregnant'),
                    value: _isPregnant,
                    onChanged: (bool? value) {
                      setState(() {
                        _isPregnant = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 16.0),
                  // Lactating Checkbox
                  CheckboxListTile(
                    title: const Text('Lactating'),
                    value: _isLactating,
                    onChanged: (bool? value) {
                      setState(() {
                        _isLactating = value!;
                      });
                    },
                  )
                ]),
              const SizedBox(height: 16.0),
              // Obese Checkbox
              CheckboxListTile(
                  title: const Text('Obese'),
                  value: _isObese,
                  onChanged: (bool? value) {
                    setState(() {
                      _isObese = value!;
                    });
                  }),
              const SizedBox(height: 16.0),
              // Diabetic Checkbox
              CheckboxListTile(
                title: const Text('Diabetic'),
                value: _isDiabetic,
                onChanged: (bool? value) {
                  setState(() {
                    _isDiabetic = value!;
                  });
                },
              ),
              const SizedBox(height: 16.0),
              // Hypertention
              CheckboxListTile(
                  title: const Text('Hypertention'),
                  value: _isHyperTension,
                  onChanged: (bool? value) {
                    setState(() {
                      _isHyperTension = value!;
                    });
                  }),
              const SizedBox(height: 24.0),
              // Submit Button
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    var value = checkProduct();
                    // Process data
                    // ScaffoldMessenger.of(context).showSnackBar(
                    //   SnackBar(content: Text(value)),
                    // );
                    await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ResultScreen(result: value.toLowerCase()),
                        ));
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 36, vertical: 18),
                ),
                child: const Text('Check'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
