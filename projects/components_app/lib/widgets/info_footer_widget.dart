import 'package:core/core.dart';
import 'package:flutter/material.dart';
import '../utils/asset_paths.dart';

class InfoFooterWidget extends StatelessWidget {
  const InfoFooterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return OsmeaComponents.padding(
      padding: const EdgeInsets.only(top: 40, bottom: 20, left: 20, right: 20),
      child: OsmeaComponents.row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          OsmeaComponents.sizedBox(width: 8),
          OsmeaComponents.text(
            'Built with ❤️ by the OSMEA Team',
            textStyle: OsmeaTextStyle.bodySmall(context).copyWith(
              fontWeight: FontWeight.w400,
              color: OsmeaColors.slate,
            ),
          ),
        ],
      ),
    );
  }
}
