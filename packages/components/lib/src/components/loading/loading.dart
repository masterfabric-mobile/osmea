// ignore_for_file: unused_element

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:osmea_components/src/components/align/align.dart';
import 'package:osmea_components/src/components/center/center.dart';
import 'package:osmea_components/src/components/column/column.dart';
import 'package:osmea_components/src/components/container/container.dart';
import 'package:osmea_components/src/components/row/row.dart';
import 'package:osmea_components/src/components/sized_box/sized_box.dart';
import 'package:osmea_components/src/core/container_widget.dart';
import 'package:osmea_components/src/utils/sizer_extensions.dart';
import '../../enums/loading_enums.dart';
import 'cubit/loading_cubit.dart';
import 'cubit/loading_state.dart';
import '../../styles/colors.dart';

class CoreLoadingWidget extends CoreContainer {
  final LoadingCubit cubit;

  const CoreLoadingWidget({
    required this.cubit,
    super.key,
    super.width,
    super.height,
    super.color,
    super.decoration,
    super.padding,
    super.margin,
    super.alignment,
    super.constraints,
    super.transform,
    super.transformAlignment,
    super.foregroundDecoration,
    super.clipBehavior,
    super.child,
    super.customTheme,
  });

  @override
  Widget buildWidget(BuildContext context) {
    return BlocBuilder<LoadingCubit, LoadingState>(
      bloc: cubit,
      builder: (context, state) {
        if (!state.visible) return const SizedBox.shrink();
        switch (state.type) {
          case LoadingType.circularFade:
            return _buildCircularFade(state.size, state.color);
          case LoadingType.bouncingDots:
            return _buildBouncingDots(state.size, state.color, state.progress);
          case LoadingType.waveBars:
            return _buildWaveBars(state.size, state.color, state.progress);
          case LoadingType.chasingDots:
            return _buildChasingDots(state.size, state.color, state.progress);
          case LoadingType.dualRing:
            return _buildDualRing(state.size, state.color, state.progress);
          case LoadingType.zigzagDots:
            return _buildZigzagDots(state.size, state.color, state.progress);
          case LoadingType.tripleBounce:
            return _buildTripleBounce(state.size, state.color, state.progress);
          case LoadingType.dotCircle:
            return _buildDotCircle(state.size, state.color, state.progress);
          case LoadingType.barLoader:
            return _buildBarLoader(state.size, state.color, state.progress);
          case LoadingType.fadingCircle:
            return _buildFadingCircle(state.size, state.color, state.progress);
          case LoadingType.rotatingDots:
            return _buildRotatingDots(state.size, state.color, state.progress);
          case LoadingType.dancingSquares:
            return _buildDancingSquares(
                state.size, state.color, state.progress);
          case LoadingType.orbitDot:
            return _buildOrbitDot(state.size, state.color, state.progress);
          case LoadingType.spiral:
            return _buildSpiral(state.size, state.color, state.progress);
          case LoadingType.rotatingArcs:
            return _buildRotatingArcs(state.size, state.color, state.progress);
          case LoadingType.gridPulse:
            return _buildGridPulse(state.size, state.color, state.progress);
          case LoadingType.arcLoader:
            return _buildArcLoader(state.size, state.color, state.progress);
          case LoadingType.dotFlash:
            return _buildDotFlash(state.size, state.color, state.progress);
          case LoadingType.barWave:
            return _buildBarWave(state.size, state.color, state.progress);
          case LoadingType.atom:
            return _buildAtom(state.size, state.color, state.progress);
        }
      },
    );
  }

  Widget _buildCircularFade(double size, Color? color) {
    final c = color ?? OsmeaColors.nordicBlue;
    return OsmeaSizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        strokeWidth: size * 0.12,
        valueColor:
            AlwaysStoppedAnimation<Color>(c.withAlpha((0.8 * 255).round())),
        backgroundColor: c.withAlpha((0.2 * 255).round()),
      ),
    );
  }

  Widget _buildBouncingDots(double size, Color? color,
      [double progress = 0.0]) {
    final c = color ?? OsmeaColors.nordicBlue;
    return _BouncingDotsLoading(size: size, color: c, progress: progress);
  }

  Widget _buildWaveBars(double size, Color? color, [double progress = 0.0]) {
    final c = color ?? OsmeaColors.nordicBlue;
    return _WaveBarsLoading(size: size, color: c, progress: progress);
  }

  Widget _buildChasingDots(double size, Color? color, double progress) {
    final c = color ?? OsmeaColors.nordicBlue;
    return _ChasingDotsLoading(size: size, color: c, progress: progress);
  }

  Widget _buildDualRing(double size, Color? color, double progress) {
    final c = color ?? OsmeaColors.nordicBlue;
    return _DualRingLoading(size: size, color: c, progress: progress);
  }

  Widget _buildZigzagDots(double size, Color? color, double progress) {
    final c = color ?? OsmeaColors.nordicBlue;
    return _ZigzagDotsLoading(size: size, color: c, progress: progress);
  }

  Widget _buildTripleBounce(double size, Color? color, double progress) {
    final c = color ?? OsmeaColors.nordicBlue;
    return _TripleBounceLoading(size: size, color: c, progress: progress);
  }

  Widget _buildDotCircle(double size, Color? color, double progress) {
    final c = color ?? OsmeaColors.nordicBlue;
    return _DotCircleLoading(size: size, color: c, progress: progress);
  }

  Widget _buildBarLoader(double size, Color? color, double progress) {
    final c = color ?? OsmeaColors.nordicBlue;
    return _BarLoaderLoading(size: size, color: c, progress: progress);
  }

  Widget _buildFadingCircle(double size, Color? color, double progress) {
    final c = color ?? OsmeaColors.nordicBlue;
    return _FadingCircleLoading(size: size, color: c, progress: progress);
  }

  Widget _buildRotatingDots(double size, Color? color, double progress) {
    final c = color ?? OsmeaColors.nordicBlue;
    return _RotatingDotsLoading(size: size, color: c, progress: progress);
  }

  Widget _buildDancingSquares(double size, Color? color, double progress) {
    final c = color ?? OsmeaColors.nordicBlue;
    return _DancingSquaresLoading(size: size, color: c, progress: progress);
  }

  Widget _buildOrbitDot(double size, Color? color, double progress) {
    final c = color ?? OsmeaColors.nordicBlue;
    return _OrbitDotLoading(size: size, color: c, progress: progress);
  }

  Widget _buildSpiral(double size, Color? color, double progress) {
    final c = color ?? OsmeaColors.nordicBlue;
    return _SpiralLoading(size: size, color: c, progress: progress);
  }

  Widget _buildRotatingArcs(double size, Color? color, double progress) {
    final c = color ?? OsmeaColors.nordicBlue;
    return _RotatingArcsLoading(size: size, color: c, progress: progress);
  }

  Widget _buildJumpingBall(double size, Color? color, double progress) {
    final c = color ?? OsmeaColors.nordicBlue;
    return _JumpingBallLoading(size: size, color: c, progress: progress);
  }

  Widget _buildGridPulse(double size, Color? color, double progress) {
    final c = color ?? OsmeaColors.nordicBlue;
    return _GridPulseLoading(size: size, color: c, progress: progress);
  }

  Widget _buildArcLoader(double size, Color? color, double progress) {
    final c = color ?? OsmeaColors.nordicBlue;
    return _ArcLoaderLoading(size: size, color: c, progress: progress);
  }

  Widget _buildDotFlash(double size, Color? color, double progress) {
    final c = color ?? OsmeaColors.nordicBlue;
    return _DotFlashLoading(size: size, color: c, progress: progress);
  }

  Widget _buildBarWave(double size, Color? color, double progress) {
    final c = color ?? OsmeaColors.nordicBlue;
    return _BarWaveLoading(size: size, color: c, progress: progress);
  }

  Widget _buildAtom(double size, Color? color, double progress) {
    final c = color ?? OsmeaColors.nordicBlue;
    return _AtomLoading(size: size, color: c, progress: progress);
  }
}

class _BouncingDotsLoading extends StatelessWidget {
  final double size;
  final Color color;
  final double progress;
  const _BouncingDotsLoading(
      {Key? key,
      required this.size,
      required this.color,
      required this.progress})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    const count = 3;
    final dotWidth = size / (count * 1.4);
    final margin = size / (count * 7);
    return OsmeaSizedBox(
      width: size,
      height: size * 0.5,
      child: OsmeaRow(
        mainAxisAlignment: centerMain,
        children: List.generate(count, (i) {
          final t = ((progress + i * 0.2) % 1.0);
          final y = -size * 0.15 * sin(t * pi);
          return Transform.translate(
            offset: Offset(0, y),
            child: OsmeaContainer(
              width: dotWidth,
              height: dotWidth,
              margin: EdgeInsets.symmetric(horizontal: margin),
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
          );
        }),
      ),
    );
  }
}

class _WaveBarsLoading extends StatelessWidget {
  final double size;
  final Color color;
  final double progress;
  const _WaveBarsLoading(
      {Key? key, this.size = 32, required this.color, required this.progress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    const barCount = 5;
    return SizedBox(
      width: size,
      height: size * 0.6,
      child: OsmeaRow(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(barCount, (i) {
          final delay = i * 0.1;
          final t = ((progress + delay) % 1.0);
          final scale = 0.5 + 0.5 * (1 - (t - 0.5).abs() * 2);
          return Transform.scale(
            scale: scale,
            child: OsmeaContainer(
              width: size * 0.12,
              height: size * 0.5,
              margin: EdgeInsets.symmetric(horizontal: size * 0.03),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _ChasingDotsLoading extends StatefulWidget {
  final double size;
  final Color color;
  final double progress;
  const _ChasingDotsLoading(
      {Key? key, this.size = 32, required this.color, required this.progress})
      : super(key: key);
  @override
  State<_ChasingDotsLoading> createState() => _ChasingDotsLoadingState();
}

class _ChasingDotsLoadingState extends State<_ChasingDotsLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: context.animationMedium)
          ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OsmeaSizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final angle = _controller.value * 6.28319;
          return Stack(
            alignment: center,
            children: [
              Transform.translate(
                offset: Offset(widget.size * 0.35 * cos(angle),
                    widget.size * 0.35 * sin(angle)),
                child: _dot(
                    widget.size, widget.color.withAlpha((0.7 * 255).round())),
              ),
              Transform.translate(
                offset: Offset(widget.size * 0.35 * cos(angle + 3.14159),
                    widget.size * 0.35 * sin(angle + 3.14159)),
                child: _dot(
                    widget.size, widget.color.withAlpha((0.3 * 255).round())),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _dot(double size, Color color) => OsmeaContainer(
        width: size * 0.22,
        height: size * 0.22,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      );
}

class _DualRingLoading extends StatefulWidget {
  final double size;
  final Color color;
  final double progress;
  const _DualRingLoading(
      {Key? key, this.size = 32, required this.color, required this.progress})
      : super(key: key);
  @override
  State<_DualRingLoading> createState() => _DualRingLoadingState();
}

class _DualRingLoadingState extends State<_DualRingLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: context.animationMedium)
          ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OsmeaSizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Stack(
            alignment: Alignment.center,
            children: [
              Transform.rotate(
                angle: _controller.value * 6.28319,
                child: CustomPaint(
                  size: Size(widget.size, widget.size),
                  painter: _RingPainter(
                      widget.color.withAlpha((0.7 * 255).round()), 0.8),
                ),
              ),
              Transform.rotate(
                angle: -_controller.value * 6.28319,
                child: CustomPaint(
                  size: Size(widget.size * 0.7, widget.size * 0.7),
                  painter: _RingPainter(
                      widget.color.withAlpha((0.3 * 255).round()), 0.6),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  final Color color;
  final double thickness;
  _RingPainter(this.color, this.thickness);
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = size.width * 0.12 * thickness
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromLTWH(0, 0, size.width, size.height),
      0,
      3.14159 * 1.5,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ZigzagDotsLoading extends StatelessWidget {
  final double size;
  final Color color;
  final double progress;
  const _ZigzagDotsLoading(
      {Key? key,
      required this.size,
      required this.color,
      required this.progress})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    const count = 5;
    final dotWidth = size / (count * 1.4);
    final margin = size / (count * 7);
    return OsmeaSizedBox(
      width: size,
      height: size * 0.5,
      child: OsmeaRow(
        mainAxisAlignment: centerMain,
        children: List.generate(count, (i) {
          final t = ((progress + i * 0.15) % 1.0);
          final y =
              (i.isEven ? -1 : 1) * (size * 0.15) * (0.5 - (t - 0.5).abs());
          return Transform.translate(
            offset: Offset(0, y),
            child: OsmeaContainer(
              width: dotWidth,
              height: dotWidth,
              margin: EdgeInsets.symmetric(horizontal: margin),
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
          );
        }),
      ),
    );
  }
}

class _TripleBounceLoading extends StatelessWidget {
  final double size;
  final Color color;
  final double progress;
  const _TripleBounceLoading(
      {Key? key,
      required this.size,
      required this.color,
      required this.progress})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    const count = 3;
    final dotWidth = size / (count * 1.4);
    final margin = size / (count * 7);
    return SizedBox(
      width: size,
      height: size * 0.5,
      child: OsmeaRow(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(count, (i) {
          final t = ((progress + i * 0.2) % 1.0);
          final scale = 0.5 + 0.5 * sin(t * pi);
          return Transform.scale(
            scale: scale,
            child: OsmeaContainer(
              width: dotWidth,
              height: dotWidth,
              margin: EdgeInsets.symmetric(horizontal: margin),
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
          );
        }),
      ),
    );
  }
}

class _DotCircleLoading extends StatelessWidget {
  final double size;
  final Color color;
  final double progress;
  const _DotCircleLoading(
      {Key? key,
      required this.size,
      required this.color,
      required this.progress})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    const count = 10;
    return OsmeaSizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: center,
        children: List.generate(count, (i) {
          final angle = 2 * pi * i / count;
          final t = ((progress + i / count) % 1.0);
          final scale = 0.5 + 0.5 * t;
          return Transform.translate(
            offset: Offset(size * 0.38 * cos(angle), size * 0.38 * sin(angle)),
            child: Transform.scale(
              scale: scale,
              child: OsmeaContainer(
                width: size * 0.11,
                height: size * 0.11,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _BarLoaderLoading extends StatelessWidget {
  final double size;
  final Color color;
  final double progress;
  const _BarLoaderLoading(
      {Key? key,
      required this.size,
      required this.color,
      required this.progress})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    const barCount = 6;
    final barWidth = size / (barCount * 2.2);
    final margin = size / (barCount * 7);
    return OsmeaSizedBox(
      width: size,
      height: size * 0.3,
      child: OsmeaRow(
        mainAxisAlignment: centerMain,
        children: List.generate(barCount, (i) {
          final t = ((progress + i * 0.12) % 1.0);
          final h = size * 0.18 + size * 0.12 * t;
          return OsmeaContainer(
            width: barWidth,
            height: h,
            margin: EdgeInsets.symmetric(horizontal: margin),
            decoration: BoxDecoration(
                color: color, borderRadius: context.borderRadiusLow),
          );
        }),
      ),
    );
  }
}

class _FadingCircleLoading extends StatelessWidget {
  final double size;
  final Color color;
  final double progress;
  const _FadingCircleLoading(
      {Key? key,
      required this.size,
      required this.color,
      required this.progress})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    const count = 12;
    return OsmeaSizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: List.generate(count, (i) {
          final angle = 2 * pi * i / count;
          final t = ((progress + i / count) % 1.0);
          final opacity = 0.2 + 0.8 * t;
          return Transform.translate(
            offset: Offset(size * 0.38 * cos(angle), size * 0.38 * sin(angle)),
            child: Opacity(
              opacity: opacity,
              child: OsmeaContainer(
                width: size * 0.11,
                height: size * 0.11,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _RotatingDotsLoading extends StatelessWidget {
  final double size;
  final Color color;
  final double progress;
  const _RotatingDotsLoading(
      {Key? key,
      required this.size,
      required this.color,
      required this.progress})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    const count = 8;
    return OsmeaSizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: center,
        children: List.generate(count, (i) {
          final angle = 2 * pi * i / count + progress * 2 * pi;
          return Transform.translate(
            offset: Offset(size * 0.38 * cos(angle), size * 0.38 * sin(angle)),
            child: OsmeaContainer(
              width: size * 0.13,
              height: size * 0.13,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
          );
        }),
      ),
    );
  }
}

class _DancingSquaresLoading extends StatelessWidget {
  final double size;
  final Color color;
  final double progress;
  const _DancingSquaresLoading(
      {Key? key,
      required this.size,
      required this.color,
      required this.progress})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    const count = 4;
    final squareWidth = size / (count * 1.4);
    final margin = size / (count * 7);
    return OsmeaSizedBox(
      width: size,
      height: size * 0.5,
      child: OsmeaRow(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(count, (i) {
          final t = ((progress + i * 0.18) % 1.0);
          final scale = 0.7 + 0.3 * sin(t * 2 * pi);
          return Transform.scale(
            scale: scale,
            child: OsmeaContainer(
              width: squareWidth,
              height: squareWidth,
              margin: EdgeInsets.symmetric(horizontal: margin),
              decoration: BoxDecoration(
                color: color,
                borderRadius: context.borderRadiusLow,
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _OrbitDotLoading extends StatelessWidget {
  final double size;
  final Color color;
  final double progress;
  const _OrbitDotLoading(
      {Key? key,
      required this.size,
      required this.color,
      required this.progress})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return OsmeaSizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: center,
        children: [
          Opacity(
            opacity: 0.2,
            child: OsmeaContainer(
              width: size * 0.8,
              height: size * 0.8,
              decoration: BoxDecoration(
                border: Border.all(color: color, width: size * 0.07),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Transform.rotate(
            angle: progress * 2 * pi,
            child: OsmeaAlign(
              alignment: topCenter,
              child: OsmeaContainer(
                width: size * 0.18,
                height: size * 0.18,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SpiralLoading extends StatelessWidget {
  final double size;
  final Color color;
  final double progress;
  const _SpiralLoading(
      {Key? key,
      required this.size,
      required this.color,
      required this.progress})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    const count = 12;
    return OsmeaSizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: center,
        children: List.generate(count, (i) {
          final t = ((progress + i / count) % 1.0);
          final angle = 2 * pi * i / count + t * 2 * pi;
          final r = size * 0.15 + size * 0.25 * t;
          return Transform.translate(
            offset: Offset(r * cos(angle), r * sin(angle)),
            child: OsmeaContainer(
              width: size * 0.09,
              height: size * 0.09,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
          );
        }),
      ),
    );
  }
}

class _RotatingArcsLoading extends StatelessWidget {
  final double size;
  final Color color;
  final double progress;
  const _RotatingArcsLoading(
      {Key? key,
      required this.size,
      required this.color,
      required this.progress})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return OsmeaSizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        size: Size(size, size),
        painter: _RotatingArcsPainter(color, progress),
      ),
    );
  }
}

class _RotatingArcsPainter extends CustomPainter {
  final Color color;
  final double progress;
  _RotatingArcsPainter(this.color, this.progress);
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = size.width * 0.13
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    for (int i = 0; i < 2; i++) {
      final start = (progress + i * 0.5) * 2 * pi;
      canvas.drawArc(
        Rect.fromLTWH(0, 0, size.width, size.height),
        start,
        pi / 1.5,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _JumpingBallLoading extends StatelessWidget {
  final double size;
  final Color color;
  final double progress;
  const _JumpingBallLoading(
      {Key? key,
      required this.size,
      required this.color,
      required this.progress})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final t = (progress % 1.0);
    final y = -size * 0.25 * sin(t * pi);
    return OsmeaSizedBox(
      width: size,
      height: size * 0.7,
      child: OsmeaAlign(
        alignment: Alignment.bottomCenter,
        child: Transform.translate(
          offset: Offset(0, y),
          child: OsmeaContainer(
            width: size * 0.22,
            height: size * 0.22,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
        ),
      ),
    );
  }
}

class _GridPulseLoading extends StatelessWidget {
  final double size;
  final Color color;
  final double progress;
  const _GridPulseLoading(
      {Key? key,
      required this.size,
      required this.color,
      required this.progress})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    const count = 3;
    final margin = size < 30 ? size * 0.01 : size * 0.02;
    return OsmeaSizedBox(
      width: size,
      height: size,
      child: OsmeaColumn(
        mainAxisAlignment: centerMain,
        children: List.generate(count, (i) {
          return OsmeaRow(
            mainAxisAlignment: centerMain,
            children: List.generate(count, (j) {
              final t = ((progress + (i * count + j) * 0.07) % 1.0);
              final scale = 0.7 + 0.3 * sin(t * 2 * pi);
              return Transform.scale(
                scale: scale,
                child: OsmeaContainer(
                  width: size * 0.18,
                  height: size * 0.18,
                  margin: EdgeInsets.all(margin),
                  decoration: BoxDecoration(
                      color: color, borderRadius: context.borderRadiusLow),
                ),
              );
            }),
          );
        }),
      ),
    );
  }
}

class _DiamondSpinLoading extends StatelessWidget {
  final double size;
  final Color color;
  final double progress;
  const _DiamondSpinLoading(
      {Key? key,
      required this.size,
      required this.color,
      required this.progress})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return OsmeaSizedBox(
      width: size,
      height: size,
      child: Transform.rotate(
        angle: progress * 2 * pi,
        child: OsmeaCenter(
          child: OsmeaContainer(
            width: size * 0.6,
            height: size * 0.6,
            decoration: BoxDecoration(
              color: color,
              borderRadius: context.borderRadiusMedium,
              shape: BoxShape.rectangle,
            ),
            transform: Matrix4.rotationZ(pi / 4),
          ),
        ),
      ),
    );
  }
}

class _WaveCircleLoading extends StatelessWidget {
  final double size;
  final Color color;
  final double progress;
  const _WaveCircleLoading(
      {Key? key,
      required this.size,
      required this.color,
      required this.progress})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    const count = 8;
    return OsmeaSizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: center,
        children: List.generate(count, (i) {
          final t = ((progress + i / count) % 1.0);
          final r = size * 0.25 + size * 0.18 * sin(t * 2 * pi);
          final angle = 2 * pi * i / count;
          return Transform.translate(
            offset: Offset(r * cos(angle), r * sin(angle)),
            child: OsmeaContainer(
              width: size * 0.13,
              height: size * 0.13,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
          );
        }),
      ),
    );
  }
}

class _FlipSquareLoading extends StatelessWidget {
  final double size;
  final Color color;
  final double progress;
  const _FlipSquareLoading(
      {Key? key,
      required this.size,
      required this.color,
      required this.progress})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final t = (progress % 1.0);
    final angle = pi * t;
    return OsmeaSizedBox(
      width: size,
      height: size,
      child: OsmeaCenter(
        child: Transform(
          alignment: center,
          transform: Matrix4.rotationY(angle),
          child: OsmeaContainer(
            width: size * 0.5,
            height: size * 0.5,
            decoration: BoxDecoration(
              color: color,
              borderRadius: context.borderRadiusMinStandard,
            ),
          ),
        ),
      ),
    );
  }
}

class _ColorFadeLoading extends StatelessWidget {
  final double size;
  final Color color;
  final double progress;
  const _ColorFadeLoading(
      {Key? key,
      required this.size,
      required this.color,
      required this.progress})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final t = (progress % 1.0);
    final c = Color.lerp(color.withAlpha((0.2 * 255).round()), color, t)!;
    return OsmeaSizedBox(
      width: size,
      height: size,
      child: OsmeaCenter(
        child: OsmeaContainer(
          width: size * 0.6,
          height: size * 0.6,
          decoration: BoxDecoration(
            color: c,
            borderRadius: context.borderRadiusMaxStandard,
          ),
        ),
      ),
    );
  }
}

class _ArcLoaderLoading extends StatelessWidget {
  final double size;
  final Color color;
  final double progress;
  const _ArcLoaderLoading(
      {Key? key,
      required this.size,
      required this.color,
      required this.progress})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return OsmeaSizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        size: Size(size, size),
        painter: _ArcLoaderPainter(color, progress),
      ),
    );
  }
}

class _ArcLoaderPainter extends CustomPainter {
  final Color color;
  final double progress;
  _ArcLoaderPainter(this.color, this.progress);
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = size.width * 0.13
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final start = progress * 2 * pi;
    canvas.drawArc(
      Rect.fromLTWH(0, 0, size.width, size.height),
      start,
      pi * 1.5,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _DotFlashLoading extends StatelessWidget {
  final double size;
  final Color color;
  final double progress;
  const _DotFlashLoading(
      {Key? key,
      required this.size,
      required this.color,
      required this.progress})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    const count = 4;
    final dotWidth = size / (count * 1.4);
    final margin = size / (count * 7);
    return OsmeaSizedBox(
      width: size,
      height: size * 0.5,
      child: OsmeaRow(
        mainAxisAlignment: centerMain,
        children: List.generate(count, (i) {
          final t = ((progress + i * 0.2) % 1.0);
          final opacity = 0.3 + 0.7 * t;
          return Opacity(
            opacity: opacity,
            child: OsmeaContainer(
              width: dotWidth,
              height: dotWidth,
              margin: EdgeInsets.symmetric(horizontal: margin),
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
          );
        }),
      ),
    );
  }
}

class _BarWaveLoading extends StatelessWidget {
  final double size;
  final Color color;
  final double progress;
  const _BarWaveLoading(
      {Key? key,
      required this.size,
      required this.color,
      required this.progress})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    const barCount = 5;
    final barWidth = size / (barCount * 2.2);
    final margin = size / (barCount * 7);
    return OsmeaSizedBox(
      width: size,
      height: size * 0.4,
      child: OsmeaRow(
        mainAxisAlignment: centerMain,
        children: List.generate(barCount, (i) {
          final t = ((progress + i * 0.13) % 1.0);
          final h = size * 0.18 + size * 0.18 * sin(t * 2 * pi);
          return OsmeaContainer(
            width: barWidth,
            height: h,
            margin: EdgeInsets.symmetric(horizontal: margin),
            decoration: BoxDecoration(
                color: color, borderRadius: context.borderRadiusMinStandard),
          );
        }),
      ),
    );
  }
}

class _AtomLoading extends StatelessWidget {
  final double size;
  final Color color;
  final double progress;
  const _AtomLoading(
      {Key? key,
      required this.size,
      required this.color,
      required this.progress})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return OsmeaSizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: center,
        children: [
          // Center point
          OsmeaContainer(
            width: size * 0.15,
            height: size * 0.15,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          Transform.rotate(
            angle: progress * 2 * pi,
            child: OsmeaContainer(
              width: size * 0.6,
              height: size * 0.6,
              decoration: BoxDecoration(
                border: Border.all(
                    color: color.withAlpha((0.3 * 255).round()),
                    width: size * 0.02),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Transform.rotate(
            angle: -progress * 2 * pi * 0.7,
            child: OsmeaContainer(
              width: size * 0.8,
              height: size * 0.8,
              decoration: BoxDecoration(
                border: Border.all(
                    color: color.withAlpha((0.2 * 255).round()),
                    width: size * 0.015),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Transform.rotate(
            angle: progress * 2 * pi,
            child: OsmeaAlign(
              alignment: topCenter,
              child: OsmeaContainer(
                width: size * 0.08,
                height: size * 0.08,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
            ),
          ),
          Transform.rotate(
            angle: progress * 2 * pi + pi,
            child: OsmeaAlign(
              alignment: bottomCenter,
              child: OsmeaContainer(
                width: size * 0.08,
                height: size * 0.08,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
