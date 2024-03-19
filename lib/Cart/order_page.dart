import 'package:flutter/material.dart';

class OrderPage extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;
  final String frameType;
  final String printType;
  final String size;

  const OrderPage({
    Key? key,
    required this.cartItems,
    required this.frameType,
    required this.printType,
    required this.size,
  }) : super(key: key);

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  @override
  Widget build(BuildContext context) {
    double totalPrice = widget.cartItems.fold(
      0,
      (previousValue, item) => previousValue + (item['price'] as double? ?? 0),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '¡Aquí va la orden!',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text("Mi odern", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),

              for (final item in widget.cartItems) ...[
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 3,
                        blurRadius: 10,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 180,
                        height: 100,
                        child: Image.network(item['imageUrl'] ?? '', fit: BoxFit.cover,),
                    // 
                      ),
                      Expanded(child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(item['name'] ?? '', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                            Text(
                            'Marco: ${item['frameType'] ?? 'No especificado'}',
                            style: TextStyle(fontSize: 14, ),
                          ),
                          Text(
                            'Impresión: ${item['printType'] ?? 'No especificado'}',
                            style: TextStyle(fontSize: 14, ),
                          ),
                          Text(
                            'Tamaño: ${item['size'] ?? 'No especificado'}',
                            style: TextStyle(fontSize: 14, ),
                          ),
                          Text(
                        '\$${(item['price'] as double?)?.toStringAsFixed(2) ?? ''}',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red),
                      ),
                          ],
                        ),
                      ))
                    ],
                    
                  ),
                ),
                SizedBox(height: 20),
              ],
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total a pagar:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '\$${totalPrice.toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Lógica para procesar el pago
                  // Aquí puedes agregar la navegación a la página de pago o la lógica correspondiente
                },
                child: Text('Pagar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
