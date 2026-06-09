import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_constants.dart';
import '../../core/widgets/menu_card.dart';
import '../../services/home_provider.dart';
import '../fill_blank/fill_blank_screen.dart';
import '../visual_matching/visual_matching_screen.dart';
import '../stories/stories_screen.dart';
import '../puzzle/puzzle_screen.dart';
import '../coloring/coloring_screen.dart';
import '../routine/routine_screen.dart';
import '../pecs/pecs_screen.dart';
import '../colors_shapes/colors_shapes_screen.dart';
import '../sequencing/sequencing_screen.dart';
import '../reminders/reminders_screen.dart';
import '../calm_down/calm_down_screen.dart';
import '../emotion_recognition/emotion_recognition_screen.dart';
import '../animal_sounds/animal_sounds_screen.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback? onSeeAllModules;

  const HomeScreen({super.key, this.onSeeAllModules});

  static final Map<String, Map<String, dynamic>> availableModules = {
    'Boşluk Doldurma': {
      'icon': Icons.edit_note,
      'gradient': AppColors.blueGradient,
      'screen': const FillBlankScreen(),
    },
    'Görsel Eşleştirme': {
      'icon': Icons.image_outlined,
      'gradient': AppColors.violetGradient,
      'screen': const VisualMatchingScreen(),
    },
    'Hikaye Dinleme': {
      'icon': Icons.menu_book_outlined,
      'gradient': AppColors.orangeGradient,
      'screen': const StoriesScreen(),
    },
    'Puzzle': {
      'icon': Icons.extension_outlined,
      'gradient': AppColors.blueGradient,
      'screen': const PuzzleScreen(),
    },
    'Boyama': {
      'icon': Icons.palette_outlined,
      'gradient': AppColors.violetGradient,
      'screen': const ColoringScreen(),
    },
    'Günlük Rutin': {
      'icon': Icons.calendar_today_outlined,
      'gradient': AppColors.orangeGradient,
      'screen': const RoutineScreen(),
    },
    'İletişim Kartları': {
      'icon': Icons.chat_bubble_outline,
      'gradient': AppColors.greenGradient,
      'screen': const PecsScreen(),
    },
    'Renk ve Şekil': {
      'icon': Icons.category_outlined,
      'gradient': AppColors.pinkGradient,
      'screen': const ColorShapeScreen(),
    },
    'Sıralama Oyunu': {
      'icon': Icons.low_priority,
      'gradient': AppColors.amberGradient,
      'screen': const SequencingScreen(),
    },
    'Sakinleşme': {
      'icon': Icons.spa_outlined,
      'gradient': AppColors.greenGradient,
      'screen': const CalmDownScreen(),
    },
    'Duygu Tanıma': {
      'icon': Icons.face_retouching_natural,
      'gradient': AppColors.pinkGradient,
      'screen': const EmotionRecognitionScreen(),
    },
    'Hayvan Sesleri': {
      'icon': Icons.pets_outlined,
      'gradient': AppColors.orangeGradient,
      'screen': const AnimalSoundsScreen(),
    },
    'Anımsatıcılar': {
      'icon': Icons.notifications_active_outlined,
      'gradient': AppColors.blueGradient,
      'screen': const RemindersScreen(),
    },
  };

  @override
  Widget build(BuildContext context) {
    // Calculate Daily Recommendation
    final now = DateTime.now();
    final dateString = "${now.year}-${now.month}-${now.day}";
    final List<String> moduleKeys = availableModules.keys.toList();
    // Use hash of date string to get a stable index for the day
    final int dayIndex = dateString.hashCode.abs() % moduleKeys.length;
    final String suggestedModuleName = moduleKeys[dayIndex];
    final suggestedModule = availableModules[suggestedModuleName]!;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            // Decorative background elements
            Positioned(
              top: -50,
              right: -50,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.05),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              bottom: 100,
              left: -30,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: AppColors.secondary.withOpacity(0.05),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            
            Consumer<HomeProvider>(
              builder: (context, homeProvider, child) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Merhaba! 👋",
                              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              "Bugün ne öğrenmek istersin?",
                              style: TextStyle(
                                fontSize: 18, 
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(28),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Color(0xFF4ECDC4), Color(0xFF4D96FF)],
                            ),
                            borderRadius: BorderRadius.circular(32),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF4ECDC4).withOpacity(0.3),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(suggestedModule['icon'], color: Colors.white, size: 54),
                              ),
                              const SizedBox(height: 20),
                              const Text(
                                "Günün Önerisi",
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 1.2,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                suggestedModuleName,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 26,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              const SizedBox(height: 24),
                              ElevatedButton(
                                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => suggestedModule['screen'])),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: const Color(0xFF4D96FF),
                                  minimumSize: const Size(220, 56),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                  elevation: 0,
                                ),
                                child: const Text(
                                  "Hemen Başla",
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Reminders Section
                      if (homeProvider.reminders.isNotEmpty) ...[
                        const Padding(
                          padding: EdgeInsets.fromLTRB(24, 32, 24, 16),
                          child: Text(
                            "Yaklaşan Anımsatıcılar 🔔",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 100,
                          child: ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            scrollDirection: Axis.horizontal,
                            itemCount: homeProvider.reminders.length,
                            itemBuilder: (context, index) {
                              final reminder = homeProvider.reminders[index];
                              return Container(
                                width: 200,
                                margin: const EdgeInsets.symmetric(horizontal: 8),
                                padding: const EdgeInsets.all(16),
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
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: AppColors.primary.withOpacity(0.1),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(Icons.alarm, color: AppColors.primary, size: 20),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            reminder.title,
                                            style: const TextStyle(fontWeight: FontWeight.bold),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            "${reminder.dateTime.hour}:${reminder.dateTime.minute.toString().padLeft(2, '0')}",
                                            style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],

                      // Quick Access Section
                      Padding(
                        padding: const EdgeInsets.fromLTRB(24, 32, 24, 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Hızlı Erişim ✨",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.edit_outlined, size: 20),
                              onPressed: () => _showEditQuickAccessDialog(context, homeProvider),
                              style: IconButton.styleFrom(
                                backgroundColor: AppColors.primary.withOpacity(0.1),
                                foregroundColor: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      SizedBox(
                        height: 180,
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          scrollDirection: Axis.horizontal,
                          itemCount: homeProvider.quickAccessModules.length,
                          itemBuilder: (context, index) {
                            final moduleName = homeProvider.quickAccessModules[index];
                            final module = availableModules[moduleName];
                            if (module == null) return const SizedBox.shrink();
                            
                            return _buildQuickAction(
                              context,
                              title: moduleName,
                              icon: module['icon'],
                              gradient: module['gradient'],
                              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => module['screen'])),
                            );
                          },
                        ),
                      ),
                      
                      // Tips Section
                      Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: AppColors.success.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(32),
                            border: Border.all(color: AppColors.success.withOpacity(0.2), width: 2),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: AppColors.success.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.auto_awesome, color: AppColors.success),
                              ),
                              const SizedBox(width: 16),
                              const Expanded(
                                child: Text(
                                  "✨ Bugün yeni şeyler öğrenelim!",
                                  style: TextStyle(
                                    color: AppColors.textPrimary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showEditQuickAccessDialog(BuildContext context, HomeProvider provider) {
    List<String> tempSelected = List.from(provider.quickAccessModules);

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Hızlı Erişimi Düzenle'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView(
              shrinkWrap: true,
              children: availableModules.keys.map((moduleName) {
                final isSelected = tempSelected.contains(moduleName);
                return CheckboxListTile(
                  title: Text(moduleName),
                  value: isSelected,
                  activeColor: AppColors.primary,
                  onChanged: (bool? value) {
                    setState(() {
                      if (value == true) {
                        tempSelected.add(moduleName);
                      } else {
                        tempSelected.remove(moduleName);
                      }
                    });
                  },
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('İptal'),
            ),
            ElevatedButton(
              onPressed: () {
                provider.updateQuickAccessModules(tempSelected);
                Navigator.pop(context);
              },
              child: const Text('Kaydet'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAction(
    BuildContext context, {
    required String title,
    required IconData icon,
    required List<Color> gradient,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: 140,
        child: MenuCard(
          title: title,
          icon: icon,
          gradient: gradient,
          onTap: onTap,
        ),
      ),
    );
  }
}
