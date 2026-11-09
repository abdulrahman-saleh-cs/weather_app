import 'package:flutter/material.dart';
import 'package:weather_app/core/theme/app_dimensions.dart';
import 'package:weather_app/core/theme/app_text_styles.dart';
import 'package:weather_app/features/weather/presentation/pages/weather/widgets/weather_data_card.dart';

import 'hourly_item_widget.dart';

class HourlyForecastCard extends StatelessWidget {
  const HourlyForecastCard({super.key});

  @override
  Widget build(BuildContext context) {
    return const WeatherDataCard(
      child: Column(
        spacing: AppDimensions.p10,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Today',
                style: AppTextStyles.titleLarge,
              ),
              Text(
                'Mar, 9',
                style: AppTextStyles.bodyMedium,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              HourlyItemWidget(
                  temperature: '29°',
                  image: 'assets/images/sun_cloud_day.png',
                  time: '15.00',
                  isNow: false),
              HourlyItemWidget(
                  temperature: '26°',
                  image: 'assets/images/sun_cloud_day.png',
                  time: '16.00',
                  isNow: false),
              HourlyItemWidget(
                  temperature: '24°',
                  image: 'assets/images/overcast_cloud.png',
                  time: '17.00',
                  isNow: true),
              HourlyItemWidget(
                  temperature: '23°',
                  image: 'assets/images/moon_cloud_night.png',
                  time: '18.00',
                  isNow: false),
            ],
          ),
        ],
      ),
    );
  }
}
