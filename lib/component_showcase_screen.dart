import 'package:flutter/material.dart';
import 'ui/components/game_button.dart';
import 'ui/components/game_choice_tile.dart';
import 'ui/theme/brand_colors.dart';

class ComponentShowcaseScreen extends StatefulWidget {
  const ComponentShowcaseScreen({super.key});

  @override
  State<ComponentShowcaseScreen> createState() => _ComponentShowcaseScreenState();
}

class _ComponentShowcaseScreenState extends State<ComponentShowcaseScreen> {
  bool _isLoading = false;
  TileState _tileState = TileState.idle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Game Components Showcase'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: AppColors.textDark,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Game Buttons',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            GameButton(
              label: 'PRIMARY BUTTON',
              onPressed: () {
                setState(() => _isLoading = true);
                Future.delayed(const Duration(seconds: 2), () {
                  if (mounted) setState(() => _isLoading = false);
                });
              },
              isLoading: _isLoading,
            ),
            const SizedBox(height: 16),
            GameButton(
              label: 'SECONDARY BUTTON',
              faceColor: AppColors.neutralFace,
              baseColor: AppColors.neutralBase,
              outlineColor: AppColors.neutralOutline,
              textStyle: const TextStyle(color: AppColors.textMain, fontWeight: FontWeight.bold),
              onPressed: () {},
            ),
            const SizedBox(height: 16),
            const GameButton(
              label: 'DISABLED BUTTON',
              onPressed: null,
              enabled: false,
            ),
            const SizedBox(height: 32),
            const Text(
              'Choice Tiles',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            GameChoiceTile(
              label: 'Idle State',
              state: TileState.idle,
              onPressed: () => setState(() => _tileState = TileState.selected),
            ),
            const SizedBox(height: 12),
            GameChoiceTile(
              label: 'Selected State',
              state: TileState.selected,
              onPressed: () => setState(() => _tileState = TileState.correct),
            ),
            const SizedBox(height: 12),
            GameChoiceTile(
              label: 'Correct State',
              state: TileState.correct,
              onPressed: () => setState(() => _tileState = TileState.wrong),
              leading: const Icon(Icons.music_note, color: AppColors.successFace),
            ),
            const SizedBox(height: 12),
            GameChoiceTile(
              label: 'Wrong State',
              state: TileState.wrong,
              onPressed: () => setState(() => _tileState = TileState.idle),
              leading: const Icon(Icons.error_outline, color: AppColors.errorFace),
            ),
          ],
        ),
      ),
    );
  }
}
