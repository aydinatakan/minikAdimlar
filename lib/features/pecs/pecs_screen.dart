import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_constants.dart';
import '../../services/firebase_service.dart';
import '../../models/models.dart';

class PecsScreen extends StatefulWidget {
  const PecsScreen({super.key});

  @override
  State<PecsScreen> createState() => _PecsScreenState();
}

class _PecsScreenState extends State<PecsScreen> {
  final FlutterTts _tts = FlutterTts();
  List<PecsCard> _cards = [];
  bool _isLoading = true;
  String _selectedCategory = 'Temel İhtiyaçlar';

  final List<String> _categories = [
    'Temel İhtiyaçlar',
    'Duygular',
    'Sosyal İletişim',
    'Sağlık',
    'İstekler',
  ];

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
      var cards = await service.getPecsCards();
      if (cards.isEmpty) {
        await _seedData();
        cards = await service.getPecsCards();
      }
      setState(() {
        _cards = cards;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _seedData() async {
    final service = Provider.of<FirestoreService>(context, listen: false);
    final List<Map<String, dynamic>> initialData = [
      // Temel İhtiyaçlar
      {'id': 'p_01', 'title': 'Su istiyorum', 'icon': '💧', 'category': 'Temel İhtiyaçlar'},
      {'id': 'p_02', 'title': 'Acıktım', 'icon': '🍎', 'category': 'Temel İhtiyaçlar'},
      {'id': 'p_03', 'title': 'Tuvalete gitmek istiyorum', 'icon': '🚽', 'category': 'Temel İhtiyaçlar'},
      {'id': 'p_04', 'title': 'Yardım istiyorum', 'icon': '🙋‍♂️', 'category': 'Temel İhtiyaçlar'},
      {'id': 'p_05', 'title': 'Uyumak istiyorum', 'icon': '😴', 'category': 'Temel İhtiyaçlar'},
      {'id': 'p_06', 'title': 'Dinlenmek istiyorum', 'icon': '🛋️', 'category': 'Temel İhtiyaçlar'},
      // Duygular
      {'id': 'p_07', 'title': 'Mutluyum', 'icon': '😊', 'category': 'Duygular'},
      {'id': 'p_08', 'title': 'Üzgünüm', 'icon': '😢', 'category': 'Duygular'},
      {'id': 'p_09', 'title': 'Korktum', 'icon': '😨', 'category': 'Duygular'},
      {'id': 'p_10', 'title': 'Sinirlendim', 'icon': '😡', 'category': 'Duygular'},
      {'id': 'p_11', 'title': 'Heyecanlıyım', 'icon': '🤩', 'category': 'Duygular'},
      // Sosyal
      {'id': 'p_12', 'title': 'Merhaba', 'icon': '👋', 'category': 'Sosyal İletişim'},
      {'id': 'p_13', 'title': 'Teşekkür ederim', 'icon': '🙏', 'category': 'Sosyal İletişim'},
      {'id': 'p_14', 'title': 'Lütfen', 'icon': '🥺', 'category': 'Sosyal İletişim'},
      {'id': 'p_15', 'title': 'Oyun oynayalım', 'icon': '⚽', 'category': 'Sosyal İletişim'},
      {'id': 'p_16', 'title': 'Sarılmak istiyorum', 'icon': '🫂', 'category': 'Sosyal İletişim'},
      // Sağlık
      {'id': 'p_17', 'title': 'Karnım ağrıyor', 'icon': '🤢', 'category': 'Sağlık'},
      {'id': 'p_18', 'title': 'Başım ağrıyor', 'icon': '🤕', 'category': 'Sağlık'},
      {'id': 'p_19', 'title': 'Yoruldum', 'icon': '😫', 'category': 'Sağlık'},
      {'id': 'p_20', 'title': 'Hastayım', 'icon': '🤒', 'category': 'Sağlık'},
      // İstekler
      {'id': 'p_21', 'title': 'Müzik aç', 'icon': '🎵', 'category': 'İstekler'},
      {'id': 'p_22', 'title': 'Hikaye dinlemek istiyorum', 'icon': '📖', 'category': 'İstekler'},
      {'id': 'p_23', 'title': 'Dışarı çıkmak istiyorum', 'icon': '🌳', 'category': 'İstekler'},
      {'id': 'p_24', 'title': 'Oyuncak istiyorum', 'icon': '🧸', 'category': 'İstekler'},
    ];
    await service.uploadPecs(initialData);
  }

  void _onCardTap(PecsCard card) {
    _tts.speak(card.title);
  }

  @override
  Widget build(BuildContext context) {
    final filteredCards = _cards.where((c) => c.category == _selectedCategory).toList();

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
                  Text("İletişim Kartları 💬", style: Theme.of(context).textTheme.headlineSmall),
                ],
              ),
            ),
            
            // Categories
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: _categories.map((cat) {
                  final isSelected = _selectedCategory == cat;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(cat),
                      selected: isSelected,
                      onSelected: (val) => setState(() => _selectedCategory = cat),
                      selectedColor: const Color(0xFFFDBA74),
                      labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black87),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),

            Expanded(
              child: _isLoading 
                ? const Center(child: CircularProgressIndicator())
                : GridView.builder(
                    padding: const EdgeInsets.all(24),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.9,
                    ),
                    itemCount: filteredCards.length,
                    itemBuilder: (context, index) {
                      final card = filteredCards[index];
                      return InkWell(
                        onTap: () => _onCardTap(card),
                        borderRadius: BorderRadius.circular(24),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
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
                              Text(card.icon, style: const TextStyle(fontSize: 56)),
                              const SizedBox(height: 12),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                child: Text(
                                  card.title,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
