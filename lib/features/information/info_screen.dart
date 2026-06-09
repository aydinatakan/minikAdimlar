import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';

class InfoScreen extends StatefulWidget {
  const InfoScreen({super.key});

  @override
  State<InfoScreen> createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  final List<Map<String, dynamic>> _topics = [
    {
      'title': 'Otizm Nedir?',
      'subtitle': 'Temel bilgiler ve belirtiler',
      'icon': Icons.psychology,
      'color': const Color(0xFF93C5FD),
      'content': 'Otizm spektrum bozukluğu (OSB), sosyal etkileşim, iletişim ve davranışlarda görülen farklılıklarla karakterize edilen gelişimsel bir durumdur.',
    },
    {
      'title': 'İletişim Stratejileri',
      'subtitle': 'Daha iyi etkileşim için ipuçları',
      'icon': Icons.forum,
      'color': const Color(0xFFC4B5FD),
      'content': 'Görsel destekler kullanmak, basit ve net cümleler kurmak ve sabırlı olmak iletişimde anahtar rol oynar.',
    },
    {
      'title': 'Duyusal Destek',
      'subtitle': 'Hassasiyetleri yönetmek',
      'icon': Icons.waves,
      'color': const Color(0xFFFDBA74),
      'content': 'Ses, ışık ve doku gibi duyusal uyaranlara karşı hassasiyeti anlamak ve uygun ortamlar oluşturmak önemlidir.',
    },
    {
      'title': 'Günlük Rutinler',
      'subtitle': 'Düzenli bir gün planlamak',
      'icon': Icons.calendar_today,
      'color': const Color(0xFF86EFAC),
      'content': 'Öngörülebilir rutinler, kaygıyı azaltmaya ve çocuğun günü daha rahat geçirmesine yardımcı olur.',
    },
  ];

  Map<String, dynamic>? _selectedTopic;

  @override
  Widget build(BuildContext context) {
    if (_selectedTopic != null) {
      return _buildDetailView();
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                  Text(
                    "Bilgilendirme 💡",
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemCount: _topics.length,
                itemBuilder: (context, index) {
                  final topic = _topics[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: InkWell(
                      onTap: () => setState(() => _selectedTopic = topic),
                      borderRadius: BorderRadius.circular(24),
                      child: Container(
                        padding: const EdgeInsets.all(20),
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
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: topic['color'].withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Icon(topic['icon'], color: topic['color'], size: 32),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    topic['title'],
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                  ),
                                  Text(
                                    topic['subtitle'],
                                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
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

  Widget _buildDetailView() {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => setState(() => _selectedTopic = null),
                    icon: const Icon(Icons.arrow_back),
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.inputBackground,
                      padding: const EdgeInsets.all(12),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 200,
                      decoration: BoxDecoration(
                        color: _selectedTopic!['color'].withOpacity(0.2),
                        borderRadius: BorderRadius.circular(32),
                      ),
                      child: Icon(_selectedTopic!['icon'], size: 100, color: _selectedTopic!['color']),
                    ),
                    const SizedBox(height: 32),
                    Text(
                      _selectedTopic!['title'],
                      style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _selectedTopic!['content'],
                      style: const TextStyle(fontSize: 18, color: AppColors.textPrimary, height: 1.6),
                    ),
                    const SizedBox(height: 32),
                    const Text(
                      "Önemli Notlar:",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    _buildNoteItem("Her çocuk benzersizdir."),
                    _buildNoteItem("Gelişim süreleri farklılık gösterebilir."),
                    _buildNoteItem("Profesyonel destek almak önemlidir."),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoteItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Color(0xFF86EFAC), size: 20),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 16))),
        ],
      ),
    );
  }
}
