import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/services.dart';

/// Swipe left to reveal a round delete button (spring-loaded), tap it and the
/// item shrinks, fades and collapses so the items below glide up.
///
/// [spacing] is the gap below the item. It lives inside the collapsing area so
/// the gap disappears smoothly too.
class SwipeToDelete extends StatefulWidget {
  const SwipeToDelete({
    super.key,
    required this.child,
    required this.onDelete,
    this.enabled = true,
    this.spacing = 12,
  });

  final Widget child;
  final VoidCallback onDelete;
  final bool enabled;
  final double spacing;

  @override
  State<SwipeToDelete> createState() => _SwipeToDeleteState();
}

class _SwipeToDeleteState extends State<SwipeToDelete> with TickerProviderStateMixin {
  static const double _revealWidth = 84;
  static const double _overshoot = 24;
  static const double _flingVelocity = 400;
  static const _spring = SpringDescription(mass: 1, stiffness: 320, damping: 28);

  late final AnimationController _slide = AnimationController.unbounded(vsync: this);
  late final AnimationController _exit =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 380));

  late final Animation<double> _size =
      Tween<double>(begin: 1, end: 0).chain(CurveTween(curve: Curves.easeInOutCubic)).animate(_exit);
  late final Animation<double> _fade =
      Tween<double>(begin: 1, end: 0).chain(CurveTween(curve: const Interval(0, .6))).animate(_exit);
  late final Animation<double> _scale =
      Tween<double>(begin: 1, end: .92).chain(CurveTween(curve: const Interval(0, .6))).animate(_exit);

  bool _open = false;
  bool _pastHalf = false;

  @override
  void dispose() {
    _slide.dispose();
    _exit.dispose();
    super.dispose();
  }

  void _onDragUpdate(DragUpdateDetails details) {
    if (_slide.isAnimating) _slide.stop();
    final next = (_slide.value + details.delta.dx).clamp(-_revealWidth - _overshoot, 0.0).toDouble();
    _slide.value = next;

    final pastHalf = next < -_revealWidth / 2;
    if (pastHalf != _pastHalf) {
      _pastHalf = pastHalf;
      HapticFeedback.selectionClick();
    }
  }

  void _onDragEnd(DragEndDetails details) {
    final velocity = details.velocity.pixelsPerSecond.dx;
    final open = velocity < -_flingVelocity
        ? true
        : velocity > _flingVelocity
            ? false
            : _slide.value < -_revealWidth / 2;
    _snapTo(open, velocity: velocity);
  }

  void _snapTo(bool open, {double velocity = 0}) {
    setState(() => _open = open);
    _slide.animateWith(
      SpringSimulation(_spring, _slide.value, open ? -_revealWidth : 0, velocity),
    );
  }

  Future<void> _delete() async {
    HapticFeedback.mediumImpact();
    await _exit.forward();
    if (mounted) widget.onDelete();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) {
      return Padding(padding: EdgeInsets.only(bottom: widget.spacing), child: widget.child);
    }

    return AbsorbPointer(
      absorbing: _exit.isAnimating || _exit.isCompleted,
      child: SizeTransition(
        sizeFactor: _size,
        axisAlignment: -1,
        child: FadeTransition(
          opacity: _fade,
          child: ScaleTransition(
            scale: _scale,
            child: Padding(
              padding: EdgeInsets.only(bottom: widget.spacing),
              child: AnimatedBuilder(
                animation: _slide,
                builder: (context, _) {
                  final dx = _slide.value;
                  final progress = (-dx / _revealWidth).clamp(0.0, 1.0);
                  return GestureDetector(
                    onHorizontalDragUpdate: _onDragUpdate,
                    onHorizontalDragEnd: _onDragEnd,
                    child: Stack(children: [
                      Positioned.fill(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 16),
                            child: Opacity(
                              opacity: progress,
                              child: Transform.scale(
                                scale: .6 + .4 * progress,
                                child: _DeleteButton(onTap: _delete),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Transform.translate(
                        offset: Offset(dx, 0),
                        // While open, a tap anywhere on the card closes it.
                        child: GestureDetector(
                          onTap: _open ? () => _snapTo(false) : null,
                          child: AbsorbPointer(absorbing: _open, child: widget.child),
                        ),
                      ),
                    ]),
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

class _DeleteButton extends StatelessWidget {
  const _DeleteButton({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFFE5484D),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFE5484D).withValues(alpha: .45),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: const Icon(Icons.delete_outline_rounded, color: Colors.white, size: 26),
        ),
      );
}
