import 'package:flutter/material.dart';
import 'package:arthub/Home/home_page.dart';
import 'package:arthub/authentication/register_page.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 55, 66, 103),
      body: Center(
        child: isSmallScreen
            ? Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 200,
              height: 200,
              child: Image.asset('assets/arthub2.jpg'),
            ),
            const _Logo(),
            const _FormContent(),
          ],
        )
            : Container(
          padding: const EdgeInsets.all(32.0),
          constraints: const BoxConstraints(maxWidth: 800),
          child: const Row(
            children: [
              Expanded(child: _Logo()),
              Expanded(
                child: Center(child: _FormContent()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  const _Logo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            "Inicio de Sesión",
            textAlign: TextAlign.center,
            style: isSmallScreen
                ? Theme.of(context).textTheme.headline4?.copyWith(color: const Color.fromARGB(255, 255, 178, 63)) // Tamaño del texto para pantallas pequeñas
                : Theme.of(context).textTheme.headline3?.copyWith(color: const Color.fromARGB(255, 255, 178, 63)), // Tamaño del texto para pantallas grandes
          ),
        ),
      ],
    );
  }
}

class _FormContent extends StatefulWidget {
  const _FormContent({Key? key}) : super(key: key);

  @override
  State<_FormContent> createState() => __FormContentState();
}

class __FormContentState extends State<_FormContent> {
  late String _email;
  late String _password;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 300),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _InputField(
              hintText: 'Nombre de usuario',
              labelText: 'Nombre de usuario',
              icon: Icons.person_2_rounded,
              onChanged: (value) {},
            ),
            const SizedBox(height: 16.0),
            _InputField(
              hintText: 'Contraseña',
              labelText: 'Contraseña',
              icon: Icons.lock_outline,
              obscureText: true,
              onChanged: (value) {
                setState(() {
                  _password = value;
                  print('El Password es $_password');
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, introduce una contraseña';
                }
                if (value.length < 6) {
                  return 'La contraseña debe tener al menos 6 caracteres';
                }
                return null;
              },
            ),
            const SizedBox(height: 16.0),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: const Color.fromARGB(255, 255, 178, 63),
                  onPrimary: const Color.fromARGB(255, 255, 255, 255),
                ),
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SimpleBottomNavigation()),
                    );
                  }
                },
                child: const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    'Iniciar sesión',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'NerkoOne', color: Color.fromARGB(255, 55, 66, 103)),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RegisterPage()),
                );
              },
              child: const Text(
                "¿No tienes una cuenta? Crea una",
                style: TextStyle(color: Color.fromARGB(255, 255, 178, 63)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  const _InputField({
    Key? key,
    required this.hintText,
    required this.labelText,
    required this.icon,
    this.obscureText = false,
    required this.onChanged,
    this.validator,
  }) : super(key: key);

  final String hintText;
  final String labelText;
  final IconData icon;
  final bool obscureText;
  final ValueChanged<String> onChanged;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obscureText,
      style: const TextStyle(color: const Color.fromARGB(255, 253, 192, 84)), // Estilo para el texto del campo
      decoration: InputDecoration(
        hintText: hintText,
        labelText: labelText,
        prefixIcon: Icon(icon, color: const Color.fromARGB(255, 253, 192, 84)), // Color del icono
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: const BorderSide(color: const Color.fromARGB(255, 253, 192, 84)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: const BorderSide(color: const Color.fromARGB(255, 253, 192, 84)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: const BorderSide(color: const Color.fromARGB(255, 253, 192, 84)),
        ),
        labelStyle: const TextStyle(color: const Color.fromARGB(255, 253, 192, 84)), // Estilo para el texto del label
        hintStyle: const TextStyle(color: const Color.fromARGB(255, 253, 192, 84)), // Estilo para el texto de sugerencia
      ),
      cursorColor: const Color.fromARGB(255, 253, 192, 84), // Color del cursor
      onChanged: onChanged,
      validator: validator,
    );
  }
}
