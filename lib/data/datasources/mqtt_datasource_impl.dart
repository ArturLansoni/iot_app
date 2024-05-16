import 'dart:convert';
import 'package:iot_app/data/datasources/mqtt_datasource.dart';
import 'package:iot_app/domain/entities/message_entity.dart';
import 'package:iot_app/domain/entities/payload_entity.dart';
import 'package:mqtt_client/mqtt_client.dart';

class MQTTDataSource implements IoTDataSource {
  MQTTDataSource({
    required MqttClient client,
  }) : _client = client;
  final MqttClient _client;

  @override
  bool get isConnected =>
      _client.connectionStatus!.state == MqttConnectionState.connected;

  @override
  Future<void> connect({
    required List<String> topics,
  }) async {
    await _client.connect();

    for (final topic in topics) {
      _client.subscribe(topic, MqttQos.atMostOnce);
    }
    print('Connected to MQTT broker');
  }

  @override
  void publishMessage(MessageEntity message) {
    if (isConnected) {
      final String topic = message.topic;
      final PayloadEntity payload = message.payload;
      final Map<String, dynamic> payloadData = payload.toMap();
      final payloadString = jsonEncode(payloadData);
      final builder = MqttClientPayloadBuilder();
      builder.addString(payloadString);
      _client.publishMessage(
        topic,
        MqttQos.atLeastOnce,
        builder.payload!,
      );
      print('Published message: $payloadString');
    }
  }

  @override
  Stream<MessageEntity>? getMessages() {
    return _client.updates?.map(
      (event) {
        final receivedMessage = event.first;
        final topic = receivedMessage.topic;
        final payload = receivedMessage.payload as MqttPublishMessage;
        final payloadString = MqttPublishPayload.bytesToStringAsString(
          payload.payload.message,
        );
        final Map<String, dynamic> payloadData = jsonDecode(payloadString);
        final MessageEntity message = MessageEntity(
          topic: topic,
          payload: PayloadEntity.fromMap(payloadData),
        );
        print('Received message: $payloadString');
        return message;
      },
    );
  }

  @override
  void disconnect() {
    _client.disconnect();
    print('Disconnected from MQTT broker');
  }
}
