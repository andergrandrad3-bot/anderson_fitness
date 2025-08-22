import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:camera/camera.dart';

void main() {
  runApp(const AndersonFitness());
}

class AndersonFitness extends StatelessWidget {
  const AndersonFitness({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Anderson Fitness',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> _treinoDoDia = [
    "30 Polichinelos",
    "20 Agachamentos",
    "30 Afundos",
    "20 Flexões",
    "40 Socos Retos",
    "Prancha 60s (+10s/dia)",
    "20 Abdominais",
  ];

  TimeOfDay? _horario;
  late FlutterLocalNotificationsPlugin _notificacoes;

  @override
  void initState() {
    super.initState();
    _notificacoes = FlutterLocalNotificationsPlugin();

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings();
    const settings = InitializationSettings(android: android, iOS: ios);
    _notificacoes.initialize(settings);
  }

  Future<void> _agendarNotificacao(TimeOfDay horario) async {
    final agora = DateTime.now();
    final agendado = DateTime(
      agora.year,
      agora.month,
      agora.day,
      horario.hour,
      horario.minute,
    );

    final android = AndroidNotificationDetails(
      'anderson_channel',
      'Treino Diário',
      importance: Importance.max,
      priority: Priority.high,
    );

    const ios = DarwinNotificationDetails();

    await _notificacoes.zonedSchedule(
      0,
      'Hora do treino!',
      'Vamos treinar: Anderson Fitness',
      agendado,
      NotificationDetails(android: android, iOS: ios),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Anderson Fitness')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _treinoDoDia.length,
                itemBuilder: (_, i) => ListTile(title: Text(_treinoDoDia[i])),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                final selecionado = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (selecionado != null) {
                  setState(() => _horario = selecionado);
                  _agendarNotificacao(selecionado);
                }
              },
              child: const Text('Definir horário do treino'),
            ),
          ],
        ),
      ),
    );
  }
}
