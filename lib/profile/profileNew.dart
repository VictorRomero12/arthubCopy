import 'dart:convert';
import 'package:arthub/authentication/login_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProfilePage3 extends StatefulWidget {
  final String username;
  final String password;

  const ProfilePage3({Key? key, required this.username, required this.password})
      : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage3> {
  late Future<Map<String, dynamic>> _profileData;

  @override
  void initState() {
    super.initState();
    _profileData = _fetchProfileData();
  }

  Future<Map<String, dynamic>> _fetchProfileData() async {
    final Uri url = Uri.parse('https://arthub.somee.com/api/Registro');
    final response = await http.get(
      url,
      headers: {
        'accept': 'application/json',
        'Authorization':
            'Basic ${base64Encode(utf8.encode('${widget.username}:${widget.password}'))}',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      // Convertir el username proporcionado a minúsculas
      final String lowercaseUsername = widget.username.toLowerCase();
      // Buscamos el perfil del usuario que inició sesión (ignorando mayúsculas/minúsculas)
      final Map<String, dynamic>? profileData = data.firstWhere(
        (profile) =>
            profile['username'].toString().toLowerCase() == lowercaseUsername,
        orElse: () => null,
      );
      if (profileData != null) {
        return profileData;
      } else {
        throw Exception('Perfil no encontrado');
      }
    } else {
      throw Exception('Error al cargar los datos del perfil');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _profileData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final profile = snapshot.data!;
            // Obtenemos la fecha de nacimiento del perfil
            String fechaNacimientoString = profile['fechaNacimiento'];
            DateTime fechaNacimiento = DateTime.parse(fechaNacimientoString);
            DateTime now = DateTime.now();
            // Calculamos la edad en años
            int edad = now.year - fechaNacimiento.year;
            // Creamos un nuevo mapa con la información del perfil, incluyendo la edad
            Map<String, dynamic> profileWithAge =
                Map<String, dynamic>.from(profile);
            profileWithAge['edad'] = edad;
            // Retornamos el nuevo mapa con la información actualizada
            return ProfilePage1(profileData: profileWithAge);
          }
        },
      ),
    );
  }
}

class ProfilePage1 extends StatelessWidget {
  final Map<String, dynamic> profileData;

  const ProfilePage1({Key? key, required this.profileData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String fotoPerfil = profileData['fotoPerfil'];
    String nombre = profileData['nombre'];
    String apellidos = profileData['apellido'];
    String userName = profileData['username'];
    String email = profileData['email'];
    int edad = profileData['edad'];

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: _TopPortion(fotoPerfil: fotoPerfil),
          ),
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 15, top: 20),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color:
                              Colors.black), // Cambiar color del borde a negro
                    ),
                    width: 370,
                    child: Stack(
                      children: [
                        TextFormField(
                          initialValue: nombre,
                          readOnly: true,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: nombre,
                            hintStyle: const TextStyle(fontSize: 18),
                            suffixIcon: Icon(Icons.edit,
                                color: Colors.black), // Icono de editar
                          ),
                        ),
                        Positioned(
                          left: 10,
                          top: 0,
                          child: Text(
                            'Nombre',
                            style: TextStyle(
                              fontSize: 12, // Tamaño de texto pequeño
                              color: Colors.grey, // Color de texto gris
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 15, top: 20),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color:
                              Colors.black), // Cambiar color del borde a negro
                    ),
                    width: 370,
                    child: Stack(
                      children: [
                        TextFormField(
                          initialValue: apellidos,
                          readOnly: true,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: apellidos,
                            hintStyle: const TextStyle(fontSize: 18),
                            suffixIcon: Icon(Icons.edit,
                                color: Colors.black), // Icono de editar
                          ),
                        ),
                        Positioned(
                          left: 10,
                          top: 0,
                          child: Text(
                            'Apellidos',
                            style: TextStyle(
                              fontSize: 12, // Tamaño de texto pequeño
                              color: Colors.grey, // Color de texto gris
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 15, top: 20),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color:
                              Colors.black), // Cambiar color del borde a negro
                    ),
                    width: 370,
                    child: Stack(
                      children: [
                        TextFormField(
                          initialValue: userName,
                          readOnly: true,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: userName,
                            hintStyle: const TextStyle(fontSize: 18),
                            suffixIcon: Icon(Icons.edit,
                                color: Colors.black), // Icono de editar
                          ),
                        ),
                        Positioned(
                          left: 10,
                          top: 0,
                          child: Text(
                            'Nombre de Usuario',
                            style: TextStyle(
                              fontSize: 12, // Tamaño de texto pequeño
                              color: Colors.grey, // Color de texto gris
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 15, top: 20),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color:
                              Colors.black), // Cambiar color del borde a negro
                    ),
                    width: 370,
                    child: Stack(
                      children: [
                        TextFormField(
                          initialValue: email,
                          readOnly: true,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: email,
                            hintStyle: const TextStyle(fontSize: 18),
                            suffixIcon: Icon(Icons.edit,
                                color: Colors.black), // Icono de editar
                          ),
                        ),
                        Positioned(
                          left: 10,
                          top: 0,
                          child: Text(
                            'Correo Electrónico',
                            style: TextStyle(
                              fontSize: 12, // Tamaño de texto pequeño
                              color: Colors.grey, // Color de texto gris
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 15, top: 20),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color:
                              Colors.black), // Cambiar color del borde a negro
                    ),
                    width: 370,
                    child: Stack(
                      children: [
                        TextFormField(
                          initialValue:
                              edad.toString(), // Convertir la edad a String
                          readOnly: true,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText:
                                edad.toString(), // Convertir la edad a String
                            hintStyle: const TextStyle(fontSize: 18),
                            suffixIcon: Icon(Icons.edit,
                                color: Colors.black), // Icono de editar
                          ),
                        ),
                        Positioned(
                          left: 10,
                          top: 0,
                          child: Text(
                            'Edad',
                            style: TextStyle(
                              fontSize: 12, // Tamaño de texto pequeño
                              color: Colors.grey, // Color de texto gris
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        // Redirigir al usuario a la pantalla de inicio de sesión
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPageModal()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.red,
                      ),
                      child: Text('Cerrar Sesión'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileInfoList extends StatelessWidget {
  final String nombre;
  final String apellidos;
  final String userName;
  final String email;
  final int edad;
  final String fotoPerfil;

  const _ProfileInfoList({
    Key? key,
    required this.nombre,
    required this.apellidos,
    required this.userName,
    required this.email,
    required this.edad,
    required this.fotoPerfil,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<ProfileInfoItem> _items = [
      ProfileInfoItem("Nombre", nombre),
      ProfileInfoItem("Apellidos", apellidos),
      ProfileInfoItem("Nombre de Usuario", userName),
      ProfileInfoItem("Correo", email),
      ProfileInfoItem("Edad", "$edad años"),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _items.map((item) => _buildItem(context, item)).toList(),
    );
  }

  Widget _buildItem(BuildContext context, ProfileInfoItem item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${item.title}:",
            style: Theme.of(context).textTheme.subtitle1?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              item.value,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileInfoItem {
  final String title;
  final String value;
  const ProfileInfoItem(this.title, this.value);
}

class _TopPortion extends StatelessWidget {
  final String fotoPerfil;

  const _TopPortion({Key? key, required this.fotoPerfil}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: SizedBox(
            width: 120,
            height: 120,
            child: Stack(
              fit: StackFit.expand,
              children: [
                ClipOval(
                  child: Image.network(
                    fotoPerfil,
                    fit: BoxFit.cover,
                    loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      } else {
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        );
                      }
                    },
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    child: Container(
                      margin: const EdgeInsets.all(8.0),
                      decoration: const BoxDecoration(
                          color: Colors.green, shape: BoxShape.circle),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
