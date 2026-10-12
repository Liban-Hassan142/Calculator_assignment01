import 'package:flutter/material.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatefulWidget {
  const CalculatorApp({super.key});

  @override
  State<CalculatorApp> createState() => _CalculatorAppState();
}

class _CalculatorAppState extends State<CalculatorApp> {
  bool isDark = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF7F8FC),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF151821),
      ),
      home: CalculatorPage(
        isDark: isDark,
        onThemeToggle: () {
          setState(() {
            isDark = !isDark;
          });
        },
      ),
    );
  }
}

class CalculatorPage extends StatefulWidget {
  final bool isDark;
  final VoidCallback onThemeToggle;

  const CalculatorPage({
    super.key,
    required this.isDark,
    required this.onThemeToggle,
  });

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  String display = "0";

  double accumulator = 0;
  String pendingOperator = "";

  bool awaitingOperand = false;
  bool resultDisplayed = false;

  void onDigitPressed(String digit) {
    setState(() {
      if (resultDisplayed) {
        display = digit;
        accumulator = 0;
        pendingOperator = "";
        awaitingOperand = false;
        resultDisplayed = false;
        return;
      }

      if (awaitingOperand) {
        display = digit;
        awaitingOperand = false;
        return;
      }

      if (display == "0") {
        display = digit;
      } else {
        display += digit;
      }
    });
  }

  double calculate(double left, double right, String op) {
    switch (op) {
      case "+":
        return left + right;

      case "-":
        return left - right;

      case "×":
        return left * right;

      case "÷":
        return left / right;

      default:
        return right;
    }
  }

  void onOperatorPressed(String op) {
    setState(() {
      double value = double.tryParse(display) ?? 0;

      if (awaitingOperand) {
        pendingOperator = op;
        return;
      }

      if (pendingOperator.isEmpty) {
        accumulator = value;
        pendingOperator = op;
        awaitingOperand = true;
        return;
      }

      accumulator = calculate(accumulator, value, pendingOperator);

      display = formatNumber(accumulator);

      pendingOperator = op;
      awaitingOperand = true;
    });
  }

  void onEqualsPressed() {
    setState(() {
      if (awaitingOperand || pendingOperator.isEmpty) {
        return;
      }

      double value = double.tryParse(display) ?? 0;

      accumulator = calculate(accumulator, value, pendingOperator);

      display = formatNumber(accumulator);

      pendingOperator = "";
      awaitingOperand = false;
      resultDisplayed = true;
    });
  }

  void clearAll() {
    setState(() {
      display = "0";
      accumulator = 0;
      pendingOperator = "";
      awaitingOperand = false;
      resultDisplayed = false;
    });
  }

  void toggleSign() {
    setState(() {
      double value = double.tryParse(display) ?? 0;

      value *= -1;

      display = formatNumber(value);
    });
  }

  void applyPercent() {
    setState(() {
      double value = double.tryParse(display) ?? 0;

      value /= 100;

      display = formatNumber(value);
    });
  }

  String formatNumber(double value) {
    if (value == value.toInt()) {
      return value.toInt().toString();
    }

    return value.toStringAsFixed(2);
  }

  Widget buildButton(String text, {Color? color, VoidCallback? onTap}) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: AnimatedCalculatorButton(text: text, color: color, onTap: onTap),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool dark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Calculator State Lab"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: widget.onThemeToggle,
            icon: Icon(widget.isDark ? Icons.light_mode : Icons.dark_mode),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Container(
                alignment: Alignment.bottomRight,
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 20,
                ),
                child: Text(
                  display,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 52,
                    fontWeight: FontWeight.w300,
                    color: dark ? Colors.white : Colors.black,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: GridView.count(
                crossAxisCount: 4,
                childAspectRatio: 1.15,
                padding: const EdgeInsets.all(10),
                children: [
                  buildButton(
                    "AC",
                    color: Colors.red.shade300,
                    onTap: clearAll,
                  ),

                  buildButton(
                    "±",
                    color: Colors.cyan.shade300,
                    onTap: toggleSign,
                  ),

                  buildButton(
                    "%",
                    color: Colors.cyan.shade300,
                    onTap: applyPercent,
                  ),

                  buildButton(
                    "÷",
                    color: Colors.orange.shade300,
                    onTap: () => onOperatorPressed("÷"),
                  ),

                  buildButton(
                    "7",
                    color: Colors.indigo.shade100,
                    onTap: () => onDigitPressed("7"),
                  ),

                  buildButton(
                    "8",
                    color: Colors.indigo.shade100,
                    onTap: () => onDigitPressed("8"),
                  ),

                  buildButton(
                    "9",
                    color: Colors.indigo.shade100,
                    onTap: () => onDigitPressed("9"),
                  ),

                  buildButton(
                    "×",
                    color: Colors.orange.shade300,
                    onTap: () => onOperatorPressed("×"),
                  ),

                  buildButton(
                    "4",
                    color: Colors.indigo.shade100,
                    onTap: () => onDigitPressed("4"),
                  ),

                  buildButton(
                    "5",
                    color: Colors.indigo.shade100,
                    onTap: () => onDigitPressed("5"),
                  ),

                  buildButton(
                    "6",
                    color: Colors.indigo.shade100,
                    onTap: () => onDigitPressed("6"),
                  ),

                  buildButton(
                    "-",
                    color: Colors.orange.shade300,
                    onTap: () => onOperatorPressed("-"),
                  ),

                  buildButton(
                    "1",
                    color: Colors.indigo.shade100,
                    onTap: () => onDigitPressed("1"),
                  ),

                  buildButton(
                    "2",
                    color: Colors.indigo.shade100,
                    onTap: () => onDigitPressed("2"),
                  ),

                  buildButton(
                    "3",
                    color: Colors.indigo.shade100,
                    onTap: () => onDigitPressed("3"),
                  ),

                  buildButton(
                    "+",
                    color: Colors.orange.shade300,
                    onTap: () => onOperatorPressed("+"),
                  ),

                  buildButton(
                    "0",
                    color: Colors.indigo.shade100,
                    onTap: () => onDigitPressed("0"),
                  ),

                  const SizedBox(),

                  buildButton(
                    "=",
                    color: Colors.green.shade400,
                    onTap: onEqualsPressed,
                  ),

                  const SizedBox(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AnimatedCalculatorButton extends StatefulWidget {
  final String text;
  final Color? color;
  final VoidCallback? onTap;

  const AnimatedCalculatorButton({
    super.key,
    required this.text,
    this.color,
    this.onTap,
  });

  @override
  State<AnimatedCalculatorButton> createState() =>
      _AnimatedCalculatorButtonState();
}

class _AnimatedCalculatorButtonState extends State<AnimatedCalculatorButton> {
  double scale = 1.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          scale = 0.90;
        });
      },
      onTapUp: (_) {
        setState(() {
          scale = 1.0;
        });

        widget.onTap?.call();
      },
      onTapCancel: () {
        setState(() {
          scale = 1.0;
        });
      },
      child: AnimatedScale(
        duration: const Duration(milliseconds: 120),
        scale: scale,
        child: Container(
          decoration: BoxDecoration(
            color: widget.color,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Center(
            child: Text(
              widget.text,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
