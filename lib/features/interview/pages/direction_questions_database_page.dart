import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_master/core/constants/direction.dart';
import 'package:interview_master/core/constants/interviews_data.dart';
import 'package:interview_master/core/utils/capitalize_extention.dart';
import 'package:interview_master/features/interview/blocs/search_cubit/search_cubit.dart';

import '../../../generated/l10n.dart';

class DirectionQuestionsDatabasePage extends StatelessWidget {
  final Direction direction;

  const DirectionQuestionsDatabasePage({super.key, required this.direction});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchCubit(),
      child: DefaultTabController(
        length: 3,
        child: _DirectionQuestionsDatabasePageView(direction: direction),
      ),
    );
  }
}

class _DirectionQuestionsDatabasePageView extends StatelessWidget {
  final Direction direction;

  const _DirectionQuestionsDatabasePageView({required this.direction});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(direction.direction),
        bottom: PreferredSize(
          preferredSize: Size(double.infinity, size.height * 0.12),
          child: Column(
            children: [
              _SearchField(),
              TabBar(
                tabs: [
                  Tab(text: InterviewsData.junior.capitalize),
                  Tab(text: InterviewsData.middle.capitalize),
                  Tab(text: InterviewsData.senior.capitalize),
                ],
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: TabBarView(
          children: [
            _KeepAlivePage(
              child: _DifficultyQuestionsDatabaseTab(
                questions: direction.juniorQuestions,
              ),
            ),
            _KeepAlivePage(
              child: _DifficultyQuestionsDatabaseTab(
                questions: direction.middleQuestions,
              ),
            ),
            _KeepAlivePage(
              child: _DifficultyQuestionsDatabaseTab(
                questions: direction.seniorQuestions,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DifficultyQuestionsDatabaseTab extends StatelessWidget {
  final List<String> questions;

  const _DifficultyQuestionsDatabaseTab({required this.questions});

  @override
  Widget build(BuildContext context) {
    final search = context.watch<SearchCubit>();
    final searchQuestions = Direction.searchQuestions(search.state, questions);
    if (searchQuestions.isEmpty) return _EmptyList(search);
    return ListView.builder(
      itemCount: searchQuestions.length,
      itemBuilder: (context, index) {
        final question = searchQuestions[index];
        return Card(
          child: ListTile(leading: Text('${index + 1}'), title: Text(question)),
        );
      },
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField();

  @override
  Widget build(BuildContext context) {
    final search = context.read<SearchCubit>();
    final theme = Theme.of(context);
    final s = S.of(context);
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8.0),
      child: TextField(
        onChanged: search.update,
        decoration: InputDecoration(
          fillColor: theme.canvasColor,
          hintText: s.search,
          prefixIcon: Icon(Icons.search),
        ),
      ),
    );
  }
}

class _EmptyList extends StatelessWidget {
  final SearchCubit search;

  const _EmptyList(this.search);

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = Theme.of(context);
    return Center(
      child: Text(s.nothing_found, style: theme.textTheme.displayLarge),
    );
  }
}

class _KeepAlivePage extends StatefulWidget {
  final Widget child;

  const _KeepAlivePage({required this.child});

  @override
  State<_KeepAlivePage> createState() => _KeepAlivePageState();
}

class _KeepAlivePageState extends State<_KeepAlivePage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}
