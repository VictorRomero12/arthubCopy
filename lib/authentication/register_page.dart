import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
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
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 170,
                      height: 170,
                      child: Image(image: AssetImage('assets/arthub2.jpg')),
                    ),
                    _Logo(),
                    Expanded( // Add Expanded here
                      child: SingleChildScrollView(
                        child: _FormContent(),
                      ),
                    ),
                  ],
                )
              : Center(
                  child: Container(
                    padding: const EdgeInsets.all(32.0),
                    constraints: const BoxConstraints(maxWidth: 800),
                    child: Row(
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
  late String _firstName;
  late String _lastName;
  late String _fotoPerfil="";
  late DateTime _fechaNacimiento = DateTime.now(); // Inicializa con la fecha actual

  bool _isObscure = true;

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
            //
            //fotoPerfil
            //
            const SizedBox(height: 16.0),
            _InputField(
              hintText: 'Nombre de Usuario',
              labelText: 'Nombre de Usuario',
              icon: Icons.person,
              onChanged: (value) {
                setState(() {
                  _userName = value;
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
              hintText: 'Nombre',
              labelText: 'Nombre',
              icon: Icons.person,
              onChanged: (value) {
                setState(() {
                  _firstName = value;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, introduce tu nombre';
                }
                return null;
              },
            ),
            const SizedBox(height: 16.0),
            _InputField(
              hintText: 'Apellido',
              labelText: 'Apellido',
              icon: Icons.person_outline,
              onChanged: (value) {
                setState(() {
                  _lastName = value;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, introduce tu apellido';
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
              obscureText: _isObscure,
              onChanged: (value) {
                setState(() {
                  _password = value;
                });
              },
              suffixIcon: IconButton(
                icon: Icon(_isObscure ? Icons.visibility : Icons.visibility_off),
                onPressed: () {
                  setState(() {
                    _isObscure = !_isObscure;
                  });
                },
              ),
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
            InkWell(
              onTap: () {
                _selectDate(context);
              },
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Fecha de Nacimiento',
                  hintText: 'Selecciona tu fecha de nacimiento',
                  prefixIcon: Icon(Icons.calendar_today),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                child: Text(
                  '${_fechaNacimiento.year}-${_fechaNacimiento.month}-${_fechaNacimiento.day}',
                  style: const TextStyle(color: Color.fromARGB(255, 255, 178, 63)),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: const Color.fromARGB(255, 255, 178, 63),
                  onPrimary: const Color.fromARGB(255, 255, 255, 255),
                ),
                onPressed: () async {
  if (_formKey.currentState?.validate() ?? false) {
    // Crear un mapa con los datos del formulario
    Map<String, dynamic> formData = {
      "nombre": _firstName,
      "apellido": _lastName,
      "username": _userName,
      "fechaNacimiento": _fechaNacimiento.toIso8601String(),
      "email": _email,
      "contrasena": _password,
      "idRol": 1,
      // Aquí agregamos la variable fotoPerfil
      "fotoPerfil": _fotoPerfil ?? "", // Usamos el valor de _fotoPerfil si está definido, de lo contrario enviamos un string vacío
    };

    // Convertir el mapa a JSON
    String jsonData = jsonEncode(formData);

    // Realizar la solicitud POST a la API
    var response = await http.post(
      Uri.parse('https://arthub.somee.com/api/Registro'),
      headers: {
        'Content-Type': 'application/json',
        'accept': '*/*'
      },
      body: jsonData,
    );

    // Verificar si la solicitud fue exitosa (código de respuesta 201)
    if (response.statusCode == 201) {
      // Si la solicitud fue exitosa, muestra una alerta
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Registro exitoso'),
            content: const Text('Te has registrado con éxito.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
                child: const Text('Aceptar'),
              ),
            ],
          );
        },
      );
    } else {
      // Si la solicitud no fue exitosa, muestra un mensaje de error
      print('Error al registrar usuario: ${response.body}');
    }
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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _fechaNacimiento,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null && pickedDate != _fechaNacimiento) {
      setState(() {
        _fechaNacimiento = pickedDate;
      });
    }
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
    this.suffixIcon,
  }) : super(key: key);

  final String hintText;
  final String labelText;
  final IconData icon;
  final bool obscureText;
  final ValueChanged<String> onChanged;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obscureText,
      style: const TextStyle(color: Color.fromARGB(255, 255, 178, 63)), // Estilo para el texto del campo
      decoration: InputDecoration(
        hintText: hintText,
        labelText: labelText,
        prefixIcon: Icon(icon, color: const Color.fromARGB(255, 255, 178, 63)), // Color del icono
        suffixIcon: suffixIcon,
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


