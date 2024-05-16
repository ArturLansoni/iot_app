part of 'doorbell_cubit.dart';

sealed class DoorBellState extends Equatable {
  @override
  List<Object?> get props => [];
}

final class DoorBellDisconnected extends DoorBellState {}

final class DoorBellLoading extends DoorBellState {}

final class DoorBellError extends DoorBellState {}

final class DoorBellConnected extends DoorBellState {}
