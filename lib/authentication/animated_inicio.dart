import 'package:arthub/authentication/login_page.dart';
import 'package:flutter/material.dart';
import 'dart:async';


class AnimacionInicio extends StatefulWidget {
  @override
  _AnimacionInicioState createState() => _AnimacionInicioState();
}

class _AnimacionInicioState extends State<AnimacionInicio> {
  bool _showLogo = true;

  @override
  void initState() {
    super.initState();
    // Ocultar el logo después de 3 segundos (3000 milisegundos)
    Timer(Duration(milliseconds: 3000), () {
      setState(() {
        _showLogo = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 47, 60, 79),
      body: Stack(
        children: [
          Center(
            child: AnimatedOpacity(
              opacity: _showLogo ? 1.0 : 0.0,
              duration: Duration(seconds: 1),
              child: Image.asset('assets/arthub2.jpg'),
            ),
          ),
          Visibility(
            visible: !_showLogo,
            child: Positioned.fill(
              child: LoginPage(),
            ),
          ),
        ],
      ),
    );
  }
}
