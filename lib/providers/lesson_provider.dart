
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/lesson_state.dart';
import '../models/structure.dart';
import '../models/word.dart';

// Simple provider that holds the lesson state
final lessonProvider = Provider<LessonState>((ref) {
  // Mock lesson 1: "Who does what"
  final structure = SentenceStructure(
    id: 's1',
    description: 'Who does what',
    slots: [
      SentenceSlot(id: 'slot1', allowedType: WordType.noun, hint: '?'),
      SentenceSlot(id: 'slot2', allowedType: WordType.verb, hint: '?'),
    ],
  );

  final words = [
    Word(id: 'w1', text: 'Fox', meaning: 'Fox', type: WordType.noun),
    Word(id: 'w2', text: 'Cat', meaning: 'Cat', type: WordType.noun),
    Word(id: 'w3', text: 'runs', meaning: 'runs', type: WordType.verb),
    Word(id: 'w4', text: 'sleeps', meaning: 'sleeps', type: WordType.verb),
  ];

  return LessonState(
    lessonId: 'lesson1',
    structure: structure,
    availableWords: words,
    foxMessage: 'Pick who does it, then what they do.',
  );
});
