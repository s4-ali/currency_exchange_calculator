import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Currency Exchange Calculator',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Foreign To PKR'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController foreignCurrencyController =
      TextEditingController();
  final TextEditingController usdtBuyingRateController =
      TextEditingController();
  final TextEditingController usdtToPkrRateController = TextEditingController();
  final TextEditingController rateProvidedController = TextEditingController();

  double totalUSDT = 0;
  double totalPKR = 0;
  double exchangeRate = 0;
  double profit = 0;

  @override
  void initState() {
    foreignCurrencyController.text = "";
    usdtBuyingRateController.text = "";
    usdtToPkrRateController.text = "";
    rateProvidedController.text = "";

    foreignCurrencyController.addListener(onValuesUpdated);
    usdtBuyingRateController.addListener(onValuesUpdated);
    usdtToPkrRateController.addListener(onValuesUpdated);
    rateProvidedController.addListener(onValuesUpdated);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const padding16 = SizedBox(height: 16);
    const padding48 = SizedBox(height: 48);
    const keyboardType =
        TextInputType.numberWithOptions(decimal: true, signed: false);
    InputDecoration decoration(String label) {
      return InputDecoration(
        border: const OutlineInputBorder(),
        labelText: label,
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 500,
            minHeight: double.infinity,
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  padding16,
                  LabeledValue(label: "Exchange Rate", value: exchangeRate),
                  const Divider(),
                  LabeledValue(label: "Total USDT", value: totalUSDT),
                  const Divider(),
                  LabeledValue(label: "Total PKR", value: totalPKR),
                  const Divider(),
                  LabeledValue(label: "Profit", value: profit),
                  padding48,
                  TextField(
                    controller: usdtBuyingRateController,
                    keyboardType: keyboardType,
                    decoration: decoration('USDT Buying Rate'),
                  ),
                  TextField(
                    controller: usdtToPkrRateController,
                    keyboardType: keyboardType,
                    decoration: decoration('USDT to PKR Rate'),
                  ),
                  padding16,
                  TextField(
                    controller: foreignCurrencyController,
                    keyboardType: keyboardType,
                    decoration: decoration('Total Foreign Currency'),
                  ),
                  padding16,
                  TextField(
                    controller: rateProvidedController,
                    keyboardType: keyboardType,
                    decoration: decoration('Rate Given to Customer'),
                  ),
                  padding48,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void onValuesUpdated() {
    try {
      final usdtBuyingPrice =
          double.tryParse(usdtBuyingRateController.text) ?? 0;
      final foreignPrice = 1 / usdtBuyingPrice;
      final totalForeign = double.tryParse(foreignCurrencyController.text) ?? 0;
      totalUSDT = totalForeign * foreignPrice;

      final usdtToPkr = double.tryParse(usdtToPkrRateController.text) ?? 0;
      totalPKR = totalUSDT * usdtToPkr;
      exchangeRate = usdtToPkr / usdtBuyingPrice;

      final rateProvided = double.tryParse(rateProvidedController.text) ?? 0;
      profit = rateProvided == 0 ? 0 : totalPKR - (totalForeign * rateProvided);
    } catch (e) {
      //TODO: Handle this
    } finally {
      setState(() {});
    }
  }
}

class LabeledValue extends StatelessWidget {
  const LabeledValue({
    super.key,
    required this.label,
    required this.value,
  });

  final String label;
  final double value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const Spacer(),
        Text(
          value.toStringAsFixed(3),
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ],
    );
  }
}
