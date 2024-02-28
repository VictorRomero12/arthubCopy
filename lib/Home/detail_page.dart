// import 'package:flutter/material.dart';
// import 'package:arthub/Cart/cart_page.dart';

// class DetailPage extends StatefulWidget {
//   const DetailPage({
//     Key? key,
//     required this.imageUrl,
//     required this.name,
//     required this.description,
//     required this.randomPrice, required String artistName,
//   }) : super(key: key);

//   final String imageUrl;
//   final String name;
//   final String description;
//   final double randomPrice;

//   @override
//   _DetailPageState createState() => _DetailPageState();
// }


// class _DetailPageState extends State<DetailPage> {
//   bool isLiked = false;
//   String selectedFrame = 'Sin Marco';
//   String selectedSize = 'Tamaño Predeterminado';
//   String selectedPrintType = 'Tipo Predeterminado';

//   final Map<String, double> framePrices = {
//     'Sin Marco': 0.0,
//     'Madera - \$10': 10.0,
//     'Metal - \$15': 15.0,
//     'Aluminio - \$20': 20.0,
//     'Plastico - \$5': 5.0,
//   };

//   final Map<String, double> sizePrices = {
//     'Tamaño Predeterminado': 0.0,
//     '20 x 25 - \$5': 5.0,
//     '28 x 35 - \$10': 10.0,
//     '40 x 35 - \$15': 15.0,
//     '46 x 51 - \$20': 20.0,
//     '61 x 91 - \$25': 25.0,
//   };

//   final Map<String, double> printTypePrices = {
//     'Tipo Predeterminado': 0.0,
//     'Impresión Cartulina - \$8': 8.0,
//     'Impresión Opalina - \$12': 12.0,
//     'Impresion Laser - \$15': 15.0,
//     'Impresion Fotografica - \$18': 18.0,
//   };

//   double calculateTotalPrice() {
//     double framePrice = framePrices[selectedFrame] ?? 0.0;
//     double sizePrice = sizePrices[selectedSize] ?? 0.0;
//     double printTypePrice = printTypePrices[selectedPrintType] ?? 0.0;

//     double totalPrice = framePrice + sizePrice + printTypePrice + widget.randomPrice;

//     return totalPrice;
//   }

//   void _showLikeSnackBar() {
//     final snackBar = const SnackBar(
//       content: Text('Te gusta esta imagen'),
//     );
//     ScaffoldMessenger.of(context).showSnackBar(snackBar);
//   }

//   void _openAuthorProfile() {
//     // Implementación pendiente
//     print('Abriendo perfil de algún usuario');
//   }

//   void _showFullScreenImage() {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return Dialog(
//           child: GestureDetector(
//             onTap: () {
//               Navigator.of(context).pop();
//             },
//             child: Container(
//               width: double.infinity,
//               height: double.infinity,
//               decoration: BoxDecoration(
//                 image: DecorationImage(
//                   image: NetworkImage(widget.imageUrl),
//                   fit: BoxFit.contain,
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   void _addToCart() {
//     // Añadir el elemento al carrito
//     CartItem newItem = CartItem(
//       name: widget.name,
//       description: widget.description,
//       totalPrice: calculateTotalPrice(),
//     );

//     // Navegar a la página del carrito y pasar los detalles del artículo añadido
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => CartPage(cartItem: newItem)),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: [
//           Expanded(
//             child: SingleChildScrollView(
//               child: Column(
//                 children: [
//                   AspectRatio(
//                     aspectRatio: 3 / 4,
//                     child: Hero(
//                       tag: 'imageTag${widget.imageUrl}',
//                       child: GestureDetector(
//                         onTap: _showFullScreenImage,
//                         child: Container(
//                           decoration: BoxDecoration(
//                             image: DecorationImage(
//                               image: NetworkImage(widget.imageUrl),
//                               fit: BoxFit.cover,
//                             ),
//                           ),
//                           child: SafeArea(
//                             child: Padding(
//                               padding: const EdgeInsets.symmetric(horizontal: 18),
//                               child: Column(
//                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                 crossAxisAlignment: CrossAxisAlignment.end,
//                                 children: [
//                                   Row(
//                                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       InkWell(
//                                         onTap: () => Navigator.pop(context),
//                                         child: CircleAvatar(
//                                           backgroundColor: Colors.black.withOpacity(0.2),
//                                           child: const Icon(
//                                             Icons.chevron_left,
//                                             color: Colors.white,
//                                             size: 28,
//                                           ),
//                                         ),
//                                       ),
//                                       InkWell(
//                                         onTap: _openAuthorProfile,
//                                         child: CircleAvatar(
//                                           backgroundColor: Colors.black.withOpacity(0.2),
//                                           child: const Icon(
//                                             Icons.person,
//                                             color: Colors.white,
//                                             size: 28,
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                   Container(
//                     padding: const EdgeInsets.only(
//                       top: 10,
//                       left: 18,
//                       right: 18,
//                     ),
//                     color: Colors.white,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.only(bottom: 8),
//                           child: Text(
//                             widget.name,
//                             style: const TextStyle(
//                               fontSize: 24,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.only(bottom: 16),
//                           child: Text(
//                             widget.description,
//                             style: const TextStyle(
//                               fontSize: 16,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Container(
//                     padding: const EdgeInsets.only(
//                       top: 10,
//                       bottom: 30,
//                       left: 18,
//                       right: 18,
//                     ),
//                     color: Colors.white,
//                     child: Column(
//                       children: [
//                         const SizedBox(height: 10),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Container(
//                               padding: const EdgeInsets.symmetric(
//                                 horizontal: 17,
//                                 vertical: 15,
//                               ),
//                               decoration: BoxDecoration(
//                                 color: const Color(0xFFF1F1F1),
//                                 borderRadius: BorderRadius.circular(30),
//                               ),
//                               child: Text(
//                                 'Precio Imagen: \$${widget.randomPrice.toStringAsFixed(2)}',
//                                 style: const TextStyle(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ),
//                             IconButton(
//                               icon: Icon(
//                                 isLiked
//                                     ? Icons.favorite
//                                     : Icons.favorite_border,
//                                 color: Colors.red,
//                               ),
//                               onPressed: () {
//                                 setState(() {
//                                   isLiked = !isLiked;
//                                   _showLikeSnackBar();
//                                 });
//                               },
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 10),
//                         Row(
//                           children: [
//                             CircleAvatar(
//                               backgroundColor: Colors.black.withOpacity(0.2),
//                               child: const Icon(
//                                 Icons.person,
//                                 color: Colors.white,
//                                 size: 28,
//                               ),
//                             ),
//                             const SizedBox(width: 10),
//                             const Text(
//                               'Creado por: Placeholder',
//                               style: TextStyle(
//                                 fontSize: 16,
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 10),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             const Text(
//                               'Tipo de Marco:',
//                               style: TextStyle(
//                                 fontSize: 16,
//                               ),
//                             ),
//                             DropdownButton<String>(
//                               value: selectedFrame,
//                               items: ['Sin Marco', 'Madera - \$10', 'Metal - \$15', 'Aluminio - \$20', 'Plastico - \$5']
//                                   .map<DropdownMenuItem<String>>(
//                                     (String value) => DropdownMenuItem<String>(
//                                       value: value,
//                                       child: Text(value),
//                                     ),
//                                   )
//                                   .toList(),
//                               onChanged: (String? newValue) {
//                                 setState(() {
//                                   selectedFrame = newValue ?? 'Sin Marco';
//                                 });
//                               },
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 10),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             const Text(
//                               'Tamaño de la Imagen:',
//                               style: TextStyle(
//                                 fontSize: 16,
//                               ),
//                             ),
//                             DropdownButton<String>(
//                               value: selectedSize,
//                               items: ['Tamaño Predeterminado', '20 x 25 - \$5', '28 x 35 - \$10', '40 x 35 - \$15', '46 x 51 - \$20', '61 x 91 - \$25']
//                                   .map<DropdownMenuItem<String>>(
//                                     (String value) => DropdownMenuItem<String>(
//                                       value: value,
//                                       child: Text(value),
//                                     ),
//                                   )
//                                   .toList(),
//                               onChanged: (String? newValue) {
//                                 setState(() {
//                                   selectedSize = newValue ?? 'Tamaño Predeterminado';
//                                 });
//                               },
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 10),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             const Text(
//                               'Tipo de Impresión:',
//                               style: TextStyle(
//                                 fontSize: 16,
//                               ),
//                             ),
//                             DropdownButton<String>(
//                               value: selectedPrintType,
//                               items: ['Tipo Predeterminado', 'Impresión Cartulina - \$8', 'Impresión Opalina - \$12', 'Impresion Laser - \$15', 'Impresion Fotografica - \$18']
//                                   .map<DropdownMenuItem<String>>(
//                                     (String value) => DropdownMenuItem<String>(
//                                       value: value,
//                                       child: Text(value),
//                                     ),
//                                   )
//                                   .toList(),
//                               onChanged: (String? newValue) {
//                                 setState(() {
//                                   selectedPrintType = newValue ?? 'Tipo Predeterminado';
//                                 });
//                               },
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 10),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             const Text(
//                               'Precio Total:',
//                               style: TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             Text(
//                               '\$${calculateTotalPrice().toStringAsFixed(2)}',
//                               style: const TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 16),
//                         ElevatedButton.icon(
//                           onPressed: _addToCart,
//                           icon: const Icon(Icons.shopping_cart),
//                           label: const Text('Añadir al carrito'),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class CartItem {
//   final String name;
//   final String description;
//   final double totalPrice;

//   CartItem({
//     required this.name,
//     required this.description,
//     required this.totalPrice,
//   });
// }
