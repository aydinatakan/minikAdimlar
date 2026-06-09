import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_constants.dart';
import '../../services/firebase_service.dart';
import '../../models/models.dart';

class SequencingScreen extends StatefulWidget {
  const SequencingScreen({super.key});

  @override
  State<SequencingScreen> createState() => _SequencingScreenState();
}

class _SequencingScreenState extends State<SequencingScreen> {
  List<SequenceScenario> _scenarios = [];
  bool _isLoading = true;
  SequenceScenario? _selectedScenario;
  List<String>? _currentOrder;
  List<String>? _currentIcons;
  bool _isCorrect = false;
  bool _showResult = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    final service = Provider.of<FirestoreService>(context, listen: false);
    try {
      var scenarios = await service.getSequenceScenarios();
      if (scenarios.isEmpty) {
        await _seedData();
        scenarios = await service.getSequenceScenarios();
      }
      setState(() {
        _scenarios = scenarios;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _seedData() async {
    final service = Provider.of<FirestoreService>(context, listen: false);
    final List<Map<String, dynamic>> initialData = [
      {
        'id': 'seq_01', 
        'title': 'Yemek Rutini', 
        'steps': ['Ellerini yıka', 'Sofraya otur', 'Yemek ye'], 
        'icons': ['🧼', '🪑', '🍲']
      },
      {
        'id': 'seq_02', 
        'title': 'Uyku Rutini', 
        'steps': ['Pijamanı giy', 'Dişlerini fırçala', 'Yatağına yat'], 
        'icons': ['👕', '🪥', '🛌']
      },
      {
        'id': 'seq_03', 
        'title': 'Sabah Rutini', 
        'steps': ['Uyan', 'Yüzünü yıka', 'Kahvaltı yap'], 
        'icons': ['⏰', '🧼', '🍳']
      },
      {
        'id': 'seq_04', 
        'title': 'Okul Hazırlığı', 
        'steps': ['Çantanı hazırla', 'Ayakkabılarını giy', 'Okula git'], 
        'icons': ['🎒', '👟', '🏫']
      },
      {
        'id': 'seq_05', 
        'title': 'Bitki Bakımı', 
        'steps': ['Saksıyı getir', 'Çiçeği sula', 'Güneşe koy'], 
        'icons': ['🪴', '🚿', '☀️']
      },
      {
        'id': 'seq_06', 
        'title': 'Temizlik Rutini', 
        'steps': ['Oyuncakları topla', 'Masayı sil', 'Ellerini yıka'], 
        'icons': ['🧸', '🧽', '🧼']
      },
    ];
    await service.uploadSequences(initialData);
  }

  void _startScenario(SequenceScenario scenario) {
    setState(() {
      _selectedScenario = scenario;
      _currentOrder = List.from(scenario.steps)..shuffle();
      // Map icons to the shuffled steps
      _currentIcons = _currentOrder!.map((step) {
        int originalIndex = scenario.steps.indexOf(step);
        return scenario.icons[originalIndex];
      }).toList();
      _isCorrect = false;
      _showResult = false;
    });
  }

  void _checkOrder() {
    bool correct = true;
    for (int i = 0; i < _currentOrder!.length; i++) {
      if (_currentOrder![i] != _selectedScenario!.steps[i]) {
        correct = false;
        break;
      }
    }
    setState(() {
      _isCorrect = correct;
      _showResult = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    return Scaffold(
      body: SafeArea(
        child: _selectedScenario == null ? _buildSelection() : _buildGame(),
      ),
    );
  }

  Widget _buildSelection() {
    return Column(
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
              Text("Sıralama Oyunu 🧩", style: Theme.of(context).textTheme.headlineSmall),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            itemCount: _scenarios.length,
            itemBuilder: (context, index) {
              final sc = _scenarios[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: InkWell(
                  onTap: () => _startScenario(sc),
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
                        const Icon(Icons.low_priority, color: AppColors.primary, size: 32),
                        const SizedBox(width: 16),
                        Text(sc.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                        const Spacer(),
                        const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildGame() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: Row(
            children: [
              IconButton(
                onPressed: () => setState(() => _selectedScenario = null),
                icon: const Icon(Icons.close),
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.inputBackground,
                  padding: const EdgeInsets.all(12),
                ),
              ),
              const SizedBox(width: 16),
              Text(_selectedScenario!.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            ],
          ),
        ),
        
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Text("Doğru sıraya koyalım! 👇", style: TextStyle(color: AppColors.textSecondary)),
        ),
        
        Expanded(
          child: ReorderableListView.builder(
            padding: const EdgeInsets.all(24),
            itemCount: _currentOrder!.length,
            onReorder: (oldIndex, newIndex) {
              setState(() {
                if (newIndex > oldIndex) newIndex -= 1;
                final step = _currentOrder!.removeAt(oldIndex);
                final icon = _currentIcons!.removeAt(oldIndex);
                _currentOrder!.insert(newIndex, step);
                _currentIcons!.insert(newIndex, icon);
                _showResult = false;
              });
            },
            itemBuilder: (context, index) {
              return Padding(
                key: ValueKey(_currentOrder![index]),
                padding: const EdgeInsets.only(bottom: 12),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
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
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.inputBackground,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(_currentIcons![index], style: const TextStyle(fontSize: 24)),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          _currentOrder![index],
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                      ReorderableDragStartListener(
                        index: index,
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(Icons.drag_handle, color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        
        if (_showResult)
          Padding(
            padding: const EdgeInsets.all(24),
            child: Container(
              padding: const EdgeInsets.all(16),
              width: double.infinity,
              decoration: BoxDecoration(
                color: _isCorrect ? const Color(0xFFDCFCE7) : const Color(0xFFFEE2E2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                _isCorrect ? "Harika! Doğru sıraya koydun. 🎉" : "Tekrar deneyelim. 😊",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: _isCorrect ? Colors.green[800] : Colors.red[800],
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: ElevatedButton(
            onPressed: _checkOrder,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 56),
            ),
            child: const Text("Kontrol Et"),
          ),
        ),
      ],
    );
  }
}
