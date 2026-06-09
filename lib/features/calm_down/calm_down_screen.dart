import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'dart:math';
import '../../core/constants/app_constants.dart';
import '../../models/models.dart';

class CalmDownScreen extends StatelessWidget {
  const CalmDownScreen({super.key});

  final List<CalmDownActivity> _activities = const [
    CalmDownActivity(
      id: 'calm_01',
      title: 'Balon Nefesi',
      instruction: 'Balon büyürken derin nefes al, küçülürken yavaşça nefes ver.',
      lottiePath: 'assets/calm/balloon.json',
    ),
    CalmDownActivity(
      id: 'calm_02',
      title: 'Bulut Nefesi',
      instruction: 'Bulutu takip et ve sakin nefes al.',
      lottiePath: 'assets/calm/cloud.json',
    ),
    CalmDownActivity(
      id: 'calm_03',
      title: 'Deniz Dalgası',
      instruction: 'Dalgayı izle, yavaşça nefes al.',
      lottiePath: 'assets/calm/wave.json',
    ),
    CalmDownActivity(
      id: 'calm_04',
      title: 'Yıldız Sayma',
      instruction: 'Bir yıldız, iki yıldız, üç yıldız... Yıldızları sayalım.',
      lottiePath: 'assets/calm/stars.json',
    ),
    CalmDownActivity(
      id: 'calm_05',
      title: 'Sakin Renkler',
      instruction: 'Renkleri izle ve rahatla.',
      lottiePath: 'assets/calm/colors.json',
    ),
    CalmDownActivity(
      id: 'calm_06',
      title: 'Sessiz Dinlenme',
      instruction: 'Gözlerini kapat ve biraz dinlen.',
      lottiePath: 'assets/calm/rest.json',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sakinleşme 🧘'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(24),
        itemCount: _activities.length,
        itemBuilder: (context, index) {
          final activity = _activities[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: InkWell(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => CalmDetailScreen(activity: activity)),
              ),
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
                    const CircleAvatar(
                      backgroundColor: AppColors.inputBackground,
                      child: Icon(Icons.spa_outlined, color: AppColors.primary),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      activity.title,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    const Spacer(),
                    const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class CalmDetailScreen extends StatefulWidget {
  final CalmDownActivity activity;
  const CalmDetailScreen({super.key, required this.activity});

  @override
  State<CalmDetailScreen> createState() => _CalmDetailScreenState();
}

class _CalmDetailScreenState extends State<CalmDetailScreen> with TickerProviderStateMixin {
  final FlutterTts _tts = FlutterTts();
  late AnimationController _controller;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3), // Default duration if onLoaded fails
    );
    _tts.setLanguage("tr-TR");
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _togglePlay() {
    if (_controller.duration == null || _controller.duration!.inMilliseconds == 0) {
      _controller.duration = const Duration(seconds: 3);
    }

    setState(() {
      _isPlaying = !_isPlaying;
      if (_isPlaying) {
        _controller.repeat();
      } else {
        _controller.stop();
      }
    });
  }

  void _reset() {
    setState(() {
      _isPlaying = false;
      _controller.reset();
    });
  }

  Widget _buildAnimation(bool isPlaying) {
    switch (widget.activity.id) {
      case 'calm_01':
        return BalloonAnimation(controller: _controller);
      case 'calm_02':
        return CloudAnimation(controller: _controller);
      case 'calm_03':
        return WaveAnimation(controller: _controller);
      case 'calm_04':
        return StarAnimation(controller: _controller);
      case 'calm_05':
        return ColorAnimation(controller: _controller);
      case 'calm_06':
        return RestAnimation(controller: _controller);
      default:
        return const Icon(Icons.spa, size: 80, color: AppColors.primary);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.activity.title),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
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
                child: Center(
                  child: _buildAnimation(_isPlaying),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.inputBackground,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.activity.instruction,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                  ),
                  IconButton(
                    onPressed: () => _tts.speak(widget.activity.instruction),
                    icon: const Icon(Icons.volume_up, color: AppColors.primary),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _togglePlay,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isPlaying ? Colors.orange : Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: Text(_isPlaying ? 'Durdur' : 'Başlat'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _reset,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade300,
                      foregroundColor: Colors.black87,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: const Text('Tekrar Başlat'),
                  ),
                ),
              ],
            ),
            if (!_isPlaying && _controller.value > 0) ...[
               const SizedBox(height: 16),
               const Text("Harika! Biraz daha sakinleştik. 🎉", 
                style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 16))
            ]
          ],
        ),
      ),
    );
  }
}

// --- Custom Animation Widgets ---

class BalloonAnimation extends StatelessWidget {
  final AnimationController controller;
  const BalloonAnimation({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final double scale = 1.0 + (controller.value * 0.5);
        return Transform.scale(
          scale: scale,
          child: Container(
            width: 150,
            height: 180,
            decoration: BoxDecoration(
              color: Colors.red.shade200,
              borderRadius: const BorderRadius.all(Radius.elliptical(150, 180)),
              boxShadow: [
                BoxShadow(color: Colors.red.withOpacity(0.2), blurRadius: 20, spreadRadius: 5),
              ],
            ),
            child: Center(
              child: Container(
                width: 10,
                height: 10,
                margin: const EdgeInsets.only(top: 150),
                color: Colors.white,
              ),
            ),
          ),
        );
      },
    );
  }
}

class CloudAnimation extends StatelessWidget {
  final AnimationController controller;
  const CloudAnimation({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(20 * sin(controller.value * 2 * pi), 0),
          child: const Icon(Icons.cloud, size: 150, color: Color(0xFFB3E5FC)),
        );
      },
    );
  }
}


class WaveAnimation extends StatelessWidget {
  final AnimationController controller;
  const WaveAnimation({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return CustomPaint(
          size: const Size(200, 100),
          painter: WavePainter(controller.value),
        );
      },
    );
  }
}

class WavePainter extends CustomPainter {
  final double value;
  WavePainter(this.value);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue.shade300
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5;

    final path = Path();
    path.moveTo(0, size.height / 2);
    for (double x = 0; x <= size.width; x++) {
      path.lineTo(x, size.height / 2 + 20 * sin((x / size.width * 2 * pi) + (value * 2 * pi)));
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(WavePainter oldDelegate) => true;
}

class StarAnimation extends StatelessWidget {
  final AnimationController controller;
  const StarAnimation({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: List.generate(5, (index) {
            final double angle = (index * 2 * pi) / 5;
            final double offset = 50 + (20 * controller.value);
            return Transform.translate(
              offset: Offset(offset * cos(angle), offset * sin(angle)),
              child: Icon(Icons.star, color: Colors.yellow.withOpacity(0.5 + 0.5 * sin(controller.value * pi)), size: 40),
            );
          }),
        );
      },
    );
  }
}

class ColorAnimation extends StatelessWidget {
  final AnimationController controller;
  const ColorAnimation({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                HSLColor.fromAHSL(1.0, (controller.value * 360), 0.5, 0.8).toColor(),
                HSLColor.fromAHSL(1.0, ((controller.value * 360) + 60) % 360, 0.5, 0.9).toColor(),
              ],
            ),
          ),
        );
      },
    );
  }
}

class RestAnimation extends StatelessWidget {
  final AnimationController controller;
  const RestAnimation({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Opacity(
          opacity: 0.5 + (0.5 * sin(controller.value * pi)),
          child: const Icon(Icons.remove_red_eye, size: 120, color: Colors.indigoAccent),
        );
      },
    );
  }
}
