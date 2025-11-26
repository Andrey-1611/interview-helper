import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:interview_master/app/router/app_router_names.dart';
import 'package:interview_master/core/constants/interviews_data.dart';
import 'package:interview_master/core/utils/dialog_helper.dart';
import 'package:interview_master/core/utils/toast_helper.dart';
import '../../../app/widgets/custom_button.dart';
import '../../../core/utils/data_cubit.dart';
import '../../../data/repositories/local_repository.dart';
import '../../../data/repositories/remote_repository.dart';
import '../blocs/directions_cubit/directions_cubit.dart';
import '../blocs/tracker_bloc/tracker_bloc.dart';

class DirectionsPage extends StatelessWidget {
  const DirectionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => TrackerBloc(
            GetIt.I<LocalRepository>(),
            GetIt.I<RemoteRepository>(),
          ),
        ),
        BlocProvider(create: (context) => DirectionsCubit()),
      ],
      child: BlocListener<TrackerBloc, TrackerState>(
        listener: (context, state) {
          if (state is TrackerLoading) {
            DialogHelper.showLoadingDialog(context, 'Сохранение данных...');
          } else if (state is TrackerDirectionsSuccess) {
            context.pop();
            context.read<DataCubit>().updateKeyValue();
            context.go(AppRouterNames.initial);
          } else if (state is TrackerFailure) {
            context.pop();
            context.pushReplacement(AppRouterNames.signIn);
            ToastHelper.unknownError(context);
          }
        },
        child: _DirectionsPageView(),
      ),
    );
  }
}

class _DirectionsPageView extends StatelessWidget {
  const _DirectionsPageView();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Выбор направлений'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: EdgeInsets.all(size.width * 0.04),
        child: Column(
          children: [
            Card(
              color: theme.primaryColor.withValues(alpha: 0.1),
              child: ListTile(
                leading: Icon(Icons.info_outline),
                title: Text(
                  'Выберите от 1 до 3 направлений',
                  style: theme.textTheme.bodyMedium,
                ),
              ),
            ),
            SizedBox(height: size.height * 0.01),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.8,
                ),
                itemCount: InterviewsData.directions.length,
                itemBuilder: (context, index) {
                  final direction = InterviewsData.directions[index];
                  return _DirectionCard(direction: direction);
                },
              ),
            ),
            SizedBox(height: size.height * 0.02),
            CustomButton(
              text: 'Продолжить',
              onPressed: () => context.read<TrackerBloc>().add(
                SetDirections(
                  directions: context.read<DirectionsCubit>().state,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DirectionCard extends StatelessWidget {
  final String direction;

  const _DirectionCard({required this.direction});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final directions = context.watch<DirectionsCubit>();
    final isSelected = directions.state.contains(direction);
    return GestureDetector(
      onTap: () => directions.add(direction),
      child: Card(
        color: isSelected ? theme.primaryColor.withValues(alpha: 0.1) : null,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            color: isSelected ? theme.primaryColor : theme.hintColor,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Stack(
          children: [
            Center(
              child: Text(
                direction,
                style: theme.textTheme.displaySmall?.copyWith(
                  color: isSelected ? theme.primaryColor : null,
                ),
              ),
            ),
            if (isSelected)
              Positioned(
                top: 8,
                right: 8,
                child: Icon(
                  Icons.check_circle,
                  color: theme.primaryColor,
                  size: 20,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
