import 'dart:convert';

import 'package:duit_kernel/duit_kernel.dart';
import 'package:duit_kernel/src/ui/theme/index.dart';
import 'package:duit_kernel/src/ui/theme/preprocessor.dart';
import 'package:flutter/services.dart';

final class AssetThemeLoader implements ResourceLoader<DuitTheme> {
  final String path;

  const AssetThemeLoader(this.path);

  @override
  Future<DuitTheme> load() async {
    final theme = await rootBundle.loadString(path);
    final preprocessor = ThemePreprocessor();
    return preprocessor.tokenize(json.decode(theme));
  }
}

final class StaticThemeLoader implements ResourceLoader<DuitTheme> {
  final Map<String, dynamic> theme;

  const StaticThemeLoader(this.theme);

  @override
  Future<DuitTheme> load() async {
    final preprocessor = ThemePreprocessor();
    return preprocessor.tokenize(theme);
  }
}
