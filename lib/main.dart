import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stylish Calculator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFE8B4CB),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _display = '0';
  String _currentInput = '';
  String _operator = '';
  double _firstOperand = 0;
  bool _shouldResetDisplay = false;

  // Faded pastel colors for the stylish theme
  static const Color _backgroundStart = Color(0xFFF8E8F0);
  static const Color _backgroundEnd = Color(0xFFE8D4F0);
  static const Color _displayColor = Color(0xFFFAF0F5);
  static const Color _numberButtonColor = Color(0xFFF5E6EE);
  static const Color _operatorButtonColor = Color(0xFFE8D0E8);
  static const Color _specialButtonColor = Color(0xFFD8E8F8);
  static const Color _equalsButtonColor = Color(0xFFD0B8E0);
  static const Color _glowPink = Color(0xFFFFB6D9);
  static const Color _glowPurple = Color(0xFFD4A5E8);
  static const Color _glowSkyBlue = Color(0xFF87CEEB);
  static const Color _textColor = Color(0xFF6B4C7A);

  void _onButtonPressed(String value) {
    setState(() {
      switch (value) {
        case 'C':
          _clear();
          break;
        case '±':
          _toggleSign();
          break;
        case '%':
          _percentage();
          break;
        case '+':
        case '-':
        case '×':
        case '÷':
          _setOperator(value);
          break;
        case '=':
          _calculate();
          break;
        case '.':
          _addDecimal();
          break;
        default:
          _addDigit(value);
      }
    });
  }

  void _clear() {
    _display = '0';
    _currentInput = '';
    _operator = '';
    _firstOperand = 0;
    _shouldResetDisplay = false;
  }

  void _toggleSign() {
    if (_display != '0') {
      if (_display.startsWith('-')) {
        _display = _display.substring(1);
      } else {
        _display = '-$_display';
      }
      _currentInput = _display;
    }
  }

  void _percentage() {
    double value = double.tryParse(_display) ?? 0;
    value = value / 100;
    _display = _formatResult(value);
    _currentInput = _display;
  }

  void _setOperator(String op) {
    _firstOperand = double.tryParse(_display) ?? 0;
    _operator = op;
    _shouldResetDisplay = true;
  }

  void _calculate() {
    if (_operator.isEmpty) return;
    
    double secondOperand = double.tryParse(_display) ?? 0;
    double result = 0;

    switch (_operator) {
      case '+':
        result = _firstOperand + secondOperand;
        break;
      case '-':
        result = _firstOperand - secondOperand;
        break;
      case '×':
        result = _firstOperand * secondOperand;
        break;
      case '÷':
        if (secondOperand != 0) {
          result = _firstOperand / secondOperand;
        } else {
          _display = 'Error';
          _currentInput = '';
          _operator = '';
          return;
        }
        break;
    }

    _display = _formatResult(result);
    _currentInput = '';
    _operator = '';
    _shouldResetDisplay = true;
  }

  String _formatResult(double value) {
    if (value == value.toInt()) {
      return value.toInt().toString();
    }
    String result = value.toStringAsFixed(8);
    result = result.replaceAll(RegExp(r'0+$'), '');
    result = result.replaceAll(RegExp(r'\.$'), '');
    return result;
  }

  void _addDecimal() {
    if (_shouldResetDisplay) {
      _display = '0.';
      _currentInput = '0.';
      _shouldResetDisplay = false;
    } else if (!_display.contains('.')) {
      _display = '$_display.';
      _currentInput = _display;
    }
  }

  void _addDigit(String digit) {
    if (_shouldResetDisplay) {
      _display = digit;
      _currentInput = digit;
      _shouldResetDisplay = false;
    } else {
      if (_display == '0' && digit != '0') {
        _display = digit;
      } else if (_display != '0') {
        _display = '$_display$digit';
      }
      _currentInput = _display;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [_backgroundStart, _backgroundEnd],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                flex: 2,
                child: _buildDisplay(),
              ),
              Expanded(
                flex: 5,
                child: _buildButtonGrid(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDisplay() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: _displayColor.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: _glowPurple.withValues(alpha: 0.3),
            blurRadius: 20,
            spreadRadius: 2,
          ),
          BoxShadow(
            color: _glowPink.withValues(alpha: 0.2),
            blurRadius: 30,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (_operator.isNotEmpty)
            Text(
              '${_formatResult(_firstOperand)} $_operator',
              style: TextStyle(
                fontSize: 20,
                color: _textColor.withValues(alpha: 0.6),
                fontWeight: FontWeight.w300,
              ),
            ),
          const SizedBox(height: 8),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerRight,
            child: Text(
              _display,
              style: const TextStyle(
                fontSize: 56,
                fontWeight: FontWeight.w300,
                color: _textColor,
                letterSpacing: 2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButtonGrid() {
    final List<List<String>> buttons = [
      ['C', '±', '%', '÷'],
      ['7', '8', '9', '×'],
      ['4', '5', '6', '-'],
      ['1', '2', '3', '+'],
      ['0', '.', '='],
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: buttons.map((row) {
          return Expanded(
            child: Row(
              children: row.map((buttonText) {
                bool isOperator = ['÷', '×', '-', '+'].contains(buttonText);
                bool isSpecial = ['C', '±', '%'].contains(buttonText);
                bool isEquals = buttonText == '=';
                bool isZero = buttonText == '0';

                Color buttonColor;
                Color glowColor;

                if (isEquals) {
                  buttonColor = _equalsButtonColor;
                  glowColor = _glowPurple;
                } else if (isOperator) {
                  buttonColor = _operatorButtonColor;
                  glowColor = _glowPink;
                } else if (isSpecial) {
                  buttonColor = _specialButtonColor;
                  glowColor = _glowSkyBlue;
                } else {
                  buttonColor = _numberButtonColor;
                  glowColor = _glowPink.withValues(alpha: 0.7);
                }

                return Expanded(
                  flex: isZero ? 2 : 1,
                  child: _buildButton(
                    buttonText,
                    buttonColor,
                    glowColor,
                    isZero: isZero,
                  ),
                );
              }).toList(),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildButton(
    String text,
    Color backgroundColor,
    Color glowColor, {
    bool isZero = false,
  }) {
    return Container(
      margin: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: glowColor.withValues(alpha: 0.4),
            blurRadius: 12,
            spreadRadius: 1,
          ),
          BoxShadow(
            color: glowColor.withValues(alpha: 0.2),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Material(
        color: backgroundColor.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: () => _onButtonPressed(text),
          borderRadius: BorderRadius.circular(20),
          splashColor: glowColor.withValues(alpha: 0.3),
          highlightColor: glowColor.withValues(alpha: 0.1),
          child: Container(
            alignment: isZero ? Alignment.centerLeft : Alignment.center,
            padding: isZero ? const EdgeInsets.only(left: 32) : null,
            child: Text(
              text,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w500,
                color: _textColor,
                shadows: [
                  Shadow(
                    color: glowColor.withValues(alpha: 0.5),
                    blurRadius: 8,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
