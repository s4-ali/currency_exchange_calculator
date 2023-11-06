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
                  const SizedBox(
                    height: 16,
                  ),
                  LabeledValue(label: "Exchange Rate", value: exchangeRate),
                  const Divider(),
                  LabeledValue(label: "Total USDT", value: totalUSDT),
                  const Divider(),
                  LabeledValue(label: "Total PKR", value: totalPKR),
                  const Divider(),
                  LabeledValue(label: "Profit", value: profit),
                  const SizedBox(
                    height: 48,
                  ),
                  TextField(
                    controller: usdtBuyingRateController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'USDT Buying Rate',
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  padding16,
                  TextField(
                    controller: usdtToPkrRateController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'USDT to PKR Rate',
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  TextField(
                    controller: foreignCurrencyController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Total Foreign Currency',
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  TextField(
                    controller: rateProvidedController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Rate Given to Customer',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool get totalForeignCurrencyProvided {
    final result = foreignCurrencyController.text.isNotEmpty &&
        foreignCurrencyController.text != "0";
    print(
        "totalForeignCurrencyProvided: $result => text.isNotEmpty: ${foreignCurrencyController.text.isNotEmpty} text != '0': ${foreignCurrencyController.text != '0'}");
    return result;
  }

  bool get rateGivenToCustomerProvided {
    final result = rateProvidedController.text.isNotEmpty &&
        rateProvidedController.text != "0";
    print(
        "rateGivenToCustomerProvided: $result => text.isNotEmpty: ${rateProvidedController.text.isNotEmpty} text != '0': ${rateProvidedController.text != '0'}");
    return result;
  }

  void onValuesUpdated() {
    try {
      final usdtBuyingPrice = double.parse(usdtBuyingRateController.text);
      final foreignPrice = 1 / usdtBuyingPrice;
      final totalForeign = double.parse(foreignCurrencyController.text);
      totalUSDT = totalForeign * foreignPrice;
      final usdtToPkr = double.parse(usdtToPkrRateController.text);
      totalPKR = totalUSDT * usdtToPkr;
      exchangeRate = usdtToPkr / usdtBuyingPrice;
      if (rateGivenToCustomerProvided) {
        final rateProvided = double.parse(rateProvidedController.text);
        profit = totalPKR - (totalForeign * rateProvided);
        print(profit);
      } else {
        print("rate not provided");
      }
    } catch (e) {
      print("calculation failed: $e");
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
