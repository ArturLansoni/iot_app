import 'package:equatable/equatable.dart';

final class PayloadEntity extends Equatable {
  const PayloadEntity({
    required this.topic,
    required this.value,
  });

  final String topic;
  final num value;

  @override
  List<Object?> get props => [topic, value];

  Map<String, dynamic> toMap() {
    return {
      'topic': topic,
      'value': value,
    };
  }

  factory PayloadEntity.fromMap(Map<String, dynamic> map) {
    return PayloadEntity(
      topic: map['topic'] ?? '',
      value: map['value'] ?? 0,
    );
  }
}
