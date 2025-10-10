part of 'change_is_favourite_bloc.dart';

sealed class ChangeIsFavouriteEvent extends Equatable {
  const ChangeIsFavouriteEvent();

  @override
  List<Object?> get props => [];
}

final class ChangeIsFavourite extends ChangeIsFavouriteEvent {
  final String id;

  const ChangeIsFavourite({required this.id});

  @override
  List<Object?> get props => [id];
}
