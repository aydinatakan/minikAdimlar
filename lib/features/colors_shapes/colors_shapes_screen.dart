import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_constants.dart';
import '../../services/firebase_service.dart';
import '../../models/models.dart';

class ColorShapeScreen extends StatefulWidget {
  const ColorShapeScreen({super.key});

  @override
  State<ColorShapeScreen> createState() => _ColorShapeScreenState();
}

class _ColorShapeScreenState extends State<ColorShapeScreen> {
  final FlutterTts _tts = FlutterTts();
  List<ColorShapeQuestion> _questions = [];
  int _currentIndex = 0;
  String? _selectedAnswer;
  bool _showResult = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initTts();
    _loadData();
  }

  void _initTts() async {
    await _tts.setLanguage("tr-TR");
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    final service = Provider.of<FirestoreService>(context, listen: false);
    try {
      var questions = await service.getColorShapeQuestions();
      if (questions.isEmpty) {
        await _seedData();
        questions = await service.getColorShapeQuestions();
      }
      setState(() {
        _questions = questions;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _seedData() async {
    final service = Provider.of<FirestoreService>(context, listen: false);
    final List<Map<String, dynamic>> initialData = [
      {'id': 'cs_01', 'question': 'Kırmızı olanı seç.', 'type': 'color', 'options': ['Kırmızı', 'Mavi', 'Sarı'], 'correctAnswer': 'Kırmızı'},
      {'id': 'cs_02', 'question': 'Daireyi seç.', 'type': 'shape', 'options': ['Daire', 'Kare', 'Üçgen'], 'correctAnswer': 'Daire'},
      {'id': 'cs_03', 'question': 'Mavi rengi bul.', 'type': 'color', 'options': ['Yeşil', 'Mavi', 'Turuncu'], 'correctAnswer': 'Mavi'},
      {'id': 'cs_04', 'question': 'Yıldızı seç.', 'type': 'shape', 'options': ['Kalp', 'Yıldız', 'Kare'], 'correctAnswer': 'Yıldız'},
      {'id': 'cs_05', 'question': 'Kalbi bul.', 'type': 'shape', 'options': ['Üçgen', 'Daire', 'Kalp'], 'correctAnswer': 'Kalp'},
      {'id': 'cs_06', 'question': 'Yeşil olanı seç.', 'type': 'color', 'options': ['Pembe', 'Yeşil', 'Mor'], 'correctAnswer': 'Yeşil'},
    ];
    await service.uploadColorShapes(initialData);
  }

  void _onAnswerSelect(String answer) {
    if (_showResult) return;
    setState(() {
      _selectedAnswer = answer;
      _showResult = true;
    });
  }

  void _nextQuestion() {
    if (_currentIndex < _questions.length - 1) {
      setState(() {
        _currentIndex++;
        _selectedAnswer = null;
        _showResult = false;
      });
    } else {
      Navigator.pop(context);
    }
  }

  Color _getColor(String colorName) {
    switch (colorName) {
      case 'Kırmızı': return Colors.red;
      case 'Mavi': return Colors.blue;
      case 'Sarı': return Colors.yellow;
      case 'Yeşil': return Colors.green;
      case 'Turuncu': return Colors.orange;
      case 'Mor': return Colors.purple;
      case 'Pembe': return Colors.pink;
      default: return Colors.grey;
    }
  }

  Widget _getShapeIcon(String shapeName, Color color) {
    switch (shapeName) {
      case 'Daire': return Icon(Icons.circle, size: 64, color: color);
      case 'Kare': return Icon(Icons.square, size: 64, color: color);
      case 'Üçgen': return Icon(Icons.change_history, size: 64, color: color);
      case 'Yıldız': return Icon(Icons.star, size: 64, color: color);
      case 'Dikdörtgen': return Icon(Icons.rectangle, size: 64, color: color);
      case 'Kalp': return Icon(Icons.favorite, size: 64, color: color);
      default: return Icon(Icons.help, size: 64, color: color);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    if (_questions.isEmpty) return const Scaffold(body: Center(child: Text("Soru bulunamadı.")));

    final question = _questions[_currentIndex];

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back),
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.inputBackground,
                      padding: const EdgeInsets.all(12),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text("Renk ve Şekil 🎨", style: Theme.of(context).textTheme.headlineSmall),
                ],
              ),
            ),
            
            // Question Area
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      question.question,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    IconButton(
                      onPressed: () => _tts.speak(question.question),
                      icon: const Icon(Icons.volume_up, size: 32, color: AppColors.primary),
                    ),
                  ],
                ),
              ),
            ),
            
            const Spacer(),
            
            // Options
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: question.options.map((opt) {
                  final isCorrect = opt == question.correctAnswer;
                  final isSelected = _selectedAnswer == opt;
                  
                  Color borderColor = Colors.transparent;
                  if (_showResult) {
                    if (isCorrect) borderColor = Colors.green;
                    else if (isSelected) borderColor = Colors.red;
                  }

                  return GestureDetector(
                    onTap: () => _onAnswerSelect(opt),
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: borderColor, width: 4),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Center(
                        child: question.type == 'color'
                          ? Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: _getColor(opt),
                                borderRadius: BorderRadius.circular(12),
                              ),
                            )
                          : _getShapeIcon(opt, Colors.grey[700]!),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            
            const Spacer(),
            
            if (_showResult)
              Padding(
                padding: const EdgeInsets.all(32.0),
                child: ElevatedButton(
                  onPressed: _nextQuestion,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 56),
                  ),
                  child: Text(_currentIndex < _questions.length - 1 ? "Sonraki Soru" : "Bitir"),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
