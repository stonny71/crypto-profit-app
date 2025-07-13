import 'package:flutter/material.dart';

void main() {
  runApp(CryptoProfitApp());
}

class CryptoProfitApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Crypto Spot Calculator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Color(0xFF121212),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Color(0xFF2a2a2a),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      home: ProfitCalculator(),
    );
  }
}

class ProfitCalculator extends StatefulWidget {
  @override
  _ProfitCalculatorState createState() => _ProfitCalculatorState();
}

class _ProfitCalculatorState extends State<ProfitCalculator> {
  final TextEditingController equityController = TextEditingController();
  final TextEditingController cpController = TextEditingController();
  final TextEditingController tpController = TextEditingController();

  double? coins, profit, total, roi;

  void calculate() {
    final double? equity = double.tryParse(equityController.text);
    final double? cp = double.tryParse(cpController.text);
    final double? tp = double.tryParse(tpController.text);

    if (equity != null && cp != null && tp != null && cp > 0) {
      final double _coins = equity / cp;
      final double _profit = _coins * (tp - cp);
      final double _total = equity + _profit;
      final double _roi = (_profit / equity) * 100;

      setState(() {
        coins = _coins;
        profit = _profit;
        total = _total;
        roi = _roi;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please enter valid numbers.'),
        backgroundColor: Colors.redAccent,
      ));
    }
  }

  Widget resultItem(String label, dynamic value) {
    return Text(
      "$label: ${value != null ? value.toStringAsFixed(2) : "--"}",
      style: TextStyle(color: Colors.limeAccent, fontSize: 16),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crypto Profit Calculator'),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            buildInput("Equity (\$)", equityController),
            buildInput("Current Price (CP)", cpController),
            buildInput("Take Profit Price (TP)", tpController),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.limeAccent,
                foregroundColor: Colors.black,
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: calculate,
              child: Text("CALCULATE", style: TextStyle(fontSize: 16)),
            ),
            SizedBox(height: 30),
            if (coins != null) ...[
              resultItem("🪙 Coins Bought", coins),
              resultItem("📈 Profit", profit),
              resultItem("💼 Total Return", total),
              resultItem("📊 ROI", roi),
            ]
          ],
        ),
      ),
    );
  }

  Widget buildInput(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.white70),
        ),
        style: TextStyle(color: Colors.limeAccent),
      ),
    );
  }
}
