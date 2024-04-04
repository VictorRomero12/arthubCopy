import 'dart:async';
import 'package:arthub/Home/home_page.dart';
import 'package:arthub/authentication/login_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(CarouselInicio());
}

class CarouselInicio extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

final List<String> imagePaths = [
  "assets/digital1.jpg",
  "assets/digital2.jpg",
  "assets/digital3.jpg"
];

late List<Widget> _pages;
int _activePage = 0;
late PageController _pageController;

class _MyAppState extends State<CarouselInicio> {
  late String _email='';
  late String _password='';
  late int _idUsuario=0;
  int explorarPageIndex = 0; // Índice de la página "Explorar"

  @override
  void initState() {
    super.initState();
    _pages = List.generate(
      imagePaths.length,
      (index) => ImagePlaceholder(
        imagePath: imagePaths[index],
      ),
    );

    _pageController = PageController(initialPage: _activePage);
    startAutoPlay();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void startAutoPlay() {
    Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_activePage < _pages.length - 1) {
        _activePage++;
      } else {
        _activePage = 0;
      }
      _pageController.animateToPage(
        _activePage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  void onPageChanged(int index) {
    setState(() {
      _activePage = index;
    });
  }

  void onPageSelected(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height / 1,
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: _pages.length,
                      itemBuilder: ((context, index) {
                        return _pages[index];
                      }),
                      onPageChanged: onPageChanged,
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    left: 0,
                    right: 0,
                    child: Column(
                      children: [
                        const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "¡Bienvenido a ArtHub!",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 30),
                              )
                            ]),
                        const SizedBox(
                            height:
                                10), // Espacio entre los botones y los indicadores
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            _pages.length,
                            (index) => InkWell(
                              onTap: () => onPageSelected(index),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                child: CircleAvatar(
                                  radius: 4,
                                  backgroundColor: _activePage == index
                                      ? Colors.yellow
                                      : Colors.grey,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  explorarPageIndex =
                                      1; // Cambia este valor al índice de la página deseada
                                });
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        SimpleBottomNavigation(
                                      username: _email,
                                      password: _password,
                                      idUsuario: _idUsuario,
                                      isLoggedIn: false,
                                      // Pasa el índice de la página
                                    ),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                primary: const Color.fromARGB(255, 255, 178,
                                    63), // Color de fondo del botón
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),
                                ),
                              ),
                              child: Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 20),
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: const Text(
                                  "Explorar",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            const SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const LoginPageModal()),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                primary: const Color.fromARGB(255, 55, 66,
                                    103), // Color de fondo del botón
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),
                                ),
                              ),
                              child: Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 20),
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: const Text(
                                  "Iniciar Sesion",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ImagePlaceholder extends StatelessWidget {
  final String? imagePath;
  const ImagePlaceholder({Key? key, this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      imagePath!,
      fit: BoxFit.cover, // Ajustar la imagen para que llene toda la pantalla
      width: MediaQuery.of(context)
          .size
          .width, // Ancho igual al ancho de la pantalla
      height: MediaQuery.of(context)
          .size
          .height, // Altura igual a la altura de la pantalla
    );
  }
}
