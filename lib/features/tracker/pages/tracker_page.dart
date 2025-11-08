import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:interview_master/app/widgets/custom_loading_indicator.dart';
import 'package:interview_master/app/widgets/custom_score_indicator.dart';
import 'package:interview_master/core/constants/interviews_data.dart';
import 'package:interview_master/core/theme/app_pallete.dart';
import 'package:interview_master/core/utils/data_cubit.dart';
import 'package:interview_master/core/utils/dialog_helper.dart';
import 'package:interview_master/core/utils/filter_text_formatter.dart';
import 'package:interview_master/core/utils/toast_helper.dart';
import 'package:interview_master/core/utils/task_type_helper.dart';
import 'package:interview_master/data/repositories/local/local.dart';
import 'package:interview_master/features/tracker/blocs/selector_subit/selector_cubit.dart';
import 'package:interview_master/features/tracker/blocs/tracker_bloc/tracker_bloc.dart';
import 'package:intl/intl.dart';
import '../../../app/router/app_router_names.dart';
import '../../../app/widgets/custom_button.dart';
import '../../../app/widgets/custom_dropdown_menu.dart';
import '../../../app/widgets/custom_filter_button.dart';
import '../../../data/models/task.dart';
import '../../../data/repositories/remote/remote_repository.dart';
import '../blocs/filter_tasks_cubit/filter_tasks_cubit.dart';

class TrackerPage extends StatelessWidget {
  const TrackerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          key: ValueKey(context.watch<DataCubit>().state),
          create: (context) => TrackerBloc(
            GetIt.I<LocalRepository>(),
            GetIt.I<RemoteRepository>(),
          )..add(GetTasks()),
        ),
        BlocProvider(create: (context) => FilterTasksCubit()),
        BlocProvider(create: (context) => SelectorCubit()),
      ],
      child: _TrackerPageView(),
    );
  }
}

class _TrackerPageView extends StatelessWidget {
  const _TrackerPageView();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final filter = context.watch<FilterTasksCubit>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Трекер'),
        actions: [
          IconButton(
            onPressed: () => DialogHelper.showCustomDialog(
              dialog: _CreateTaskDialog(
                trackerBloc: context.read<TrackerBloc>(),
                selectorCubit: context.read<SelectorCubit>(),
              ),
              context: context,
            ),
            icon: Icon(Icons.add_task),
          ),
          IconButton(
            onPressed: () => context.push(AppRouterNames.profile),
            icon: Icon(Icons.settings),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size(double.infinity, size.height * 0.077),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Expanded(
                  child: CustomFilterButton(
                    filterController: TextEditingController(
                      text: FilterTextFormatter.tasks(
                        filter.state.direction,
                        filter.state.type,
                        filter.state.sort,
                      ),
                    ),
                    resetFilter: () => filter.reset(),
                    filterDialog: _FilterDialog(filterCubit: filter),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: IconButton(
                    onPressed: () => filter.changeIsCompleted(),
                    icon: Icon(
                      filter.state.isCompleted == null
                          ? Icons.radio_button_off
                          : filter.state.isCompleted!
                          ? Icons.check_circle
                          : Icons.remove_circle,
                    ),
                    color: switch (filter.state.isCompleted) {
                      null => AppPalette.textSecondary,
                      false => AppPalette.error,
                      true => AppPalette.primary,
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
        child: _TasksList(filter: filter),
      ),
    );
  }
}

class _TasksList extends StatelessWidget {
  final FilterTasksCubit filter;

  const _TasksList({required this.filter});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TrackerBloc, TrackerState>(
      listener: (context, state) {
        if (state is TrackerFailure) {
          ToastHelper.unknownError();
        } else if (state is TrackerTasksFailure) {
          ToastHelper.tasksIsCompletedError();
        }
      },
      builder: (context, state) {
        if (state is TrackerSuccess) {
          return _TasksListView(tasks: state.tasks, filter: filter);
        } else if (state is TrackerTasksFailure) {
          return _TasksListView(tasks: state.tasks, filter: filter);
        }
        return CustomLoadingIndicator();
      },
    );
  }
}

class _TasksListView extends StatelessWidget {
  final List<Task> tasks;
  final FilterTasksCubit filter;

  const _TasksListView({required this.tasks, required this.filter});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    if (tasks.isEmpty) return _EmptyList();
    final filteredTasks = Task.filterTasks(
      filter.state.direction,
      filter.state.type,
      filter.state.sort,
      filter.state.isCompleted,
      tasks,
    );
    if (filteredTasks.isEmpty) return _EmptyFilterList();
    return ListView.builder(
      itemCount: filteredTasks.length,
      itemBuilder: (context, index) {
        final task = filteredTasks[index];
        return Card(
          shape: RoundedRectangleBorder(
            side: task.isCompleted
                ? BorderSide(color: AppPalette.primary, width: 2.0)
                : BorderSide.none,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: ListTile(
            onTap: () => context.push(AppRouterNames.task, extra: task),
            leading: CustomScoreIndicator(
              score: task.progress,
              height: size.height * 0.055,
            ),
            title: Text(
              '${task.direction}, ${DateFormat('dd/MM/yyyy').format(task.createdAt)}',
            ),
            subtitle: Text(
              '${task.targetValue} ${TaskTypeHelper.getType(task.targetValue, task.type)}',
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  task.isCompleted ? Icons.check : Icons.remove_circle,
                  color: task.isCompleted
                      ? AppPalette.primary
                      : AppPalette.textSecondary,
                ),
                !task.isCompleted
                    ? IconButton(
                        onPressed: () => DialogHelper.showCustomDialog(
                          dialog: _DeleteTaskDialog(
                            trackerBloc: context.read<TrackerBloc>(),
                            taskId: task.id,
                          ),
                          context: context,
                        ),
                        icon: Icon(Icons.delete),
                      )
                    : SizedBox.shrink(),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _EmptyList extends StatelessWidget {
  const _EmptyList();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Задач еще нету', style: theme.textTheme.displayLarge),
          TextButton(
            onPressed: () => DialogHelper.showCustomDialog(
              dialog: _CreateTaskDialog(
                trackerBloc: context.read<TrackerBloc>(),
                selectorCubit: context.read<SelectorCubit>(),
              ),
              context: context,
            ),
            child: Text('Создать задачу'),
          ),
        ],
      ),
    );
  }
}

class _EmptyFilterList extends StatelessWidget {
  const _EmptyFilterList();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Задач по данному фильтру нет',
            style: theme.textTheme.displayLarge,
          ),
          TextButton(
            onPressed: () => context.read<FilterTasksCubit>().reset(),
            child: Text('Сбросить фильтр'),
          ),
        ],
      ),
    );
  }
}

class _DeleteTaskDialog extends StatelessWidget {
  final TrackerBloc trackerBloc;
  final String taskId;

  const _DeleteTaskDialog({required this.trackerBloc, required this.taskId});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AlertDialog(
      content: Text(
        'Вы уверены, что хотите удалить эту задачу?',
        style: theme.textTheme.bodyLarge,
      ),
      actions: [
        TextButton(
          onPressed: () {
            context.pop();
            trackerBloc.add(DeleteTask(id: taskId));
          },
          child: const Text('Да'),
        ),
        TextButton(onPressed: () => context.pop(), child: const Text('Нет')),
      ],
    );
  }
}

class _CreateTaskDialog extends StatelessWidget {
  final TrackerBloc trackerBloc;
  final SelectorCubit selectorCubit;

  const _CreateTaskDialog({
    required this.trackerBloc,
    required this.selectorCubit,
  });

  @override
  Widget build(BuildContext context) {
    final state = selectorCubit.state;
    return AlertDialog(
      title: const Text('Новая задача'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomDropdownMenu(
            value: state.direction,
            data: InterviewsData.directions,
            change: selectorCubit.changeDirection,
            hintText: 'Направление',
          ),
          CustomDropdownMenu(
            value: state.type,
            data: InterviewsData.types,
            change: selectorCubit.changeType,
            hintText: 'Тип',
          ),
          const SizedBox(height: 6),
          TextFormField(
            decoration: const InputDecoration(
              hintText: 'Цель',
              border: OutlineInputBorder(borderSide: BorderSide.none),
            ),
            initialValue: state.value?.toString() ?? '',
            keyboardType: TextInputType.number,
            onChanged: selectorCubit.changeValue,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            selectorCubit.reset();
          },
          child: const Text('Отмена'),
        ),
        TextButton(
          onPressed: () => _createTask(context, selectorCubit),
          child: const Text('Создать'),
        ),
      ],
    );
  }

  void _createTask(BuildContext context, SelectorCubit cubit) {
    final state = selectorCubit.state;
    if (state.direction != null &&
        state.type != null &&
        state.value != null &&
        state.value! > 0) {
      trackerBloc.add(
        CreateTask(
          direction: selectorCubit.state.direction!,
          type: selectorCubit.state.type!,
          targetValue: selectorCubit.state.value!,
        ),
      );
      selectorCubit.reset();
      context.pop();
    } else {
      ToastHelper.taskSelectorError();
    }
  }
}

class _FilterDialog extends StatelessWidget {
  final FilterTasksCubit filterCubit;

  const _FilterDialog({required this.filterCubit});

  @override
  Widget build(BuildContext context) {
    String? direction = filterCubit.state.direction;
    String? type = filterCubit.state.type;
    String? sort = filterCubit.state.sort;
    return AlertDialog(
      content: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomDropdownMenu(
            value: direction,
            data: InterviewsData.directions,
            change: (value) => direction = value,
            hintText: 'Направление',
          ),
          CustomDropdownMenu(
            value: type,
            data: InterviewsData.types,
            change: (value) => type = value,
            hintText: 'Тип',
          ),
          CustomDropdownMenu(
            value: sort,
            data: InterviewsData.tasksSorts,
            change: (value) => sort = value,
            hintText: 'Сортировка',
          ),
          CustomButton(
            text: 'Применить',
            selectedColor: AppPalette.primary,
            onPressed: () {
              filterCubit.runFilter(direction, type, sort);
              context.pop();
            },
          ),
        ],
      ),
    );
  }
}
