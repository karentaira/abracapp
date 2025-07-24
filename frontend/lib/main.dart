import 'package:flutter/material.dart';
import 'screens/home_screens/homes.dart'; // Importa o EventHome unificado
import 'screens/abrac.dart'; // Importa a AbracPage
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Associação Brasileira de Canção',
      theme: ThemeData(
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  
  // Controlador de páginas
  final PageController _pageController = PageController();
  
  // Lista das telas
  final List<Widget> _screens = [
    const EventHome(), // Tela inicial do evento
    Container(), // Placeholder para câmera
    const AbracPage(), // Tela da ABRAC (botão do logo)
    Container(), // Placeholder para loja
    Container(), // Placeholder para perfil
  ];
  
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(), // Desativa o scroll horizontal
        children: _screens,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      extendBody: true,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(171, 148, 112, 89).withOpacity(0.8),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        height: 85,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavIcon(Icons.home, 0),
              _buildNavIcon(Icons.camera_alt, 1),
              _buildLogoIcon(),
              _buildNavIcon(Icons.store, 3),
              _buildNavIcon(Icons.person, 4),
            ],
          ),
        ),
      ),
    );
  }

  // Widget de ícone da navegação
  Widget _buildNavIcon(IconData iconData, int index) {
    return InkWell(
      onTap: () {
        setState(() {
          _currentIndex = index;
          _pageController.jumpToPage(index);
        });
      },
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: _currentIndex == index ? Colors.white.withOpacity(0.9) : Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(
          iconData, 
          color: _currentIndex == index ? Colors.red.shade800 : Colors.brown, 
          size: 28,
        ),
      ),
    );
  }

  // Widget de ícone do logo
  Widget _buildLogoIcon() {
    return InkWell(
      onTap: () {
        setState(() {
          _currentIndex = 2;
          _pageController.jumpToPage(2);
        });
      },
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: _currentIndex == 2 ? Colors.white.withOpacity(0.9) : Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(0),
        child: FittedBox(
          fit: BoxFit.contain,
          child: Image.asset('assets/images/logo_abrac.png'),
        ),
      ),
    );
  }
}