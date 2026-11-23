import 'package:flutter/material.dart';
import 'package:weather_app/core/core.dart';
import 'package:weather_app/features/cities/domain/domain.dart';

/// A saved city, tinted with the gradient of its own current weather.
class SavedCityCard extends StatelessWidget {
  const SavedCityCard({
    super.key,
    required this.city,
    required this.weather,
    required this.selected,
    required this.onTap,
  });

  final CityEntity city;

  /// `null` until the weather for this city has loaded.
  final CityWeatherEntity? weather;
  final bool selected;
  final VoidCallback onTap;
  /// Calm blue-violet base shown until the city's weather arrives.
  static const _loadingGradient = [
    Color(0xFF2A3260),
    Color(0xFF323869),
    Color(0xFF3A3F78),
  ];
  @override
  Widget build(BuildContext context) {
    final w = weather;
    final condition = w == null ? null : conditionFromWmo(w.weatherCode);
    final isDay = w?.isDay ?? false;
    final gradient = w == null
        ? _loadingGradient
        : themeFor(condition ?? WeatherCondition.clear, isDay ? DayPhase.noon : DayPhase.night).gradient;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.fromLTRB(20, 16, 16, 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(26),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: gradient,
          ),
          border: Border.all(
            color: Colors.white.withValues(alpha: selected ? .85 : .16),
            width: selected ? 1.6 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: gradient[1].withValues(alpha: .35),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(children: [
          Expanded(child: _CityInfo(city: city, condition: condition, selected: selected)),
          const SizedBox(width: 12),
          _Reading(weather: w, condition: condition),
        ]),
      ),
    );
  }
}

class _CityInfo extends StatelessWidget {
  const _CityInfo({required this.city, required this.condition, required this.selected});
  final CityEntity city;
  final WeatherCondition? condition;
  final bool selected;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (selected) const _CurrentTag(),
          Text(
            city.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Colors.white),
          ),
          if (city.subtitle.isNotEmpty)
            Text(
              city.subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 13, color: Colors.white.withValues(alpha: .75)),
            ),
          const SizedBox(height: 8),
          _Pulse(
            active: condition == null,
            child: Text(
              condition?.label ?? '--',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white),
            ),
          ),
        ],
      );
}

class _CurrentTag extends StatelessWidget {
  const _CurrentTag();

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.only(bottom: 6),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: .22),
          borderRadius: BorderRadius.circular(99),
        ),
        child: const Text(
          'CURRENT',
          style: TextStyle(fontSize: 10, letterSpacing: 1, fontWeight: FontWeight.w700, color: Colors.white),
        ),
      );
}

class _Reading extends StatelessWidget {
  const _Reading({required this.weather, required this.condition});
  final CityWeatherEntity? weather;
  final WeatherCondition? condition;

  @override
  Widget build(BuildContext context) {
    final w = weather;
    return Row(mainAxisSize: MainAxisSize.min, children: [
      if (w != null && condition != null)
        WeatherIcon(condition: condition!, isNight: !w.isDay, size: 52, animate: false),
      const SizedBox(width: 6),
      _Pulse(
        active: w == null,
        child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Text(
            w == null ? '--°' : '${w.temperature}°',
            style: const TextStyle(fontSize: 40, fontWeight: FontWeight.w600, height: 1, color: Colors.white),
          ),
          const SizedBox(height: 4),
          Text(
            w == null ? 'H:--°  L:--°' : 'H:${w.maxTemp}°  L:${w.minTemp}°',
            style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: .8)),
          ),
        ]),
      ),
    ]);
  }
}
/// Slowly fades its child in and out while [active] (used for the "--" placeholders).
class _Pulse extends StatefulWidget {
  const _Pulse({required this.active, required this.child});
  final bool active;
  final Widget child;

  @override
  State<_Pulse> createState() => _PulseState();
}

class _PulseState extends State<_Pulse> with SingleTickerProviderStateMixin {
  late final AnimationController _controller =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 750));
  late final Animation<double> _opacity = Tween<double>(begin: 1, end: .45)
      .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

  @override
  void initState() {
    super.initState();
    _sync();
  }

  @override
  void didUpdateWidget(_Pulse oldWidget) {
    super.didUpdateWidget(oldWidget);
    _sync();
  }

  void _sync() {
    if (widget.active) {
      if (!_controller.isAnimating) _controller.repeat(reverse: true);
    } else {
      _controller.stop();
      _controller.value = 0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => FadeTransition(opacity: _opacity, child: widget.child);
}