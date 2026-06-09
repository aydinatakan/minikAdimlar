import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_constants.dart';
import '../../main.dart'; // To access AudioProvider

class VisualMatchingScreen extends StatefulWidget {
  const VisualMatchingScreen({super.key});

  @override
  State<VisualMatchingScreen> createState() => _VisualMatchingScreenState();
}

class _VisualMatchingScreenState extends State<VisualMatchingScreen> {
  int _currentQuestionIndex = 0;
  String? _selectedAnswer;
  bool _showResult = false;
  bool _isPlaying = false;

  final List<Map<String, dynamic>> _questions = [
    {
      'image': 'assets/images/elmagorsel.jpg',
      'audio': 'assets/audio/elma.mp3',
      'word': 'Elma',
      'options': [
        {'emoji': '🍎', 'label': 'Elma'},
        {'emoji': '🍐', 'label': 'Armut'},
        {'emoji': '🍇', 'label': 'Üzüm'},
      ],
      'correct': 'Elma',
    },
    {
      'image': 'assets/images/kedIgorsel.jpg',
      'audio': 'assets/audio/kedi.mp3',
      'word': 'Kedi',
      'options': [
        {'emoji': '🐶', 'label': 'Köpek'},
        {'emoji': '🐱', 'label': 'Kedi'},
        {'emoji': '🐦', 'label': 'Kuş'},
      ],
      'correct': 'Kedi',
    },
    {
      'image': 'assets/images/kopekgorsel.jpg',
      'audio': 'assets/audio/kopek.mp3',
      'word': 'Köpek',
      'options': [
        {'emoji': '🐱', 'label': 'Kedi'},
        {'emoji': '🐟', 'label': 'Balık'},
        {'emoji': '🐶', 'label': 'Köpek'},
      ],
      'correct': 'Köpek',
    },
    {
      'image': 'assets/images/armutgorsel.jpg',
      'audio': 'assets/audio/armut.mp3',
      'word': 'Armut',
      'options': [
        {'emoji': '🍌', 'label': 'Muz'},
        {'emoji': '🍐', 'label': 'Armut'},
        {'emoji': '🍎', 'label': 'Elma'},
      ],
      'correct': 'Armut',
    },
    {
      'image': 'assets/images/Inekgorsel.jpg',
      'audio': 'assets/audio/inek.mp3',
      'word': 'İnek',
      'options': [
        {'emoji': '🐮', 'label': 'İnek'},
        {'emoji': '🐑', 'label': 'Koyun'},
        {'emoji': '🐔', 'label': 'Tavuk'},
      ],
      'correct': 'İnek',
    },
    {
      'image': 'assets/images/esekgorsel.jpg',
      'audio': 'assets/audio/esek.mp3',
      'word': 'Eşek',
      'options': [
        {'emoji': '🐴', 'label': 'Eşek'},
        {'emoji': '🐎', 'label': 'At'},
        {'emoji': '🐐', 'label': 'Keçi'},
      ],
      'correct': 'Eşek',
    },
    {
      'image': 'assets/images/uzumgorsel.jpg',
      'audio': 'assets/audio/uzum.mp3',
      'word': 'Üzüm',
      'options': [
        {'emoji': '🍓', 'label': 'Çilek'},
        {'emoji': '🍉', 'label': 'Karpuz'},
        {'emoji': '🍇', 'label': 'Üzüm'},
      ],
      'correct': 'Üzüm',
    },
  ];

  void _handlePlaySound(String assetPath) {
    final audioProvider = Provider.of<AudioProvider>(context, listen: false);
    audioProvider.playAsset(assetPath);
    setState(() => _isPlaying = true);
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) setState(() => _isPlaying = false);
    });
  }

  void _handleAnswerSelect(String answer) {
    if (_showResult) return;
    setState(() {
      _selectedAnswer = answer;
      _showResult = true;
    });
  }

  void _handleNext() {
    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _selectedAnswer = null;
        _showResult = false;
      });
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final question = _questions[_currentQuestionIndex];
    final progress = (_currentQuestionIndex + 1) / _questions.length;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header with progress
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back),
                        style: IconButton.styleFrom(
                          backgroundColor: AppColors.inputBackground,
                          padding: const EdgeInsets.all(12),
                        ),
                      ),
                      Text(
                        "Soru ${_currentQuestionIndex + 1}/${_questions.length}",
                        style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 12,
                      backgroundColor: AppColors.inputBackground,
                      valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFA78BFA)),
                    ),
                  ),
                ],
              ),
            ),

            // Image Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
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
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(
                        question['image'],
                        height: 180,
                        width: double.infinity,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) => const Icon(Icons.image_not_supported, size: 100, color: Colors.grey),
                      ),
                    ),
                    const SizedBox(height: 24),
                    GestureDetector(
                      onTap: () => _handlePlaySound(question['audio']),
                      child: AnimatedScale(
                        scale: _isPlaying ? 1.1 : 1.0,
                        duration: const Duration(milliseconds: 200),
                        child: Container(
                          width: 64,
                          height: 64,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(colors: AppColors.violetGradient),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xFFA78BFA),
                                blurRadius: 10,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: const Icon(Icons.volume_up, color: Colors.white, size: 32),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Options
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemCount: question['options'].length,
                itemBuilder: (context, index) {
                  final option = question['options'][index];
                  final isSelected = _selectedAnswer == option['label'];
                  final isCorrect = option['label'] == question['correct'];
                  
                  Color bgColor = Colors.white;
                  Color borderColor = Colors.transparent;
                  Widget? trailing;

                  if (_showResult) {
                    if (isSelected) {
                      if (isCorrect) {
                        bgColor = const Color(0xFFDCFCE7);
                        borderColor = const Color(0xFF4ADE80);
                        trailing = const Icon(Icons.check_circle, color: Color(0xFF166534));
                      } else {
                        bgColor = const Color(0xFFFEE2E2);
                        borderColor = const Color(0xFFFB7185);
                        trailing = const Icon(Icons.cancel, color: Color(0xFF991B1B));
                      }
                    } else if (isCorrect) {
                      bgColor = const Color(0xFFDCFCE7);
                      borderColor = const Color(0xFF4ADE80).withOpacity(0.5);
                    }
                  }

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: InkWell(
                      onTap: () => _handleAnswerSelect(option['label']),
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                        decoration: BoxDecoration(
                          color: bgColor,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: borderColor, width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Text(option['emoji'], style: const TextStyle(fontSize: 32)),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                option['label'],
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                              ),
                            ),
                            if (trailing != null) trailing,
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Next Button
            if (_showResult)
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: ElevatedButton(
                  onPressed: _handleNext,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFA78BFA),
                    foregroundColor: Colors.white,
                  ),
                  child: Text(_currentQuestionIndex < _questions.length - 1 ? "Sonraki Soru" : "Bitir"),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
