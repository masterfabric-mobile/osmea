import 'package:core/core.dart';
import 'package:flutter/material.dart';
import '../widgets/logo_header_widget.dart';
import '../widgets/home_content_widget.dart';

class ModernLoginScreen extends StatefulWidget {
  const ModernLoginScreen({super.key});

  @override
  State<ModernLoginScreen> createState() => _ModernLoginScreenState();
}

class _ModernLoginScreenState extends State<ModernLoginScreen> {
  @override
  Widget build(BuildContext context) {
    return OsmeaComponents.container(
      color: OsmeaColors.white,
      child: SafeArea(
        child: OsmeaComponents.singleChildScrollView(
          padding: context.paddingNormal,
          child: OsmeaComponents.column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const LogoHeaderWidget(),
              const HomeContentWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
