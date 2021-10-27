import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:neumo_caclulator/CalculatorButton.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:just_audio/just_audio.dart';


class CalculatorView extends StatefulWidget {

  static Color calculatorBackgroundColor = Color(0xff7f7f7f);
  static Color numbersTextColor = Color(0xff7f7f7f);
  static Color operatorsTextColor = Color(0xff7f7f7f);
  static Color shadowLightColor = Color(0xff7f7f7f);
  static Color shadowDarkColor = Color(0xff7f7f7f);
  static Color toastColor = Color(0xff7f7f7f);
  static Color toastTextColor = Color(0xff7f7f7f);

  @override
  _CalculatorViewState createState() {
    return _CalculatorViewState();
  }
}

class _CalculatorViewState extends State<CalculatorView> {
  
  int openParenthesis = 0;
  bool dotUsed = false;
  bool equalClicked = false;
  String lastExpression = '';
  String mathExpression = '';
  String currentNumber = '';

  // static const int EXCEPTION = -1;
  static const int IS_NUMBER = 0;
  static const int IS_OPERAND = 1;
  static const int IS_OPEN_PARENTHESIS = 2;
  static const int IS_CLOSE_PARENTHESIS = 3;
  static const int IS_DOT = 4;

  FToast toast = FToast();

  bool isDarkTheme = false;
  bool isSoundOn = false;
  late AudioPlayer player;
  final String CALCULTOR_THEME_KEY = "is_dark_theme";
  final String CLICK_SOUND_KEY = "is_sound_enabled";
  SvgPicture soundIcon = SvgPicture.asset('assets/images/sound_on.svg', width: 36, height: 36, color: CalculatorView.numbersTextColor);

  @override
  void initState() {
    super.initState();

    _applyCalculatorTheme();
    _applySoundSetting();
    toast.init(context);

    player = AudioPlayer();
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  bool isDeviceTablet() {
    double minWidth = MediaQueryData.fromWindow(WidgetsBinding.instance!.window).size.shortestSide;
    return minWidth > 550;
  }

  @override
  Widget build(BuildContext context) {

    final screenWidth = MediaQuery.of(context).size.width;
    double buttonSize = screenWidth / 5.4;
    double numbersTextSize = buttonSize / 2.4;
    double operatorsTextSize = buttonSize / 1.8;

    return Material(
      color: CalculatorView.calculatorBackgroundColor,
      child: SafeArea(
        child:
        isDeviceTablet()
            ?
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 0, 24),
          child: Center(
            child: Text('Sorry, this app is not yet supported for tablets.',
              style: TextStyle(fontSize: 24, color: CalculatorView.numbersTextColor),
            ),
          ),
        )
            :
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 0, 8, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 4, 6, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: soundIcon,
                      iconSize: 22,
                      color: CalculatorView.numbersTextColor,
                      onPressed:() {
                        _changeSoundSetting();
                        _applySoundSetting();
                      },
                    ),
                    SizedBox(
                      width: 6,
                    ),
                    IconButton(
                      icon: isDarkTheme ?
                      SvgPicture.asset('assets/images/light.svg', width: 30, height: 30, color: CalculatorView.numbersTextColor,) :
                      SvgPicture.asset('assets/images/dark.svg', width: 25, height: 25, color: CalculatorView.numbersTextColor,),
                      iconSize: 22,
                      color: CalculatorView.numbersTextColor,
                      onPressed:() {
                        _changeCalculatorTheme();
                        _applyCalculatorTheme();
                      },
                    ),
                  ],
                ),
              ),
              Spacer(),
              SizedBox(
                height: 100,
                child: FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 18),
                    child: Text(mathExpression, style: TextStyle(fontSize: 40, color: CalculatorView.numbersTextColor),),
                  ),
                ),
              ),
              CalculatorButtonRow(
                rowButtons: [
                  CalculatorButton(
                    size: buttonSize,
                    text: 'C',
                    textColor: CalculatorView.operatorsTextColor,
                    textSize: buttonSize / 2.4,
                    onPress:() {_handleClearClick();}
                  ),
                  CalculatorButton(
                    size: buttonSize,
                    text: 'DEL',
                    textColor: CalculatorView.operatorsTextColor,
                    textSize: buttonSize / 3.4,
                    onPress:() {_handleDeleteClick();},
                  ),
                  CalculatorButton(
                    size: buttonSize,
                    text: '%',
                    textColor: CalculatorView.operatorsTextColor,
                    textSize: buttonSize / 2.8,
                    onPress:() {_handleOperandsClick('%');},
                  ),
                  CalculatorButton(
                    size: buttonSize,
                    text: '÷',
                    textColor: CalculatorView.operatorsTextColor,
                    textSize: operatorsTextSize,
                    onPress:() {_handleOperandsClick('÷');},
                  ),
                ],
              ),
              CalculatorButtonRow(
                  rowButtons: [
                    CalculatorButton(
                      size: buttonSize,
                      text: '7',
                      textColor: CalculatorView.numbersTextColor,
                      textSize: numbersTextSize,
                      onPress:() {_handleNumbersClick('7');}),
                    CalculatorButton(
                      size: buttonSize,
                      text: '8',
                      textColor: CalculatorView.numbersTextColor,
                      textSize: numbersTextSize,
                      onPress:() {_handleNumbersClick('8');}),
                    CalculatorButton(
                      size: buttonSize,
                      text: '9',
                      textColor: CalculatorView.numbersTextColor,
                      textSize: numbersTextSize,
                      onPress:() {_handleNumbersClick('9');}),
                    CalculatorButton(
                      size: buttonSize,
                      text: '×',
                      textColor: CalculatorView.operatorsTextColor,
                      textSize: operatorsTextSize,
                      onPress:() {_handleOperandsClick('×');},
                    ),
                  ]
              ),
              CalculatorButtonRow(
                rowButtons: [
                  CalculatorButton(
                    size: buttonSize,
                    text: '4',
                    textColor: CalculatorView.numbersTextColor,
                    textSize: numbersTextSize,
                    onPress:() {_handleNumbersClick('4');}),
                  CalculatorButton(
                    size: buttonSize,
                    text: '5',
                    textColor: CalculatorView.numbersTextColor,
                    textSize: numbersTextSize,
                    onPress:() {_handleNumbersClick('5');}),
                  CalculatorButton(
                    size: buttonSize,
                    text: '6',
                    textColor: CalculatorView.numbersTextColor,
                    textSize: numbersTextSize,
                    onPress:() {_handleNumbersClick('6');}),
                  CalculatorButton(
                    size: buttonSize,
                    text: '-',
                    textColor: CalculatorView.operatorsTextColor,
                    textSize: operatorsTextSize,
                    onPress:() {_handleOperandsClick('-');},
                  ),
                ]
              ),
             CalculatorButtonRow(
                 rowButtons: [
                  CalculatorButton(
                    size: buttonSize,
                    text: '1',
                    textColor: CalculatorView.numbersTextColor,
                    textSize: numbersTextSize,
                    onPress:() {_handleNumbersClick('1');}),
                  CalculatorButton(
                    size: buttonSize,
                    text: '2',
                    textColor: CalculatorView.numbersTextColor,
                    textSize: numbersTextSize,
                    onPress:() {_handleNumbersClick('2');}),
                  CalculatorButton(
                    size: buttonSize,
                    text: '3',
                    textColor: CalculatorView.numbersTextColor,
                    textSize: numbersTextSize,
                    onPress:() {_handleNumbersClick('3');}),
                  CalculatorButton(
                    size: buttonSize,
                    text: '+',
                    textColor: CalculatorView.operatorsTextColor,
                    textSize: operatorsTextSize,
                    onPress:() {_handleOperandsClick('+');},
                  ),
                ]
              ),
             CalculatorButtonRow(
                rowButtons: [
                  CalculatorButton(
                    size: buttonSize,
                    text: '( )',
                    textColor: CalculatorView.numbersTextColor,
                    textSize: buttonSize / 3.4,
                    onPress:() {_handleBracketsClick();},),
                  CalculatorButton(
                    size: buttonSize,
                    text: '0',
                    textColor: CalculatorView.numbersTextColor,
                    textSize: numbersTextSize,
                    onPress:() {_handleNumbersClick('0');}),
                  CalculatorButton(
                    size: buttonSize,
                    text: '.',
                    textColor: CalculatorView.numbersTextColor,
                    textSize: numbersTextSize,
                    onPress:() {_handleDotClick();},),
                  CalculatorButton(
                    size: buttonSize,
                    text: '=',
                    textColor: CalculatorView.operatorsTextColor,
                    textSize: operatorsTextSize,
                    onPress:() {_handleEqualsClick();},
                  ),
                ]
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showToast(String message) {
    toast.removeCustomToast();
    toast.showToast(
      toastDuration: Duration(seconds: 1, milliseconds: 500),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: CalculatorView.toastColor,
        ),
        child: Text(message, style: TextStyle(color: CalculatorView.toastTextColor, fontSize: 16),),
      ),
    );
  }


  void _playClickSound() async {
    if (isSoundOn) {
      await player.setAsset('assets/audio/button_click.mp3');
      player.play();
    }
  }
  void _changeSoundSetting() async {
    isSoundOn = !isSoundOn;
    final preferences = await SharedPreferences.getInstance();
    preferences.setBool(CLICK_SOUND_KEY, isSoundOn);
  }
  void _applySoundSetting() async {
    final preferences = await SharedPreferences.getInstance();
    isSoundOn = preferences.getBool(CLICK_SOUND_KEY) ?? true;
    _playClickSound();
    setState(() {
      _updateSoundIcon();
    });
  }
  void _updateSoundIcon() {
    soundIcon = isSoundOn ?
    SvgPicture.asset('assets/images/sound_on.svg', width: 28, height: 28, color: CalculatorView.numbersTextColor,) :
    SvgPicture.asset('assets/images/sound_off.svg', width: 28, height: 28, color: CalculatorView.numbersTextColor,);
  }

  void _changeCalculatorTheme() async {
    isDarkTheme = !isDarkTheme;
    final preferences = await SharedPreferences.getInstance();
    preferences.setBool(CALCULTOR_THEME_KEY, isDarkTheme);
  }
  void _applyCalculatorTheme() async {
    final preferences = await SharedPreferences.getInstance();
    isDarkTheme = preferences.getBool(CALCULTOR_THEME_KEY) ?? false;
    setState(() {
      if (isDarkTheme) {
        CalculatorView.calculatorBackgroundColor = Color(0xff1e1e1e);
        CalculatorView.numbersTextColor = Colors.white;
        CalculatorView.operatorsTextColor = Color(0xff999999);
        CalculatorView.shadowLightColor = Color(0xff383838);
        CalculatorView.shadowDarkColor = Color(0xff020202);
        CalculatorView.toastColor = Color(0xffe0e0e0);
        CalculatorView.toastTextColor = Colors.black;
      }
      else { // light theme
        CalculatorView.calculatorBackgroundColor = Color(0xffe0e0e0);
        CalculatorView.numbersTextColor = Colors.black;
        CalculatorView.operatorsTextColor = Color(0xff7c7c7c);
        CalculatorView.shadowLightColor = Colors.white;
        CalculatorView.shadowDarkColor = Color(0xffb6b6b6);
        CalculatorView.toastColor = Color(0xff333333);
        CalculatorView.toastTextColor = Colors.white;
      }
      _updateSoundIcon();
    });
  }

  _handleNumbersClick(String buttonText) {
    if (addNumber(buttonText)) {
      equalClicked = false;
    }
    _playClickSound();
  }

  _handleOperandsClick(String operator) {
    if (addOperand(operator)) {
      equalClicked = false;
    }
    _playClickSound();
  }

  _handleDotClick() {
    if (addDot()) {
      equalClicked = false;
    }
    _playClickSound();
  }

  _handleBracketsClick() {
    if (addParenthesis()) {
      equalClicked = false;
    }
    _playClickSound();
  }

  _handleClearClick() {
    if (mathExpression.isNotEmpty) {
      setMathExpression('');
      openParenthesis = 0;
      dotUsed = false;
      equalClicked = false;
    }
    _playClickSound();
  }

  _handleDeleteClick() {
    if (currentNumber.isNotEmpty) {
      currentNumber = currentNumber.substring(0, currentNumber.length-1);
    }
    if (mathExpression.isNotEmpty) {
      setMathExpression(mathExpression.substring(0, mathExpression.length-1));
    }
    _playClickSound();
  }

  _handleEqualsClick() {
    if (mathExpression.isNotEmpty) {
      calculate(mathExpression);
    }
    _playClickSound();
  }


  setMathExpression(String expression) {
    setState(() {
      mathExpression = expression;
    });
  }

  bool addDot() {
    bool done = false;
    if (mathExpression.length == 0) {
      currentNumber = '0.';
      setMathExpression("0.");
      dotUsed = true;
      done = true;
    }
    else if (dotUsed) {
      // if dot is already used, don't use it again
      print('dot already used');
    }
    else if (defineLastCharacter(mathExpression[mathExpression.length - 1]) == IS_OPERAND) {
      currentNumber = '0.';
      setMathExpression(mathExpression + "0.");
      done = true;
      dotUsed = true;
    }
    else if (defineLastCharacter(mathExpression[mathExpression.length - 1]) == IS_NUMBER) {
      currentNumber += '.';
      setMathExpression(mathExpression + ".");
      done = true;
      dotUsed = true;
    }
    return done;
  }

  bool addParenthesis() {
    bool done = false;
    int operationLength = mathExpression.length;

    if (operationLength == 0) {
      setMathExpression(mathExpression + "(");
      dotUsed = false;
      openParenthesis++;
      done = true;
    }
    else if (openParenthesis > 0 && operationLength > 0) {
      String lastInput = mathExpression[operationLength - 1];
      int lastCharacter = defineLastCharacter(lastInput);

      switch (lastCharacter) {
        case IS_NUMBER:
          setMathExpression(mathExpression + ")");
          done = true;
          openParenthesis--;
          dotUsed = false;
          break;
        case IS_OPERAND:
          setMathExpression(mathExpression + "(");
          done = true;
          openParenthesis++;
          dotUsed = false;
          break;
        case IS_OPEN_PARENTHESIS:
          setMathExpression(mathExpression + "(");
          done = true;
          openParenthesis++;
          dotUsed = false;
          break;
        case IS_CLOSE_PARENTHESIS:
          setMathExpression(mathExpression + ")");
          done = true;
          openParenthesis--;
          dotUsed = false;
          break;
      }
    } else if (openParenthesis == 0 && operationLength > 0) {
      String lastInput = mathExpression[operationLength - 1];
      if (defineLastCharacter(lastInput) == IS_OPERAND) {
        setMathExpression(mathExpression + "(");
        done = true;
        dotUsed = false;
        openParenthesis++;
      } else {
        setMathExpression(mathExpression + "×(");
        done = true;
        dotUsed = false;
        openParenthesis++;
      }
    }
    return done;
  }

  bool addOperand(String operand) {
    bool done = false;
    int operationLength = mathExpression.length;
    if (operationLength > 0) {
      String lastInput = mathExpression[operationLength - 1];

      if ((lastInput == '+' || lastInput == '-' || lastInput == '÷' || lastInput == '×' || lastInput == '%')) {
        _showToast( "Wrong format");
      }
      else if (operand == "%" && defineLastCharacter(lastInput) == IS_NUMBER) {
        setMathExpression(mathExpression + operand);
        dotUsed = false;
        equalClicked = false;
        lastExpression = "";
        done = true;
      }
      else if (operand != "%") {
        setMathExpression(mathExpression + operand);
        dotUsed = false;
        equalClicked = false;
        lastExpression = "";
        done = true;
      }
    }
    return done;
  }

  bool addNumber(String number) {
    bool done = false;
    int operationLength = mathExpression.length;
    if (operationLength > 0) {
      String lastCharacter = mathExpression[operationLength - 1];
      int lastCharacterState = defineLastCharacter(lastCharacter);

      if (operationLength == 1 && lastCharacterState == IS_NUMBER && lastCharacter == "0") {
        currentNumber = number;
        setMathExpression(number);
        done = true;
      }
      else if (lastCharacterState == IS_OPEN_PARENTHESIS) {
        currentNumber = number;
        setMathExpression(mathExpression + number);
        done = true;
      }
      else if (lastCharacterState == IS_CLOSE_PARENTHESIS || lastCharacter == "%") {
        currentNumber = number;
        setMathExpression(mathExpression + "×"+number);
        done = true;
      }
      else if (lastCharacterState == IS_OPERAND || lastCharacterState == IS_DOT) {
        currentNumber = number;
        setMathExpression(mathExpression + number);
        done = true;
      }
      else if (lastCharacterState == IS_NUMBER) {
        if (currentNumber.length >= 15) {
          _showToast('Can\'t enter more than 15 digits.');
        } else {
          currentNumber += number;
          setMathExpression(mathExpression + number);
        }
        done = true;
        // setMathExpression(mathExpression + number);
        // done = true;
      }
    }
    else {
      currentNumber = number;
      setMathExpression(mathExpression + number);
      done = true;
    }
    return done;
  }

  void calculate(String input) {
    String result = "";
    try {
      String temp = input;
      if (equalClicked) {
        temp = input + lastExpression;
      } else {
        saveLastExpression(input);
      }
      String finalEquation = temp.replaceAll('×', '*').replaceAll('÷', '/').replaceAll('%', '/100').replaceAll(',', '');
      result = Parser().parse(finalEquation).evaluate(EvaluationType.REAL, ContextModel()).toString();
      equalClicked = true;
    }
    catch (_) {
      _showToast("Wrong Format");
      return;
    }

    if (result == "Infinity"){
      _showToast( "Can't divide by zero.");
    }
    else {
      if (result.endsWith('.0')) {
        result = result.substring(0, result.length-2);
      }
      if (result.contains('.')) {
        dotUsed = true;
      }
      currentNumber = result;
      setMathExpression(result);
    }
  }

  void saveLastExpression(String input) {
    String lastOfExpression = input[input.length - 1];
    if (input.length > 1) {
      if (lastOfExpression == ")") {
        lastExpression = ")";
        int numberOfCloseParenthesis = 1;
        for (int i = input.length - 2; i >= 0; i--) {
          if (numberOfCloseParenthesis > 0) {
            String last = input[i] + "";
            if (last == ")") {
              numberOfCloseParenthesis++;
            } else if (last == "(") {
              numberOfCloseParenthesis--;
            }
            lastExpression = last + lastExpression;
          } else if (defineLastCharacter(input[i] + "") == IS_OPERAND) {
            lastExpression = input[i] + lastExpression;
            break;
          } else {
            lastExpression = "";
          }
        }
      } else if (defineLastCharacter(lastOfExpression + "") == IS_NUMBER) {
        lastExpression = lastOfExpression;
        for (int i = input.length - 2; i >= 0; i--) {
          String last = input[i] + "";
          if (defineLastCharacter(last) == IS_NUMBER || defineLastCharacter(last) == IS_DOT) {
            lastExpression = last + lastExpression;
          } else if (defineLastCharacter(last) == IS_OPERAND) {
            lastExpression = last + lastExpression;
            break;
          }
          if (i == 0) {
            lastExpression = "";
          }
        }
      }
    }
  }

  int defineLastCharacter(String lastCharacter) {
    try {
      int.parse(lastCharacter);
      return IS_NUMBER;
    } catch (_){ }

    if ((lastCharacter == "+" || lastCharacter == "-" || lastCharacter == "×" ||
        lastCharacter == "\u00F7") || lastCharacter  == "%") {
      return IS_OPERAND;
    }
    if (lastCharacter == "(") {
      return IS_OPEN_PARENTHESIS;
    }
    if (lastCharacter == ")") {
      return IS_CLOSE_PARENTHESIS;
    }
    if (lastCharacter == ".") {
      return IS_DOT;
    }
    return -1;
  }

}


class CalculatorButtonRow extends StatelessWidget {

  final List<CalculatorButton> rowButtons;

  CalculatorButtonRow({
    required this.rowButtons
  });

  @override
  Widget build(BuildContext context) {

    final screenWidth = MediaQuery.of(context).size.width;
    final double calculatorRowPadding = ((screenWidth - 16 - (screenWidth * 0.8)) / 10);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: calculatorRowPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: rowButtons,
      ),
    );
  }
}