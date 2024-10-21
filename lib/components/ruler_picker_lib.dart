import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class RulerPicker extends StatefulWidget {
  final double initNumber;
  final Function(double) callbackDouble;
  final Function(int)? callbackInt;
  final int? maxNumber;
  final int? minNumber;

  final int factor;
  final int unitSize;

  final double resistance;
  final double acceleration;

  final double width;
  final double height;
  final double borderWidth;
  final Color pickedBarColor;
  final Color barColor;

  final double longVerticalLineHeightRatio;
  final double shortVerticalLineHeightRatio;

  const RulerPicker({
    super.key,
    required this.callbackDouble,
    this.callbackInt,
    required this.initNumber,
    required this.width,
    required this.height,
    required this.borderWidth,
    required this.pickedBarColor,
    required this.barColor,
    required this.longVerticalLineHeightRatio,
    required this.shortVerticalLineHeightRatio,
    this.resistance = 1,
    this.acceleration = 1,
    this.maxNumber,
    this.minNumber,
    this.factor = 1,
    this.unitSize = 1,
  });

  @override
  State<StatefulWidget> createState() => _RulerPickerState();
}

class _RulerPickerState extends State<RulerPicker> {
  double get resistance => 0.99 / widget.resistance;
  double get acceleration => 0.0002 * widget.acceleration;
  double get rulerBetweenAlignWidth => 0.071;

  Timer? timer;
  late int prev;
  late double selectedNumber;

  int? get maxNumber => widget.maxNumber;
  int? get minNumber => widget.minNumber;
  double get height => widget.height;
  double get longVerticalLineHeight =>
      widget.height * widget.longVerticalLineHeightRatio;
  double get shortVerticalLineHeight =>
      widget.height * widget.shortVerticalLineHeightRatio;
  double get borderWidth => widget.borderWidth;
  Color get pickedBarColor => widget.pickedBarColor;
  Color get barColor => widget.barColor;
  int get verticalLineCount => (1 ~/ rulerBetweenAlignWidth) + 1;

  @override
  void initState() {
    prev = widget.initNumber.floor();
    selectedNumber = widget.initNumber;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> rulerLines = [];

    for (int index = 0; index < verticalLineCount; index++) {
      if (maxNumber == null) {
        rulerLines.add(_RulerVerticalLine(
          standardNumber: selectedNumber,
          myNumber: selectedNumber + index,
          width: borderWidth,
          longVerticalLineHeight: longVerticalLineHeight,
          shortVerticalLineHeight: shortVerticalLineHeight,
          color: barColor,
          pickedColor: pickedBarColor,
          rulerBetweenAlignWidth: rulerBetweenAlignWidth,
          factor: widget.factor,
          unitSize: widget.unitSize,
        ));
      } else if ((selectedNumber + index) >= maxNumber!) {
        double maxDouble = maxNumber!.toDouble();
        rulerLines.add(_RulerVerticalLine(
            standardNumber: selectedNumber,
            myNumber: maxDouble,
            width: borderWidth,
            longVerticalLineHeight: longVerticalLineHeight,
            shortVerticalLineHeight: shortVerticalLineHeight,
            color: barColor,
            pickedColor: pickedBarColor,
            rulerBetweenAlignWidth: rulerBetweenAlignWidth,
            factor: widget.factor,
            unitSize: widget.unitSize));
        break;
      } else {
        rulerLines.add(_RulerVerticalLine(
            standardNumber: selectedNumber,
            myNumber: selectedNumber + index,
            width: borderWidth,
            longVerticalLineHeight: longVerticalLineHeight,
            shortVerticalLineHeight: shortVerticalLineHeight,
            color: barColor,
            pickedColor: pickedBarColor,
            rulerBetweenAlignWidth: rulerBetweenAlignWidth,
            factor: widget.factor,
            unitSize: widget.unitSize));
      }
    }

    for (int index = -1; index > -verticalLineCount; index--) {
      if (minNumber == null) {
        rulerLines.add(_RulerVerticalLine(
          standardNumber: selectedNumber,
          myNumber: selectedNumber + index,
          width: borderWidth,
          longVerticalLineHeight: longVerticalLineHeight,
          shortVerticalLineHeight: shortVerticalLineHeight,
          color: barColor,
          pickedColor: pickedBarColor,
          rulerBetweenAlignWidth: rulerBetweenAlignWidth,
          factor: widget.factor,
          unitSize: widget.unitSize,
        ));
      } else if ((selectedNumber + index) < minNumber!) {
        double minDouble = minNumber!.toDouble();
        rulerLines.add(_RulerVerticalLine(
          standardNumber: selectedNumber,
          myNumber: minDouble,
          width: borderWidth,
          longVerticalLineHeight: longVerticalLineHeight,
          shortVerticalLineHeight: shortVerticalLineHeight,
          color: barColor,
          pickedColor: pickedBarColor,
          rulerBetweenAlignWidth: rulerBetweenAlignWidth,
          factor: widget.factor,
          unitSize: widget.unitSize,
        ));
        break;
      } else {
        rulerLines.add(_RulerVerticalLine(
          standardNumber: selectedNumber,
          myNumber: selectedNumber + index,
          width: borderWidth,
          longVerticalLineHeight: longVerticalLineHeight,
          shortVerticalLineHeight: shortVerticalLineHeight,
          color: barColor,
          pickedColor: pickedBarColor,
          rulerBetweenAlignWidth: rulerBetweenAlignWidth,
          factor: widget.factor,
          unitSize: widget.unitSize,
        ));
      }
    }

    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onHorizontalDragDown: (details) {
          timer?.cancel();
          timer = null;
        },
        onHorizontalDragEnd: (details) {
          shootDrag(details);
        },
        onHorizontalDragUpdate: (details) {
          updateDrag(details);
        },
        child: SizedBox(
          width: double.infinity,
          child: Stack(children: rulerLines),
        ),
      ),
    );
  }

  void updateDrag(details) {
    setState(() {
      double delta = details.delta.dx;

      _moveRulerPicker(delta);
      _limitMaxNumber();
      _limitMinNumber();
    });

    _vibratingOnIntegerValue();

    widget.callbackDouble(selectedNumber);
    widget.callbackInt == null
        ? null
        : widget.callbackInt!(selectedNumber.floor());
  }

  void shootDrag(details) {
    double velocity = (details.primaryVelocity ?? 0) * acceleration;

    timer = Timer.periodic(const Duration(milliseconds: 10), (Timer timer) {
      velocity = velocity * resistance;
      setState(() {
        selectedNumber -= (velocity);
        _limitMaxNumber();
        _limitMinNumber();

        widget.callbackDouble(selectedNumber);
        widget.callbackInt == null
            ? null
            : widget.callbackInt!(selectedNumber.floor());
      });

      _vibratingOnIntegerValue();

      if (velocity.abs() < 0.1) {
        this.timer?.cancel();
        this.timer = null;
      }
    });
  }

  void _moveRulerPicker(double delta) {
    if (delta > 5) {
      selectedNumber -= 5 * 0.2;
    } else if (delta < -5) {
      selectedNumber -= -5 * 0.2;
    } else {
      selectedNumber -= delta * 0.2;
    }
  }

  void _limitMaxNumber() {
    if (maxNumber == null) {
    } else if ((selectedNumber) >= maxNumber!) {
      selectedNumber = maxNumber!.toDouble();
    }
  }

  void _limitMinNumber() {
    if (minNumber == null) {
    } else if ((selectedNumber) <= minNumber!) {
      selectedNumber = minNumber!.toDouble();
    }
  }

  void _vibratingOnIntegerValue() {
    if ((selectedNumber.floor() - prev).abs() >= 0.5) {
      HapticFeedback.selectionClick();
      prev = selectedNumber.floor();
    }
  }
}

class _RulerAlignedLongVerticalLine extends StatelessWidget {
  final double standardNumber;
  final int myNumber;
  final double alignX;

  final double height;
  final double width;
  final Color pickedColor;
  final Color color;

  final int factor;

  double get _diff => (standardNumber - myNumber).abs();
  bool get _widgetStandard => (_diff < 0.5);

  const _RulerAlignedLongVerticalLine(
      {required this.standardNumber,
      required this.myNumber,
      required this.height,
      required this.width,
      required this.color,
      required this.pickedColor,
      required this.alignX,
      required this.factor});

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Align(
          alignment: Alignment(alignX, -1),
          child: _widgetStandard
              ? _VerticalLine(
                  height: height, width: width * 1.2, color: pickedColor)
              : _VerticalLine(height: height, width: width, color: color)),
      Align(
        alignment: Alignment(alignX, .5),
        child: Text(
          (myNumber ~/ factor).toString(),
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            height: 0.17,
          ),
        ),
      ),
    ]);
  }
}

class _RulerAlignedShortVerticalLine extends StatelessWidget {
  final double standardNumber;
  final int myNumber;
  final double alignX;

  final double height;
  final double width;
  final Color pickedColor;
  final Color color;

  double get _diff => (standardNumber - myNumber);
  bool get _widgetStandard =>
      (myNumber % 5 == 1 && standardNumber - myNumber < 0)
          ? (_diff < 0.5 && _diff >= -0.5)
          : (_diff <= 0.5 && _diff > -0.5);

  const _RulerAlignedShortVerticalLine(
      {required this.standardNumber,
      required this.myNumber,
      required this.width,
      required this.height,
      required this.color,
      required this.pickedColor,
      required this.alignX});

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment(alignX, -1),
        child: _widgetStandard
            ? _VerticalLine(
                width: width * 1.2,
                height: height * 1.46,
                color: pickedColor,
              )
            : _VerticalLine(
                width: width,
                height: height,
                color: color,
              ));
  }
}

class _RulerVerticalLine extends StatelessWidget {
  final double standardNumber;
  final double myNumber;

  final double longVerticalLineHeight;
  final double shortVerticalLineHeight;

  final double width;
  final Color pickedColor;
  final Color color;
  final double rulerBetweenAlignWidth;

  final int factor;
  final int unitSize;

  int get verticalLineNumber => myNumber.floor();
  double get alignX =>
      (verticalLineNumber - standardNumber) * rulerBetweenAlignWidth;

  const _RulerVerticalLine({
    required this.standardNumber,
    required this.myNumber,
    required this.width,
    required this.longVerticalLineHeight,
    required this.shortVerticalLineHeight,
    required this.color,
    required this.pickedColor,
    required this.rulerBetweenAlignWidth,
    required this.factor,
    required this.unitSize,
  });

  @override
  Widget build(BuildContext context) {
    if (myNumber.floor() % unitSize == 0) {
      return _RulerAlignedLongVerticalLine(
        standardNumber: standardNumber,
        myNumber: verticalLineNumber,
        width: width,
        height: longVerticalLineHeight,
        color: color,
        pickedColor: pickedColor,
        alignX: alignX,
        factor: factor,
      );
    } else {
      return _RulerAlignedShortVerticalLine(
        standardNumber: standardNumber,
        myNumber: verticalLineNumber,
        width: width,
        height: shortVerticalLineHeight,
        color: color,
        pickedColor: pickedColor,
        alignX: alignX,
      );
    }
  }
}

class _VerticalLine extends StatelessWidget {
  final double height;
  final double width;
  final Color color;

  const _VerticalLine(
      {required this.height, required this.width, required this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: VerticalDivider(
        width: width,
        thickness: width,
        color: color,
      ),
    );
  }
}
