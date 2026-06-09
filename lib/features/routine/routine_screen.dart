import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_constants.dart';
import '../../services/firebase_service.dart';
import '../../models/models.dart';

class RoutineScreen extends StatefulWidget {
  const RoutineScreen({super.key});

  @override
  State<RoutineScreen> createState() => _RoutineScreenState();
}

class _RoutineScreenState extends State<RoutineScreen> {
  final FlutterTts _tts = FlutterTts();
  List<RoutineTask> _tasks = [];
  final Set<String> _completedTaskIds = {};
  bool _isLoading = true;
  String _selectedCategory = 'Sabah Rutini';

  final List<String> _categories = [
    'Sabah Rutini',
    'Okul Rutini',
    'Akşam Rutini',
    'Hijyen Rutini',
  ];

  @override
  void initState() {
    super.initState();
    _initTts();
    _loadData();
  }

  void _initTts() async {
    await _tts.setLanguage("tr-TR");
    await _tts.setPitch(1.0);
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    final service = Provider.of<FirestoreService>(context, listen: false);
    try {
      var tasks = await service.getRoutineTasks();
      if (tasks.isEmpty) {
        await _seedData();
        tasks = await service.getRoutineTasks();
      }
      setState(() {
        _tasks = tasks;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _seedData() async {
    final service = Provider.of<FirestoreService>(context, listen: false);
    final List<Map<String, dynamic>> initialData = [
      // Sabah
      {'id': 'r_01', 'title': 'Uyan', 'icon': '⏰', 'category': 'Sabah Rutini', 'order': 1},
      {'id': 'r_02', 'title': 'Yatağını düzelt', 'icon': '🛏️', 'category': 'Sabah Rutini', 'order': 2},
      {'id': 'r_03', 'title': 'Dişlerini fırçala', 'icon': '🪥', 'category': 'Sabah Rutini', 'order': 3},
      {'id': 'r_04', 'title': 'Yüzünü yıka', 'icon': '🧼', 'category': 'Sabah Rutini', 'order': 4},
      {'id': 'r_05', 'title': 'Kahvaltı yap', 'icon': '🍳', 'category': 'Sabah Rutini', 'order': 5},
      {'id': 'r_06', 'title': 'Çantanı hazırla', 'icon': '🎒', 'category': 'Sabah Rutini', 'order': 6},
      {'id': 'r_07', 'title': 'Okula hazırlan', 'icon': '🏫', 'category': 'Sabah Rutini', 'order': 7},
      // Okul
      {'id': 'r_08', 'title': 'Öğretmeni dinle', 'icon': '👩‍🏫', 'category': 'Okul Rutini', 'order': 8},
      {'id': 'r_09', 'title': 'Arkadaşlarınla selamlaş', 'icon': '👋', 'category': 'Okul Rutini', 'order': 9},
      {'id': 'r_10', 'title': 'Kalemini hazırla', 'icon': '✏️', 'category': 'Okul Rutini', 'order': 10},
      {'id': 'r_11', 'title': 'Kitabını aç', 'icon': '📖', 'category': 'Okul Rutini', 'order': 11},
      // Akşam
      {'id': 'r_12', 'title': 'Ellerini yıka', 'icon': '🙌', 'category': 'Akşam Rutini', 'order': 12},
      {'id': 'r_13', 'title': 'Akşam yemeği ye', 'icon': '🍲', 'category': 'Akşam Rutini', 'order': 13},
      {'id': 'r_14', 'title': 'Oyuncaklarını topla', 'icon': '🧸', 'category': 'Akşam Rutini', 'order': 14},
      {'id': 'r_15', 'title': 'Pijamanı giy', 'icon': '👕', 'category': 'Akşam Rutini', 'order': 15},
      {'id': 'r_16', 'title': 'Hikaye dinle', 'icon': '🎧', 'category': 'Akşam Rutini', 'order': 16},
      {'id': 'r_17', 'title': 'Uyku zamanı', 'icon': '😴', 'category': 'Akşam Rutini', 'order': 17},
      // Hijyen
      {'id': 'r_18', 'title': 'Ellerini sabunla yıka', 'icon': '🧼', 'category': 'Hijyen Rutini', 'order': 18},
      {'id': 'r_19', 'title': 'Tırnaklarını kontrol et', 'icon': '💅', 'category': 'Hijyen Rutini', 'order': 19},
      {'id': 'r_20', 'title': 'Banyonu yap', 'icon': '🛁', 'category': 'Hijyen Rutini', 'order': 20},
    ];
    await service.uploadRoutines(initialData);
  }

  void _toggleTask(String id, String title) {
    setState(() {
      if (_completedTaskIds.contains(id)) {
        _completedTaskIds.remove(id);
      } else {
        _completedTaskIds.add(id);
        _tts.speak(title);
      }
    });

    final currentCategoryTasks = _tasks.where((t) => t.category == _selectedCategory).toList();
    final completedInCategory = currentCategoryTasks.where((t) => _completedTaskIds.contains(t.id)).length;

    if (completedInCategory == currentCategoryTasks.length && currentCategoryTasks.isNotEmpty) {
      _showSuccessDialog();
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text("Tebrikler! 🌟", textAlign: TextAlign.center),
        content: const Text("Harika! Bugünkü rutin tamamlandı.", textAlign: TextAlign.center),
        actions: [
          TextButton(
            onPressed: () {
              setState(() => _completedTaskIds.clear());
              Navigator.pop(context);
            },
            child: const Text("Tekrar Başlat"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Kapat"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredTasks = _tasks.where((t) => t.category == _selectedCategory).toList();

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
                  Text("Günlük Rutinim 📅", style: Theme.of(context).textTheme.headlineSmall),
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
                      selectedColor: const Color(0xFFC4B5FD),
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
                : ListView.builder(
                    padding: const EdgeInsets.all(24),
                    itemCount: filteredTasks.length,
                    itemBuilder: (context, index) {
                      final task = filteredTasks[index];
                      final isDone = _completedTaskIds.contains(task.id);
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: InkWell(
                          onTap: () => _toggleTask(task.id, task.title),
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: isDone ? const Color(0xFFDCFCE7) : Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isDone ? const Color(0xFF4ADE80) : Colors.transparent,
                                width: 2,
                              ),
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
                                Text(task.icon, style: const TextStyle(fontSize: 32)),
                                const SizedBox(width: 20),
                                Expanded(
                                  child: Text(
                                    task.title,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      decoration: isDone ? TextDecoration.lineThrough : null,
                                      color: isDone ? Colors.green[800] : Colors.black87,
                                    ),
                                  ),
                                ),
                                if (isDone)
                                  const Icon(Icons.check_circle, color: Colors.green, size: 32)
                                else
                                  const Icon(Icons.circle_outlined, color: Colors.grey, size: 32),
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
}
