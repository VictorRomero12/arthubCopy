import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:arthub/authentication/register_page.dart';
import 'package:arthub/Home/home_page.dart';

class LoginPageModal extends StatefulWidget {
  const LoginPageModal({Key? key}) : super(key: key);

  @override
  State<LoginPageModal> createState() => _LoginPageModalState();
}

class _LoginPageModalState extends State<LoginPageModal> {
  late String _email;
  late String _password;
  late int _idUsuario;
  bool _isLoading = false; // Nuevo estado para controlar la animación de carga
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 55, 66, 103),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(32.0),
            constraints: const BoxConstraints(maxWidth: 400),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _InputField(
                    hintText: 'Nombre de usuario',
                    labelText: 'Nombre de usuario',
                    icon: Icons.person,
                    onChanged: (value) {
                      _email = value; // Almacena el valor del nombre de usuario
                    },
                  ),
                  const SizedBox(height: 16.0),
                  _InputField(
                    hintText: 'Contraseña',
                    labelText: 'Contraseña',
                    icon: Icons.lock_outline,
                    obscureText: true,
                    onChanged: (value) {
                      _password = value; // Almacena el valor de la contraseña
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
                  Visibility(
                    visible: !_isLoading, // Oculta el botón cuando _isLoading es true
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: const Color.fromARGB(255, 255, 178, 63),
                          onPrimary: const Color.fromARGB(255, 255, 255, 255),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState?.validate() ?? false) {
                            setState(() {
                              _isLoading = true; // Activamos la animación de carga
                            });

                            final Uri url = Uri.parse('https://arthub.somee.com/api/v1/login');
                            final response = await http.post(
                              url,
                              body: json.encode({
                                'correoUsername': _email,
                                'password': _password,
                              }),
                              headers: {'Content-Type': 'application/json'},
                            );

                            setState(() {
                              _isLoading = false; // Desactivamos la animación de carga
                            });

                            if (response.statusCode == 200) {
                              final int? idUsuario = int.tryParse(response.body);

                              if (idUsuario != null) {
                                print('Inicio de sesión exitoso. ID de usuario: $idUsuario');
                                _idUsuario = idUsuario;
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SimpleBottomNavigation(
                                      username: _email,
                                      password: _password,
                                      idUsuario: _idUsuario,
                                      isLoggedIn: true,
                                    ),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Credenciales inválidas')),
                                );
                              }
                            } else if (response.statusCode == 400) {
                              final String errorMessage = response.body;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(errorMessage)),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Error al conectar con el servidor')),
                              );
                            }
                          }
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Text('Iniciar sesión'),
                        ),
                      ),
                    ),
                  ),
                  if (_isLoading) // Mostramos la animación de carga si _isLoading es true
                    Container(
                      child: Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Color.fromARGB(255, 255, 178, 63), // Cambia el color aquí
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
          ),
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
      style: const TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
      decoration: InputDecoration(
        hintText: hintText,
        labelText: labelText,
        prefixIcon: Icon(icon, color: const Color.fromARGB(255, 253, 192, 84)),
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
        labelStyle: const TextStyle(color: const Color.fromARGB(255, 253, 192, 84)),
        hintStyle: const TextStyle(color: const Color.fromARGB(255, 253, 192, 84)),
      ),
      cursorColor: const Color.fromARGB(255, 253, 192, 84),
      onChanged: onChanged,
      validator: validator,
    );
  }
}
