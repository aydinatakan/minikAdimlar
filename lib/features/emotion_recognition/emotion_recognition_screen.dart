import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../../core/constants/app_constants.dart';
import '../../models/models.dart';

class EmotionRecognitionScreen extends StatefulWidget {
  const EmotionRecognitionScreen({super.key});

  @override
  State<EmotionRecognitionScreen> createState() => _EmotionRecognitionScreenState();
}

class _EmotionRecognitionScreenState extends State<EmotionRecognitionScreen> {
  final FlutterTts _tts = FlutterTts();
  int _currentIndex = 0;
  int? _selectedIndex;
  bool _showResult = false;

  final List<EmotionQuestion> _questions = [
    EmotionQuestion(
      id: 'em_01',
      question: 'Bu çocuk nasıl hissediyor?',
      emoji: '😊',
      options: ['Mutlu', 'Üzgün', 'Kızgın', 'Korkmuş'],
      correctAnswer: 'Mutlu',
      correctIndex: 0,
    ),
    EmotionQuestion(
      id: 'em_02',
      question: 'Bu çocuk nasıl hissediyor?',
      emoji: '😢',
      options: ['Şaşkın', 'Üzgün', 'Heyecanlı', 'Mutlu'],
      correctAnswer: 'Üzgün',
      correctIndex: 1,
    ),
    EmotionQuestion(
      id: 'em_03',
      question: 'Bu çocuk nasıl hissediyor?',
      emoji: '😡',
      options: ['Yorgun', 'Korkmuş', 'Kızgın', 'Sakin'],
      correctAnswer: 'Kızgın',
      correctIndex: 2,
    ),
    EmotionQuestion(
      id: 'em_04',
      question: 'Bu çocuk nasıl hissediyor?',
      emoji: '😱',
      options: ['Korkmuş', 'Mutlu', 'Uykulu', 'Ağlayan'],
      correctAnswer: 'Korkmuş',
      correctIndex: 0,
    ),
    EmotionQuestion(
      id: 'em_05',
      question: 'Bu çocuk nasıl hissediyor?',
      emoji: '😲',
      options: ['Üzgün', 'Şaşkın', 'Kızgın', 'Sakin'],
      correctAnswer: 'Şaşkın',
      correctIndex: 1,
    ),
    EmotionQuestion(
      id: 'em_06',
      question: 'Bu çocuk nasıl hissediyor?',
      emoji: '🤩',
      options: ['Yorgun', 'Korkmuş', 'Heyecanlı', 'Utangaç'],
      correctAnswer: 'Heyecanlı',
      correctIndex: 2,
    ),
    EmotionQuestion(
      id: 'em_07',
      question: 'Bu çocuk nasıl hissediyor?',
      emoji: '😴',
      options: ['Mutlu', 'Uykulu', 'Kızgın', 'Şaşkın'],
      correctAnswer: 'Uykulu',
      correctIndex: 1,
    ),
    EmotionQuestion(
      id: 'em_08',
      question: 'Bu çocuk nasıl hissediyor?',
      emoji: '😫',
      options: ['Yorgun', 'Gülen', 'Heyecanlı', 'Sakin'],
      correctAnswer: 'Yorgun',
      correctIndex: 0,
    ),
    EmotionQuestion(
      id: 'em_09',
      question: 'Bu çocuk nasıl hissediyor?',
      emoji: '😌',
      options: ['Kızgın', 'Korkmuş', 'Sakin', 'Ağlayan'],
      correctAnswer: 'Sakin',
      correctIndex: 2,
    ),
    EmotionQuestion(
      id: 'em_10',
      question: 'Bu çocuk nasıl hissediyor?',
      emoji: '😭',
      options: ['Ağlayan', 'Mutlu', 'Şaşkın', 'Heyecanlı'],
      correctAnswer: 'Ağlayan',
      correctIndex: 0,
    ),
    EmotionQuestion(
      id: 'em_11',
      question: 'Bu çocuk nasıl hissediyor?',
      emoji: '😄',
      options: ['Üzgün', 'Gülen', 'Korkmuş', 'Yorgun'],
      correctAnswer: 'Gülen',
      correctIndex: 1,
    ),
    EmotionQuestion(
      id: 'em_12',
      question: 'Bu çocuk nasıl hissediyor?',
      emoji: '😊',
      options: ['Utangaç', 'Mutlu', 'Kızgın', 'Şaşkın'],
      correctAnswer: 'Utangaç',
      correctIndex: 0,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tts.setLanguage("tr-TR");
  }

  void _handleOptionTap(int index) {
    if (_showResult) return;
    setState(() {
      _selectedIndex = index;
      _showResult = true;
    });
    
    final current = _questions[_currentIndex];
    if (index == current.correctIndex) {
      _tts.speak("Harika! Doğru cevap.");
    } else {
      _tts.speak("Yanlış cevap. Doğru cevap ${current.correctAnswer} olmalıydı.");
    }
  }

  void _nextQuestion() {
    setState(() {
      if (_currentIndex < _questions.length - 1) {
        _currentIndex++;
        _selectedIndex = null;
        _showResult = false;
      } else {
        // Reset or finish
        _currentIndex = 0;
        _selectedIndex = null;
        _showResult = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final current = _questions[_currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Duygu Tanıma 🎭'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // Question Counter
            Text(
              "Soru ${_currentIndex + 1} / ${_questions.length}",
              style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            
            // Emoji Display
            Container(
              width: double.infinity,
              height: 200,
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
              child: Center(
                child: Text(
                  current.emoji,
                  style: const TextStyle(fontSize: 100),
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // Question Text
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    current.question,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  onPressed: () => _tts.speak(current.question),
                  icon: const Icon(Icons.volume_up, color: AppColors.primary),
                ),
              ],
            ),
            const SizedBox(height: 32),
            
            // Options
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 2,
                ),
                itemCount: current.options.length,
                itemBuilder: (context, index) {
                  final isSelected = _selectedIndex == index;
                  final isCorrect = index == current.correctIndex;
                  
                  Color bgColor = Colors.white;
                  if (_showResult) {
                    if (isCorrect) bgColor = Colors.green.shade100;
                    else if (isSelected) bgColor = Colors.red.shade100;
                  }

                  return InkWell(
                    onTap: () => _handleOptionTap(index),
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      decoration: BoxDecoration(
                        color: bgColor,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: _showResult && isCorrect ? Colors.green : Colors.grey.shade300,
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          current.options[index],
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: _showResult && isCorrect ? Colors.green.shade800 : Colors.black87,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            
            // Next Button
            if (_showResult)
              ElevatedButton(
                onPressed: _nextQuestion,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: Text(_currentIndex < _questions.length - 1 ? "Sonraki Soru" : "Tekrar Başla"),
              ),
          ],
        ),
      ),
    );
  }
}
