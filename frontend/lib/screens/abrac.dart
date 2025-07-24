import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter/services.dart' show rootBundle, ByteData;
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

class AbracPage extends StatefulWidget {
  const AbracPage({super.key});

  @override
  State<AbracPage> createState() => _AbracPageState();
}

class _AbracPageState extends State<AbracPage> {
  // Variável para controlar qual botão de menu está selecionado
  bool _isMenuSelected = true;

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
                                child: TextButton(
                                  onPressed: () {
                                    setState(() {
                                      _isMenuSelected = true;
                                    });
                                  },
                                  child: const Text(
                                    'ABRAC 2025',
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
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Text(
                                      'MENU',
                                      style: TextStyle(
                                        color: Color.fromARGB(255, 255, 255, 255),
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      
                      // Widget da ABRAC com botões clicáveis
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Imagem do widget (sem modificação)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.asset(
                                'assets/images/abrac_wid.png',
                                fit: BoxFit.contain,
                              ),
                            ),
                            
                            // Áreas clicáveis sobrepostas aos botões existentes
                            // LISTA DE CANTORES
                            Positioned(
                              top: 196,
                              left: 22,
                              child: _buildClickableArea(
                                width: 165, 
                                height: 38,
                                onTap: () => _openPDF('lista_cantores'),
                              ),
                            ),
                            
                            // CRONOGRAMA
                            Positioned(
                              top: 196,
                              right: 28,
                              child: _buildClickableArea(
                                width: 165,
                                height: 38,
                                onTap: () => _openPDF('cronograma'),
                              ),
                            ),
                            
                            // COMISSÃO ORGANIZADORA
                            Positioned(
                              top: 246,
                              left: 22,
                              child: _buildClickableArea(
                                width: 165,
                                height: 48,
                                onTap: () => _openPDF('comissao_organizadora'),
                              ),
                            ),
                            
                            // COMISSÃO JULGADORA
                            Positioned(
                              top: 246,
                              right: 28,
                              child: _buildClickableArea(
                                width: 165,
                                height: 48,
                                onTap: () => _openPDF('comissao_julgadora'),
                              ),
                            ),
                            
                            // TRANSMISSÃO AO VIVO
                            Positioned(
                              top: 312,
                              left: 22,
                              child: _buildClickableArea(
                                width: 165,
                                height: 48,
                                onTap: () => _navigateTo('transmissao_ao_vivo'),
                              ),
                            ),
                            
                            // REGULAMENTOS
                            Positioned(
                              top: 312,
                              right: 28,
                              child: _buildClickableArea(
                                width: 165,
                                height: 48,
                                onTap: () => _openPDF('regulamentos'),
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  // Widget para criar áreas clicáveis
  Widget _buildClickableArea({
    required double width,
    required double height,
    required VoidCallback onTap,
    bool showDebug = false, // activate for debug
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        // Durante o desenvolvimento, defina showDebug como true para
        // visualizar as áreas clicáveis
        color: showDebug ? Colors.red.withOpacity(0.3) : Colors.transparent,
      ),
    );
  }
  
  // Função para abrir PDFs
  void _openPDF(String pdfId) async {
    // Mostrar indicador de carregamento
    _showLoadingDialog();

    try {
      // Determinar o caminho do PDF
      String pdfPath = await _getPDFPath(pdfId);
      
      // Fechar o diálogo de carregamento
      Navigator.pop(context);
      
      // Navegar para a tela do visualizador de PDF
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PDFViewerScreen(
            pdfPath: pdfPath,
            title: _getTitleFromId(pdfId),
          ),
        ),
      );
    } catch (e) {
      // Fechar o diálogo de carregamento
      Navigator.pop(context);
      
      // Mostrar erro
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao abrir PDF: $e')),
      );
    }
  }
  
// Método para obter o caminho do PDF
Future<String> _getPDFPath(String pdfId) async {
  try {
    // Definir os nomes dos arquivos
    String assetPath = 'assets/pdfs/$pdfId.pdf';
    
    // Obter diretório para armazenar o PDF
    final directory = await getApplicationDocumentsDirectory();
    String targetPath = '${directory.path}/$pdfId.pdf';
    
    // Verificar se o arquivo já existe no armazenamento local
    File targetFile = File(targetPath);
    if (!await targetFile.exists()) {
      // Carregar o PDF dos assets para a memória
      ByteData data = await rootBundle.load(assetPath);
      
      // Escrever os bytes no sistema de arquivos
      List<int> bytes = data.buffer.asUint8List();
      await targetFile.writeAsBytes(bytes);
    }
    
    // Retornar o caminho do arquivo local
    return targetPath;
  } catch (e) {
    print('Erro ao carregar PDF: $e');
    rethrow;
  }
}

  // Método para obter o título baseado no ID
  String _getTitleFromId(String pdfId) {
    switch (pdfId) {
      case 'lista_cantores':
        return 'Lista de Cantores';
      case 'cronograma':
        return 'Cronograma';
      case 'comissao_organizadora':
        return 'Comissão Organizadora';
      case 'comissao_julgadora':
        return 'Comissão Julgadora';
      case 'regulamentos':
        return 'Regulamentos';
      default:
        return 'Documento';
    }
  }
  
  // Diálogo de carregamento
  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
        ),
      ),
    );
  }
  
  // Função para navegar para a página de transmissão ao vivo
  void _navigateTo(String destination) {
    // Feedback visual temporário (opcional)
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Navegando para $destination'),
        duration: Duration(seconds: 1),
      ),
    );
    
    // Implementar navegação para transmissão ao vivo
    // Por enquanto, mostra o diálogo informativo
    _showInfoDialog('Transmissão ao Vivo', 'Aqui será exibida a transmissão ao vivo do evento.');
  }
  
  // Dialog temporário para feedback
  void _showInfoDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

// Tela para visualização de PDF
class PDFViewerScreen extends StatefulWidget {
  final String pdfPath;
  final String title;

  const PDFViewerScreen({
    required this.pdfPath,
    required this.title,
    Key? key,
  }) : super(key: key);

  @override
  State<PDFViewerScreen> createState() => _PDFViewerScreenState();
}

class _PDFViewerScreenState extends State<PDFViewerScreen> {
  int _totalPages = 0;
  int _currentPage = 0;
  bool _isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.red.shade800,
      ),
      body: Stack(
        children: [
          // Visualizador de PDF
          PDFView(
            filePath: widget.pdfPath,
            enableSwipe: true,
            swipeHorizontal: false,
            autoSpacing: false,
            pageFling: true,
            pageSnap: true,
            onRender: (pages) {
              setState(() {
                _totalPages = pages!;
                _isLoading = false;
              });
            },
            onError: (error) {
              setState(() {
                _isLoading = false;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Erro ao carregar PDF: $error')),
              );
            },
            onPageChanged: (page, total) {
              setState(() {
                _currentPage = page!;
              });
            },
          ),
          
          // Indicador de carregamento
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
              ),
            ),
            
          // Indicador de página
          if (!_isLoading)
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Página ${_currentPage + 1} de $_totalPages',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}