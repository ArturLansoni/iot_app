import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iot_app/data/datasources/mqtt_datasource_impl.dart';
import 'package:iot_app/domain/cubits/doorbell_cubit.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'dart:math' as math;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    final client = MqttServerClient('broker.emqx.io', 'app');
    client.port = 1883;
    client.keepAlivePeriod = 120;
    client.connectTimeoutPeriod = 2000;
    client.autoReconnect = true;
    final dataSource = MQTTDataSource(client: client);
    final cubit = DoorBellCubit(dataSource);

    return MaterialApp(
      title: 'IOT App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: BlocProvider.value(
        value: cubit,
        child: const HomePage(),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  int _shakeCount = 0;
  DoorBellState? previousState;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
  }

  void _shake() {
    if (_shakeCount < 5) {
      _controller.forward().then((_) {
        _controller.reverse().then((_) {
          setState(() => _shakeCount++);
          _shake();
        });
      });
    } else {
      setState(() => _shakeCount = 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DoorBellCubit, DoorBellState>(
      listener: (context, newState) {
        if (newState is DoorBellConnected &&
            previousState is DoorBellConnected) {
          _shake();
        }
        previousState = newState;
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: const Text('IOT App')),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (state is DoorBellLoading) const CircularProgressIndicator(),
                if (state is DoorBellConnected) ...[
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (_, __) {
                      return Transform.rotate(
                        angle: _controller.value * 0.1 * math.pi,
                        child: const Icon(Icons.sensors, size: 100),
                      );
                    },
                  ),
                  const Text('Connected'),
                ],
                if (state is DoorBellError || state is DoorBellDisconnected)
                  ElevatedButton(
                    onPressed: () {
                      context.read<DoorBellCubit>().connect();
                    },
                    child: Text(
                      state is DoorBellError ? 'Reconnect' : 'Connect',
                    ),
                  ),
              ],
            ),
          ),
          floatingActionButton: (state is! DoorBellConnected)
              ? null
              : FloatingActionButton(
                  onPressed: () =>
                      context.read<DoorBellCubit>().triggerDoorBell(),
                  child: const Icon(Icons.notifications_active),
                ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    context.read<DoorBellCubit>().dispose();
    super.dispose();
  }
}
