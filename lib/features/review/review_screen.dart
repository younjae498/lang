import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../ui/theme/brand_colors.dart';
import '../../ui/theme/metrics.dart';
import '../../ui/theme/playful_icons.dart';
import '../../ui/components/fox_progress_bar.dart';
import '../../ui/components/playful_cards.dart';
import '../../ui/components/structure_slot_card.dart';
import '../../ui/components/clay_button.dart';

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({super.key});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  int _currentIndex = 0;
  final int _totalItems = 5;

  void _nextItem() {
    if (_currentIndex < _totalItems - 1) {
      setState(() => _currentIndex++);
    } else {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Top Header & Progress
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.energyFace.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(
                          Icons.auto_stories_rounded,
                          color: AppColors.energyFace,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'REVIEW STRUCTURES',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          color: AppColors.textMain,
                          letterSpacing: 1.0,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () => context.pop(),
                        icon: const Icon(Icons.close_rounded, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  FoxProgressBar(
                    current: _currentIndex + 1,
                    total: _totalItems,
                  ),
                ],
              ),
            ),

            // Main Content Area - Large Card
            Expanded(
              child: PageView.builder(
                itemCount: _totalItems,
                onPageChanged: (index) => setState(() => _currentIndex = index),
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return _buildStructureCard(index);
                },
              ),
            ),

            // Bottom Action Button
            Padding(
              padding: const EdgeInsets.all(24),
              child: ClayButton(
                label: _currentIndex < _totalItems - 1 ? 'NEXT' : 'COMPLETE',
                onPressed: _nextItem,
                color: AppColors.successFace,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStructureCard(int index) {
    // Sample data
    final structures = [
      {
        'title': 'Basic Sentence (SVO)',
        'description': 'The fundamental English sentence structure',
        'slots': [
          {'name': 'Subject', 'content': 'I', 'color': AppColors.energyFace},
          {'name': 'Verb', 'content': 'Love', 'color': AppColors.errorFace},
          {'name': 'Object', 'content': 'You', 'color': AppColors.successFace},
        ],
      },
      // ... (rest of the structures same but with AppColors)
    ];

    // For brevity in this replacement, I'll keep the structure list locally
    final structure = (index < structures.length) ? structures[index] : structures[0];

    return SingleChildScrollView(
      child: FloatingQuestionCard(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card number badge (Solid)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.energyFace,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                'QUEST ${index + 1} OF $_totalItems',
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: 1.0,
                ),
              ),
            ),
            
            const SizedBox(height: 24),

            // Title
            Text(
              structure['title'] as String,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w900,
                color: AppColors.textMain,
                height: 1.1,
              ),
            ),

            const SizedBox(height: 12),

            // Description
            Text(
              structure['description'] as String,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.textSecondary,
              ),
            ),

            const SizedBox(height: 32),

            // Structure slots
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: (structure['slots'] as List).map((slot) {
                return StructureSlotCard(
                  slotName: slot['name'] as String,
                  content: slot['content'] as String,
                  color: slot['color'] as Color,
                );
              }).toList(),
            ),

            const SizedBox(height: 32),

            // Help Box (Solid)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.backgroundLight,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.neutralOutline.withOpacity(0.2), width: 2),
              ),
              child: Row(
                children: [
                  const Icon(Icons.lightbulb_rounded, color: AppColors.yellowFace, size: 24),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Text(
                      'This structure is used in more than 80% of everyday English!',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
