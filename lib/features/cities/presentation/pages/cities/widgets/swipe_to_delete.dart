import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/services.dart';


class SwipeToDelete extends StatefulWidget {
  const SwipeToDelete({
    super.key,
    required this.child,
    required this.onDelete,
    this.enabled = true,
    this.padding = const EdgeInsets.fromLTRB(20, 6, 20, 14),
  });

  final Widget child;
  final VoidCallback onDelete;
  final bool enabled;
  final EdgeInsets padding;

  @override
  State<SwipeToDelete> createState() => _SwipeToDeleteState();
}

class _SwipeToDeleteState extends State<SwipeToDelete> with TickerProviderStateMixin {
  static const double _actionWidth = 78;
  static const double _actionGap = 16;
  static const double _revealWidth = _actionWidth + _actionGap;
  static const double _commitFraction = .55;
  static const double _flingVelocity = 400;
  static const double _commitFlingVelocity = 1800;
  static const double _actionRadius = 26;
  static const _spring = SpringDescription(mass: 1, stiffness: 320, damping: 28);

  late final AnimationController _slide = AnimationController.unbounded(vsync: this);
  late final AnimationController _exit =
  AnimationController(vsync: this, duration: const Duration(milliseconds: 520));

  late final Animation<double> _fade =
  Tween<double>(begin: 1, end: 0).chain(CurveTween(curve: const Interval(0, .35))).animate(_exit);
  late final Animation<double> _scale =
  Tween<double>(begin: 1, end: .92).chain(CurveTween(curve: const Interval(0, .35))).animate(_exit);
  late final Animation<double> _size = Tween<double>(begin: 1, end: 0)
      .chain(CurveTween(curve: const Interval(.3, 1, curve: Curves.easeInOutCubic)))
      .animate(_exit);

  double _cardWidth = 0;
  bool _open = false;
  bool _pastHalf = false;
  bool _armed = false;
  bool _committing = false;

  double get _commitDistance => math.max(_revealWidth * 1.4, _cardWidth * _commitFraction);

  @override
  void dispose() {
    _slide.dispose();
    _exit.dispose();
    super.dispose();
  }

  void _onDragUpdate(DragUpdateDetails details) {
    if (_committing) return;
    if (_slide.isAnimating) _slide.stop();
    final next = (_slide.value + details.delta.dx).clamp(-_cardWidth, 0.0).toDouble();
    _slide.value = next;

    final pastHalf = next < -_revealWidth / 2;
    if (pastHalf != _pastHalf) {
      _pastHalf = pastHalf;
      HapticFeedback.selectionClick();
    }

    final armed = next <= -_commitDistance;
    if (armed != _armed) {
      _armed = armed;
      HapticFeedback.mediumImpact();
    }
  }

  void _onDragEnd(DragEndDetails details) {
    if (_committing) return;
    final velocity = details.velocity.pixelsPerSecond.dx;

    final hardFling = velocity < -_commitFlingVelocity && _slide.value < -_revealWidth;
    if (_slide.value <= -_commitDistance || hardFling) {
      _commit();
      return;
    }

    final open = velocity < -_flingVelocity
        ? true
        : velocity > _flingVelocity
        ? false
        : _slide.value < -_revealWidth / 2;
    _armed = false;
    _snapTo(open, velocity: velocity);
  }

  void _snapTo(bool open, {double velocity = 0}) {
    setState(() => _open = open);
    _slide.animateWith(
      SpringSimulation(_spring, _slide.value, open ? -_revealWidth : 0, velocity),
    );
  }

  Future<void> _commit() async {
    setState(() => _committing = true);
    await _slide.animateTo(-_cardWidth, duration: const Duration(milliseconds: 180), curve: Curves.easeOut);
    if (mounted) await _delete();
  }

  Future<void> _delete() async {
    HapticFeedback.mediumImpact();
    await _exit.forward();
    if (mounted) widget.onDelete();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) {
      return Padding(padding: widget.padding, child: widget.child);
    }

    return AbsorbPointer(
      absorbing: _committing || _exit.isAnimating || _exit.isCompleted,
      child: SizeTransition(
        sizeFactor: _size,
        axisAlignment: -1,
        child: FadeTransition(
          opacity: _fade,
          child: ScaleTransition(
            scale: _scale,
            child: Padding(
              padding: widget.padding,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  _cardWidth = constraints.maxWidth;
                  return AnimatedBuilder(
                    animation: _slide,
                    builder: (context, _) {
                      final dx = _slide.value;
                      final progress = (-dx / _revealWidth).clamp(0.0, 1.0);
                      final blockWidth = dx < -_revealWidth ? -dx - _actionGap : _actionWidth;
                      return GestureDetector(
                        onHorizontalDragUpdate: _onDragUpdate,
                        onHorizontalDragEnd: _onDragEnd,
                        child: Stack(children: [
                          Positioned(
                            top: 0,
                            bottom: 0,
                            right: 0,
                            width: math.max(_actionWidth, blockWidth),
                            child: Opacity(
                              opacity: progress,
                              child: Transform.scale(
                                scale: .9 + .1 * progress,
                                alignment: Alignment.centerRight,
                                child: _DeleteAction(armed: dx <= -_commitDistance, onTap: _delete),
                              ),
                            ),
                          ),
                          Transform.translate(
                            offset: Offset(dx, 0),
                            child: GestureDetector(
                              onTap: _open ? () => _snapTo(false) : null,
                              child: AbsorbPointer(absorbing: _open, child: widget.child),
                            ),
                          ),
                        ]),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DeleteAction extends StatefulWidget {
  const _DeleteAction({required this.armed, required this.onTap});

  final bool armed;
  final VoidCallback onTap;

  @override
  State<_DeleteAction> createState() => _DeleteActionState();
}

class _DeleteActionState extends State<_DeleteAction> {
  bool _pressed = false;

  void _setPressed(bool value) => setState(() => _pressed = value);

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTapDown: (_) => _setPressed(true),
    onTapUp: (_) => _setPressed(false),
    onTapCancel: () => _setPressed(false),
    onTap: widget.onTap,
    child: AnimatedScale(
      scale: _pressed ? .93 : 1,
      duration: const Duration(milliseconds: 90),
      curve: Curves.easeOut,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: widget.armed ? const Color(0xFFF0383E) : const Color(0xFFE5484D),
          borderRadius: BorderRadius.circular(_SwipeToDeleteState._actionRadius),
        ),
        child: AnimatedScale(
          scale: widget.armed ? 1.15 : 1,
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOutBack,
          child: const Text(
            'Delete',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white),
          ),
        ),
      ),
    ),
  );
}