import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_master/features/interview/data/models/interview_info.dart';
import 'package:intl/intl.dart';
import '../../../../app/dependencies/di_container.dart';
import '../../../../app/navigation/app_router.dart';
import '../../../../app/navigation/app_router_names.dart';
import '../../../../app/widgets/custom_loading_indicator.dart';
import '../../../../core/helpers/dialog_helpers/dialog_helper.dart';
import '../../../../core/helpers/toast_helpers/toast_helper.dart';
import '../../data/models/interview.dart';
import '../blocs/show_interviews_bloc/show_interviews_bloc.dart';
import '../widgets/custom_filter_dialog.dart';
import '../widgets/custom_score_indicator.dart';

class InterviewsHistoryPage extends StatefulWidget {
  final String userId;

  const InterviewsHistoryPage({super.key, required this.userId});

  @override
  State<InterviewsHistoryPage> createState() => _InterviewsHistoryPageState();
}

class _InterviewsHistoryPageState extends State<InterviewsHistoryPage> {
  String direction = '';
  String difficulty = '';
  final TextEditingController _filterController = TextEditingController();

  @override
  void dispose() {
    _filterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ShowInterviewsBloc(DIContainer.showInterviews)
            ..add(ShowInterviews(userId: widget.userId)),
      child: _CustomInterviewsList(
        filterController: _filterController,
        runFilter: _runFilter,
        interviewInfo: InterviewInfo(
          direction: direction,
          difficulty: difficulty,
        ),
      ),
    );
  }

  void _updateFilterText() {
    _filterController.text = InterviewInfo.textInFilter(
      InterviewInfo(direction: direction, difficulty: difficulty),
    );
  }

  void _runFilter(String direction1, String difficulty1) {
    setState(() {
      direction = direction1;
      difficulty = difficulty1;
    });
    _updateFilterText();
  }
}

class _CustomInterviewsList extends StatelessWidget {
  final InterviewInfo interviewInfo;
  final Function(String, String) runFilter;
  final TextEditingController filterController;

  const _CustomInterviewsList({
    required this.interviewInfo,
    required this.runFilter,
    required this.filterController,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShowInterviewsBloc, ShowInterviewsState>(
      listener: (context, state) {
        if (state is ShowInterviewsFailure) {
          ToastHelper.loadingError();
        }
      },
      builder: (context, state) {
        if (state is ShowInterviewsLoading) {
          return CustomLoadingIndicator();
        } else if (state is ShowInterviewsSuccess) {
          if (state.interviews.isEmpty) return _EmptyHistory();
          return _InterviewsListView(
            interviews: Interview.filterInterviews(
              interviewInfo.direction,
              interviewInfo.difficulty,
              state.interviews,
            ),
            runFilter: runFilter,
            filterController: filterController,
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
  final Function(String, String) runFilter;
  final TextEditingController filterController;

  const _InterviewsListView({
    required this.interviews,
    required this.runFilter,
    required this.filterController,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _FilterButton(
            runFilter: runFilter,
            filterController: filterController,
          ),
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
      ),
    );
  }
}

class _FilterButton extends StatelessWidget {
  final Function(String, String) runFilter;
  final TextEditingController filterController;

  const _FilterButton({
    required this.runFilter,
    required this.filterController,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: TextField(
        readOnly: true,
        focusNode: FocusNode(canRequestFocus: false),
        controller: filterController,
        onTap: () {
          DialogHelper.showCustomDialog(
            context,
            CustomFilterDialog(runFilter: runFilter),
          );
        },
        decoration: InputDecoration(
          hintText: 'Фильтр',
          prefixIcon: Icon(Icons.search),
          suffixIcon: IconButton(
            onPressed: () => runFilter('', ''),
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
    return GestureDetector(
      onTap: () {
        AppRouter.pushNamed(AppRouterNames.interviewInfo, arguments: interview);
      },
      child: Card(
        child: ListTile(
          leading: CustomScoreIndicator(score: interview.score),
          title: Text(
            '${interview.direction}, ${interview.difficulty}',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat('dd/MM/yyyy HH:mm').format(interview.date),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
