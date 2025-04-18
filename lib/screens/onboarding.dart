import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_complete', true);
    
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomeScreen())
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fundo gradiente vermelho
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFAA3C3B), // Vermelho escuro
                  Color(0xFFD6716F), // Vermelho claro
                ],
              ),
            ),
          ),
          
          // Conteúdo
          Column(
            children: [
              // Cabeçalho
              Container(
                padding: const EdgeInsets.only(top: 50, bottom: 20),
                color: const Color(0xFFAA3C3B),
                width: double.infinity,
                child: Column(
                  children: [
                    // Logo
                    Image.asset(
                      'assets/images/logo_abrac.png', // Substitua pelo caminho correto
                      width: 80,
                      height: 80,
                      errorBuilder: (ctx, obj, st) => const CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.music_note, size: 40, color: Color(0xFFAA3C3B)),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'ASSOCIAÇÃO BRASILEIRA DE CANÇÃO',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Menu superior
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFBD5251),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.photo_library, color: Colors.white, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'FOTOS/VÍDEOS',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.campaign, color: Colors.white, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'NOTÍCIAS',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Páginas de onboarding
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  children: [
                    // Primeira página
                    _buildOnboardingPage1(),
                    
                    // Segunda página
                    _buildOnboardingPage2(),
                  ],
                ),
              ),
              
              // Navegação inferior
              Container(
                height: 70,
                color: const Color(0xFFB87D6A),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.home, color: Colors.white, size: 28),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: Image.asset(
                        'assets/images/logo_abrac.png',
                        width: 28,
                        height: 28,
                        errorBuilder: (ctx, obj, st) => const CircleAvatar(
                          radius: 14,
                          backgroundColor: Colors.white,
                          child: Icon(Icons.music_note, size: 14, color: Color(0xFFAA3C3B)),
                        ),
                      ),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(Icons.store, color: Colors.white, size: 28),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(Icons.person, color: Colors.white, size: 28),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOnboardingPage1() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFF8D3D0),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Olá, (nome do cantor)!',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFFAA3C3B),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'É uma grande alegria e honra tê-lo conosco em nosso novo aplicativo, desenvolvido pela ABRAC para tornar ainda mais fácil a organização e o acesso a tudo que envolve o nosso querido Concurso Brasileiro de Canção Japonesa.',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF5C1E1D),
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          const Text(
            'Aqui, você encontrará todas as informações essenciais sobre o Brasileirão, com atualizações em tempo real para garantir uma comunicação mais ágil e eficiente. Pense nele como uma versão digital do nosso programa impresso, mas muito mais completo!',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF5C1E1D),
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
          const Spacer(),
          
          // Indicadores de página
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFAA3C3B),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.5),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOnboardingPage2() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFF8D3D0),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Olá, (nome do cantor)!',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFFAA3C3B),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Gostaria de um tour pelo aplicativo?',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF5C1E1D),
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          
          // Botão SIM
          ElevatedButton(
            onPressed: _completeOnboarding,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFFAA3C3B),
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            child: const Text(
              'SIM, ONEGAI SHIMASU!',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          // Botão NÃO
          ElevatedButton(
            onPressed: _completeOnboarding,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFFAA3C3B),
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            child: const Text(
              'NÃO, ARIGATOU!',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(height: 24),
          
          // Texto de contato
          const Text(
            'Qualquer dúvida sobre o uso do aplicativo ou outros assuntos relacionados, entre em contato com Karen Taira (11 98289-3601).',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF5C1E1D),
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          
          // Texto de agradecimento
          const Column(
            children: [
              Text(
                'Muito obrigado, aproveite!',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF5C1E1D),
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                'どうもありがとうございます！',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF5C1E1D),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          const Spacer(),
          
          // Indicadores de página
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.5),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFAA3C3B),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}