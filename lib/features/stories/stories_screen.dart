import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_constants.dart';
import '../../main.dart'; // To access AudioProvider

class StoriesScreen extends StatefulWidget {
  const StoriesScreen({super.key});

  @override
  State<StoriesScreen> createState() => _StoriesScreenState();
}

class _StoriesScreenState extends State<StoriesScreen> {
  final List<Map<String, dynamic>> _stories = [
    {
      'title': 'Ay ve Güneş',
      'length': '0:45',
      'color': const Color(0xFF93C5FD),
      'emoji': '🌙☀️',
      'audio': 'assets/story_audio/ayveguneshıkaye.mp3',
      'textPath': 'assets/story_images/Ay ve Güneş.txt',
    },
    {
      'title': 'Bulutlar Ülkesi',
      'length': '1:05',
      'color': const Color(0xFFC4B5FD),
      'emoji': '☁️🏰',
      'audio': 'assets/story_audio/bulutlarulkesi.mp3',
      'textPath': 'assets/story_images/Bulutlar Ülkesi.txt',
    },
    {
      'title': 'Denizin Altında',
      'length': '1:00',
      'color': const Color(0xFF86EFAC),
      'emoji': '🌊🐢',
      'audio': 'assets/story_audio/denizaltında.mp3',
      'textPath': 'assets/story_images/Denizin Altında.txt',
    },
    {
      'title': 'Küçük Kedi Mırnav',
      'length': '0:25',
      'color': const Color(0xFFFDBA74),
      'emoji': '🐱🐾',
      'audio': 'assets/story_audio/kucukkedımırnav.mp3',
      'textPath': 'assets/story_images/Küçük Kedi Mırnav.txt',
    },
    {
      'title': 'Orman Arkadaşları',
      'length': '1:10',
      'color': const Color(0xFFF9A8D4),
      'emoji': '🌲🐘',
      'audio': 'assets/story_audio/ormanarkadasları.mp3',
      'textPath': 'assets/story_images/Orman Arkadaşları.txt',
    },
  ];

  Map<String, dynamic>? _selectedStory;
  String _storyText = "Yükleniyor...";

  Future<void> _loadStoryText(String path) async {
    try {
      final text = await DefaultAssetBundle.of(context).loadString(path);
      setState(() => _storyText = text);
    } catch (e) {
      setState(() => _storyText = "Hikaye metni yüklenemedi.");
    }
  }

  void _onStorySelect(Map<String, dynamic> story) {
    // Ensure any current audio is stopped before switching to a new story
    Provider.of<AudioProvider>(context, listen: false).stop();
    setState(() {
      _selectedStory = story;
      _storyText = "Yükleniyor...";
    });
    _loadStoryText(story['textPath']);
  }

  @override
  Widget build(BuildContext context) {
    if (_selectedStory != null) {
      return _buildPlayerView();
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
                    "Hikayeler 📚",
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemCount: _stories.length,
                itemBuilder: (context, index) {
                  final story = _stories[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: InkWell(
                      onTap: () => _onStorySelect(story),
                      borderRadius: BorderRadius.circular(24),
                      child: Container(
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
                              width: 64,
                              height: 64,
                              decoration: BoxDecoration(
                                color: story['color'].withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Center(child: Text(story['emoji'], style: const TextStyle(fontSize: 32))),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    story['title'],
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                  ),
                                  Text(
                                    "${story['length']} dakika",
                                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(Icons.play_circle_fill, color: Color(0xFFFDBA74), size: 40),
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

  Widget _buildPlayerView() {
    return Scaffold(
      backgroundColor: _selectedStory!['color'],
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Provider.of<AudioProvider>(context, listen: false).stop();
                      setState(() => _selectedStory = null);
                    },
                    icon: const Icon(Icons.close, color: Colors.white),
                  ),
                  const Spacer(),
                  const Text(
                    "Şimdi Dinleniyor",
                    style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w600),
                  ),
                  const Spacer(),
                  const SizedBox(width: 48),
                ],
              ),
            ),
            
            // Story Card with Text
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(32),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        _selectedStory!['emoji'],
                        style: const TextStyle(fontSize: 64),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _selectedStory!['title'],
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      const Divider(height: 32),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Text(
                            _storyText,
                            style: const TextStyle(fontSize: 18, height: 1.6, color: Colors.black87),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            // Audio Controls
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Consumer<AudioProvider>(
                builder: (context, audioProvider, child) {
                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: () {}, 
                            icon: const Icon(Icons.replay_10, color: Colors.white, size: 32)
                          ),
                          const SizedBox(width: 32),
                          GestureDetector(
                            onTap: () => audioProvider.togglePlay(_selectedStory!['audio']),
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                              child: Icon(
                                (audioProvider.isPlaying && audioProvider.currentAssetPath == _selectedStory!['audio'])
                                    ? Icons.pause
                                    : Icons.play_arrow,
                                color: _selectedStory!['color'],
                                size: 48
                              ),
                            ),
                          ),
                          const SizedBox(width: 32),
                          IconButton(
                            onPressed: () {}, 
                            icon: const Icon(Icons.forward_10, color: Colors.white, size: 32)
                          ),
                        ],
                      ),
                    ],
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
