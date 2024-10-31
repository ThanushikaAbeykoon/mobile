import 'package:flutter/material.dart';
import 'package:playhub/core/common/widgets/draggble_buttons.dart';
import 'package:playhub/core/theme/app_pallete.dart';
import 'package:playhub/features/customer_screens/arena/presentation/booked_arena.dart';

class DraggableHeader extends StatelessWidget {
  final String title;
  final String description;
  final VoidCallback onPressedOne;
  final VoidCallback onPressedTwo;

  DraggableHeader({
    required this.title,
    required this.description,
    required this.onPressedOne,
    required this.onPressedTwo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/icons/arena.gif',
                width: 50,
                height: 50,
              ),
              ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  colors: [AppPalettes.primary, AppPalettes.secondary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ).createShader(bounds),
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: AppPalettes.accent,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Text(
            description,
            style: TextStyle(
              fontSize: 12,
              color: AppPalettes.accent.withOpacity(0.5),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          DraggableButtons(
            onPressedOne: onPressedOne,
            onPressedTwo: onPressedTwo,
          ),
        ],
      ),
    );
  }
}
