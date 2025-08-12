import 'package:flutter/material.dart';
import 'package:interview_master/core/theme/app_colors.dart';
import 'package:interview_master/features/interview/presentation/widgets/custom_score_indicator.dart';
import '../../../../app/global_services/user/models/user_data.dart';
import '../../../../app/navigation/app_router.dart';
import '../../../../app/navigation/app_router_names.dart';

class CustomUserCard extends StatelessWidget {
  final String imageUrl;
  final int score;
  final UserData user;

  const CustomUserCard({
    super.key,
    required this.imageUrl,
    required this.score,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: BorderSide(color: AppPalette.primary, width: 4.0),
      ),
      child: ListTile(
        onTap: () =>
            AppRouter.pushNamed(AppRouterNames.userInfo, arguments: user),
        contentPadding: EdgeInsets.all(20.0),
        leading: CircleAvatar(backgroundImage: AssetImage(imageUrl)),
        title: Text(user.name, style: Theme.of(context).textTheme.bodyLarge),
        subtitle: Text(
          '$score ⭐️',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        trailing: ScoreIndicator(score: user.average, color: AppPalette.primary),
      ),
    );
  }
}
