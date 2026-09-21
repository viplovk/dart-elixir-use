import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/room_service.dart';
import '../theme/app_theme.dart';
import 'room_screen.dart';

class CreateRoomScreen extends StatefulWidget {
  const CreateRoomScreen({Key? key}) : super(key: key);

  @override
  State<CreateRoomScreen> createState() => _CreateRoomScreenState();
}

class _CreateRoomScreenState extends State<CreateRoomScreen> {
  final TextEditingController _nameController =
      TextEditingController(text: 'Alpha Tactical');
  int _ttlSeconds = 1800; // 30 minutes default
  int _maxParticipants = 8;
  bool _voiceEnabled = true;
  bool _chatEnabled = true;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _handleCreate(RoomService roomService) async {
    final success = await roomService.createRoom(
      name: _nameController.text.trim().isEmpty
          ? 'Alpha Tactical'
          : _nameController.text.trim(),
      ttlSeconds: _ttlSeconds,
      maxParticipants: _maxParticipants,
    );

    if (success && mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const RoomScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final roomService = Provider.of<RoomService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('PROVISION EPHEMERAL ROOM'),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Room Name Field
                  const Text(
                    'ROOM IDENTIFIER / NAME',
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textMuted,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _nameController,
                    style: const TextStyle(color: AppTheme.textPrimary),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AppTheme.surface,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: AppTheme.border),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Expiration TTL selection
                  const Text(
                    'EPHEMERAL LIFETIME (EXPIRATION)',
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textMuted,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildTtlChip(300, '5 MIN'),
                      const SizedBox(width: 8),
                      _buildTtlChip(900, '15 MIN'),
                      const SizedBox(width: 8),
                      _buildTtlChip(1800, '30 MIN'),
                      const SizedBox(width: 8),
                      _buildTtlChip(3600, '60 MIN'),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Max Participants
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'MAX PARTICIPANTS',
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textMuted,
                        ),
                      ),
                      Text(
                        '$_maxParticipants MEMBERS',
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryNeon,
                        ),
                      ),
                    ],
                  ),
                  Slider(
                    value: _maxParticipants.toDouble(),
                    min: 2,
                    max: 16,
                    divisions: 7,
                    activeColor: AppTheme.primaryNeon,
                    inactiveColor: AppTheme.border,
                    onChanged: (val) {
                      setState(() {
                        _maxParticipants = val.toInt();
                      });
                    },
                  ),
                  const SizedBox(height: 32),

                  if (roomService.errorMessage != null) ...[
                    Text(
                      roomService.errorMessage!,
                      style: const TextStyle(
                          color: AppTheme.dangerRed, fontSize: 12),
                    ),
                    const SizedBox(height: 12),
                  ],

                  ElevatedButton(
                    onPressed: roomService.isLoading
                        ? null
                        : () => _handleCreate(roomService),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryNeon,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      textStyle: const TextStyle(
                        fontFamily: 'monospace',
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        letterSpacing: 1.2,
                      ),
                    ),
                    child: roomService.isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('ACTIVATE EPHEMERAL CHANNEL'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTtlChip(int seconds, String label) {
    final isSelected = _ttlSeconds == seconds;
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            _ttlSeconds = seconds;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected
                ? AppTheme.primaryNeon.withOpacity(0.15)
                : AppTheme.surface,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: isSelected ? AppTheme.primaryNeon : AppTheme.border,
              width: isSelected ? 1.5 : 1.0,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: isSelected ? AppTheme.primaryNeon : AppTheme.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}
