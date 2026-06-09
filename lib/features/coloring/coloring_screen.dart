import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/constants/app_constants.dart';

class ColoringScreen extends StatefulWidget {
  const ColoringScreen({super.key});

  @override
  State<ColoringScreen> createState() => _ColoringScreenState();
}

class _ColoringScreenState extends State<ColoringScreen> {
  final List<Map<String, String>> _themes = [
    {'name': 'Güneş', 'path': 'assets/coloring/gunes.svg', 'emoji': '☀️'},
    {'name': 'Elma', 'path': 'assets/coloring/elma.svg', 'emoji': '🍎'},
    {'name': 'Kedi', 'path': 'assets/coloring/kedi.svg', 'emoji': '🐱'},
    {'name': 'Balık', 'path': 'assets/coloring/balik.svg', 'emoji': '🐟'},
    {'name': 'Araba', 'path': 'assets/coloring/araba.svg', 'emoji': '🚗'},
    {'name': 'Çiçek', 'path': 'assets/coloring/cicek.svg', 'emoji': '🌸'},
  ];

  String? _selectedSvgPath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _selectedSvgPath == null ? _buildSelection() : _buildColoringTool(),
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
              Text(
                "Boyama Seç 🎨",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ],
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: _themes.length,
            itemBuilder: (context, index) {
              final theme = _themes[index];
              return InkWell(
                onTap: () => setState(() => _selectedSvgPath = theme['path']),
                borderRadius: BorderRadius.circular(24),
                child: Container(
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
                      Text(theme['emoji']!, style: const TextStyle(fontSize: 48)),
                      const SizedBox(height: 12),
                      Text(theme['name']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildColoringTool() {
    return _ColoringCanvas(
      svgPath: _selectedSvgPath!,
      onBack: () => setState(() => _selectedSvgPath = null),
    );
  }
}

class _ColoringCanvas extends StatefulWidget {
  final String svgPath;
  final VoidCallback onBack;

  const _ColoringCanvas({required this.svgPath, required this.onBack});

  @override
  State<_ColoringCanvas> createState() => _ColoringCanvasState();
}

class _ColoringCanvasState extends State<_ColoringCanvas> {
  Color _selectedColor = Colors.red;
  List<DrawingPoint?> _points = [];
  double _strokeWidth = 10.0;

  final List<Color> _colors = [
    Colors.red,
    Colors.pink,
    Colors.purple,
    Colors.deepPurple,
    Colors.blue,
    Colors.lightBlue,
    Colors.cyan,
    Colors.teal,
    Colors.green,
    Colors.lightGreen,
    Colors.lime,
    Colors.yellow,
    Colors.amber,
    Colors.orange,
    Colors.deepOrange,
    Colors.brown,
    Colors.grey,
    Colors.black,
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: Row(
            children: [
              IconButton(
                onPressed: widget.onBack,
                icon: const Icon(Icons.close),
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.inputBackground,
                  padding: const EdgeInsets.all(12),
                ),
              ),
              const SizedBox(width: 16),
              const Text("Boyama Yap! 🎨", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              const Spacer(),
              IconButton(
                onPressed: () => setState(() => _points.clear()),
                icon: const Icon(Icons.delete_outline, color: Colors.red),
              ),
            ],
          ),
        ),
        
        // Canvas Area
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(32),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(32),
                child: Stack(
                  children: [
                    // The drawing layer
                    GestureDetector(
                      onPanStart: (details) {
                        setState(() {
                          _points.add(DrawingPoint(
                            offset: details.localPosition,
                            paint: Paint()
                              ..color = _selectedColor
                              ..isAntiAlias = true
                              ..strokeWidth = _strokeWidth
                              ..strokeCap = StrokeCap.round,
                          ));
                        });
                      },
                      onPanUpdate: (details) {
                        setState(() {
                          _points.add(DrawingPoint(
                            offset: details.localPosition,
                            paint: Paint()
                              ..color = _selectedColor
                              ..isAntiAlias = true
                              ..strokeWidth = _strokeWidth
                              ..strokeCap = StrokeCap.round,
                          ));
                        });
                      },
                      onPanEnd: (details) {
                        setState(() {
                          _points.add(null);
                        });
                      },
                      child: CustomPaint(
                        painter: DrawingPainter(points: _points),
                        size: Size.infinite,
                      ),
                    ),
                    
                    // The SVG Outline layer (stays on top)
                    IgnorePointer(
                      child: Center(
                        child: SvgPicture.asset(
                          widget.svgPath,
                          width: double.infinity,
                          fit: BoxFit.contain,
                          colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcIn),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        
        // Color Palette
        Container(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Column(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: _colors.map((color) {
                    return GestureDetector(
                      onTap: () => setState(() => _selectedColor = color),
                      child: Container(
                        margin: const EdgeInsets.only(right: 12),
                        width: _selectedColor == color ? 50 : 40,
                        height: _selectedColor == color ? 50 : 40,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: _selectedColor == color ? Colors.black : Colors.transparent,
                            width: 3,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: color.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 16),
              Slider(
                value: _strokeWidth,
                min: 2,
                max: 30,
                activeColor: _selectedColor,
                onChanged: (val) => setState(() => _strokeWidth = val),
              ),
              const Text("Fırça Boyutu", style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
            ],
          ),
        ),
      ],
    );
  }
}

class DrawingPoint {
  Offset offset;
  Paint paint;
  DrawingPoint({required this.offset, required this.paint});
}

class DrawingPainter extends CustomPainter {
  final List<DrawingPoint?> points;

  DrawingPainter({required this.points});

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i]!.offset, points[i + 1]!.offset, points[i]!.paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
