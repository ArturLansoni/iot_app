import 'package:equatable/equatable.dart';
import 'payload_entity.dart';

final class MessageEntity extends Equatable {
  const MessageEntity({
    required this.topic,
    required this.payload,
  });

  final String topic;
  final PayloadEntity payload;

  @override
  List<Object?> get props => [topic, payload];
}
