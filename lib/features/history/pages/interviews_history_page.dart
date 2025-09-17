import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:interview_master/features/history/use_cases/show_interviews_use_case.dart';
import 'package:intl/intl.dart';
import '../../../../app/router/app_router_names.dart';
import '../../../../app/widgets/custom_button.dart';
import '../../../../app/widgets/custom_loading_indicator.dart';
import '../../../../app/widgets/custom_score_indicator.dart';
import '../../../../core/constants/data.dart';
import '../../../../core/helpers/dialog_helper.dart';
import '../../../../core/helpers/toast_helper.dart';
import '../../../../core/theme/app_pallete.dart';
import '../../../../data/models/interview.dart';
import '../../../../data/models/interview_info.dart';
import '../../../../app/widgets/custom_dropdown_menu.dart';
import '../../users/widgets/custom_network_failure.dart';
import '../blocs/filter_cubit/filter_cubit.dart';
import '../blocs/show_interviews_bloc/show_interviews_bloc.dart';

class InterviewsHistoryPage extends StatefulWidget {
  final String? userId;

  const InterviewsHistoryPage({super.key, this.userId});

  @override
  State<InterviewsHistoryPage> createState() => _InterviewsHistoryPageState();
}

class _InterviewsHistoryPageState extends State<InterviewsHistoryPage> {
  final TextEditingController _filterController = TextEditingController();

  @override
  void dispose() {
    _filterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              ShowInterviewsBloc(GetIt.I<ShowInterviewsUseCase>())
                ..add(ShowInterviews(userId: widget.userId)),
        ),
        BlocProvider(create: (context) => FilterCubit()),
      ],
      child: _CustomInterviewsList(filterController: _filterController),
    );
  }
}

class _CustomInterviewsList extends StatelessWidget {
  final TextEditingController filterController;

  const _CustomInterviewsList({required this.filterController});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShowInterviewsBloc, ShowInterviewsState>(
      listener: (context, state) {
        if (state is ShowInterviewsFailure) {
          ToastHelper.loadingError();
        }
      },
      builder: (context, interviewsState) {
        if (interviewsState is ShowInterviewsLoading) {
          return CustomLoadingIndicator();
        } else if (interviewsState is ShowInterviewsNetworkFailure) {
          return NetworkFailure();
        } else if (interviewsState is ShowInterviewsSuccess) {
          if (interviewsState.interviews.isEmpty) return _EmptyHistory();
          return BlocBuilder<FilterCubit, FilterState>(
            builder: (context, filterState) {
              return _InterviewsListView(
                interviews: Interview.filterInterviews(
                  filterState.direction,
                  filterState.difficulty,
                  filterState.sort,
                  interviewsState.interviews,
                ),
                filterController: filterController,
              );
            },
          );
        }
        return SizedBox.shrink();
      },
    );
  }
}

class _EmptyHistory extends StatelessWidget {
  const _EmptyHistory();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'История пуста',
        style: Theme.of(context).textTheme.displayLarge,
      ),
    );
  }
}

class _InterviewsListView extends StatelessWidget {
  final List<Interview> interviews;
  final TextEditingController filterController;

  const _InterviewsListView({
    required this.interviews,
    required this.filterController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _FilterButton(filterController: filterController),
        Expanded(
          child: ListView.builder(
            itemCount: interviews.length,
            itemBuilder: (context, index) {
              final interview = interviews[index];
              return _InterviewCard(interview: interview);
            },
          ),
        ),
      ],
    );
  }
}

class _FilterButton extends StatelessWidget {
  final TextEditingController filterController;

  const _FilterButton({required this.filterController});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: TextField(
        readOnly: true,
        focusNode: FocusNode(canRequestFocus: false),
        controller: filterController,
        onTap: () {
          final filterCubit = context.read<FilterCubit>();
          DialogHelper.showCustomDialog(
            dialog: _FilterDialog(
              filterCubit: filterCubit,
              filterController: filterController,
            ),
            context: context,
          );
        },
        decoration: InputDecoration(
          hintText: 'Фильтр',
          prefixIcon: Icon(Icons.search),
          suffixIcon: IconButton(
            onPressed: () {
              context.read<FilterCubit>().resetFilter();
              filterController.text = '';
            },
            icon: Icon(Icons.close),
          ),
        ),
      ),
    );
  }
}

class _InterviewCard extends StatelessWidget {
  final Interview interview;

  const _InterviewCard({required this.interview});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return GestureDetector(
      onTap: () {
        context.push(AppRouterNames.interviewInfo, extra: interview);
      },
      child: Card(
        child: ListTile(
          leading: CustomScoreIndicator(score: interview.score),
          title: Text(
            '${interview.direction}, ${interview.difficulty}',
            style: textTheme.bodyLarge,
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat('dd/MM/yyyy HH:mm').format(interview.date),
                style: textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FilterDialog extends StatelessWidget {
  final FilterCubit filterCubit;
  final TextEditingController filterController;

  const _FilterDialog({
    required this.filterCubit,
    required this.filterController,
  });

  @override
  Widget build(BuildContext context) {
    String direction = filterCubit.state.direction;
    String difficulty = filterCubit.state.difficulty;
    String sort = filterCubit.state.sort;
    return AlertDialog(
      content: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomDropdownMenu(
            initialValue: direction,
            data: Data.directions,
            change: (value) => direction = value,
            hintText: 'Направления',
          ),
          CustomDropdownMenu(
            initialValue: difficulty,
            data: Data.difficulties,
            change: (value) => difficulty = value,
            hintText: 'Сложности',
          ),
          CustomDropdownMenu(
            initialValue: sort,
            data: Data.sorts,
            change: (value) => sort = value,
            hintText: 'Сортировка',
          ),
          CustomButton(
            text: 'Применить',
            selectedColor: AppPalette.primary,
            onPressed: () {
              _filter(direction, difficulty, sort);
              context.pop();
            },
          ),
        ],
      ),
    );
  }

  void _filter(String direction, String difficulty, String sort) {
    filterCubit.runFilter(
      direction: direction,
      difficulty: difficulty,
      sort: sort,
    );
    filterController.text = InterviewInfo.textInFilter(
      InterviewInfo(
        direction: direction,
        difficulty: difficulty,
        userInputs: [],
      ),
      sort,
    );
  }
}
