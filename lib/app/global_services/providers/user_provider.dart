import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:interview_master/app/global_services/user/models/user_data.dart';

final currentUserProvider = StateProvider<UserData?>((ref) => null);
final userProvider = StateProvider<UserData?>((ref) => null);

