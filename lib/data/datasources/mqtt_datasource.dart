import 'package:iot_app/domain/entities/message_entity.dart';

abstract interface class IoTDataSource {
  bool get isConnected;
  Future<void> connect({required List<String> topics});
  void publishMessage(MessageEntity message);
  Stream<MessageEntity>? getMessages();
  void disconnect();
}
