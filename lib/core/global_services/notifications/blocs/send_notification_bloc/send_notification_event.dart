part of 'send_notification_bloc.dart';

sealed class SendNotificationEvent extends Equatable {
  const SendNotificationEvent();

  @override
  List<Object?> get props => [];
}

final class SendNotification extends SendNotificationEvent {
  final MyNotification notification;

  const SendNotification({required this.notification});

  @override
  List<Object?> get props => [notification];
}


