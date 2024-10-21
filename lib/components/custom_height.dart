import 'package:flutter/material.dart';
import './ruler_picker_lib.dart';

class HeightPicker extends StatefulWidget {
  final Function(int height) onChange;
  final int height;
  const HeightPicker({super.key, required this.height, required this.onChange});
  @override
  State<HeightPicker> createState() => _HeightPickerState();
}

class _HeightPickerState extends State<HeightPicker> {
  late double _currentHeight; // Height in inches (default is 5 feet 6 inches)

  String _getHeightInFeet() {
    return (_currentHeight ~/ 12).toString();
  }

  String _getHeightInInches() {
    return (_currentHeight % 12).round().toString();
  }

  @override
  void initState() {
    super.initState();
    _currentHeight = widget.height.toDouble();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.straighten,
              color: Color(0xff4b8aed),
            ),
            const SizedBox(width: 8),
            const Text(
              'Height',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            Text(
              _getHeightInFeet(),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const Text(
              'ft ',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            Text(
              _getHeightInInches(),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const Text(
              'in',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          height: 64,
          padding: const EdgeInsets.only(left: 16, right: 0),
          decoration: BoxDecoration(boxShadow: const [
            BoxShadow(
              color: Color(0xFFf6f6f6),
              blurRadius: 2,
              spreadRadius: 2,
            )
          ], color: Colors.white, borderRadius: BorderRadius.circular(6)),
          child: RulerPicker(
              height: 32,
              width: MediaQuery.of(context).size.width,
              minNumber: 48,
              maxNumber: 84,
              factor: 12,
              unitSize: 12,
              resistance: 1,
              acceleration: 1,
              callbackDouble: (data) {
                setState(() {
                  _currentHeight = data;
                  widget.onChange((data.round()).round());
                });
              },
              callbackInt: (data) {
                setState(() {
                  // _intData = data;
                });
              },
              initNumber: _currentHeight,
              longVerticalLineHeightRatio: 1,
              shortVerticalLineHeightRatio: .5,
              // selectedNumber: _doubleData,
              borderWidth: 1.5,
              pickedBarColor: const Color(0xff4b8aed),
              barColor: const Color(0xff4b8aed).withOpacity(0.3)),
        ),
      ],
    );
  }
}
