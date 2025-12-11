import 'package:hive_flutter/adapters.dart';
import '../../generated/l10n.dart';

part 'language.g.dart';

@HiveType(typeId: 12)
enum Language {
  @HiveField(0)
  russian('Russian'),
  @HiveField(1)
  english('English');

  final String name;

  const Language(this.name);

  @override
  String toString() => name;

  String localizedName(S s) => switch (this) {
    Language.russian => s.russian,
    Language.english => s.english,
  };
}

