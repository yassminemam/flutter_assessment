import 'package:flutter/material.dart';
import 'package:flutter_assessment/core/theme/text_styles.dart';

class SubTxtWidget extends StatelessWidget {
  String txt;
  var textAlign;

  SubTxtWidget(this.txt,
      {this.textAlign});

  @override
  Widget build(BuildContext context) {
    return Text(
      txt,
      textAlign: textAlign,
      style: AppTxtStyles.subHeaderTxtStyle
    );
  }
}
