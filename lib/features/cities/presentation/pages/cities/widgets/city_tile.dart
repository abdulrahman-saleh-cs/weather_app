import 'package:flutter/material.dart';
import 'package:weather_app/core/core.dart';
import 'package:weather_app/features/cities/domain/domain.dart';

/// One search result. [best] is the highlighted first result.
/// There is no add button: tapping the row adds and selects the city.
class CityTile extends StatelessWidget {
  const CityTile({
    super.key,
    required this.city,
    required this.query,
    required this.onTap,
    this.saved = false,
    this.best = false,
    this.showDivider = true,
  });

  final CityEntity city;

  /// The text typed in the search field, used to highlight matching words.
  final String query;
  final VoidCallback onTap;

  /// The city is already in the saved list.
  final bool saved;
  final bool best;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final content = Row(children: [
      _CountryBadge(code: city.countryCode, best: best),
      const SizedBox(width: 14),
      Expanded(child: _CityTexts(city: city, query: query, best: best)),
      if (saved) const _SavedTag(),
    ]);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: best
          ? _BestCard(child: content)
          : Column(children: [
              Padding(padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6), child: content),
              if (showDivider)
                Padding(
                  padding: const EdgeInsets.only(left: _dividerInset),
                  child: Container(height: 1, color: Colors.white.withValues(alpha: .08)),
                ),
            ]),
    );
  }

  /// Row padding (6) + badge (44) + gap (14): the divider starts under the text.
  static const double _dividerInset = 64;
}

class _BestCard extends StatelessWidget {
  const _BestCard({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Accent.coral.withValues(alpha: .20), Colors.white.withValues(alpha: .07)],
          ),
          border: Border.all(color: const Color(0xFFFF8A6B).withValues(alpha: .4)),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: .2), blurRadius: 22, offset: const Offset(0, 8)),
          ],
        ),
        child: child,
      );
}

class _CountryBadge extends StatelessWidget {
  const _CountryBadge({required this.code, required this.best});
  final String code;
  final bool best;

  @override
  Widget build(BuildContext context) => Container(
        width: 44,
        height: 44,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: best ? const LinearGradient(colors: [Color(0xFFFF9A6B), Accent.coral]) : null,
          color: best ? null : Colors.white.withValues(alpha: .12),
        ),
        child: code.isEmpty
            ? const Icon(Icons.location_on_rounded, size: 20, color: Colors.white70)
            : Text(
                code.toUpperCase(),
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, letterSpacing: .6, color: Colors.white),
              ),
      );
}

class _CityTexts extends StatelessWidget {
  const _CityTexts({required this.city, required this.query, required this.best});
  final CityEntity city;
  final String query;
  final bool best;

  static const _matched = TextStyle(color: Colors.white, fontWeight: FontWeight.w700);
  static const _unmatched = TextStyle(color: Colors.white70, fontWeight: FontWeight.w400);

  /// Words of [text] that contain any word of [query] are bold white.
  List<InlineSpan> _highlight(String text) {
    final tokens = query.toLowerCase().split(' ').where((t) => t.isNotEmpty).toList();
    final words = text.split(' ');
    return [
      for (var i = 0; i < words.length; i++)
        TextSpan(
          text: i == words.length - 1 ? words[i] : '${words[i]} ',
          style: tokens.any((t) => words[i].toLowerCase().contains(t)) ? _matched : _unmatched,
        ),
    ];
  }

  /// 8300000 -> "8.3M people", 1400 -> "1.4k people".
  String? get _population {
    final p = city.population;
    if (p == null || p <= 0) return null;
    if (p >= 1000000) return '${(p / 1000000).toStringAsFixed(1)}M people';
    if (p >= 1000) return '${(p / 1000).toStringAsFixed(1)}k people';
    return '$p people';
  }

  @override
  Widget build(BuildContext context) {
    final details = [if (city.subtitle.isNotEmpty) city.subtitle, if (_population != null) _population!].join(' · ');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (best)
          const Padding(
            padding: EdgeInsets.only(bottom: 3),
            child: Text(
              'BEST MATCH',
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 1, color: Color(0xFFFF9A7E)),
            ),
          ),
        Text.rich(
          TextSpan(children: _highlight(city.name)),
          style: const TextStyle(fontSize: 18, height: 1.25),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        if (details.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Text(
              details,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 13, color: Colors.white.withValues(alpha: .62)),
            ),
          ),
      ],
    );
  }
}

class _SavedTag extends StatelessWidget {
  const _SavedTag();

  @override
  Widget build(BuildContext context) => Container(
        height: 30,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: .12),
          borderRadius: BorderRadius.circular(99),
        ),
        child: const Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(Icons.check_rounded, size: 14, color: Colors.white70),
          SizedBox(width: 5),
          Text('Saved', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white70)),
        ]),
      );
}