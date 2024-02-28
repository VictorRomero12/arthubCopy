import 'package:flutter/material.dart';
import 'package:arthub/authentication/login_page.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        color: const Color.fromARGB(255, 47, 60, 79),
        child: Center(
          child: isSmallScreen
              ? const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 200,
                      height: 200,
                      child: Image(image: AssetImage('assets/arthub2.jpg')),
                    ),
                    _Logo(),
                    _FormContent(),
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
            "Registro",
            textAlign: TextAlign.center,
            style: isSmallScreen
                ? Theme.of(context).textTheme.headline5?.copyWith(color: const Color.fromARGB(255, 255, 178, 63))
                : Theme.of(context).textTheme.headline4?.copyWith(color: const Color.fromARGB(255, 255, 178, 63)),
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

  late String _userName;
  late DateTime _fechaNacimiento;
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
            const SizedBox(height: 16.0),
            _InputField(
              hintText: 'Nombre de Usuario',
              labelText: 'Nombre de Usuario',
              icon: Icons.verified_user,
              onChanged: (value) {
                setState(() {
                  _userName = value;
                  print('El Username es $_userName');
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, introduce tu nombre de usuario';
                }
                return null;
              },
            ),
            const SizedBox(height: 16.0),
            _InputField(
              hintText: 'Correo',
              labelText: 'Correo',
              icon: Icons.alternate_email,
              onChanged: (value) {
                setState(() {
                  _email = value;
                  print('El Email es $_email');
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, introduce un correo';
                }
                if (!RegExp(
                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                    .hasMatch(value)) {
                  return 'Por favor, introduce un correo válido';
                }
                return null;
              },
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
            _InputField(
              hintText: 'Fecha de Nacimiento',
              labelText: 'Fecha de Nacimiento',
              icon: Icons.calendar_today,
              onChanged: (value) {
                // Aquí puedes manejar la entrada de la fecha de nacimiento
                // Esto podría incluir la conversión de cadenas de fecha a objetos de DateTime
                // También puedes usar un DatePicker para seleccionar la fecha
              },
              validator: (value) {
                // Puedes realizar validaciones adicionales para la fecha de nacimiento aquí
                // Por ejemplo, asegurándote de que la fecha esté en un rango válido
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
                    // Navegar a la pantalla LoginPage al hacer clic en el botón de registrarse
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginPage()),
                    );
                  }
                },
                child: const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    'Registrarse',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'NerkoOne'),
                  ),
                ),
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
      style: const TextStyle(color: Color.fromARGB(255, 255, 178, 63)), // Estilo para el texto del campo
      decoration: InputDecoration(
        hintText: hintText,
        labelText: labelText,
        prefixIcon: Icon(icon, color: const Color.fromARGB(255, 255, 178, 63)), // Color del icono
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: const BorderSide(color: Color.fromARGB(255, 255, 178, 63)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: const BorderSide(color: Color.fromARGB(255, 255, 178, 63)),
        ),
        labelStyle: const TextStyle(color: Color.fromARGB(255, 255, 178, 63)), // Estilo para el texto del label
        hintStyle: const TextStyle(color: Color.fromARGB(255, 255, 178, 63)), // Estilo para el texto de sugerencia
      ),
      cursorColor: const Color.fromARGB(255, 255, 178, 63), // Color del cursor
      onChanged: onChanged,
      validator: validator,
    );
  }
}
