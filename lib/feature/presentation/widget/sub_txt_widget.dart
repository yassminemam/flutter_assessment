import 'package:flutter/material.dart';
import 'package:flutter_assessment/core/theme/text_styles.dart';

class SubTxtWidget extends StatelessWidget {
  String txt;

  SubTxtWidget(this.txt, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      txt,
      style: AppTxtStyles.subHeaderTxtStyle
    );
  }
}
