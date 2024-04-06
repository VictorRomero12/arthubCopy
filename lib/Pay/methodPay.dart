// import 'package:flutter/material.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// void main()
// {
//   Stripe.publishableKey="pk_test_51P2MfhKWAbPpFyteEjguBmtO0NNRoolkxPh8jbVg1pCXXPEgEkTyhbo2NRpzKHOE4kCD9TbOnjTN82xubFWaBKHf00UMLw6t7b";
// }

// class MethodPay extends StatefulWidget {
//   const MethodPay({super.key});
  
  

//   @override
//   State<MethodPay> createState() => _MethodPayState();
// }

// class _MethodPayState extends State<MethodPay> {
//   Map<String, dynamic>? paymentIntent;

//   Future<Map<String, dynamic>> createPaymentIntent() async {
//     try {
//       Map<String, dynamic> body = {"amount": "100", "curreny": "USD"};

//       http.Response response = await http.post(
//         Uri.parse("https://api.stripe.com/v1/payment_intents"),
//         body: body,
//         headers: {
//           "Authorization":
//               "Bearer sk_test_51P2MfhKWAbPpFyteneueFltFg0PAtN9GH8eTlgLTzxoYBxhhT2cvGUu1a5UW6NBxa3Pp0u3swH75hdUCyKOxSBqQ00bxqrhd0n",
//           "Content-type": "application/x-www-form-urlencoded"
//         },
//       );

//       return json.decode(response.body);

//     } catch (e) {
//       throw Exception(e.toString());
//     }
//   }

//   void makePayment() async {
//     try {
//       paymentIntent = await createPaymentIntent();
//       var gpay = const PaymentSheetGooglePay(
//         merchantCountryCode: "US",
//         currencyCode: "US",
//         testEnv: true,
//       );
//       await Stripe.instance.initPaymentSheet(
//         paymentSheetParameters: SetupPaymentSheetParameters(
//           paymentIntentClientSecret: paymentIntent!["client_secret"],
//           style: ThemeMode.dark,
//           merchantDisplayName: "Sabir",
//           googlePay: gpay,
//         )
//       );

//       displayPaymentSheet();
//     } catch (e) {
//       print(e.toString());
//     }
//   }

//   void displayPaymentSheet() async {
//     try {
//       await Stripe.instance.presentPaymentSheet();
//       print("done");
//     } catch (e) {
//       print("failed");
//       print(e.toString());
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Example stripe"),
//       ),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: ()
//           {
//             makePayment();
//           }, // Usar makePayment para iniciar el proceso de pago
//           child: Text("Pay me"),
//         ),
//       ),
//     );
//   }
// }
