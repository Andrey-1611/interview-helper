import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_master/core/global_services/notifications/models/notification.dart';
import 'package:interview_master/core/global_services/notifications/services/notifications_repository.dart';

part 'send_notification_event.dart';
part 'send_notification_state.dart';

class SendNotificationBloc extends Bloc<SendNotificationEvent, SendNotificationState> {
  final NotificationsRepository notificationsInterface;
  SendNotificationBloc(this.notificationsInterface) : super(SendNotificationInitial()) {
    on<SendNotification>((event, emit) {
      emit(SendNotificationLoading());
      try {
        notificationsInterface.sendNotification(event.notification);
        emit(SendNotificationSuccess());
      } catch (e) {
        emit(SendNotificationFailure());
      }
    });
  }
}
