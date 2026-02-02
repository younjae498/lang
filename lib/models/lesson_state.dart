
import 'structure.dart';
import 'word.dart';

class LessonState {
  final String lessonId;
  final SentenceStructure structure;
  final List<Word> availableWords;
  final Map<String, Word?> filledSlots;
  final bool isComplete;
  final String foxMessage;

  const LessonState({
    required this.lessonId,
    required this.structure,
    required this.availableWords,
    this.filledSlots = const {},
    this.isComplete = false,
    this.foxMessage = '',
  });

  LessonState copyWith({
    String? lessonId,
    SentenceStructure? structure,
    List<Word>? availableWords,
    Map<String, Word?>? filledSlots,
    bool? isComplete,
    String? foxMessage,
  }) {
    return LessonState(
      lessonId: lessonId ?? this.lessonId,
      structure: structure ?? this.structure,
      availableWords: availableWords ?? this.availableWords,
      filledSlots: filledSlots ?? this.filledSlots,
      isComplete: isComplete ?? this.isComplete,
      foxMessage: foxMessage ?? this.foxMessage,
    );
  }
}
