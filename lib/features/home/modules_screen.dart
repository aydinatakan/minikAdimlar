import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/widgets/menu_card.dart';
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

class ModulesScreen extends StatelessWidget {
  const ModulesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Eğitim Modülleri",
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "Öğrenmeye devam edelim!",
                    style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                children: [
                  _buildCollapsibleCategory(
                    context: context,
                    title: "Oyunlar 🎮",
                    icon: Icons.games_outlined,
                    gradient: AppColors.blueGradient,
                    children: [
                      MenuCard(
                        title: 'Puzzle',
                        icon: Icons.extension_outlined,
                        gradient: AppColors.blueGradient,
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PuzzleScreen())),
                      ),
                      MenuCard(
                        title: 'Boyama',
                        icon: Icons.palette_outlined,
                        gradient: AppColors.violetGradient,
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ColoringScreen())),
                      ),
                      MenuCard(
                        title: 'Sıralama Oyunu',
                        icon: Icons.low_priority,
                        gradient: AppColors.amberGradient,
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SequencingScreen())),
                      ),
                      MenuCard(
                        title: 'Renk ve Şekil',
                        icon: Icons.category_outlined,
                        gradient: AppColors.pinkGradient,
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ColorShapeScreen())),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildCollapsibleCategory(
                    context: context,
                    title: "Planlama 📅",
                    icon: Icons.event_note_outlined,
                    gradient: AppColors.violetGradient,
                    children: [
                      MenuCard(
                        title: 'Günlük Rutin',
                        icon: Icons.calendar_today_outlined,
                        gradient: AppColors.orangeGradient,
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RoutineScreen())),
                      ),
                      MenuCard(
                        title: 'Anımsatıcılar',
                        icon: Icons.notifications_active_outlined,
                        gradient: AppColors.blueGradient,
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RemindersScreen())),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildCollapsibleCategory(
                    context: context,
                    title: "Diğer Eğitici Modüller ✨",
                    icon: Icons.auto_awesome_outlined,
                    gradient: AppColors.greenGradient,
                    children: [
                      MenuCard(
                        title: 'Boşluk Doldurma',
                        icon: Icons.edit_note,
                        gradient: AppColors.blueGradient,
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const FillBlankScreen())),
                      ),
                      MenuCard(
                        title: 'Görsel Eşleştirme',
                        icon: Icons.image_outlined,
                        gradient: AppColors.violetGradient,
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const VisualMatchingScreen())),
                      ),
                      MenuCard(
                        title: 'Hikaye Dinleme',
                        icon: Icons.menu_book_outlined,
                        gradient: AppColors.orangeGradient,
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const StoriesScreen())),
                      ),
                      MenuCard(
                        title: 'İletişim Kartları',
                        icon: Icons.chat_bubble_outline,
                        gradient: AppColors.greenGradient,
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PecsScreen())),
                      ),
                      MenuCard(
                        title: 'Sakinleşme',
                        icon: Icons.spa_outlined,
                        gradient: AppColors.greenGradient,
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CalmDownScreen())),
                      ),
                      MenuCard(
                        title: 'Duygu Tanıma',
                        icon: Icons.face_retouching_natural,
                        gradient: AppColors.pinkGradient,
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const EmotionRecognitionScreen())),
                      ),
                      MenuCard(
                        title: 'Hayvan Sesleri',
                        icon: Icons.pets_outlined,
                        gradient: AppColors.orangeGradient,
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AnimalSoundsScreen())),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCollapsibleCategory({
    required BuildContext context,
    required String title,
    required IconData icon,
    required List<Color> gradient,
    required List<Widget> children,
  }) {
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
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: gradient),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          children: [
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              children: children,
            ),
          ],
        ),
      ),
    );
  }
}
