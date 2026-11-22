import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/core/core.dart';
import 'package:weather_app/features/weather/domain/domain.dart';
import '../../../mappers/weather_ui_mapper.dart';
import '../layouts/weather_layout_metrics.dart';

import 'hourly_item_widget.dart';
import 'weather_data_card.dart';

class HourlyForecastCard extends StatelessWidget {
  const HourlyForecastCard({
    super.key,
    required this.hours,
    required this.selectedIndex,
    required this.onSelected,
  });

  final List<HourlyForecastEntity> hours;

  /// Index into [hours] (the full list, not the filtered one).
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  static const double _listHeight = 150;

  int _hourOf(HourlyForecastEntity h) => int.parse(h.time.split(':').first);

  /// Indexes (into [hours]) of the current hour and every hour after it.
  List<int> get _upcomingIndexes {
    final nowHour = DateTime.now().hour;
    final indexes = [
      for (var i = 0; i < hours.length; i++)
        if (_hourOf(hours[i]) >= nowHour) i,
    ];
    return indexes.isEmpty
        ? List.generate(hours.length, (i) => i)
        : indexes;
  }

  /// One tappable hour. [position] is its place in the visible list.
  Widget _tile(List<int> indexes, int position, {double? width = 66}) {
    final realIndex = indexes[position];
    final hour = hours[realIndex];

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onSelected(realIndex),
      child: HourlyItemWidget(
        temperature: '${hour.temperature.round()}°',
        condition: hour.conditionAt(),
        isNight: hour.isNight,
        time: position == 0 ? 'Now' : hour.time.replaceAll(':', '.'),
        isNow: realIndex == selectedIndex,
        width: width,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final indexes = _upcomingIndexes;
    final slots = context.layoutMetrics.hourlyCount;

    return WeatherDataCard(
      child: Column(
        spacing: AppDimensions.p10,
        children: [
          const _HourlyHeader(),
          if (slots == null)
            _ScrollableHours(
              itemCount: indexes.length,
              itemBuilder: (position) => _tile(indexes, position),
            )
          else
            _SpreadHours(
              slots: slots,
              itemCount: indexes.length,
              itemBuilder: (position) => _tile(indexes, position, width: null),
            ),
        ],
      ),
    );
  }
}

class _HourlyHeader extends StatelessWidget {
  const _HourlyHeader();

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Today', style: AppTextStyles.titleLarge),
          Text(
            DateFormat('MMM, d').format(DateTime.now()),
            style: AppTextStyles.bodyMedium,
          ),
        ],
      );
}

/// Mobile: horizontally scrolling list.
class _ScrollableHours extends StatelessWidget {
  const _ScrollableHours({required this.itemCount, required this.itemBuilder});
  final int itemCount;
  final Widget Function(int position) itemBuilder;

  @override
  Widget build(BuildContext context) => SizedBox(
        height: HourlyForecastCard._listHeight,
        child: ListView.separated(
          clipBehavior: Clip.none,
          scrollDirection: Axis.horizontal,
          itemCount: itemCount,
          separatorBuilder: (_, __) => const SizedBox(width: 8),
          itemBuilder: (_, position) => itemBuilder(position),
        ),
      );
}

/// Tablet / desktop: a fixed number of equal slots filling the card.
/// Unused slots stay empty so tiles keep the same width late in the day.
class _SpreadHours extends StatelessWidget {
  const _SpreadHours({required this.slots, required this.itemCount, required this.itemBuilder});
  final int slots;
  final int itemCount;
  final Widget Function(int position) itemBuilder;

  @override
  Widget build(BuildContext context) => SizedBox(
        height: HourlyForecastCard._listHeight,
        child: Row(
          spacing: 8,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (var position = 0; position < slots; position++)
              Expanded(
                child: position < itemCount ? itemBuilder(position) : const SizedBox.shrink(),
              ),
          ],
        ),
      );
}
