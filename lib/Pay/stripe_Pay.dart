

// import 'package:http/http.dart' as http;

// class StripeService
// {
//   String secretKey = "sk_test_51P2MfhKWAbPpFyteneueFltFg0PAtN9GH8eTlgLTzxoYBxhhT2cvGUu1a5UW6NBxa3Pp0u3swH75hdUCyKOxSBqQ00bxqrhd0n";
//   String publishableKey= "pk_test_51P2MfhKWAbPpFyteEjguBmtO0NNRoolkxPh8jbVg1pCXXPEgEkTyhbo2NRpzKHOE4kCD9TbOnjTN82xubFWaBKHf00UMLw6t7b";
  
//   static Future<dynamic> createCheckoutSession(
//    List <dynamic> productItems,
//    totalAmount, 
//   )async
//   {
//     final url=Uri.parse("https://api.stripe.com/v1/checkout/sessions");

//     String lineItems = "";
//     int index =0;

//     productItems.forEach((val)
     
//      {
//       var productPrice=(val["productPrice"] * 100).round().toString();
//       lineItems += "&line_item[$index][price_data][product_data][name]=${val['productName']}";
//       lineItems += "&line_item[$index][price_data][unit_amount]=$productPrice";
//       lineItems +="&line_item[$index][price_data][product_data][currency]=EUR";
//       lineItems += "&line_item[$index][qty]=${val['qty'].toString()}";
      
//       index++;



//       });
//       final response = await http.post(
//         url,
//         body: 'sucess_url=https://checkout.stripe.dev/success&mode=payment$lineItems',
//         headers: {
//           'Authorization':'Bearer $secretKey',
//         }
//       );
//   }


// }