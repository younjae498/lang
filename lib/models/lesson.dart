
import 'structure.dart';
import 'word.dart';

class Lesson {
  final String id;
  final String title;
  final SentenceStructure structure;
  final List<Word> vocabulary;

  const Lesson({
    required this.id,
    required this.title,
    required this.structure,
    required this.vocabulary,
  });
}
