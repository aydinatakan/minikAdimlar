import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:audioplayers/audioplayers.dart';
import '../../core/constants/app_constants.dart';
import '../../models/models.dart';
import 'dart:math';

class AnimalSoundsScreen extends StatefulWidget {
  const AnimalSoundsScreen({super.key});

  @override
  State<AnimalSoundsScreen> createState() => _AnimalSoundsScreenState();
}

class _AnimalSoundsScreenState extends State<AnimalSoundsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<Animal> _animals = [
    Animal(id: 'a1', name: 'Kedi', emoji: '🐱', soundText: 'Miyav', audioPath: 'assets/animal_sounds/kedi.mp3'),
    Animal(id: 'a2', name: 'Köpek', emoji: '🐶', soundText: 'Hav Hav', audioPath: 'assets/animal_sounds/kopek.mp3'),
    Animal(id: 'a3', name: 'İnek', emoji: '🐮', soundText: 'Möö', audioPath: 'assets/animal_sounds/inek.mp3'),
    Animal(id: 'a4', name: 'Koyun', emoji: '🐑', soundText: 'Mee', audioPath: 'assets/animal_sounds/koyun.mp3'),
    Animal(id: 'a5', name: 'Keçi', emoji: '🐐', soundText: 'Bee', audioPath: 'assets/animal_sounds/keci.mp3'),
    Animal(id: 'a6', name: 'At', emoji: '🐴', soundText: 'İhihi', audioPath: 'assets/animal_sounds/at.mp3'),
    Animal(id: 'a7', name: 'Eşek', emoji: '🫏', soundText: 'A-ii', audioPath: 'assets/animal_sounds/esek.mp3'),
    Animal(id: 'a8', name: 'Tavuk', emoji: '🐔', soundText: 'Gıt gıt gidak', audioPath: 'assets/animal_sounds/tavuk.mp3'),
    Animal(id: 'a9', name: 'Horoz', emoji: '🐓', soundText: 'Ürüüürüüü', audioPath: 'assets/animal_sounds/horoz.mp3'),
    Animal(id: 'a10', name: 'Ördek', emoji: '🦆', soundText: 'Vak vak', audioPath: 'assets/animal_sounds/ordek.mp3'),
    Animal(id: 'a11', name: 'Kuş', emoji: '🐦', soundText: 'Cik cik', audioPath: 'assets/animal_sounds/kus.mp3'),
    Animal(id: 'a12', name: 'Aslan', emoji: '🦁', soundText: 'Roar', audioPath: 'assets/animal_sounds/aslan.mp3'),
    Animal(id: 'a13', name: 'Fil', emoji: '🐘', soundText: 'Pa-uuu', audioPath: 'assets/animal_sounds/fil.mp3'),
    Animal(id: 'a14', name: 'Maymun', emoji: '🐵', soundText: 'U-u-a-a', audioPath: 'assets/animal_sounds/maymun.mp3'),
    Animal(id: 'a15', name: 'Kurbağa', emoji: '🐸', soundText: 'Vırak vırak', audioPath: 'assets/animal_sounds/kurbaga.mp3'),
    Animal(id: 'a16', name: 'Arı', emoji: '🐝', soundText: 'Vızzz', audioPath: 'assets/animal_sounds/ari.mp3'),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hayvan Sesleri 🐾'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: Colors.grey,
          indicatorColor: AppColors.primary,
          tabs: const [
            Tab(text: 'Tanıyalım'),
            Tab(text: 'Mini Oyun'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildGallery(),
          _buildGame(),
        ],
      ),
    );
  }

  Widget _buildGallery() {
    return GridView.builder(
      padding: const EdgeInsets.all(24),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.85,
      ),
      itemCount: _animals.length,
      itemBuilder: (context, index) {
        final animal = _animals[index];
        return AnimalCard(animal: animal);
      },
    );
  }

  Widget _buildGame() {
    return AnimalGameView(animals: _animals);
  }
}

class AnimalCard extends StatelessWidget {
  final Animal animal;
  final AudioPlayer _player = AudioPlayer();
  final FlutterTts _tts = FlutterTts();

  AnimalCard({super.key, required this.animal}) {
    _tts.setLanguage("tr-TR");
  }

  void _playSound() async {
    if (animal.audioPath != null) {
      try {
        await _player.play(AssetSource(animal.audioPath!.replaceFirst('assets/', '')));
      } catch (e) {
        _tts.speak("${animal.name}, ${animal.soundText}");
      }
    } else {
      _tts.speak("${animal.name}, ${animal.soundText}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(animal.emoji, style: const TextStyle(fontSize: 50)),
          const SizedBox(height: 8),
          Text(
            animal.name,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 12),
          IconButton(
            onPressed: _playSound,
            icon: const Icon(Icons.volume_up, color: AppColors.primary, size: 32),
            style: IconButton.styleFrom(
              backgroundColor: AppColors.inputBackground,
              padding: const EdgeInsets.all(12),
            ),
          ),
        ],
      ),
    );
  }
}

class AnimalGameView extends StatefulWidget {
  final List<Animal> animals;
  const AnimalGameView({super.key, required this.animals});

  @override
  State<AnimalGameView> createState() => _AnimalGameViewState();
}

class _AnimalGameViewState extends State<AnimalGameView> {
  final AudioPlayer _player = AudioPlayer();
  final FlutterTts _tts = FlutterTts();
  late Animal _correctAnimal;
  late List<Animal> _options;
  int? _selectedIndex;
  bool _showResult = false;

  @override
  void initState() {
    super.initState();
    _tts.setLanguage("tr-TR");
    _generateQuestion();
  }

  void _generateQuestion() {
    final random = Random();
    _correctAnimal = widget.animals[random.nextInt(widget.animals.length)];
    
    List<Animal> otherAnimals = widget.animals.where((a) => a.id != _correctAnimal.id).toList();
    otherAnimals.shuffle();
    _options = [
      _correctAnimal,
      otherAnimals[0],
      otherAnimals[1],
    ];
    _options.shuffle();
    
    _selectedIndex = null;
    _showResult = false;
    setState(() {});
    
    // Play sound after a small delay
    Future.delayed(const Duration(milliseconds: 500), _playSound);
  }

  void _playSound() async {
    if (_correctAnimal.audioPath != null) {
      try {
        await _player.play(AssetSource(_correctAnimal.audioPath!.replaceFirst('assets/', '')));
      } catch (e) {
        _tts.speak(_correctAnimal.soundText);
      }
    } else {
      _tts.speak(_correctAnimal.soundText);
    }
  }

  void _handleOptionTap(int index) {
    if (_showResult) return;
    setState(() {
      _selectedIndex = index;
      _showResult = true;
    });
    
    if (_options[index].id == _correctAnimal.id) {
      _tts.speak("Harika! Doğru cevap.");
    } else {
      _tts.speak("Yanlış cevap. Bu bir ${_correctAnimal.name}.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          const Text(
            "Sesi Dinle ve Hayvanı Bul! 🔊",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 32),
          
          InkWell(
            onTap: _playSound,
            borderRadius: BorderRadius.circular(50),
            child: Container(
              width: 100,
              height: 100,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.play_arrow, size: 60, color: Colors.white),
            ),
          ),
          const SizedBox(height: 40),
          
          Expanded(
            child: ListView.builder(
              itemCount: _options.length,
              itemBuilder: (context, index) {
                final animal = _options[index];
                final isSelected = _selectedIndex == index;
                final isCorrect = animal.id == _correctAnimal.id;
                
                Color bgColor = Colors.white;
                if (_showResult) {
                  if (isCorrect) bgColor = Colors.green.shade100;
                  else if (isSelected) bgColor = Colors.red.shade100;
                }

                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: InkWell(
                    onTap: () => _handleOptionTap(index),
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: bgColor,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: _showResult && isCorrect ? Colors.green : Colors.grey.shade300,
                          width: 2,
                        ),
                      ),
                      child: Row(
                        children: [
                          Text(animal.emoji, style: const TextStyle(fontSize: 40)),
                          const SizedBox(width: 16),
                          Text(
                            animal.name,
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const Spacer(),
                          if (_showResult && isCorrect) const Icon(Icons.check_circle, color: Colors.green),
                          if (_showResult && isSelected && !isCorrect) const Icon(Icons.cancel, color: Colors.red),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          
          if (_showResult)
            ElevatedButton(
              onPressed: _generateQuestion,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: const Text("Sonraki Soru"),
            ),
        ],
      ),
    );
  }
}
