import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:interview_master/app/widgets/custom_loading_indicator.dart';
import 'package:interview_master/data/repositories/local_repository.dart';
import 'package:intl/intl.dart';
import '../../../core/utils/network_info.dart';
import '../../../data/repositories/remote_repository.dart';
import '../blocs/friends_bloc/friends_bloc.dart';

class FriendRequestsPage extends StatelessWidget {
  const FriendRequestsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FriendsBloc(
        GetIt.I<RemoteRepository>(),
        GetIt.I<LocalRepository>(),
        GetIt.I<NetworkInfo>(),
      )..add(GetFriendRequests()),
      child: _FriendRequestsPageView(),
    );
  }
}

class _FriendRequestsPageView extends StatelessWidget {
  const _FriendRequestsPageView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Заявки в друзья')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocBuilder<FriendsBloc, FriendsState>(
          builder: (context, state) {
            if (state is FriendRequestsSuccess) {
              return ListView.builder(
                itemCount: state.requests.length,
                itemBuilder: (context, index) {
                  final request = state.requests[index];
                  return Card(
                    child: ListTile(
                      title: Text('Андрей'),
                      subtitle: Text(
                        DateFormat('dd/MM/yyyy HH:mm').format(request.date),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(onPressed: () {}, icon: Icon(Icons.add)),
                          IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.minimize),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
            return CustomLoadingIndicator();
          },
        ),
      ),
    );
  }
}
