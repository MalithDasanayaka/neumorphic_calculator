import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:neumo_caclulator/CalculatorView.dart';

class CalculatorButton extends StatefulWidget {

  double size;
  String text;
  Color? textColor;
  double textSize;
  Function onPress;

  CalculatorButton({
    required this.size,
    this.text = '',
    this.textColor,
    this.textSize = 33,
    required this.onPress,
  });

  /*NeumorphismButton({required double size, String text = '',
                    Color textColor = CalculatorView.numbersTextColor,
                    double textSize = 32, Function? onPress}) {
    this.size = size;
    this.text = text;
    this.textColor = textColor;
    this.textSize = textSize;
    this.onPress = onPress;
  }*/

  @override
  _CalculatorButtonState createState() => _CalculatorButtonState();
}

class _CalculatorButtonState extends State<CalculatorButton> {

  bool _isPressed = false;

  void _onPointerDown(PointerDownEvent event) {
    setState(() {
      _isPressed = true;
    });
  }

  void _onPointerUp(PointerUpEvent event) {
    setState(() {
      _isPressed = false;
      widget.onPress();
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return SizedBox(
      height: widget.size,
      width: widget.size,
      child: Listener(
        onPointerDown: _onPointerDown,
        onPointerUp: _onPointerUp,
        child: Stack(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 50),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(widget.size),
                color: CalculatorView.calculatorBackgroundColor,
                boxShadow: _isPressed ? showInnerShadow() : showShadow(),
              ),
            ),
            Align(
              alignment: Alignment(0,0),
              child: Text(widget.text, style: TextStyle(fontSize: widget.textSize, color: widget.textColor),),
            )
          ],
        ),
      ),
    );
  }
}


List<BoxShadow> showShadow() {
  return [
    BoxShadow(
      color: CalculatorView.shadowLightColor,
      blurRadius: 5,
      offset: -Offset(2, 2),
    ),
    BoxShadow(
      color: CalculatorView.shadowDarkColor,
      blurRadius: 5,
      offset: Offset(2, 2),
    ),
  ];
}

List<BoxShadow> showInnerShadow() {
  return [
    BoxShadow(
      blurRadius: 5,
      offset: Offset(2, 2),
      color: CalculatorView.shadowLightColor,
    ),
    BoxShadow(
      blurRadius: 5,
      offset: -Offset(2, 2),
      color: CalculatorView.shadowDarkColor,
    ),
  ];
}