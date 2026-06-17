import 'package:track_flowers_app/core/constants/app_constants.dart';
import 'package:track_flowers_app/core/values/app_colors.dart';
import 'package:track_flowers_app/core/values/app_font_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    dialogTheme: const DialogThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
    ),
    dropdownMenuTheme: DropdownMenuThemeData(
      menuStyle: MenuStyle(
        backgroundColor: WidgetStateProperty.all<Color>(AppColors.whiteF9),
      ),
    ),
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    canvasColor: AppColors.whiteF9,
    datePickerTheme: DatePickerThemeData(
      dayStyle: AppFontStyle.medium16(),
      weekdayStyle: AppFontStyle.medium16(),
      backgroundColor: AppColors.whiteF9,
      yearStyle: AppFontStyle.medium16().copyWith(color: AppColors.whiteF9),
      dayForegroundColor: WidgetStateProperty.all<Color>(AppColors.whiteF9),
      todayForegroundColor: WidgetStateProperty.all<Color>(
        AppColors.primerColor,
      ),
      todayBackgroundColor: WidgetStateProperty.all<Color>(AppColors.grayA6),
      rangePickerBackgroundColor: AppColors.whiteF9,
      rangePickerHeaderForegroundColor: AppColors.whiteF9,
      rangePickerHeaderBackgroundColor: AppColors.primerColor,
      rangePickerHeaderHeadlineStyle: AppFontStyle.bold16().copyWith(
        color: AppColors.whiteF9,
      ),
      rangePickerHeaderHelpStyle: AppFontStyle.medium14().copyWith(
        color: AppColors.whiteF9,
      ),
      rangePickerShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      dayShape: WidgetStateProperty.all<OutlinedBorder>(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      yearShape: WidgetStateProperty.all<OutlinedBorder>(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      headerForegroundColor: AppColors.black0C,
      headerBackgroundColor: AppColors.grayCF,
      dayOverlayColor: WidgetStateProperty.all<Color>(
        AppColors.primerColor.withValues(alpha: 0.1),
      ),
      yearOverlayColor: WidgetStateProperty.all<Color>(
        AppColors.primerColor.withValues(alpha: 0.1),
      ),
      todayBorder: const BorderSide(color: AppColors.primerColor, width: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.whiteF9,
    primaryColor: AppColors.primerColor,

    appBarTheme: const AppBarTheme(
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      iconTheme: IconThemeData(color: AppColors.primerColor),
      shadowColor: AppColors.whiteF9,
      backgroundColor: AppColors.whiteF9,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: AppColors.black,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light,
      ),
    ),
    useMaterial3: true,
    textTheme: const TextTheme(
      bodyLarge: TextStyle(
        color: AppColors.black0C,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      bodyMedium: TextStyle(
        color: AppColors.black0C,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      bodySmall: TextStyle(
        color: AppColors.black0C,
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
    ),
    cardTheme: CardThemeData(
      color: AppColors.black0C,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primerColor,
      brightness: Brightness.light,
      primary: AppColors.primerColor,
      onPrimary: AppColors.black0C,
      secondary: AppColors.primerColor,
      onSecondary: AppColors.black0C,
      surface: AppColors.black0C,
      onSurface: AppColors.black0C,
      error: AppColors.redCC,
      onError: AppColors.redCC,
    ),
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: AppColors.primerColor,
      selectionColor: AppColors.primerColor,
      selectionHandleColor: AppColors.primerColor,
    ),
    fontFamily: AppConstants.fontFamily,
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        alignment: Alignment.center,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      isDense: true,
      focusColor: AppColors.pinkF9,
      floatingLabelStyle: AppFontStyle.regular18().copyWith(
        color: AppColors.primerColor,
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: AppColors.grayCF, width: 1),
        borderRadius: BorderRadius.circular(4),
      ),
      border: OutlineInputBorder(
        borderSide: const BorderSide(width: 1, color: AppColors.primerColor),
        borderRadius: BorderRadius.circular(4),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(width: 1, color: AppColors.primerColor),
        borderRadius: BorderRadius.circular(4),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: AppColors.redCC, width: 1),
        borderRadius: BorderRadius.circular(4),
      ),
      fillColor: AppColors.whiteF9,
      filled: true,
      hintStyle: AppFontStyle.regular14().copyWith(color: AppColors.grayA6),
      labelStyle: AppFontStyle.regular14().copyWith(color: AppColors.black0C),
      errorStyle: AppFontStyle.regular12().copyWith(color: AppColors.redCC),
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      iconColor: AppColors.black0C,
      suffixIconColor: AppColors.black0C,
      prefixIconColor: AppColors.black0C,
      alignLabelWithHint: true,
      contentPadding: REdgeInsetsDirectional.only(
        start: 12,
        end: 12,
        bottom: 10,
        top: 10,
      ),
      hoverColor: AppColors.pinkF9,
    ),
    switchTheme: SwitchThemeData(
      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 0),
      splashRadius: 16,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      trackColor: WidgetStateProperty.all<Color>(AppColors.primerColor),
      thumbColor: WidgetStateProperty.all<Color>(AppColors.whiteF9),
      trackOutlineColor: WidgetStateProperty.all<Color>(AppColors.primerColor),
      overlayColor: WidgetStateProperty.all<Color>(AppColors.black0C),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        shape: WidgetStateProperty.all<OutlinedBorder>(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
        backgroundColor: WidgetStateProperty.all<Color>(AppColors.primerColor),
        foregroundColor: WidgetStateProperty.all<Color>(AppColors.whiteF9),
        overlayColor: WidgetStateProperty.all<Color>(AppColors.black0C),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.primerColor,
      foregroundColor: AppColors.whiteF9,
      shape: CircleBorder(),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: AppColors.whiteF9,
      showDragHandle: true,
      dragHandleColor: AppColors.grayA6,
      dragHandleSize: Size(48, 6),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      type: BottomNavigationBarType.fixed,
      enableFeedback: true,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      backgroundColor: AppColors.whiteF9,
      selectedItemColor: AppColors.primerColor,
      unselectedItemColor: AppColors.black0C,
      elevation: 0,
      selectedLabelStyle: AppFontStyle.regular12().copyWith(
        color: AppColors.primerColor,
      ),
      unselectedLabelStyle: AppFontStyle.regular12().copyWith(
        color: AppColors.gray7D,
      ),
    ),
    tabBarTheme: const TabBarThemeData(indicatorColor: AppColors.primerColor),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: AppColors.primerColor,
      selectionColor: AppColors.primerColor,
      selectionHandleColor: AppColors.primerColor,
    ),
    datePickerTheme: DatePickerThemeData(
      dayStyle: AppFontStyle.medium16(),
      weekdayStyle: AppFontStyle.medium16(),
      backgroundColor: AppColors.black0C,
      yearStyle: AppFontStyle.medium16().copyWith(color: AppColors.whiteF9),
      dayForegroundColor: WidgetStateProperty.all<Color>(AppColors.whiteF9),
      todayForegroundColor: WidgetStateProperty.all<Color>(
        AppColors.primerColor,
      ),
      todayBackgroundColor: WidgetStateProperty.all<Color>(AppColors.grayA6),
      rangePickerBackgroundColor: AppColors.black0C,
      rangePickerHeaderForegroundColor: AppColors.whiteF9,
      rangePickerHeaderBackgroundColor: AppColors.primerColor,
      rangePickerHeaderHeadlineStyle: AppFontStyle.bold16().copyWith(
        color: AppColors.whiteF9,
      ),
      rangePickerHeaderHelpStyle: AppFontStyle.medium14().copyWith(
        color: AppColors.whiteF9,
      ),
      rangePickerShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      dayShape: WidgetStateProperty.all<OutlinedBorder>(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      yearShape: WidgetStateProperty.all<OutlinedBorder>(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      headerForegroundColor: AppColors.whiteF9,
      headerBackgroundColor: AppColors.black0C,
      dayOverlayColor: WidgetStateProperty.all<Color>(
        AppColors.primerColor.withValues(alpha: 0.1),
      ),
      yearOverlayColor: WidgetStateProperty.all<Color>(
        AppColors.primerColor.withValues(alpha: 0.1),
      ),
      todayBorder: const BorderSide(color: AppColors.primerColor, width: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    appBarTheme: const AppBarTheme(
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      iconTheme: IconThemeData(color: AppColors.primerColor),
      shadowColor: AppColors.black0C,
      backgroundColor: AppColors.black0C,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: AppColors.black0C,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(
        color: AppColors.whiteF9,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      bodyMedium: TextStyle(
        color: AppColors.whiteF9,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      bodySmall: TextStyle(
        color: AppColors.whiteF9,
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
    ),
    cardTheme: CardThemeData(
      color: AppColors.black0C,
      shadowColor: AppColors.black,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    fontFamily: AppConstants.fontFamily,
    scaffoldBackgroundColor: AppColors.black0C,
    primaryColor: AppColors.primerColor,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primerColor,
      brightness: Brightness.dark,
      primary: AppColors.primerColor,
      onPrimary: AppColors.grayA6,
      secondary: AppColors.primerColor,
      onSecondary: AppColors.grayA6,
      surface: AppColors.black0C,
      onSurface: AppColors.whiteF9,
      error: AppColors.redCC,
      onError: AppColors.redCC,
    ),
    switchTheme: SwitchThemeData(
      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 0),
      splashRadius: 16,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      trackColor: WidgetStateProperty.all<Color>(AppColors.primerColor),
      thumbColor: WidgetStateProperty.all<Color>(AppColors.whiteF9),
      overlayColor: WidgetStateProperty.all<Color>(AppColors.primerColor),
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: AppColors.primerColor,
      splashColor: AppColors.primerColor.withValues(alpha: 0.2),
      hoverColor: AppColors.primerColor.withValues(alpha: 0.2),
      highlightColor: AppColors.primerColor.withValues(alpha: 0.2),
    ),
    iconTheme: const IconThemeData(color: AppColors.whiteF9),
    inputDecorationTheme: InputDecorationTheme(
      isDense: true,
      focusColor: AppColors.pinkF9,
      floatingLabelStyle: AppFontStyle.regular18().copyWith(
        color: AppColors.primerColor,
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: AppColors.black0C, width: 1),
        borderRadius: BorderRadius.circular(4),
      ),
      border: OutlineInputBorder(
        borderSide: const BorderSide(width: 1, color: AppColors.primerColor),
        borderRadius: BorderRadius.circular(4),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(width: 1, color: AppColors.primerColor),
        borderRadius: BorderRadius.circular(4),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: AppColors.redCC, width: 1),
        borderRadius: BorderRadius.circular(4),
      ),
      fillColor: AppColors.black0C,
      filled: true,
      hintStyle: AppFontStyle.regular14().copyWith(color: AppColors.whiteF9),
      labelStyle: AppFontStyle.regular14().copyWith(color: AppColors.whiteF9),
      errorStyle: AppFontStyle.regular12().copyWith(color: AppColors.redCC),
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      iconColor: AppColors.whiteF9,
      suffixIconColor: AppColors.whiteF9,
      prefixIconColor: AppColors.whiteF9,
      alignLabelWithHint: true,
      contentPadding: REdgeInsetsDirectional.only(
        start: 12,
        end: 12,
        bottom: 10,
        top: 10,
      ),
      hoverColor: AppColors.primerColor,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        shape: WidgetStateProperty.all<OutlinedBorder>(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
        backgroundColor: WidgetStateProperty.all<Color>(AppColors.primerColor),
        foregroundColor: WidgetStateProperty.all<Color>(AppColors.whiteF9),
        overlayColor: WidgetStateProperty.all<Color>(
          AppColors.primerColor.withValues(alpha: 0.2),
        ),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.primerColor,
      foregroundColor: AppColors.whiteF9,
      shape: CircleBorder(),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: AppColors.black0C,
      showDragHandle: true,
      dragHandleColor: AppColors.grayCF,
      dragHandleSize: Size(48, 6),
    ),
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      enableFeedback: true,
      backgroundColor: AppColors.black0C,
      selectedItemColor: AppColors.primerColor,
      unselectedItemColor: AppColors.grayA6,
      elevation: 0,
      selectedLabelStyle: AppFontStyle.regular12().copyWith(
        color: AppColors.primerColor,
      ),
      unselectedLabelStyle: AppFontStyle.regular12().copyWith(
        color: AppColors.gray7D,
      ),
    ),
  );
}
