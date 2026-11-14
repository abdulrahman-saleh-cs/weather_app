// import 'package:flutter/material.dart';
// import 'app_colors.dart';
// import 'app_text_styles.dart';
//
// class AppTheme {
//   static ThemeData get darkTheme {
//     return ThemeData(
//       // systemOverlayStyle
//       // appBarTheme: AppBarTheme(
//       //   systemOverlayStyle: ,
//       // ),
//       useMaterial3: true,
//       // brightness: Brightness.dark,
//       scaffoldBackgroundColor: AppColors.primaryDark,
//       textTheme: const TextTheme(
//         displayLarge: AppTextStyles.displayLarge,
//         titleLarge: AppTextStyles.titleLarge,
//         bodyLarge: AppTextStyles.bodyLarge,
//         bodyMedium: AppTextStyles.bodyMedium,
//         labelMedium: AppTextStyles.labelMedium,
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_text_styles.dart';

class AppTheme {
  const AppTheme._();

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.primaryDark,
    textTheme: const TextTheme(
      displayLarge: AppTextStyles.displayLarge,
      titleLarge: AppTextStyles.titleLarge,
      bodyLarge: AppTextStyles.bodyLarge,
      bodyMedium: AppTextStyles.bodyMedium,
      labelMedium: AppTextStyles.labelMedium,
    ),
  );
}