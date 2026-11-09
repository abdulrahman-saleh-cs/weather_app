import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:weather_app/core/theme/app_colors.dart';
import 'package:weather_app/core/theme/app_dimensions.dart';
import 'package:weather_app/core/theme/app_text_styles.dart';

class WeatherHeader extends StatelessWidget {
  const WeatherHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: AppDimensions.p10,
      children: [
        SvgPicture.asset(
          'assets/icons/map.svg',
          width: AppDimensions.iconM,
          height: AppDimensions.iconM,
          colorFilter: const ColorFilter.mode(
            AppColors.white,
            BlendMode.srcIn,
          ),
        ),
        const Text(
          'Fortaleza',
          style: AppTextStyles.bodyLarge,
        ),
        SvgPicture.asset(
          'assets/icons/opt.svg',
          width: AppDimensions.iconM,
          height: AppDimensions.iconM,
          colorFilter: const ColorFilter.mode(
            AppColors.white,
            BlendMode.srcIn,
          ),
        ),
        const Expanded(child: SizedBox()),
        Stack(
          alignment: AlignmentGeometry.topEnd,
          children: [
            SvgPicture.asset(
              'assets/icons/notif.svg',
              width: AppDimensions.iconM,
              height: AppDimensions.iconM,
              colorFilter: const ColorFilter.mode(
                AppColors.white,
                BlendMode.srcIn,
              ),
            ),
            Container(
              height: 12,
              width: 12,
              decoration: BoxDecoration(
                color: AppColors.accentRed,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.accentCyan,
                  width: 1.5,
                ),
              ),
            )
          ],
        ),
      ],
    );
  }
}
