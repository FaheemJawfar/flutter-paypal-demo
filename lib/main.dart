import 'package:flutter/material.dart';
import 'package:flutter_paypal/flutter_paypal.dart';
import 'app_config.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter PayPal Demo'),
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

    final amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),

      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: amountController,
                decoration: const InputDecoration(
                  label: Text('Amount'),
                ),
                keyboardType: TextInputType.number,
              ),

              ElevatedButton(onPressed: () {
                makePaypalPayment();
              }, child: const Text('Pay with PayPal'))
            ],
          ),
        ),
      )

    );
  }


  makePaypalPayment(){
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => UsePaypal(
            sandboxMode: true,
            clientId:
            AppConfig.paypalClientId, //Replace with your client ID here
            secretKey:
            AppConfig.paypalSecretKey, //Replace with your PayPal secret key here
            returnURL: "https://samplesite.com/return",
            cancelURL: "https://samplesite.com/cancel",
            transactions:  [
              {
                "amount": {
                  "total": '${amountController.text}.00',
                  "currency": "USD",
                  "details": {
                    "subtotal": '${amountController.text}.00',
                    "shipping": '0',
                    "shipping_discount": 0
                  }
                },
                "description":
                "The payment transaction description.",

                "item_list": {
                  "items": [
                    {
                      "name": "A demo product",
                      "quantity": 1,
                      "price": '${amountController.text}.00',
                      "currency": "USD"
                    }
                  ],

                }
              }
            ],
            note:
            "Contact us for any questions on your order.",
            onSuccess: (Map params) async {

              // ignore: avoid_print
              print('Payment completed successfully!');


              // ignore: avoid_print
              print("onSuccess: $params");
            },
            onError: (error) {
              // ignore: avoid_print
              print("onError: $error");
            },
            onCancel: (params) {
              // ignore: avoid_print
              print('cancelled: $params');
            }),
      ),
    );
  }
}
