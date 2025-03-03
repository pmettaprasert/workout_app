import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

/// A reusable FAB widget that displays three options:
///  - Solo
///  - Collaborative
///  - Competitive
class FabWorkoutMenu extends StatelessWidget {
  final VoidCallback onSoloTap;
  final VoidCallback onCollaborativeTap;
  final VoidCallback onCompetitiveTap;

  const FabWorkoutMenu({
    Key? key,
    required this.onSoloTap,
    required this.onCollaborativeTap,
    required this.onCompetitiveTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      icon: Icons.add,
      activeIcon: Icons.close,
      backgroundColor: Colors.blue,
      foregroundColor: Colors.white,
      activeBackgroundColor: Colors.red,
      activeForegroundColor: Colors.white,
      spacing: 10,
      spaceBetweenChildren: 5,
      buttonSize: const Size(56.0, 56.0),
      childrenButtonSize: const Size(50.0, 50.0),
      children: [
        SpeedDialChild(
          child: const Icon(Icons.person),
          label: 'Solo Workout',
          onTap: onSoloTap,
        ),
        SpeedDialChild(
          child: const Icon(Icons.group),
          label: 'Collaborative Workout',
          onTap: onCollaborativeTap,
        ),
        SpeedDialChild(
          child: const Icon(Icons.sports_kabaddi),
          label: 'Competitive Workout',
          onTap: onCompetitiveTap,
        ),
      ],
    );
  }
}