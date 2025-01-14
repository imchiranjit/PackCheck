import 'package:flutter/material.dart';
import 'package:pack_check/components/custom_checkbox_card.dart';
import 'package:pack_check/components/custom_dob.dart';
import 'package:pack_check/components/custom_gender.dart';
import 'package:pack_check/components/custom_height.dart';
import 'package:pack_check/components/custom_weight.dart';
import 'package:pack_check/screens/search_screen.dart';
import 'package:pack_check/utils.dart';

class LoginScreen extends StatefulWidget {
  final bool pop;
  const LoginScreen({super.key, this.pop = false});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  DateTime dob = DateTime(2000, 1, 1);
  int height = 66;
  int weight = 50;
  Gender _selectedGender = Gender.male;
  bool _isPregnant = false;
  bool _isLactating = false;
  bool _isDiabetic = false;
  bool _isHyperTension = false;

  bool loading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      if (await UserPreferences.hasUser() == false) {
        setState(() {
          loading = false;
        });
        return;
      }
      final userData = await UserPreferences.getUser();
      setState(() {
        dob = userData.dob;
        height = userData.height;
        weight = userData.weight;
        _selectedGender = userData.gender;
        _isPregnant = userData.pregnant;
        _isLactating = userData.lactating;
        _isDiabetic = userData.diabetic;
        _isHyperTension = userData.hyperTension;
        loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loading
          ? Center(
              child: CircularProgressIndicator(
                color: Colors.lightBlue,
                backgroundColor: Colors.lightBlue.withOpacity(0.2),
              ),
            )
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(24.0),
                // crossAxisAlignment: CrossAxisAlignment.start,
                // mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 64,
                    width: 5,
                  ),
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
                  HeightPicker(
                    height: height,
                    onChange: (value) => {
                      setState(() {
                        height = value;
                      })
                    },
                  ),
                  const SizedBox(height: 16),
                  WeightPicker(
                    weight: weight,
                    onChange: (value) => {
                      setState(() {
                        weight = value;
                      })
                    },
                  ),
                  const SizedBox(height: 16),
                  DateOfBirthInput(
                    dob: dob,
                    onChange: (value) => {
                      setState(() {
                        dob = value;
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
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 16.0),
                          CustomCheckboxCard(
                              isSelected: _isPregnant,
                              icon: const AssetImage(
                                  'assets/images/pregnant.png'),
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
                              icon: const AssetImage(
                                  'assets/images/lactating.png'),
                              title: "Lactating",
                              subtitle:
                                  "Lactation is the process of milk production and secretion from the mammary glands of a mother after childbirth.",
                              onTap: () {
                                setState(() {
                                  _isLactating = !_isLactating;
                                });
                              }),
                        ]),
                  // const SizedBox(height: 16.0),
                  // CustomCheckboxCard(
                  //     isSelected: _isObese,
                  //     icon: const AssetImage('assets/images/obese.png'),
                  //     title: "Obese",
                  //     subtitle:
                  //         "A disorder involving excessive body fat that increases the risk of health problems.",
                  //     onTap: () {
                  //       setState(() {
                  //         _isObese = !_isObese;
                  //       });
                  //     }),
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
            await UserPreferences.setUser(UserData(
              dob: dob,
              height: height,
              weight: weight,
              gender: _selectedGender,
              pregnant: _isPregnant,
              lactating: _isLactating,
              diabetic: _isDiabetic,
              hyperTension: _isHyperTension,
            ));
            if (mounted) {
              if (widget.pop) {
                Navigator.of(context).pop();
              } else {
                await Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => const SearchScreen(),
                ));
              }
            }
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.lightBlue,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 18),
        ),
        child: const Text('Save'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
