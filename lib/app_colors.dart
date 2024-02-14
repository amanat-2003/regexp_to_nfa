import 'package:flutter/material.dart'
    show immutable, Color, ColorScheme, Brightness;

extension RemoveAll on String {
  String removeAll(Iterable<String> values) => values.fold(
      this,
      (
        String result,
        String pattern,
      ) =>
          result.replaceAll(pattern, ''));
}


@immutable
class AppColors {
  static final lightColorScheme = ColorScheme.fromSeed(
    seedColor: AppColors.lightSeedColor,
    brightness: Brightness.light,
  );
  
  static final darkColorScheme = ColorScheme.fromSeed(
    seedColor: AppColors.darkSeedColor,
    brightness: Brightness.dark,
  );

  static final lightSeedColor = Color(
        int.parse(
          '#A020F0'.removeAll(['0x', '#']).padLeft(8, 'ff'),
          radix: 16,
        ),
      );
  static final darkSeedColor = Color(
        int.parse(
          '#C792EA'.removeAll(['0x', '#']).padLeft(8, 'ff'),
          radix: 16,
        ),
      );

  static final primaryLightMode = Color(int.parse('4287627486'));
static final onPrimaryLightMode = Color(int.parse('4294967295'));
static final primaryContainerLightMode = Color(int.parse('4294171391'));
static final onPrimaryContainerLightMode = Color(int.parse('4281270348'));
static final secondaryLightMode = Color(int.parse('4284963438'));
static final onSecondaryLightMode = Color(int.parse('4294967295'));
static final secondaryContainerLightMode = Color(int.parse('4293909749'));
static final onSecondaryContainerLightMode = Color(int.parse('4280424233'));
static final tertiaryLightMode = Color(int.parse('4286665044'));
static final onTertiaryLightMode = Color(int.parse('4294967295'));
static final tertiaryContainerLightMode = Color(int.parse('4294957786'));
static final onTertiaryContainerLightMode = Color(int.parse('4281536532'));
static final errorLightMode = Color(int.parse('4290386458'));
static final onErrorLightMode = Color(int.parse('4294967295'));
static final errorContainerLightMode = Color(int.parse('4294957782'));
static final onErrorContainerLightMode = Color(int.parse('4282449922'));
static final outlineLightMode = Color(int.parse('4286346366'));
static final outlineVariantLightMode = Color(int.parse('4291675086'));
static final backgroundLightMode = Color(int.parse('4294966271'));
static final onBackgroundLightMode = Color(int.parse('4280097566'));
static final surfaceLightMode = Color(int.parse('4294966271'));
static final onSurfaceLightMode = Color(int.parse('4280097566'));
static final surfaceVariantLightMode = Color(int.parse('4293582826'));
static final onSurfaceVariantLightMode = Color(int.parse('4283123021'));
static final inverseSurfaceLightMode = Color(int.parse('4281544499'));
static final onInverseSurfaceLightMode = Color(int.parse('4294373363'));
static final inversePrimaryLightMode = Color(int.parse('4293113343'));
static final shadowLightMode = Color(int.parse('4278190080'));
static final scrimLightMode = Color(int.parse('4278190080'));
static final surfaceTintLightMode = Color(int.parse('4287627486'));


  static final primaryDarkMode = Color(int.parse('4293113343'));
static final onPrimaryDarkMode = Color(int.parse('4282914665'));
static final primaryContainerDarkMode = Color(int.parse('4284494209'));
static final onPrimaryContainerDarkMode = Color(int.parse('4294171391'));
static final secondaryDarkMode = Color(int.parse('4292002265'));
static final onSecondaryDarkMode = Color(int.parse('4281871422'));
static final secondaryContainerDarkMode = Color(int.parse('4283384406'));
static final onSecondaryContainerDarkMode = Color(int.parse('4293909749'));
static final tertiaryDarkMode = Color(int.parse('4294227898'));
static final onTertiaryDarkMode = Color(int.parse('4283180328'));
static final tertiaryContainerDarkMode = Color(int.parse('4284889917'));
static final onTertiaryContainerDarkMode = Color(int.parse('4294957786'));
static final errorDarkMode = Color(int.parse('4294948011'));
static final onErrorDarkMode = Color(int.parse('4285071365'));
static final errorContainerDarkMode = Color(int.parse('4287823882'));
static final onErrorContainerDarkMode = Color(int.parse('4294948011'));
static final outlineDarkMode = Color(int.parse('4288056984'));
static final outlineVariantDarkMode = Color(int.parse('4283123021'));
static final backgroundDarkMode = Color(int.parse('4280097566'));
static final onBackgroundDarkMode = Color(int.parse('4293386469'));
static final surfaceDarkMode = Color(int.parse('4280097566'));
static final onSurfaceDarkMode = Color(int.parse('4293386469'));
static final surfaceVariantDarkMode = Color(int.parse('4283123021'));
static final onSurfaceVariantDarkMode = Color(int.parse('4291675086'));
static final inverseSurfaceDarkMode = Color(int.parse('4293386469'));
static final onInverseSurfaceDarkMode = Color(int.parse('4281544499'));
static final inversePrimaryDarkMode = Color(int.parse('4286138779'));
static final shadowDarkMode = Color(int.parse('4278190080'));
static final scrimDarkMode = Color(int.parse('4278190080'));
static final surfaceTintDarkMode = Color(int.parse('4293113343'));

  
  const AppColors._();
}
  