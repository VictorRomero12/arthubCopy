import 'package:flutter/material.dart';


class FirstAnimation extends StatelessWidget {
  const FirstAnimation({Key? key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Page1()),
          );
        },
        child: Card(
          elevation: 4.0,
           color: Color.fromARGB(255, 237, 12, 12),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Icon(
                  Icons.change_circle,
                  size: 25,
                  color: Colors.white, // Usa el color primario de la aplicación
                ),
                SizedBox(width: 16.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Animate a page route transition",
                       style: Theme.of(context).textTheme.headline6!.copyWith(
            color: Colors.white), // Cambia el color del texto a blanco
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        "Animation 1",
                       style: Theme.of(context).textTheme.subtitle1!.copyWith(
            color: Colors.white, // Cambia el color del texto a blanco
          ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.keyboard_arrow_right,
                color: Colors.white,),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
class Page1 extends StatefulWidget {
  const Page1({super.key});

  @override
  State<Page1> createState() => _Page1State();
}

class _Page1State extends State<Page1> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
