import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/theme/app_theme.dart';
import 'services/firebase_service.dart';
import 'services/audio_service.dart';
import 'services/notification_service.dart';
import 'services/home_provider.dart';
import 'features/home/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MinikAdimlarApp());
}

class MinikAdimlarApp extends StatelessWidget {
  const MinikAdimlarApp({super.key});

  @override
  Widget build(BuildContext context) {
    final notificationService = NotificationService();
    
    return MultiProvider(
      providers: [
        Provider<AuthService>(create: (_) => AuthService()),
        Provider<FirestoreService>(create: (_) => FirestoreService()),
        Provider<NotificationService?>(create: (_) => notificationService),
        ChangeNotifierProvider<AudioProvider>(create: (_) => AudioProvider()),
        ChangeNotifierProvider<HomeProvider>(create: (_) => HomeProvider()),
      ],
      child: MaterialApp(
        title: 'Minik Adımlar',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const SplashScreen(),
      ),
    );
  }
}

class AudioProvider extends ChangeNotifier {
  final AudioService _service = AudioService();
  bool _isSoundEnabled = true;
  String? _currentAssetPath;
  
  bool get isPlaying => _service.isPlaying;
  bool get isSoundEnabled => _isSoundEnabled;
  String? get currentAssetPath => _currentAssetPath;

  AudioProvider() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _isSoundEnabled = prefs.getBool('is_sound_enabled') ?? true;
      notifyListeners();
    } catch (e) {
      print("SharedPreferences Error: $e");
    }
  }

  Future<void> setSoundEnabled(bool enabled) async {
    _isSoundEnabled = enabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_sound_enabled', enabled);
    if (!enabled) {
      await stop();
    }
    notifyListeners();
  }

  Future<void> playAsset(String assetPath) async {
    if (!_isSoundEnabled) return;
    _currentAssetPath = assetPath;
    await _service.playAsset(assetPath);
    notifyListeners();
  }

  Future<void> stop() async {
    _currentAssetPath = null;
    await _service.stop();
    notifyListeners();
  }

  Future<void> togglePlay(String assetPath) async {
    if (!_isSoundEnabled) return;
    
    if (_currentAssetPath == assetPath) {
      await _service.togglePlay(assetPath);
    } else {
      _currentAssetPath = assetPath;
      await _service.playAsset(assetPath);
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _service.dispose();
    super.dispose();
  }
}
