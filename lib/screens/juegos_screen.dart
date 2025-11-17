import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:math';
import '../models/palabra.dart';
import '../services/palabra_service.dart';

class JuegosScreen extends StatefulWidget {
  const JuegosScreen({super.key});

  @override
  State<JuegosScreen> createState() => _JuegosScreenState();
}

class _JuegosScreenState extends State<JuegosScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Juegos Interactivos'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16),
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        children: [
          _buildGameCard(
            title: 'Memoria',
            description: 'Encuentra las parejas',
            icon: Icons.grid_on,
            color: Colors.blue,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const MemoriaGame()),
            ),
          ),
          _buildGameCard(
            title: 'Quiz',
            description: 'Prueba tus conocimientos',
            icon: Icons.quiz,
            color: Colors.green,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const QuizGame()),
            ),
          ),
          _buildGameCard(
            title: 'Flashcards',
            description: 'Repasa vocabulario',
            icon: Icons.style,
            color: Colors.orange,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const FlashcardsGame()),
            ),
          ),
          _buildGameCard(
            title: 'Completar',
            description: 'Completa la palabra',
            icon: Icons.text_fields,
            color: Colors.purple,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CompletarGame()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGameCard({
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [color, color.withOpacity(0.7)],
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 48, color: Colors.white),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.white70,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------
// JUEGO 1: QUIZ
// ---------------------------------------------------------
class QuizGame extends StatefulWidget {
  const QuizGame({super.key});

  @override
  State<QuizGame> createState() => _QuizGameState();
}

class _QuizGameState extends State<QuizGame> {
  final PalabraService _palabraService = PalabraService();
  List<Palabra> _palabras = [];
  int _currentIndex = 0;
  int _score = 0;
  bool _isLoading = true;
  bool _answered = false;
  List<String> _opciones = [];
  String? _selectedOption;

  @override
  void initState() {
    super.initState();
    _loadGame();
  }

  Future<void> _loadGame() async {
    try {
      final palabras = await _palabraService.getPalabras();
      if (palabras.length < 4) {
        Fluttertoast.showToast(
          msg: 'Se necesitan al menos 4 palabras',
          backgroundColor: Colors.orange,
        );
        Navigator.pop(context);
        return;
      }
      palabras.shuffle();
      setState(() {
        _palabras = palabras.take(10).toList();
        _isLoading = false;
      });
      _generateOptions();
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error al cargar juego', backgroundColor: Colors.red);
      Navigator.pop(context);
    }
  }

  void _generateOptions() {
    final correctWord = _palabras[_currentIndex];
    final others = List<Palabra>.from(_palabras)..remove(correctWord)..shuffle();
    _opciones = [
      correctWord.traduccionEspanol,
      others[0].traduccionEspanol,
      others[1].traduccionEspanol,
      others[2].traduccionEspanol,
    ]..shuffle();
  }

  void _checkAnswer(String option) {
    if (_answered) return;
    setState(() {
      _answered = true;
      _selectedOption = option;
      if (option == _palabras[_currentIndex].traduccionEspanol) _score++;
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (_currentIndex < _palabras.length - 1) {
        setState(() {
          _currentIndex++;
          _answered = false;
          _selectedOption = null;
        });
        _generateOptions();
      } else {
        _showResults();
      }
    });
  }

  void _showResults() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('¡Juego Terminado!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _score >= 7 ? Icons.emoji_events : Icons.thumb_up,
              size: 64,
              color: _score >= 7 ? Colors.amber : Colors.blue,
            ),
            const SizedBox(height: 16),
            Text(
              'Puntuación: $_score/${_palabras.length}',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(_score >= 7 ? '¡Excelente!' : '¡Sigue practicando!'),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Salir')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _currentIndex = 0;
                _score = 0;
                _answered = false;
                _palabras.shuffle();
              });
              _generateOptions();
            },
            child: const Text('Reiniciar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    final palabra = _palabras[_currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz de Vocabulario'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Puntuación: $_score', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 40),
            Card(
              elevation: 8,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Colors.indigo, Colors.indigoAccent]),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(children: [
                  const Text('¿Cómo se traduce?', style: TextStyle(color: Colors.white70)),
                  const SizedBox(height: 16),
                  Text(
                    palabra.palabraInga,
                    style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ]),
              ),
            ),
            const SizedBox(height: 40),
            ..._opciones.map((opcion) {
              final isCorrect = opcion == palabra.traduccionEspanol;
              final isSelected = _selectedOption == opcion;
              Color color;
              if (!_answered) color = Colors.indigo;
              else if (isSelected && isCorrect) color = Colors.green;
              else if (isSelected && !isCorrect) color = Colors.red;
              else if (isCorrect) color = Colors.green;
              else color = Colors.grey;
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: ElevatedButton(
                  onPressed: _answered ? null : () => _checkAnswer(opcion),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: color,
                    minimumSize: const Size(double.infinity, 60),
                  ),
                  child: Text(opcion, style: const TextStyle(fontSize: 18, color: Colors.white)),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------
// JUEGO 2: FLASHCARDS
// ---------------------------------------------------------
class FlashcardsGame extends StatefulWidget {
  const FlashcardsGame({super.key});
  @override
  State<FlashcardsGame> createState() => _FlashcardsGameState();
}

class _FlashcardsGameState extends State<FlashcardsGame> {
  final PalabraService _palabraService = PalabraService();
  List<Palabra> _palabras = [];
  int _currentIndex = 0;
  bool _showTranslation = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadGame();
  }

  Future<void> _loadGame() async {
    try {
      final palabras = await _palabraService.getPalabras();
      palabras.shuffle();
      setState(() {
        _palabras = palabras;
        _isLoading = false;
      });
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error al cargar', backgroundColor: Colors.red);
      Navigator.pop(context);
    }
  }

  void _nextCard() {
    setState(() {
      _showTranslation = false;
      _currentIndex = (_currentIndex + 1) % _palabras.length;
    });
  }

  void _previousCard() {
    setState(() {
      _showTranslation = false;
      _currentIndex = (_currentIndex - 1 + _palabras.length) % _palabras.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    final palabra = _palabras[_currentIndex];

    return Scaffold(
      appBar: AppBar(title: const Text('Flashcards'), backgroundColor: Colors.orange),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () => setState(() => _showTranslation = !_showTranslation),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: 300,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: _showTranslation
                          ? [Colors.orange, Colors.deepOrange]
                          : [Colors.indigo, Colors.indigoAccent],
                    ),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Center(
                    child: Text(
                      _showTranslation ? palabra.traduccionEspanol : palabra.palabraInga,
                      style: const TextStyle(fontSize: 36, color: Colors.white, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FloatingActionButton(onPressed: _previousCard, child: const Icon(Icons.arrow_back)),
                  FloatingActionButton(onPressed: _nextCard, child: const Icon(Icons.arrow_forward)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------
// JUEGO 3: MEMORIA
// ---------------------------------------------------------
class MemoriaGame extends StatefulWidget {
  const MemoriaGame({super.key});
  @override
  State<MemoriaGame> createState() => _MemoriaGameState();
}

class _MemoriaGameState extends State<MemoriaGame> {
  final PalabraService _palabraService = PalabraService();
  List<MemoryCard> _cards = [];
  List<int> _flipped = [];
  int _matches = 0;
  bool _isLoading = true;
  bool _isChecking = false;

  @override
  void initState() {
    super.initState();
    _loadGame();
  }

  Future<void> _loadGame() async {
    try {
      final palabras = await _palabraService.getPalabras();
      palabras.shuffle();
      final selected = palabras.take(6).toList();
      final cards = [
        for (var i = 0; i < selected.length; i++) ...[
          MemoryCard(text: selected[i].palabraInga, pairId: i),
          MemoryCard(text: selected[i].traduccionEspanol, pairId: i),
        ]
      ]..shuffle();
      setState(() {
        _cards = cards;
        _isLoading = false;
      });
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error al cargar juego', backgroundColor: Colors.red);
      Navigator.pop(context);
    }
  }

  void _onCardTap(int i) {
    if (_flipped.contains(i) || _isChecking || _cards[i].matched) return;
    setState(() => _flipped.add(i));
    if (_flipped.length == 2) {
      _isChecking = true;
      Future.delayed(const Duration(seconds: 1), () {
        final a = _flipped[0], b = _flipped[1];
        if (_cards[a].pairId == _cards[b].pairId) {
          setState(() {
            _cards[a].matched = true;
            _cards[b].matched = true;
            _matches++;
          });
          if (_matches == 6) _showWin();
        }
        setState(() {
          _flipped.clear();
          _isChecking = false;
        });
      });
    }
  }

  void _showWin() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('¡Ganaste!'),
        content: const Text('Has encontrado todas las parejas 🎉'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Salir')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _matches = 0;
                for (var c in _cards) c.matched = false;
                _cards.shuffle();
              });
            },
            child: const Text('Reiniciar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    return Scaffold(
      appBar: AppBar(title: const Text('Memoria'), backgroundColor: Colors.blue),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
        itemCount: _cards.length,
        itemBuilder: (_, i) {
          final flipped = _flipped.contains(i) || _cards[i].matched;
          return GestureDetector(
            onTap: () => _onCardTap(i),
            child: Card(
              color: flipped ? Colors.indigo : Colors.grey[300],
              child: Center(
                child: flipped
                    ? Text(
                        _cards[i].text,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      )
                    : const Icon(Icons.help_outline, color: Colors.black45),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ---------------------------------------------------------
// JUEGO 4: COMPLETAR PALABRA
// ---------------------------------------------------------
class CompletarGame extends StatefulWidget {
  const CompletarGame({super.key});

  @override
  State<CompletarGame> createState() => _CompletarGameState();
}

class _CompletarGameState extends State<CompletarGame> {
  final PalabraService _palabraService = PalabraService();
  List<Palabra> _palabras = [];
  bool _isLoading = true;
  int _index = 0;
  int _score = 0;
  String _input = '';

  @override
  void initState() {
    super.initState();
    _loadGame();
  }

  Future<void> _loadGame() async {
    final palabras = await _palabraService.getPalabras();
    palabras.shuffle();
    setState(() {
      _palabras = palabras.take(10).toList();
      _isLoading = false;
    });
  }

  void _checkAnswer() {
    final correct = _palabras[_index].traduccionEspanol.trim().toLowerCase();
    if (_input.trim().toLowerCase() == correct) {
      _score++;
      Fluttertoast.showToast(msg: '¡Correcto!', backgroundColor: Colors.green);
    } else {
      Fluttertoast.showToast(msg: 'Incorrecto', backgroundColor: Colors.red);
    }

    if (_index < _palabras.length - 1) {
      setState(() {
        _index++;
        _input = '';
      });
    } else {
      _showEndDialog();
    }
  }

  void _showEndDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Juego Terminado'),
        content: Text('Puntuación: $_score/${_palabras.length}'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Salir')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _index = 0;
                _score = 0;
                _input = '';
                _palabras.shuffle();
              });
            },
            child: const Text('Reiniciar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    final palabra = _palabras[_index];

    return Scaffold(
      appBar: AppBar(title: const Text('Completar la Palabra'), backgroundColor: Colors.purple),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Puntuación: $_score', style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 20),
            Text(
              palabra.palabraInga,
              style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextField(
              decoration: const InputDecoration(
                hintText: 'Escribe la traducción en español...',
                border: OutlineInputBorder(),
              ),
              onChanged: (v) => _input = v,
              onSubmitted: (_) => _checkAnswer(),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _checkAnswer,
              child: const Text('Comprobar'),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------
// Modelo auxiliar para juego de memoria
// ---------------------------------------------------------
class MemoryCard {
  String text;
  int pairId;
  bool matched;
  MemoryCard({
    required this.text,
    required this.pairId,
    this.matched = false,
  });
}
