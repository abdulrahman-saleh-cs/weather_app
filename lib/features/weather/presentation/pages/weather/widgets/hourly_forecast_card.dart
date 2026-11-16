import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/core/core.dart';
import 'package:weather_app/features/weather/domain/domain.dart';
import '../../../mappers/weather_ui_mapper.dart';

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

  @override
  Widget build(BuildContext context) {
    final indexes = _upcomingIndexes;

    return WeatherDataCard(
      child: Column(
        spacing: AppDimensions.p10,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Today', style: AppTextStyles.titleLarge),
              Text(
                DateFormat('MMM, d').format(DateTime.now()),
                style: AppTextStyles.bodyMedium,
              ),
            ],
          ),
          SizedBox(
            height: 150,
            child: ListView.separated(
              clipBehavior: Clip.none,
              scrollDirection: Axis.horizontal,
              itemCount: indexes.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, position) {
                final realIndex = indexes[position];
                final hour = hours[realIndex];

                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => onSelected(realIndex),
                  child: HourlyItemWidget(
                    temperature: '${hour.temperature.round()}°',
                    condition: hour.conditionAt(),
                    isNight: hour.isNight,
                    time: position == 0
                        ? 'Now'
                        : hour.time.replaceAll(':', '.'),
                    isNow: realIndex == selectedIndex,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}