import 'dart:math' show pi;

import 'package:flutter/material.dart';

class AnimationExample2 extends StatefulWidget {
  const AnimationExample2({super.key});

  @override
  State<AnimationExample2> createState() => _AnimationExample2State();
}

enum CircleSide { left, right }

class HalfCirclerClipper extends CustomClipper<Path> {
  final CircleSide circleSide;

  const HalfCirclerClipper({required this.circleSide});

  @override
  getClip(Size size) => circleSide.toPath(size);

  @override
  bool shouldReclip(covariant CustomClipper oldClipper) => true;
}

class _AnimationExample2State extends State<AnimationExample2>
    with TickerProviderStateMixin {
  late AnimationController _counterClockWiseRotationAnimationCtrl;
  late Animation _counterClockWiseRotationAnimation;

  late AnimationController _flipAnimCtrl;
  late Animation _flipAnimation;

  @override
  Widget build(BuildContext context) {
    _counterClockWiseRotationAnimationCtrl
      ..reset()
      ..forward.delayed(Duration(seconds: 1));

    return Scaffold(
      body: Center(
        child: SafeArea(
          child: AnimatedBuilder(
            animation: _counterClockWiseRotationAnimationCtrl,
            builder: (context, child) {
              return Transform(
                alignment: Alignment.center,
                transform:
                    Matrix4.identity()
                      ..rotateZ(_counterClockWiseRotationAnimation.value),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedBuilder(
                      animation: _flipAnimCtrl,
                      builder: (context, child) {
                        return Transform(
                          alignment: Alignment.centerRight,
                          transform:
                              Matrix4.identity()..rotateY(_flipAnimation.value),
                          child: ClipPath(
                            clipper: HalfCirclerClipper(
                              circleSide: CircleSide.left,
                            ),
                            child: Container(
                              width: 100,
                              height: 100,
                              color: Colors.blue,
                            ),
                          ),
                        );
                      },
                    ),
                    AnimatedBuilder(
                      animation: _flipAnimCtrl,
                      builder: (context, child) {
                        return Transform(
                          alignment: Alignment.centerLeft,
                          transform:
                              Matrix4.identity()..rotateY(_flipAnimation.value),
                          child: ClipPath(
                            clipper: HalfCirclerClipper(
                              circleSide: CircleSide.right,
                            ),
                            child: Container(
                              width: 100,
                              height: 100,
                              color: Colors.yellow,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _counterClockWiseRotationAnimationCtrl.dispose();
    _flipAnimCtrl.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _counterClockWiseRotationAnimationCtrl = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );

    _counterClockWiseRotationAnimation = Tween(
      begin: 0.0,
      end: -(pi / 2),
    ).animate(
      CurvedAnimation(
        parent: _counterClockWiseRotationAnimationCtrl,
        curve: Curves.bounceOut,
      ),
    );

    _counterClockWiseRotationAnimationCtrl.repeat();

    _flipAnimCtrl = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );

    _flipAnimation = Tween<double>(
      begin: 0.0,
      end: pi,
    ).animate(CurvedAnimation(parent: _flipAnimCtrl, curve: Curves.bounceOut));

    _counterClockWiseRotationAnimationCtrl.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _flipAnimation = Tween(
          begin: _flipAnimation.value,
          end: _flipAnimation.value + pi,
        ).animate(
          CurvedAnimation(parent: _flipAnimCtrl, curve: Curves.bounceOut),
        );

        _flipAnimCtrl
          ..reset()
          ..forward();
      }
    });

    _flipAnimCtrl.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _counterClockWiseRotationAnimation = Tween(
          begin: _counterClockWiseRotationAnimation.value,
          end: _counterClockWiseRotationAnimation.value + -(pi / 2),
        ).animate(
          CurvedAnimation(
            parent: _counterClockWiseRotationAnimationCtrl,
            curve: Curves.bounceOut,
          ),
        );

        _counterClockWiseRotationAnimationCtrl
          ..reset()
          ..forward();
      }
    });

    // _flipAnimCtrl.repeat();
  }
}

extension on VoidCallback {
  Future<void> delayed(Duration duration) => Future.delayed(duration, this);
}

extension ToPath on CircleSide {
  Path toPath(Size size) {
    final path = Path();
    late Offset offset;

    late bool clockWise;

    switch (this) {
      case CircleSide.left:
        {
          path.moveTo(size.width, 0);
          offset = Offset(size.width, size.height);
          clockWise = false;
        }
        break;
      case CircleSide.right:
        {
          offset = Offset(0, size.height);
          clockWise = true;
        }
        break;
    }

    path.arcToPoint(
      offset,
      radius: Radius.elliptical(size.width / 2, size.height / 2),
      clockwise: clockWise,
    );
    path.close();

    return path;
  }
}
