import 'package:weather_app/core/constants/app_images.dart';


class WeatherCodeMapper {
  static String image(int code, {bool isDay = true}) {
    // clear sky
    if (code == 0) return isDay ? AppImages.sun : AppImages.moon;

    // mainly clear and partly cloudy
    if (code <= 2) return isDay ? AppImages.cloudSun : AppImages.moonCloud;

    if (code == 3) return AppImages.cloud;
    if (code == 45 || code == 48) return AppImages.fog;

    // freezing drizzle / freezing rain
    if (code == 56 || code == 57 || code == 66 || code == 67) {
      return AppImages.rainWithSnow;
    }
    // drizzle, rain, showers
    if (code == 65 || code == 82) return AppImages.heavyRain;
    if ((code >= 51 && code <= 63) || code == 80 || code == 81) {
      return AppImages.rain;
    }
    // snow and snow showers
    if ((code >= 71 && code <= 77) || code == 85 || code == 86) {
      return AppImages.snow;
    }
    // thunderstorm
    if (code == 95) return AppImages.cloudLightning;
    if (code >= 96) return AppImages.rainWithThunder;

    return AppImages.cloud;
  }

  static String largeImage(int code, {bool isDay = true}) =>
      image(code, isDay: isDay);
}