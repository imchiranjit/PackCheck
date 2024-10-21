import 'package:flutter/material.dart';
import './ruler_picker_lib.dart';

class WeightPicker extends StatefulWidget {
  final Function(int weight) onChange;
  final int weight;
  const WeightPicker({super.key, required this.weight, required this.onChange});
  @override
  State<WeightPicker> createState() => _WeightPickerState();
}

class _WeightPickerState extends State<WeightPicker> {
  late double _currentWeight;

  String _getWeight(double weight) {
    return '${weight.round()}';
  }

  @override
  void initState() {
    super.initState();
    _currentWeight = widget.weight.toDouble();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.scale,
              color: Color(0xff7e52e0),
            ),
            const SizedBox(width: 8),
            const Text(
              'Weight',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            Text(
              _getWeight(_currentWeight),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const Text(
              ' Kg',
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
              minNumber: 25,
              maxNumber: 150,
              factor: 1,
              unitSize: 5,
              resistance: 1,
              acceleration: 1,
              callbackDouble: (data) {
                setState(() {
                  _currentWeight = data;
                  widget.onChange(data.round());
                });
              },
              callbackInt: (data) {
                setState(() {
                  // _intData = data;
                });
              },
              initNumber: _currentWeight,
              longVerticalLineHeightRatio: 1,
              shortVerticalLineHeightRatio: .5,
              // selectedNumber: _doubleData,
              borderWidth: 1.5,
              pickedBarColor: const Color(0xff7e52e0),
              barColor: const Color(0xff7e52e0).withOpacity(0.3)),
        ),
      ],
    );
  }
}
