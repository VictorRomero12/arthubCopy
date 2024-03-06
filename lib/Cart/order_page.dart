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
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final item in widget.cartItems) ...[
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: ListTile(
                      title: Text(
                        item['name'] ?? '',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Text(
                          //   item['description'] ?? '',
                          //   style: TextStyle(fontSize: 18),
                          // ),
                          Text(
                            'Marco: ${item['frameType'] ?? 'No especificado'}',
                            style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                          ),
                          Text(
                            'Impresión: ${item['printType'] ?? 'No especificado'}',
                            style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                          ),
                          Text(
                            'Tamaño: ${item['size'] ?? 'No especificado'}',
                            style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                          ),
                        ],
                      ),
                      trailing: Text(
                        '\$${(item['price'] as double?)?.toStringAsFixed(2) ?? ''}',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      leading: Container(
                        width: 100,
                        height: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              spreadRadius: 1,
                              blurRadius: 5,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            item['imageUrl'] ?? '',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
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
