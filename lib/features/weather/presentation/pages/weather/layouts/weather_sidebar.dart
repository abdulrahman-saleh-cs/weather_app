import 'package:flutter/material.dart';
import 'package:weather_app/core/core.dart';
import 'weather_layout_metrics.dart';

/// Desktop navigation panel: logo, navigation entries and the current city.
/// Entries are visual only until the app has other destinations.
class WeatherSidebar extends StatelessWidget {
  const WeatherSidebar({
    super.key,
    required this.cityName,
    required this.temperature,
    required this.condition,
    required this.isNight,
  });

  final String cityName;
  final int temperature;
  final WeatherCondition condition;
  final bool isNight;

  static const _items = [
    (Icons.home_rounded, 'Today'),
    (Icons.calendar_month_rounded, 'Forecast'),
    (Icons.map_rounded, 'Map'),
    (Icons.notifications_rounded, 'Alerts'),
    (Icons.settings_rounded, 'Settings'),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 18, 0, 18),
      child: SizedBox(
        width: context.layoutMetrics.sidebarWidth,
        child: GlassCard(
          padding: const EdgeInsets.all(14),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _Logo(),
                for (var i = 0; i < _items.length; i++)
                  _NavItem(icon: _items[i].$1, label: _items[i].$2, selected: i == 0),
                const _SectionLabel('Current city'),
                _CityTile(name: cityName, temperature: temperature, condition: condition, isNight: isNight),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  const _Logo();

  @override
  Widget build(BuildContext context) => const Padding(
        padding: EdgeInsets.fromLTRB(8, 4, 8, 14),
        child: Row(children: [
          DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(11)),
              gradient: LinearGradient(colors: [Color(0xFFFFB86B), Accent.coral]),
            ),
            child: SizedBox(
              width: 34,
              height: 34,
              child: Icon(Icons.wb_sunny_rounded, color: Colors.white, size: 19),
            ),
          ),
          SizedBox(width: 10),
          Text('Weather', style: AppTextStyles.titleLarge),
        ]),
      );
}

class _NavItem extends StatelessWidget {
  const _NavItem({required this.icon, required this.label, required this.selected});
  final IconData icon;
  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.only(bottom: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
        decoration: BoxDecoration(
          color: selected ? Colors.white.withValues(alpha: .22) : null,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(children: [
          Icon(icon, size: 20, color: Colors.white.withValues(alpha: selected ? 1 : .85)),
          const SizedBox(width: 12),
          Text(
            label,
            style: TextStyle(
              fontSize: 15,
              fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
              color: Colors.white.withValues(alpha: selected ? 1 : .85),
            ),
          ),
        ]),
      );
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(8, 16, 8, 6),
        child: Text(
          text.toUpperCase(),
          style: TextStyle(fontSize: 11, letterSpacing: .8, color: Colors.white.withValues(alpha: .65)),
        ),
      );
}

class _CityTile extends StatelessWidget {
  const _CityTile({
    required this.name,
    required this.temperature,
    required this.condition,
    required this.isNight,
  });

  final String name;
  final int temperature;
  final WeatherCondition condition;
  final bool isNight;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: .18),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(children: [
          WeatherIcon(condition: condition, isNight: isNight, size: 30, animate: false),
          const SizedBox(width: 10),
          Expanded(child: Text(name, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 15, color: Colors.white))),
          Text('$temperature°', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white)),
        ]),
      );
}
