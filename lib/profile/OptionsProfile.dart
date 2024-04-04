import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class BodyProfile2 extends StatelessWidget {
  const BodyProfile2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        
        
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: TextButton(
            onPressed: () {
              // Navegar a la pantalla de dirección de envío al presionar el botón
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => ShippingAddress()),
              // );
            },
            style: TextButton.styleFrom(
              padding: EdgeInsets.all(20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              backgroundColor: Color.fromARGB(255, 232, 232, 235),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      CupertinoIcons.person_fill,
                      color: const Color.fromARGB(255, 255, 0, 0),
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Text Button',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ],
                ),
                Icon(CupertinoIcons.chevron_right, color: Colors.black),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
