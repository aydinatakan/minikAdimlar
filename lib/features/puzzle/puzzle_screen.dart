import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';

class PuzzleScreen extends StatefulWidget {
  const PuzzleScreen({super.key});

  @override
  State<PuzzleScreen> createState() => _PuzzleScreenState();
}

class _PuzzleScreenState extends State<PuzzleScreen> {
  final List<Map<String, String>> _themes = [
    {'name': 'Elma', 'path': 'assets/puzzle/elma.png'},
    {'name': 'Güneş', 'path': 'assets/puzzle/gunes.png'},
    {'name': 'Kedi', 'path': 'assets/puzzle/kedi.png'},
    {'name': 'Balık', 'path': 'assets/puzzle/balik.png'},
    {'name': 'Araba', 'path': 'assets/puzzle/araba.png'},
  ];

  String? _selectedImagePath;
  int _gridSize = 2; // 2 for 2x2, 3 for 3x3

  void _startPuzzle(String path, int size) {
    setState(() {
      _selectedImagePath = path;
      _gridSize = size;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _selectedImagePath == null ? _buildSelection() : _buildPuzzleGame(),
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
                "Puzzle Seç 🧩",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            itemCount: _themes.length,
            itemBuilder: (context, index) {
              final theme = _themes[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
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
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(theme['path']!, width: 60, height: 60, fit: BoxFit.cover),
                    ),
                    title: Text(theme['name']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    subtitle: const Text("Zorluk seçin"),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ElevatedButton(
                          onPressed: () => _startPuzzle(theme['path']!, 2),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.blueGradient[0],
                            minimumSize: const Size(60, 40),
                            padding: EdgeInsets.zero,
                          ),
                          child: const Text("2x2"),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () => _startPuzzle(theme['path']!, 3),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.violetGradient[0],
                            minimumSize: const Size(60, 40),
                            padding: EdgeInsets.zero,
                          ),
                          child: const Text("3x3"),
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
    );
  }

  Widget _buildPuzzleGame() {
    return _PuzzleGameView(
      imagePath: _selectedImagePath!,
      gridSize: _gridSize,
      onBack: () => setState(() => _selectedImagePath = null),
    );
  }
}

class _PuzzleGameView extends StatefulWidget {
  final String imagePath;
  final int gridSize;
  final VoidCallback onBack;

  const _PuzzleGameView({
    required this.imagePath,
    required this.gridSize,
    required this.onBack,
  });

  @override
  State<_PuzzleGameView> createState() => _PuzzleGameViewState();
}

class _PuzzleGameViewState extends State<_PuzzleGameView> {
  late List<bool> _isPlaced;
  late List<int> _shuffledPieces;
  bool _isFinished = false;

  @override
  void initState() {
    super.initState();
    int count = widget.gridSize * widget.gridSize;
    _isPlaced = List.generate(count, (index) => false);
    _shuffledPieces = List.generate(count, (index) => index)..shuffle();
  }

  void _onPiecePlaced(int pieceIndex, int targetIndex) {
    if (pieceIndex == targetIndex) {
      setState(() {
        _isPlaced[targetIndex] = true;
        _shuffledPieces.remove(pieceIndex);
        if (_isPlaced.every((p) => p)) {
          _isFinished = true;
        }
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Yanlış yer! ❌"), duration: Duration(milliseconds: 500)),
      );
    }
  }

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
              const Text("Puzzle Tamamla! 🧩", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            ],
          ),
        ),
        
        // Target Grid
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: AspectRatio(
            aspectRatio: 1,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.inputBackground, width: 4),
              ),
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: widget.gridSize,
                ),
                itemCount: widget.gridSize * widget.gridSize,
                itemBuilder: (context, index) {
                  return DragTarget<int>(
                    builder: (context, candidateData, rejectedData) {
                      return Container(
                        margin: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: AppColors.inputBackground.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: _isPlaced[index]
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: _PuzzlePiece(
                                  imagePath: widget.imagePath,
                                  index: index,
                                  gridSize: widget.gridSize,
                                ),
                              )
                            : null,
                      );
                    },
                    onWillAccept: (data) => !_isPlaced[index],
                    onAccept: (data) => _onPiecePlaced(data, index),
                  );
                },
              ),
            ),
          ),
        ),
        
        const SizedBox(height: 32),
        
        // Pieces Area
        if (!_isFinished)
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: _shuffledPieces.map((pieceIndex) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: Draggable<int>(
                      data: pieceIndex,
                      feedback: Material(
                        color: Colors.transparent,
                        child: SizedBox(
                          width: 100,
                          height: 100,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: _PuzzlePiece(
                              imagePath: widget.imagePath,
                              index: pieceIndex,
                              gridSize: widget.gridSize,
                            ),
                          ),
                        ),
                      ),
                      childWhenDragging: Opacity(
                        opacity: 0.3,
                        child: SizedBox(
                          width: 100,
                          height: 100,
                          child: _PuzzlePiece(
                            imagePath: widget.imagePath,
                            index: pieceIndex,
                            gridSize: widget.gridSize,
                          ),
                        ),
                      ),
                      child: SizedBox(
                        width: 100,
                        height: 100,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: _PuzzlePiece(
                            imagePath: widget.imagePath,
                            index: pieceIndex,
                            gridSize: widget.gridSize,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          )
        else
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("🎉 Harika! 🎉", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.green)),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: widget.onBack,
                    child: const Text("Geri Dön"),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class _PuzzlePiece extends StatelessWidget {
  final String imagePath;
  final int index;
  final int gridSize;

  const _PuzzlePiece({
    required this.imagePath,
    required this.index,
    required this.gridSize,
  });

  @override
  Widget build(BuildContext context) {
    final x = index % gridSize;
    final y = index ~/ gridSize;

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.none,
          scale: 1, // Will adjust via Alignment
          alignment: FractionalOffset(
            x / (gridSize - 1),
            y / (gridSize - 1),
          ),
        ),
      ),
      // To make it show only the part, we need to calculate the alignment correctly
      // But for simple DecorationImage, we might need a custom painter or a LayoutBuilder
      // Let's use a simpler approach with Image and Alignment inside a ClipRect
      child: LayoutBuilder(builder: (context, constraints) {
        return OverflowBox(
          maxWidth: constraints.maxWidth * gridSize,
          maxHeight: constraints.maxHeight * gridSize,
          alignment: FractionalOffset(
            gridSize > 1 ? x / (gridSize - 1) : 0.5,
            gridSize > 1 ? y / (gridSize - 1) : 0.5,
          ),
          child: Image.asset(
            imagePath,
            width: constraints.maxWidth * gridSize,
            height: constraints.maxHeight * gridSize,
            fit: BoxFit.fill,
          ),
        );
      }),
    );
  }
}
