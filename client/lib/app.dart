import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/phoenix_socket.dart';
import 'services/encryption_service.dart';
import 'services/audio_service.dart';
import 'services/room_service.dart';
import 'theme/app_theme.dart';
import 'screens/home_screen.dart';

class WalkieTalkieApp extends StatelessWidget {
  const WalkieTalkieApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<PhoenixSocketService>(
          create: (_) => PhoenixSocketService(),
          dispose: (_, s) => s.dispose(),
        ),
        Provider<EncryptionService>(
          create: (_) => EncryptionService(),
        ),
        Provider<AudioService>(
          create: (_) => AudioService(),
          dispose: (_, a) => a.dispose(),
        ),
        ChangeNotifierProvider<RoomService>(
          create: (ctx) => RoomService(
            socketService: ctx.read<PhoenixSocketService>(),
            encryptionService: ctx.read<EncryptionService>(),
            audioService: ctx.read<AudioService>(),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Wave // Tactical Comms',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        home: const HomeScreen(),
      ),
    );
  }
}
