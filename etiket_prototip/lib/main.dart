import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:typed_data';
import 'login_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'gemini_chat_screen.dart';
import 'groq_analysis_screen.dart';
import 'groq_service.dart';
import 'profile_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/home': (context) => const MyHomePage(),
        '/gemini': (context) => const GeminiChatScreen(),
        '/groq': (context) => const GroqAnalysisScreen(),
        '/profile': (context) => const ProfileScreen(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  XFile? _imageFile;
  Uint8List? _webImageBytes;
  String? _errorMessage;
  final ImagePicker _picker = ImagePicker();
  int _currentIndex = 0;
  String _recognizedText = '';
  bool _isProcessing = false;
  bool _isAnalyzingWithGroq = false;

  Future<void> _takePhoto() async {
    setState(() {
      _errorMessage = null;
      _recognizedText = '';
      _isProcessing = false;
    });
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 800,
        maxHeight: 800,
      );
      if (pickedFile != null) {
        if (kIsWeb) {
          final bytes = await pickedFile.readAsBytes();
          setState(() {
            _imageFile = pickedFile;
            _webImageBytes = bytes;
            _recognizedText = 'OCR işlemi web tarayıcısında desteklenmiyor. Lütfen mobil cihazda deneyin.';
          });
        } else {
          setState(() {
            _imageFile = pickedFile;
            _webImageBytes = null;
            _isProcessing = true;
          });
          await _recognizeText(pickedFile);
        }
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Fotoğraf yüklenirken hata oluştu: \n${e.toString()}';
      });
    }
  }

  Future<void> _recognizeText(XFile imageFile) async {
    try {
      final inputImage = InputImage.fromFilePath(imageFile.path);
      final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
      final recognizedText = await textRecognizer.processImage(inputImage);
      
      setState(() {
        _recognizedText = recognizedText.text;
        _isProcessing = false;
      });
      
      await textRecognizer.close();
    } catch (e) {
      setState(() {
        _recognizedText = 'Metin tanıma sırasında hata oluştu: ${e.toString()}';
        _isProcessing = false;
      });
    }
  }

  Future<void> _analyzeWithGroq() async {
    if (_recognizedText.isEmpty || _isAnalyzingWithGroq) return;

    setState(() {
      _isAnalyzingWithGroq = true;
    });

    try {
      final analysis = await GroqService.analyzeImageText(_recognizedText);
      setState(() {
        _recognizedText = '=== OCR SONUCU ===\n\n$_recognizedText\n\n=== GROQ ANALİZİ ===\n\n$analysis';
        _isAnalyzingWithGroq = false;
      });
    } catch (e) {
      setState(() {
        _recognizedText = '$_recognizedText\n\n=== GROQ ANALİZ HATASI ===\n\n${e.toString()}';
        _isAnalyzingWithGroq = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF6E3),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 32),
              // MERHABA! başlığı
              Text(
                'MERHABA!',
                style: GoogleFonts.quicksand(
                  color: const Color(0xFFF36A00),
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 40),
              // Karekod okuyan alan (buton gibi)
              GestureDetector(
                onTap: _takePhoto,
                child: Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: Image.asset(
                          'assets/kare.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                      
                      if (kIsWeb && _webImageBytes != null)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(18),
                          child: Image.memory(_webImageBytes!, fit: BoxFit.cover, width: 300, height: 300),
                        ),
                      if (!kIsWeb && _imageFile != null)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(18),
                          child: Image.file(File(_imageFile!.path), fit: BoxFit.cover, width: 300, height: 300),
                        ),
                    ],
                  ),
                ),
              ),
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
                ),
              
              // OCR sonucu gösterim alanı
              if (_isProcessing)
                const Padding(
                  padding: EdgeInsets.only(top: 16.0),
                  child: CircularProgressIndicator(),
                ),
              
              if (_recognizedText.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0, left: 20.0, right: 20.0),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Tanınan Metin:',
                              style: GoogleFonts.quicksand(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFFF36A00),
                              ),
                            ),
                            if (!_recognizedText.contains('=== GROQ ANALİZİ ==='))
                              SizedBox(
                                height: 32,
                                child: ElevatedButton(
                                  onPressed: _isAnalyzingWithGroq ? null : _analyzeWithGroq,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF379D6E),
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    padding: const EdgeInsets.symmetric(horizontal: 12),
                                  ),
                                  child: _isAnalyzingWithGroq
                                      ? const SizedBox(
                                          width: 16,
                                          height: 16,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                          ),
                                        )
                                      : Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Icon(Icons.analytics, size: 14),
                                            const SizedBox(width: 4),
                                            Text(
                                              'Groq ile Analiz',
                                              style: GoogleFonts.quicksand(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _recognizedText,
                          style: GoogleFonts.quicksand(
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              
              // AI Butonları
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 48,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFF36A00),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            Navigator.pushNamed(context, '/gemini');
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.chat, size: 18),
                              const SizedBox(width: 6),
                              Text(
                                'Snack AI',
                                style: GoogleFonts.quicksand(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SizedBox(
                        height: 48,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF379D6E),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            Navigator.pushNamed(context, '/groq');
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.analytics, size: 18),
                              const SizedBox(width: 6),
                              Text(
                                'Snack Analyzer',
                                style: GoogleFonts.quicksand(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Diğer içerikler aşağıya eklenebilir
              const Spacer(),
              Container(
                width: double.infinity,
                color: const Color(0xFF379D6E),
                padding: const EdgeInsets.only(top: 12, bottom: 8),
                child: Center(
                  child: SizedBox(
                    width: 220,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF379D6E),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          _currentIndex = 0;
                        });
                      },
                      child: Text(
                        'Ana Sayfa',
                        style: GoogleFonts.quicksand(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF379D6E),
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          
          // Navigate to different screens based on index
          if (index == 2) { // Profile tab
            Navigator.pushNamed(context, '/profile');
          }
        },
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Ana sayfa',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Geçmiş',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}


