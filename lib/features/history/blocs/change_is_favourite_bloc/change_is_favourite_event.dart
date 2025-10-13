part of 'change_is_favourite_bloc.dart';

sealed class ChangeIsFavouriteEvent extends Equatable {
  const ChangeIsFavouriteEvent();

  @override
  List<Object?> get props => [];
}

final class ChangeIsFavouriteInterview extends ChangeIsFavouriteEvent {
  final String id;

  const ChangeIsFavouriteInterview({required this.id});

  @override
  List<Object?> get props => [id];
}

final class ChangeIsFavouriteQuestion extends ChangeIsFavouriteEvent {
  final String id;

  const ChangeIsFavouriteQuestion({required this.id});

  @override
  List<Object?> get props => [id];
}
