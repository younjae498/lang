import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProgressNotifier extends Notifier<Set<String>> {
  @override
  Set<String> build() {
    return {'lesson1'}; // lesson1 is unlocked by default
  }

  void completeLesson(String lessonId) {
    state = {...state, lessonId};
    
    // Unlock next lesson
    final lessonNumber = int.tryParse(lessonId.replaceAll('lesson', ''));
    if (lessonNumber != null) {
      final nextLesson = 'lesson${lessonNumber + 1}';
      state = {...state, nextLesson};
    }
  }

  bool isUnlocked(String lessonId) {
    return state.contains(lessonId);
  }
}

final progressProvider = NotifierProvider<ProgressNotifier, Set<String>>(() {
  return ProgressNotifier();
});
