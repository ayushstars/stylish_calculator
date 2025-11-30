import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(const StylishCalculatorApp());
}

class StylishCalculatorApp extends StatelessWidget {
  const StylishCalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stylish Calculator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        useMaterial3: true,
        colorScheme: const ColorScheme(
          brightness: Brightness.light,
          primary: Color(0xFFB274FF),
          onPrimary: Colors.white,
          secondary: Color(0xFFFFC1E3),
          onSecondary: Colors.black,
          error: Color(0xFFEF476F),
          onError: Colors.white,
          background: Color(0xFFFFF7FB),
          onBackground: Colors.black,
          surface: Colors.white,
          onSurface: Colors.black,
        ),
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
  String _expression = '';
  String _result = '0';

  void _handleInput(String value) {
    setState(() {
      if (value == 'AC') {
        _expression = '';
        _result = '0';
        return;
      }

      if (value == '+/-') {
        if (_expression.startsWith('-')) {
          _expression = _expression.substring(1);
        } else if (_expression.isNotEmpty) {
          _expression = '-$_expression';
        }
        return;
      }

      if (value == '%') {
        _applyPercentage();
        return;
      }

      if (value == '=') {
        _calculateResult();
        return;
      }

      if (value == '.') {
        final lastNumber = RegExp(r'[0-9]+\.?[0-9]*$').stringMatch(_expression) ?? '';
        if (lastNumber.contains('.')) return;
      }

      if (_expression.isEmpty && _isOperator(value)) return;
      _expression += value;
      if (!_isOperator(value) && value != '.') {
        _updateRealtimeResult();
      }
    });
  }

  bool _isOperator(String value) => value == '÷' || value == '×' || value == '−' || value == '+';

  bool _endsWithOperator(String value) => value.isNotEmpty && _isOperator(value[value.length - 1]);

  void _calculateResult() {
    if (_expression.isEmpty) return;

    final formatted = _formattedEvaluation(_expression);
    if (formatted != null) {
      _result = formatted;
      _expression = formatted;
    } else {
      _result = 'Error';
    }
  }

  void _applyPercentage() {
    if (_expression.isEmpty) return;

    final value = _evaluateRawExpression(_expression);
    if (value != null) {
      final formatted = _formatResult(value / 100);
      _result = formatted;
      _expression = formatted;
    } else {
      _result = 'Error';
    }
  }

  String _formatResult(num value) {
    if (value.isNaN || value.isInfinite) return 'Error';
    if (value == value.roundToDouble()) {
      return value.toInt().toString();
    }
    return value.toStringAsFixed(6).replaceFirst(RegExp(r'0+$'), '').replaceFirst(RegExp(r'\.$'), '');
  }

  String _prepareExpressionForEvaluation(String expression) {
    var trimmed = expression;
    while (trimmed.isNotEmpty && _isOperator(trimmed[trimmed.length - 1])) {
      trimmed = trimmed.substring(0, trimmed.length - 1);
    }
    if (trimmed.endsWith('.')) {
      trimmed = trimmed.substring(0, trimmed.length - 1);
    }
    return trimmed;
  }

  num? _evaluateRawExpression(String expression) {
    final prepared = _prepareExpressionForEvaluation(expression);
    if (prepared.isEmpty) return null;
    final normalized = prepared
        .replaceAll('×', '*')
        .replaceAll('÷', '/')
        .replaceAll('−', '-')
        .replaceAll('%', '/100');

    try {
      final parser = Parser();
      final parsed = parser.parse(normalized);
      final contextModel = ContextModel();
      return parsed.evaluate(EvaluationType.REAL, contextModel);
    } catch (_) {
      return null;
    }
  }

  String? _formattedEvaluation(String expression) {
    final value = _evaluateRawExpression(expression);
    if (value == null) return null;
    return _formatResult(value);
  }

  void _updateRealtimeResult() {
    if (_expression.isEmpty) {
      _result = '0';
      return;
    }
    if (_endsWithOperator(_expression)) return;
    final preview = _formattedEvaluation(_expression);
    if (preview != null) {
      _result = preview;
    }
  }

  LinearGradient _buttonGradient(String label) {
    const pinkGlow = [Color(0xFFFFD6EB), Color(0xFFFFB3D8)];
    const purpleGlow = [Color(0xFFCE9FFC), Color(0xFF7360FF)];
    const skyGlow = [Color(0xFF9EE5FF), Color(0xFF7ED2FF)];

    if (label == '=' || _isOperator(label)) {
      return const LinearGradient(colors: [Color(0xFFB18BFF), Color(0xFF8B6DFF)], begin: Alignment.topLeft, end: Alignment.bottomRight);
    }

    if (label == 'AC' || label == '+/-' || label == '%') {
      return const LinearGradient(colors: pinkGlow, begin: Alignment.topLeft, end: Alignment.bottomRight);
    }

    if (label == '.') {
      return const LinearGradient(colors: skyGlow, begin: Alignment.topLeft, end: Alignment.bottomRight);
    }

    return const LinearGradient(colors: purpleGlow, begin: Alignment.topLeft, end: Alignment.bottomRight);
  }

  Color _buttonGlowColor(String label) {
    if (label == '=' || _isOperator(label)) {
      return const Color(0x80F7A9FF);
    }
    if (label == 'AC' || label == '+/-' || label == '%') {
      return const Color(0x80FFD6EB);
    }
    if (label == '.') {
      return const Color(0x809EE5FF);
    }
    return const Color(0x80CE9FFC);
  }

  Color _textColor(String label) {
    if (label == '=' || _isOperator(label)) {
      return Colors.white;
    }
    return const Color(0xFF2A0831);
  }

  List<Widget> _buildButtonRows() {
    final actionRows = const [
      ['AC', '+/-', '%', '÷'],
      ['7', '8', '9', '×'],
      ['4', '5', '6', '−'],
      ['1', '2', '3', '+'],
    ];

    return actionRows
        .map(
          (row) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: row
                  .map(
                    (label) => Expanded(
                      child: CalculatorButton(
                        label: label,
                        gradient: _buttonGradient(label),
                        textColor: _textColor(label),
                        glowColor: _buttonGlowColor(label),
                        onTap: () => _handleInput(label),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final displayGradient = LinearGradient(
      colors: [
        Colors.pink.shade50.withOpacity(0.8),
        const Color(0xFFF5E6FF),
        Colors.purple.shade50.withOpacity(0.8),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFFF7FB), Color(0xFFEDE0FF), Color(0xFFDCC9FF)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Positioned(
            top: 60,
            right: -70,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Colors.pink.withOpacity(0.45),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 80,
            left: -60,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Colors.blue.withOpacity(0.35),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(36),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(24, 36, 24, 28),
                        decoration: BoxDecoration(
                          gradient: displayGradient,
                          borderRadius: BorderRadius.circular(36),
                          border: Border.all(color: Colors.white.withOpacity(0.35)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.purple.shade100.withOpacity(0.45),
                              blurRadius: 34,
                              offset: const Offset(0, 18),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              reverse: true,
                              physics: const BouncingScrollPhysics(),
                              child: Text(
                                _expression.isEmpty ? '0' : _expression,
                                style: TextStyle(
                                  color: Colors.grey.shade700,
                                  fontSize: 28,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              _result,
                              style: const TextStyle(
                                fontSize: 56,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF240046),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: Column(
                      children: [
                        ..._buildButtonRows(),
                        Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: CalculatorButton(
                                  label: '0',
                                  gradient: _buttonGradient('0'),
                                  textColor: _textColor('0'),
                                  glowColor: _buttonGlowColor('0'),
                                  onTap: () => _handleInput('0'),
                                ),
                              ),
                              Expanded(
                                child: CalculatorButton(
                                  label: '.',
                                  gradient: _buttonGradient('.'),
                                  textColor: _textColor('.'),
                                  glowColor: _buttonGlowColor('.'),
                                  onTap: () => _handleInput('.'),
                                ),
                              ),
                              Expanded(
                                child: CalculatorButton(
                                  label: '=',
                                  gradient: _buttonGradient('='),
                                  textColor: _textColor('='),
                                  glowColor: _buttonGlowColor('='),
                                  onTap: () => _handleInput('='),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Center(
                    child: Text(
                      'AYUSH STAR PRODUCTION',
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CalculatorButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  final LinearGradient gradient;
  final Color textColor;
  final Color glowColor;

  const CalculatorButton({
    super.key,
    required this.label,
    required this.onTap,
    required this.gradient,
    required this.textColor,
    required this.glowColor,
  });

  @override
  State<CalculatorButton> createState() => _CalculatorButtonState();
}

class _CalculatorButtonState extends State<CalculatorButton> {
  bool _isPressed = false;

  void _setPressed(bool value) {
    if (_isPressed == value) return;
    setState(() {
      _isPressed = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6),
      child: GestureDetector(
        onTap: widget.onTap,
        onTapDown: (_) => _setPressed(true),
        onTapUp: (_) => _setPressed(false),
        onTapCancel: () => _setPressed(false),
        child: AnimatedScale(
          scale: _isPressed ? 0.96 : 1,
          duration: const Duration(milliseconds: 130),
          curve: Curves.easeOut,
          child: Container(
            height: 78,
            decoration: BoxDecoration(
              gradient: widget.gradient,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: Colors.white.withOpacity(0.45), width: 1),
              boxShadow: [
                BoxShadow(
                  color: widget.glowColor,
                  blurRadius: 36,
                  spreadRadius: 2,
                  offset: const Offset(0, 18),
                ),
                BoxShadow(
                  color: widget.gradient.colors.last.withOpacity(0.45),
                  blurRadius: 24,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: Center(
              child: Text(
                widget.label,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w600,
                  color: widget.textColor,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

