import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

void main() {
  Stripe.publishableKey =
      "pk_test_51PZwiQAIcs9UKTF78L8N5hYWUfjaNPmrRgxV5OU3yifq2Ov782oc72fy7pht0pOCDwmwmeAaObEzU1onrwdPMIP600KxYzoggM";
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Map<String, dynamic>? paymentIntent;
  void makePayment() async {
    try {
      paymentIntent = await createPaymentIntent();
      var gpay = const PaymentSheetGooglePay(
          merchantCountryCode: "US", currencyCode: "USD", testEnv: true);

      await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
              paymentIntentClientSecret: paymentIntent!["client_secret"],
              style: ThemeMode.dark,
              merchantDisplayName: "Kunal",
              googlePay: gpay));

      displayPaymentSheet();
    } catch (e) {}
  }

  void displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet();
      print('done');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  createPaymentIntent() async {
    try {
      Map<String, dynamic> body = {
        "amount": "1000",
        "currency": "USD",
      };

      http.Response response = await http.post(
          Uri.parse('https://api.stripe.com/v1/payment_intents'),
          body: body,
          headers: {
            "Authorization":
                "Bearer sk_test_51PZwiQAIcs9UKTF7EPTKE9QUAGpdCbvsPLqkPF6jPGAkwNoC4xapSLI4BkUSqno1f2cK0B2iQelb4PdQQJFqPeXV00hT83F3kl",
            "Content-Type": "application/x-www-form-urlencoded"
          });
      return jsonDecode(response.body);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            makePayment();
          },
          child: const Text('Make Payment'),
        ),
      ),
    );
  }
}
