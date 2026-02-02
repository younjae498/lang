
import 'structure.dart';

class Word {
  final String id;
  final String text; // The word in the target language
  final String meaning; // English meaning
  final WordType type;
  final String? assetPath; // Path to image/icon if any

  const Word({
    required this.id,
    required this.text,
    required this.meaning,
    required this.type,
    this.assetPath,
  });
}
