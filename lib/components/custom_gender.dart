import 'package:flutter/material.dart';
import 'package:pack_check/utils.dart';

class CustomGender extends StatelessWidget {
  final Gender selectedGender;
  final Function(Gender selectedGender) onSelection;
  const CustomGender(
      {Key? key, required this.selectedGender, required this.onSelection});

  @override
  Widget build(BuildContext context) {
    var decoration = BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withAlpha(50),
              blurRadius: 1,
              spreadRadius: 1,
              offset: const Offset(0, 1))
        ],
        border: Border.all(color: Colors.blue));
    return Center(
        child: Container(
            height: 68,
            width: 132,
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: const Color(0xFFf3ecfa),
              borderRadius: BorderRadius.circular(64),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  child: Container(
                    width: 64,
                    height: 64,
                    padding: const EdgeInsets.all(8),
                    decoration:
                        selectedGender == Gender.male ? decoration : null,
                    child: Image.asset('assets/images/male.png'),
                  ),
                  onTap: () => {onSelection(Gender.male)},
                ),
                GestureDetector(
                  child: Container(
                    width: 64,
                    height: 64,
                    padding: const EdgeInsets.all(8),
                    decoration:
                        selectedGender == Gender.female ? decoration : null,
                    child: Image.asset('assets/images/female.png'),
                  ),
                  onTap: () => {onSelection(Gender.female)},
                ),
              ],
            )));
  }
}
