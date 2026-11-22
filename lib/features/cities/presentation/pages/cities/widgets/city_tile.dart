import 'package:flutter/material.dart';
import 'package:weather_app/core/core.dart';
import 'package:weather_app/features/cities/domain/domain.dart';

/// A plain search-result row (no card): name, region, and an add button.
class CityTile extends StatelessWidget {
  const CityTile({super.key, required this.city, required this.onTap});

  final CityEntity city;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 14),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.white.withValues(alpha: .12))),
        ),
        child: Row(children: [
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(city.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white)),
              if (city.subtitle.isNotEmpty)
                Text(city.subtitle, style: TextStyle(fontSize: 13, color: Colors.white.withValues(alpha: .6))),
            ]),
          ),
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Accent.coral, width: 1.5),
            ),
            child: const Icon(Icons.add_rounded, size: 20, color: Accent.coral),
          ),
        ]),
      ),
    );
  }
}
