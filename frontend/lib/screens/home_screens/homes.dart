import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Enumeração para controlar o estado do evento
enum EventState {
  before,
  during,
  after,
}

// Classe para gerenciar a data do evento
class EventDateManager {
  // Data do evento - ajuste conforme necessário
  static final DateTime eventStartDate = DateTime(2025, 7, 18);
  static final DateTime eventEndDate = DateTime(2025, 7, 21);

  // Verifica o estado atual do evento
  static EventState getCurrentEventState() {
    final now = DateTime.now();
    
    if (now.isBefore(eventStartDate)) {
      return EventState.before;
    } else if (now.isBefore(eventEndDate)) {
      return EventState.during;
    } else {
      return EventState.after; 
    }
  }

  // Retorna o número de dias restantes até o evento
  static int getDaysRemaining() {
    final now = DateTime.now();
    final difference = eventStartDate.difference(now);
    return difference.inDays >= 0 ? difference.inDays : 0;
  }
  
  // Método para salvar a configuração de depuração (forçar um estado específico)
  static Future<void> saveDebugState(EventState state) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('debug_event_state', state.index);
  }
  
  // Método para carregar a configuração de depuração
  static Future<EventState?> loadDebugState() async {
    final prefs = await SharedPreferences.getInstance();
    final stateIndex = prefs.getInt('debug_event_state');
    
    if (stateIndex != null && stateIndex < EventState.values.length) {
      return EventState.values[stateIndex];
    }
    
    return null; // Retorna null se não houver estado de depuração salvo
  }
  
  // Método para limpar a configuração de depuração
  static Future<void> clearDebugState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('debug_event_state');
  }
}

class EventHome extends StatefulWidget {
  const EventHome({Key? key}) : super(key: key);

  @override
  State<EventHome> createState() => _EventHomeState();
}

class _EventHomeState extends State<EventHome> {
  EventState _currentState = EventState.before;
  int _daysRemaining = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadEventState();
  }

  // Carrega o estado do evento
  Future<void> _loadEventState() async {
    // Verifica se há um estado de depuração ativo
    final debugState = await EventDateManager.loadDebugState();
    
    setState(() {
      // Usa o estado de depuração se estiver disponível, senão usa o estado real
      _currentState = debugState ?? EventDateManager.getCurrentEventState();
      _daysRemaining = EventDateManager.getDaysRemaining();
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Mostra um indicador de carregamento enquanto determina o estado
    if (_isLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

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
                                    size: 18,
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
                                    size: 18,
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
                      
                      // Widget específico baseado na fase do evento
                      // Aqui chamamos o método que retorna o widget adequado
                      _getEventSpecificWidgets(),
                      
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
      
      // Botão de debug flutuante
      floatingActionButton: FloatingActionButton(
        mini: true,
        onPressed: _showDebugOptions,
        child: Icon(Icons.bug_report),
        backgroundColor: Colors.grey.withOpacity(0.7),
      ),
    );
  }

  // Método para mostrar opções de debug
  void _showDebugOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'debuga ai sua otaria',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => _setDebugState(EventState.before),
                  child: Text('before'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _currentState == EventState.before 
                        ? Colors.red.shade800 
                        : Colors.grey,
                  ),
                ),
                ElevatedButton(
                  onPressed: () => _setDebugState(EventState.during),
                  child: Text('during'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _currentState == EventState.during 
                        ? Colors.red.shade800 
                        : Colors.grey,
                  ),
                ),
                ElevatedButton(
                  onPressed: () => _setDebugState(EventState.after),
                  child: Text('after'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _currentState == EventState.after 
                        ? Colors.red.shade800 
                        : Colors.grey,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            TextButton(
              onPressed: () async {
                await EventDateManager.clearDebugState();
                _loadEventState();
                Navigator.pop(context);
              },
              child: Text('data real'),
            ),
          ],
        ),
      ),
    );
  }
  
  // Método para definir o estado de debug
  Future<void> _setDebugState(EventState state) async {
    await EventDateManager.saveDebugState(state);
    await _loadEventState();
    Navigator.pop(context);
  }

  // Método que retorna os widgets específicos com base na fase atual do evento
  Widget _getEventSpecificWidgets() {
    switch (_currentState) {
      case EventState.before:
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: _buildBeforeEventWidgets(),
        );
      case EventState.during:
        return _buildDuringEventWidgets();
      case EventState.after:
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: _buildAfterEventWidgets(),
        );
      default:
        return Container();
    }
  }

  // WIDGET PARA ANTES DO EVENTO - Contador regressivo
  Widget _buildBeforeEventWidgets() {
    return _buildCounter();
  }

  // WIDGET PARA DURANTE O EVENTO - Transmissão ao vivo e widget do cantor
  Widget _buildDuringEventWidgets() {
    return Column(
      children: [
        // Widget de Transmissão ao Vivo
        const SizedBox(height: 1),
        GestureDetector(
          onTap: () {
            print('Abrindo transmissão ao vivo');
          },
          child: Container(
            width: MediaQuery.of(context).size.width * 0.83,
            height: 55,
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color.fromARGB(42, 102, 42, 42),
                  const Color.fromARGB(96, 110, 30, 30),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              border: Border.all(
                color: const Color.fromARGB(0, 255, 209, 209),
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(25),
            ),
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'TRANSMISSÃO AO VIVO',
                  style: TextStyle(
                    color: Color.fromARGB(255, 255, 82, 70),
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'TOQUE PARA ABRIR',
                  style: TextStyle(
                    color: Color.fromARGB(255, 184, 184, 184),
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Widget do cantor
        const SizedBox(height: 10),
        _buildSingerWidgetWithBackground(
          context: context,
          number: '615',
          name: 'Gustavo Maekawa Harano',
          music: 'KONO INORI - この祈り～ THE PRAYER ～',
          category: 'ADULTO A',
        ),

        const SizedBox(height: 20),
      ],
    );
  }

  // WIDGET PARA APÓS O EVENTO - Agradecimento
  Widget _buildAfterEventWidgets() {
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

  // Widget do contador (antes do evento)
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
                'assets/images/counter_widget.png',
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Número (centralizado no topo)
          Positioned(
            top: 48,
            left: 0,
            right: 0,
            child: Text(
              _daysRemaining.toString(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 100,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget do cantor (durante o evento)
  Widget _buildSingerWidgetWithBackground({
    required BuildContext context,
    required String number,
    required String name,
    required String music,
    required String category,
  }) {
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
                'assets/images/widget.png',
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Número (centralizado no topo)
          Positioned(
            top: 48,
            left: 0,
            right: 0,
            child: Text(
              number,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 90,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // Categoria (logo abaixo do número)
          Positioned(
            top: 154,
            left: 0,
            right: 0,
            child: Text(
              category,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // Nome (em cima, do lado esquerdo)
          Positioned(
            bottom: 115,
            left: 35,
            right: 60,
            child: Text(
              name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // Música (centralizado horizontalmente)
          Positioned(
            bottom: 43,
            left: 0,
            right: 0,
            child: Text(
              music,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          // Regional (lado direito inferior) - de acordo com a regional do cantor
          Positioned(
            bottom: 107,
            right: 35,
            child: CircleAvatar(
              radius: 22,
              backgroundColor: const Color.fromARGB(255, 255, 255, 255),
              child: Padding(
                padding: const EdgeInsets.all(0), // Remove o padding interno
                  child: Image.asset(
                    'assets/images/higashi.png',
                    fit: BoxFit.cover,
                    height: 44,
                    width: 44,
                  )
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget de ícone da navegação
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

  // Widget de ícone do logo
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