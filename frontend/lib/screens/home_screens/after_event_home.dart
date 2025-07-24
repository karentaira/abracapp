import 'package:flutter/material.dart';

class AfterEventHome extends StatefulWidget {
  const AfterEventHome({super.key});

  @override
  State<AfterEventHome> createState() => _AfterEventHomeState();
}

class _AfterEventHomeState extends State<AfterEventHome> {

  @override
  Widget build(BuildContext context) {
    
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.red.shade800,
              const Color.fromARGB(255, 181, 82, 82),
              const Color.fromARGB(255, 247, 188, 151),
              const Color.fromARGB(255, 120, 103, 97),
            ],
            stops: const [0.0, 0.25, 0.75, 1.0],
          ),
        ),
        child: Column(
          children: [
            // ─── AppBar ───
            Container(
              padding: EdgeInsets.fromLTRB(30, statusBarHeight + 8, 16, 8),
              decoration: BoxDecoration(
                color: Colors.red.shade800,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                    child: Padding(
                      padding: const EdgeInsets.all(0),
                      child: Image.asset(
                        'assets/images/logo_abrac.png',
                        fit: BoxFit.cover,
                        height: 100,
                        width: 100,
                      ),
                    ),
                  ),
                  const SizedBox(width: 1),
                  const Expanded(
                    child: Center(
                      child: Text(
                        'ASSOCIAÇÃO BRASILEIRA DE CANÇÃO',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ─── Conteúdo Principal ───
            Expanded(
              child: SafeArea(
                top: false,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Barra de Fotos/Vídeos e Notícias
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 236, 98, 95)
                                .withOpacity(0.7),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextButton.icon(
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.photo_library,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                  label: const Text(
                                    'FOTOS/VÍDEOS',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  style: TextButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: TextButton.icon(
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.campaign,
                                    color: Colors.white,
                                    size: 26,
                                  ),
                                  label: const Text(
                                    'NOTÍCIAS',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  style: TextButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      
                      // Contador regressivo
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: _buildCounter(),
                      ),
                      
                      // Você pode adicionar mais widgets aqui para completar o conteúdo
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

      // ─── Bottom Navigation Bar ───
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
              _buildNavIcon(Icons.home),
              _buildNavIcon(Icons.camera_alt),
              _buildLogoIcon(),
              _buildNavIcon(Icons.store),
              _buildNavIcon(Icons.person),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCounter() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      height: 350,
      child: Stack(
        children: [
          // Imagem de fundo
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                'assets/images/widget2.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavIcon(IconData iconData) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Icon(iconData, color: Colors.brown, size: 28),
    );
  }

  Widget _buildLogoIcon() {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
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
    );
  }
}