import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:weather_app/core/core.dart';

class WeatherHeader extends StatelessWidget {
  const WeatherHeader({super.key, required this.cityName});
  final String cityName ;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: AppDimensions.p10,
      children: [
        SvgPicture.asset(
          AppIcons.map,
          width: AppDimensions.iconM,
          height: AppDimensions.iconM,
          colorFilter: const ColorFilter.mode(
            AppColors.white,
            BlendMode.srcIn,
          ),
        ),
        Text(
          cityName,
          style: AppTextStyles.bodyLarge,
        ),
        SvgPicture.asset(
          AppIcons.opt,
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
              AppIcons.notif,
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
