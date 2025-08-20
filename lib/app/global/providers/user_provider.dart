import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_data.dart';

final currentUserProvider = StateProvider<UserData?>((ref) => null);
final userProvider = StateProvider<UserData?>((ref) => null);

