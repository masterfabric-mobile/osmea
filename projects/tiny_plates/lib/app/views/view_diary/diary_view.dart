import 'package:flutter/material.dart';
import 'package:osmea_components/osmea_components.dart';
import 'package:tiny_plates/gen/strings.g.dart';

class DiaryView extends StatelessWidget {
  const DiaryView({super.key});

  @override
  Widget build(BuildContext context) {
    return OsmeaComponents.center(
      child: OsmeaComponents.text(
        context.t.diary,
        fontSize: context.fontSizeExtraLarge,
        fontWeight: context.bold,
        color: OsmeaColors.thunder,
      ),
    );
  }
}
