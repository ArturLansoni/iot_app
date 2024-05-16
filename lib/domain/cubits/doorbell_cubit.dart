import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:iot_app/data/datasources/mqtt_datasource.dart';
import 'package:iot_app/domain/entities/message_entity.dart';
import 'package:iot_app/domain/entities/payload_entity.dart';

part 'doorbell_state.dart';

class DoorBellCubit extends Cubit<DoorBellState> {
  DoorBellCubit(this._dataSource) : super(DoorBellDisconnected());

  final IoTDataSource _dataSource;

  static const topic = '/doorbell/fb';
  static const command = '/doorbell/cm';

  StreamSubscription<MessageEntity>? _messages;

  Future<void> connect() async {
    emit(DoorBellLoading());
    try {
      await _dataSource.connect(topics: [topic]);
      getMessages();
      emit(DoorBellConnected());
    } catch (e) {
      emit(DoorBellError());
    }
  }

  void getMessages() {
    _messages = _dataSource
        .getMessages()
        ?.where((message) => message.topic == topic)
        .listen((event) => emit(DoorBellConnected()));
  }

  void triggerDoorBell() {
    _dataSource.publishMessage(const MessageEntity(
      topic: command,
      payload: PayloadEntity(
        topic: command,
        value: 1,
      ),
    ));
    emit(DoorBellConnected());
  }

  void dispose() {
    _messages?.cancel();
    _dataSource.disconnect();
  }
}
