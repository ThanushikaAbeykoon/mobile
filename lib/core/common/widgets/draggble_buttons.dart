import 'package:flutter/material.dart';
import 'package:playhub/core/common/widgets/gradient_button.dart';
import 'package:playhub/core/theme/app_pallete.dart';

class DraggableButtons extends StatelessWidget {
  final VoidCallback onPressedOne;
  final VoidCallback onPressedTwo;

  const DraggableButtons(
      {required this.onPressedOne, required this.onPressedTwo});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        DraggableButton(
          icon: Icons.favorite,
          text: "Wishlist",
          textColor: AppPalettes.accent,
          onPressed: onPressedOne,
        ),
        DraggableButton(
          icon: Icons.event,
          text: "Bookings",
          textColor: Colors.white,
          onPressed: onPressedTwo,
        ),
      ],
    );
  }
}
