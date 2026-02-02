import 'package:flutter/material.dart';
import 'dart:ui';
import '../../ui/theme/brand_colors.dart';
import '../../ui/theme/metrics.dart';
import '../../ui/theme/playful_icons.dart';
import '../../ui/components/structure_slot_card.dart';
import '../../ui/components/clay_button.dart';

class QuestPreviewSheet extends StatelessWidget {
  const QuestPreviewSheet({
    super.key,
    required this.title,
    required this.description,
    required this.onStart,
    this.exampleSentence = "The fox runs fast.",
  });

  final String title;
  final String description;
  final VoidCallback onStart;
  final String exampleSentence;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.8,
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.6),
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 2,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Drag Handle
                Container(
                  margin: const EdgeInsets.only(top: 12),
                  width: 40,
                  height: 6,
                  decoration: BoxDecoration(
                    color: AppColors.textMain.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                
                // Content
                Flexible(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Title Section
                        Row(
                          children: [
                            const Text('✨', style: TextStyle(fontSize: 32)),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    title,
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w900,
                                      color: AppColors.textMain,
                                    ),
                                  ),
                                  const Text(
                                    'MISSION START',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w900,
                                      color: AppColors.energyFace,
                                      letterSpacing: 2.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 32),
                        
                        // Description 
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Text(
                            description,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textMain,
                              height: 1.5,
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 32),
                        
                        // Structure Preview (Dynamic slots)
                        const Text(
                          "LEARNING TARGET",
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                            color: AppColors.textSecondary,
                            letterSpacing: 2.0,
                          ),
                        ),
                        const SizedBox(height: 12),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: const [
                               StructureSlotCard(
                                slotName: "SUBJECT",
                                content: "THE FOX",
                                color: AppColors.energyFace,
                               ),
                               SizedBox(width: 12),
                               StructureSlotCard(
                                slotName: "VERB",
                                content: "RUNS",
                                color: AppColors.successFace,
                               ),
                               SizedBox(width: 12),
                               StructureSlotCard(
                                slotName: "ADVERB",
                                content: "FAST",
                                color: AppColors.vividPink,
                               ),
                            ],
                          ),
                        ),
                        
                        const SizedBox(height: 48),
                        
                        // Action Button
                        ClayButton(
                          label: "START MISSION",
                          onPressed: () {
                            Navigator.pop(context);
                            onStart();
                          },
                          color: AppColors.successFace,
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
