part of 'change_is_favourite_bloc.dart';

sealed class ChangeIsFavouriteState extends Equatable {
  const ChangeIsFavouriteState();

  @override
  List<Object> get props => [];
}

final class ChangeIsFavouriteInitial extends ChangeIsFavouriteState {}

final class ChangeIsFavouriteLoading extends ChangeIsFavouriteState {}

final class ChangeIsFavouriteFailure extends ChangeIsFavouriteState {}

final class ChangeIsFavouriteNetworkFailure extends ChangeIsFavouriteState {}

final class ChangeIsFavouriteSuccess extends ChangeIsFavouriteState {}
