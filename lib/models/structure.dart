
enum WordType {
  noun,
  verb,
  adjective,
  adverb,
  particle, // For Korean/Japanese etc if needed, though we start simple
  auxiliaryVerb,
  // Add others as needed
}

/// Represents a slot in a sentence structure that needs to be filled
class SentenceSlot {
  final String id;
  final WordType allowedType;
  final String hint; // e.g., "Who?" or "Does what?"

  const SentenceSlot({
    required this.id,
    required this.allowedType,
    required this.hint,
  });
}

/// Represents a sentence structure template
class SentenceStructure {
  final String id;
  final String description; // e.g., "Subject + Verb"
  final List<SentenceSlot> slots;
  
  // Logic to build the final sentence would go here or in a service
  // For now, it's just data.
  
  const SentenceStructure({
    required this.id,
    required this.description,
    required this.slots,
  });
}
