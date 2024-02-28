// import 'dart:convert';
// import 'dart:math';
// import 'package:arthub/search/search_page.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// import 'detail_page.dart';


// class ApiPage extends StatefulWidget {
//   @override
//   _ApiPageState createState() => _ApiPageState();
// }

// class _ApiPageState extends State<ApiPage> {
//   List<String> imageUrls = [];

//   @override
//   void initState() {
//     super.initState();
//     fetchImageUrls();
//   }

//   Future<void> fetchImageUrls() async {
//     try {
//       final response = await http.get(
//         Uri.parse('http://arthub.somee.com/api/Publicacion'),
//         headers: {'accept': 'application/json'}, // Cambiar '*' por 'application/json'
//       );

//       if (response.statusCode == 200) {
//         final List<dynamic> jsonData = jsonDecode(response.body);
//         final List<String> urls = [];
//         for (final entry in jsonData) {
//           if (entry is Map<String, dynamic> && entry.containsKey('archivo')) {
//             urls.add(entry['archivo']);
//           }
//         }
//         if(mounted) {
//           setState(() {
//             imageUrls = urls;
//           });
//         }
//       } else {
//         throw Exception('Failed to load images');
//       }
//     } catch (e) {
//       print('Error: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Inicio'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//         child: GridView.builder(
//           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: 2,
//             mainAxisSpacing: 10,
//             crossAxisSpacing: 10,
//           ),
//           itemCount: imageUrls.length,
//           itemBuilder: (context, index) {
//             return GestureDetector(
//               onTap: () {
//                 // Implementa la acción cuando se toca una imagen
//               },
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(10),
//                 child: Image.network(
//                   imageUrls[index],
//                   fit: BoxFit.cover,
//                   loadingBuilder: (context, child, loadingProgress) {
//                     if (loadingProgress == null) return child;
//                     return Center(
//                       child: CircularProgressIndicator(),
//                     );
//                   },
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }