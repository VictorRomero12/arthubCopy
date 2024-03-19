import 'dart:convert';
import 'package:arthub/authentication/login_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProfilePage extends StatefulWidget {
  final String username;
  final String password;

  const ProfilePage({Key? key, required this.username, required this.password}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
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
        'Authorization': 'Basic ${base64Encode(utf8.encode('${widget.username}:${widget.password}'))}',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      // Buscamos el perfil del usuario que inició sesión
      final Map<String, dynamic>? profileData = data.firstWhere((profile) => profile['username'] == widget.username, orElse: () => null);
      if (profileData != null) {
        return profileData;
      } else {
        throw Exception('Perfile no encontrado ');
      }
    } else {
      throw Exception('Failed to load profile data');
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
            // Calculamos la edad
            int edad = DateTime.now().year - fechaNacimiento.year;
            // Creamos un nuevo mapa con la información del perfil, incluyendo la edad
            Map<String, dynamic> profileWithAge = Map<String, dynamic>.from(profile);
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
      body: ListView(
        children: [
          Column(
            children: [
              Expanded(
                flex: 2,
                child: _TopPortion(fotoPerfilUrl: fotoPerfil),
              ),
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "$nombre $apellidos",
                            style: Theme.of(context)
                                .textTheme
                                .headline6
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          const Divider(),
                          const SizedBox(height: 8),
                          _ProfileInfoList(
                            fotoPerfil: fotoPerfil,
                            nombre: nombre,
                            apellidos: apellidos,
                            userName: userName,
                            email: email,
                            edad: edad,
                          ),
                          const SizedBox(height: 16),
                          Center(
                            child: ElevatedButton(
                              onPressed: () {
                                // Redirigir al usuario a la pantalla de inicio de sesión
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginPage()),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                primary: Colors.red, // Cambiar el color a rojo
                              ),
                              child: Text('Cerrar Sesión'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          ZeroWidget(), // Agregar el widget ZeroWidget al final de la lista
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
  final String fotoPerfilUrl;

  const _TopPortion({Key? key, required this.fotoPerfilUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 50),
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Color(0xff0043ba), Color(0xff006df1)]),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(50),
                bottomRight: Radius.circular(50),
              )),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            width: 150,
            height: 150,
            child: Stack(
              fit: StackFit.expand,
              children: [
                ClipOval(
                  child: Image.network(
                    fotoPerfilUrl,
                    fit: BoxFit.cover,
                    loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      } else {
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
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

class ZeroWidget extends StatelessWidget {
  const ZeroWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListTile(
        leading: const CircleAvatar(
          radius: 25,
          backgroundColor: Colors.red,
        ),
        title: const Text("Add Drawer to a screen", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        subtitle: const Text("Design 1"),
        trailing: const Icon(Icons.keyboard_arrow_right),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MyZeroDart()),
          );
        },
        dense: true,
        selected: false,
        enabled: true,
      ),
    );
  }
}

class FirstWidget extends StatelessWidget {
  const FirstWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListTile(
        leading: const CircleAvatar(
          radius: 25,
          backgroundColor: Colors.red,
        ),
        title: const Text("Display a snackbar", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        subtitle: const Text("Design 2"),
        trailing: const Icon(Icons.keyboard_arrow_right),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SnackBarDemo()),
          );
        },
        dense: true,
        selected: false,
        enabled: true,
      ),
    );
  }
}

void main() => runApp(const MyZeroDart());

class MyZeroDart extends StatelessWidget {
  const MyZeroDart({Key? key}) : super(key: key);

  static const appTitle = 'Drawer Demo';

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: appTitle,
      home: MyHomePage(title: appTitle),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: Home',
      style: optionStyle,
    ),
    Text(
      'Index 1: Business',
      style: optionStyle,
    ),
    Text(
      'Index 2: School',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Center(
        child: _widgetOptions[_selectedIndex],
      ),
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Drawer Header'),
            ),
            ListTile(
              title: const Text('Home'),
              selected: _selectedIndex == 0,
              onTap: () {
                // Update the state of the app
                _onItemTapped(0);
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Business'),
              selected: _selectedIndex == 1,
              onTap: () {
                // Update the state of the app
                _onItemTapped(1);
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('School'),
              selected: _selectedIndex == 2,
              onTap: () {
                // Update the state of the app
                _onItemTapped(2);
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class DetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detalle"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Navegar de regreso al menú principal
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Navegar a la pantalla con el SnackBar
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SnackBarDemo()),
            );
          },
          child: Text("Mostrar SnackBar"),
        ),
      ),
    );
  }
}

class SnackBarDemo extends StatelessWidget {
  const SnackBarDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SnackBar Demo',
      home: Scaffold(
        appBar: AppBar(
          title: Text('SnackBar Demo'),
          // Agregar botón de regreso en la AppBar para volver al menú principal
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              // Navegar de regreso al menú principal
              Navigator.pop(context);
            },
          ),
        ),
        body: const SnackBarPage(),
      ),
    );
  }
}

class SnackBarPage extends StatelessWidget {
  const SnackBarPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          final snackBar = SnackBar(
            content: const Text('Yay! A SnackBar!'),
            action: SnackBarAction(
              label: 'Undo',
              onPressed: () {
                // Some code to undo the change.
              },
            ),
          );

          // Find the ScaffoldMessenger in the widget tree
          // and use it to show a SnackBar.
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        },
        child: const Text('Show SnackBar'),
      ),
    );
  }
}


