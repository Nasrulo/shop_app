import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/utilities/animation_color_list/animation_color_util.dart';

class ColorizeAnimationWidget extends StatelessWidget {
  ColorizeAnimationWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedTextKit(
      repeatForever: true,
      animatedTexts: [
        ColorizeAnimatedText(
          'Welcome',
          textStyle: TextStyle(
            fontSize: 45,
            fontWeight: FontWeight.bold,
            fontFamily: 'Acme',
          ),
          colors: AnimationColorListUtil.textColor,
        ),
        ColorizeAnimatedText(
          'Duck Store',
          textStyle: TextStyle(
            fontSize: 45,
            fontWeight: FontWeight.bold,
            fontFamily: 'Acme',
          ),
          colors: AnimationColorListUtil.textColor,
        ),
      ],
      // onTap: () {
      //   print("Tap Event");
      // },
    );
  }
}