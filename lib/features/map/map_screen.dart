import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:math' as math;
import 'snake_node_button.dart';
import 'snake_path_painter.dart';
import 'quest_preview_sheet.dart';
import '../../ui/theme/brand_colors.dart';
import '../../ui/theme/metrics.dart';
import '../../ui/components/map_hud.dart';
import '../../ui/components/skip_jump_button.dart';
import '../../ui/components/navigation_sidebar.dart';
import '../../ui/components/dashboard_panel.dart';
import '../../ui/components/clay_button.dart';
import '../../ui/components/progress_node_button.dart';


// ==================== [Data Model] ====================

class MapQuest {
  final String id;
  final String title;
  final String description;
  final ProgressNodeStatus status;
  final double progress;
  final IconData? icon;
  final ProgressNodeStyle style;
  final NodeShape shape;
  final Color color;

  MapQuest({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    this.progress = 0.0,
    this.icon,
    required this.style,
    required this.shape,
    required this.color,
  });
}

final List<MapQuest> snakeQuests = List.generate(20, (i) {
  ProgressNodeStatus status = ProgressNodeStatus.locked;
  if (i < 3) status = ProgressNodeStatus.completed;
  if (i == 3) status = ProgressNodeStatus.available;
  
  IconData icon;
  final int type = i % 6;
  switch (type) {
    case 0: icon = Icons.star_rounded; break;
    case 1: icon = Icons.my_library_books_rounded; break;
    case 2: icon = Icons.headphones_rounded; break;
    case 3: icon = Icons.edit_note_rounded; break;
    case 4: icon = Icons.mic_rounded; break;
    case 5: icon = Icons.emoji_events_rounded; break;
    default: icon = Icons.star_rounded;
  }

  // Variety generation logic
  final style = ProgressNodeStyle.values[i % ProgressNodeStyle.values.length];
  final shape = (i % 3 == 0) ? NodeShape.roundedSquare : NodeShape.circle;
  
  final colors = [
    AppColors.duoBlue,
    AppColors.duoGreen,
    AppColors.duoRed,
    Colors.purple,
    Colors.orange,
    Colors.teal,
  ];
  final color = colors[i % colors.length];
  
  return MapQuest(
    id: "$i",
    title: "Lesson ${i + 1}",
    description: "Learn essential structure #${i + 1}",
    status: status,
    progress: (i == 3) ? 0.4 : 1.0,
    icon: icon,
    style: style,
    shape: shape,
    color: color,
  );
});

// ==================== [Main Map Screen] ====================

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final ScrollController _scrollController = ScrollController();
  
  @override
  Widget build(BuildContext context) {
    const double nodeSpacing = 120.0;
    final List<Offset> nodePositions = List.generate(snakeQuests.length, (i) {
      double dx = _calculateHorizontalOffset(i, 80.0);
      double dy = i * nodeSpacing + 100; 
      return Offset(dx, dy);
    });

    return Scaffold(
      backgroundColor: AppColors.duoDarkBg,
      body: Row(
        children: [
          // 1. LEFT SIDEBAR
          const NavigationSidebar(),

          // 2. CENTER CONTENT (Path)
          Expanded(
            flex: 3,
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
                  const SizedBox(height: 32),
                  // GREEN UNIT HEADER
                  Center(
                    child: Container(
                      width: 600,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: AppColors.duoGreen,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "섹션 1, 유닛 1",
                                  style: TextStyle(color: Colors.white.withOpacity(0.8), fontWeight: FontWeight.bold, fontSize: 13),
                                ),
                                const Text(
                                  "음식과 음료 주문하기",
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 24),
                                ),
                              ],
                            ),
                          ),
                          _buildGuidebookButton(),
                        ],
                      ),
                  ),
                  
                  const SizedBox(height: 40),
                  const Text("CHOOSE YOUR STYLE", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 2, fontSize: 12)),
                  const SizedBox(height: 20),
                  
                  // Style Comparison Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ProgressNodeButton(
                        progress: 0.6,
                        icon: Icons.star_rounded,
                        label: "CLASSIC 3D",
                        onPressed: () {},
                        style: ProgressNodeStyle.classic3D,
                        size: 70,
                      ),
                      const SizedBox(width: 24),
                      ProgressNodeButton(
                        progress: 0.8,
                        icon: Icons.auto_awesome,
                        label: "GLASS",
                        onPressed: () {},
                        style: ProgressNodeStyle.glassmorphic,
                        size: 70,
                      ),
                      const SizedBox(width: 24),
                      ProgressNodeButton(
                        progress: 0.4,
                        icon: Icons.fingerprint,
                        label: "SOFT",
                        onPressed: () {},
                        style: ProgressNodeStyle.neumorphic,
                        size: 70,
                      ),
                      const SizedBox(width: 24),
                      ProgressNodeButton(
                        progress: 0.7,
                        icon: Icons.rocket_launch,
                        label: "FLOATING",
                        onPressed: () {},
                        style: ProgressNodeStyle.floatingIsland,
                        size: 70,
                        color: AppColors.duoRedBase,
                      ),
                    ],
                  ),
                  const SizedBox(height: 60),
                  const Text("WOOD COLLAGE STYLE (FROM IMAGE)", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 2, fontSize: 12)),
                  const SizedBox(height: 30),
                  
                  // Row 1: Green Rounded Squares
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ProgressNodeButton(
                        style: ProgressNodeStyle.woody3D,
                        shape: NodeShape.roundedSquare,
                        icon: Icons.play_arrow_rounded,
                        onPressed: () {},
                        color: const Color(0xFF66BB6A),
                        size: 60,
                      ),
                      const SizedBox(width: 12),
                      ProgressNodeButton(
                        style: ProgressNodeStyle.woody3D,
                        shape: NodeShape.roundedSquare,
                        icon: Icons.settings,
                        onPressed: () {},
                        color: const Color(0xFF66BB6A),
                        size: 60,
                      ),
                      const SizedBox(width: 12),
                      ProgressNodeButton(
                        style: ProgressNodeStyle.woody3D,
                        shape: NodeShape.roundedSquare,
                        icon: Icons.mail_rounded,
                        onPressed: () {},
                        color: const Color(0xFF66BB6A),
                        size: 60,
                      ),
                      const SizedBox(width: 12),
                      ProgressNodeButton(
                        style: ProgressNodeStyle.woody3D,
                        shape: NodeShape.roundedSquare,
                        icon: Icons.volume_up_rounded,
                        onPressed: () {},
                        color: const Color(0xFF66BB6A),
                        size: 60,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  
                  // Row 2: Capsules and Mixed
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ProgressNodeButton(
                        style: ProgressNodeStyle.woody3D,
                        shape: NodeShape.capsule,
                        text: "PLAY",
                        onPressed: () {},
                        color: const Color(0xFFFFCA28),
                        size: 60,
                        width: 160,
                      ),
                      const SizedBox(width: 20),
                      ProgressNodeButton(
                        style: ProgressNodeStyle.woody3D,
                        shape: NodeShape.circle,
                        icon: Icons.favorite,
                        onPressed: () {},
                        color: const Color(0xFFEC407A),
                        size: 70,
                      ),
                      const SizedBox(width: 20),
                      ProgressNodeButton(
                        style: ProgressNodeStyle.woody3D,
                        shape: NodeShape.capsule,
                        text: "NEXT",
                        onPressed: () {},
                        color: const Color(0xFF29B6F6),
                        size: 60,
                        width: 160,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  
                  // Row 3: Squares with different colors
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ProgressNodeButton(
                        style: ProgressNodeStyle.woody3D,
                        shape: NodeShape.roundedSquare,
                        icon: Icons.close_rounded,
                        onPressed: () {},
                        color: const Color(0xFFEF5350),
                        size: 65,
                      ),
                      const SizedBox(width: 15),
                      ProgressNodeButton(
                        style: ProgressNodeStyle.woody3D,
                        shape: NodeShape.roundedSquare,
                        icon: Icons.check_rounded,
                        onPressed: () {},
                        color: const Color(0xFF66BB6A),
                        size: 65,
                      ),
                      const SizedBox(width: 15),
                      ProgressNodeButton(
                        style: ProgressNodeStyle.woody3D,
                        shape: NodeShape.roundedSquare,
                        icon: Icons.star_rounded,
                        onPressed: () {},
                        color: const Color(0xFFFFCA28),
                        size: 65,
                      ),
                    ],
                  ),
                  const SizedBox(height: 60),
                  const Text("JUICY ENHANCEMENTS (SHINE & SQUISH)", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 2, fontSize: 12)),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ProgressNodeButton(
                        style: ProgressNodeStyle.classic3D,
                        icon: Icons.flash_on_rounded,
                        onPressed: () {},
                        color: Colors.orange,
                        size: 75,
                      ),
                      const SizedBox(width: 25),
                      ProgressNodeButton(
                        style: ProgressNodeStyle.woody3D,
                        shape: NodeShape.capsule,
                        text: "JUICY",
                        onPressed: () {},
                        color: Colors.purpleAccent,
                        size: 70,
                        width: 180,
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  const Text("FANTASY GLOW STYLE", style: TextStyle(color: Colors.cyanAccent, fontWeight: FontWeight.bold, letterSpacing: 2, fontSize: 12)),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ProgressNodeButton(
                        style: ProgressNodeStyle.fantasyGlow,
                        shape: NodeShape.circle,
                        icon: Icons.auto_awesome,
                        onPressed: () {},
                        color: Colors.indigo,
                        size: 80,
                      ),
                      const SizedBox(width: 20),
                      ProgressNodeButton(
                        style: ProgressNodeStyle.fantasyGlow,
                        shape: NodeShape.roundedSquare,
                        icon: Icons.diamond_rounded,
                        onPressed: () {},
                        color: Colors.deepPurple,
                        size: 80,
                      ),
                    ],
                  ),
                  const SizedBox(height: 80),

                  // THE PATH
                  SizedBox(
                    width: 600,
                    height: nodePositions.last.dy + 300,
                    child: Stack(
                      alignment: Alignment.topCenter,
                      clipBehavior: Clip.none,
                      children: [
                        // Path Painter
                        CustomPaint(
                          size: Size(600, nodePositions.last.dy),
                          painter: SnakePathPainter(
                            nodePositions: nodePositions,
                            color: Colors.white.withOpacity(0.05),
                          ),
                        ),

                        // Nodes
                        ...List.generate(snakeQuests.length, (i) {
                          final quest = snakeQuests[i];
                          final pos = nodePositions[i];
                          
                          return Positioned(
                            left: (300 + pos.dx) - (quest.shape == NodeShape.roundedSquare ? 40 : 48),
                            top: pos.dy - 10,
                            child: ProgressNodeButton(
                              progress: quest.progress,
                              icon: quest.icon ?? Icons.star_rounded,
                              label: "STEP ${i + 1}",
                              onPressed: () => _showQuestPreview(quest),
                              color: quest.color,
                              size: quest.shape == NodeShape.roundedSquare ? 80 : 90,
                              style: quest.style,
                              shape: quest.shape,
                              status: quest.status,
                            ),
                          );
                        }),

                        // Mascot
                        _buildMascot(nodePositions[3]),
                        
                        // Skip Button (Tooltipped)
                        Positioned(
                          left: (300 + nodePositions[5].dx) - 60,
                          top: nodePositions[5].dy - 130,
                          child: SkipJumpButton(onTap: () {}),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 3. RIGHT SIDEBAR
          Container(
            width: 380,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            decoration: const BoxDecoration(
              border: Border(left: BorderSide(color: AppColors.duoBorder, width: 2)),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  const MapHUD(streak: 5, hearts: 5, gems: 500),
                  const SizedBox(height: 24),
                  
                  DashboardPanel(
                    title: "리더보드 잠금 해제!", 
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white10,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.shield_rounded, color: Colors.white38, size: 32),
                        ),
                        const SizedBox(width: 16),
                        Expanded(child: Text("레슨을 10개 이상 완료하여 경쟁을 시작하세요.", style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 13))),
                      ],
                    ),
                  ),

                  DashboardPanel(
                    title: "오늘의 퀘스트", 
                    actionText: "모두 보기",
                    child: _buildQuestCard(),
                  ),

                  DashboardPanel(
                    title: "프로필을 생성하여 진도를 저장하세요!", 
                    child: Column(
                      children: [
                        ClayButton(label: "프로필 생성하기", onPressed: () {}, color: AppColors.duoGreen, fullWidth: true),
                        const SizedBox(height: 12),
                        ClayButton(label: "로그인", onPressed: () {}, color: AppColors.duoBlue, fullWidth: true),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGuidebookButton() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.duoGreenBase,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.2), width: 2),
      ),
      child: const Row(
        children: [
          Icon(Icons.menu_book_rounded, color: Colors.white, size: 20),
          SizedBox(width: 8),
          Text("가이드북", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildQuestCard() {
    return Row(
      children: [
        const Icon(Icons.bolt_rounded, color: Colors.yellow, size: 48),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("10 XP 획득하기", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: 0.1, 
                  minHeight: 8,
                  backgroundColor: Colors.white10, 
                  valueColor: AlwaysStoppedAnimation(Colors.yellow[700])
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  double _calculateHorizontalOffset(int index, double amplitude) {
    final int cycleIndex = index % 8;
    const double duoAmplitude = 100.0;
    switch (cycleIndex) {
      case 0: return 0;
      case 1: return -60;
      case 2: return -duoAmplitude;
      case 3: return -60;
      case 4: return 0;
      case 5: return 60;
      case 6: return duoAmplitude;
      case 7: return 60;
      default: return 0;
    }
  }

  void _showQuestPreview(MapQuest quest) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => QuestPreviewSheet(
        title: quest.title,
        description: quest.description,
        onStart: () => context.push('/review'),
      ),
    );
  }

  Widget _buildMascot(Offset position) {
    return Positioned(
      left: (300 + position.dx) + 40,
      top: position.dy - 60,
      child: Image.asset(
        'assets/mascot_fox.png',
        width: 140.0,
        height: 140.0,
        fit: BoxFit.contain,
      ),
    );
  }
}
