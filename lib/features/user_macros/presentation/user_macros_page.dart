import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/app_models.dart';
import '../../../core/providers/app_state_provider.dart';
import '../../../core/utils/formatters.dart';

class UserMacrosPage extends ConsumerWidget {
  const UserMacrosPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final RelapAppState appState = ref.watch(relapAppControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Từ điển vị trí'),
        actions: <Widget>[
          IconButton(
            onPressed: appState.isSyncing
                ? null
                : () => ref.read(relapAppControllerProvider.notifier).syncMacros(),
            icon: appState.isSyncing
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.cloud_sync),
            tooltip: 'Đồng bộ Oracle Cloud',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          Text(
            'Quản lý keyword để T-Mod hiểu lệnh dẫn đường bằng giọng nói.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 12),
          _SyncSummary(appState: appState),
          const SizedBox(height: 12),
          for (final UserMacro macro in appState.macros)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _MacroTile(macro: macro),
            ),
          if (appState.macros.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 40),
              child: Center(child: Text('Chưa có vị trí nào.')),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showMacroEditor(context, ref),
        icon: const Icon(Icons.add_location_alt),
        label: const Text('Thêm'),
      ),
    );
  }
}

class _SyncSummary extends StatelessWidget {
  const _SyncSummary({required this.appState});

  final RelapAppState appState;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: <Widget>[
            Icon(
              appState.pendingMacroCount == 0
                  ? Icons.cloud_done
                  : Icons.cloud_upload_outlined,
              color: appState.pendingMacroCount == 0 ? Colors.teal : Colors.orange,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    appState.pendingMacroCount == 0
                        ? 'Đã đồng bộ'
                        : '${appState.pendingMacroCount} macro đang chờ',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(
                    appState.lastSyncAt == null
                        ? 'Chưa đồng bộ'
                        : 'Lần cuối: ${timeAgo(appState.lastSyncAt!)}',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MacroTile extends ConsumerWidget {
  const _MacroTile({required this.macro});

  final UserMacro macro;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isSynced = macro.syncStatus == MacroSyncStatus.synced;

    return Dismissible(
      key: ValueKey<String>(macro.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 18),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.error,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) =>
          ref.read(relapAppControllerProvider.notifier).deleteMacro(macro.id),
      child: Card(
        child: ListTile(
          leading: const Icon(Icons.place_outlined),
          title: Text(macro.keyword),
          subtitle: Text(formatLatLng(macro.latitude, macro.longitude)),
          trailing: Wrap(
            spacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: <Widget>[
              Chip(
                avatar: Icon(
                  isSynced ? Icons.check_circle : Icons.pending,
                  size: 18,
                ),
                label: Text(isSynced ? 'Synced' : 'Pending'),
              ),
              IconButton(
                onPressed: () => _showMacroEditor(context, ref, macro: macro),
                icon: const Icon(Icons.edit_location_alt),
                tooltip: 'Sửa vị trí',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void _showMacroEditor(
  BuildContext context,
  WidgetRef ref, {
  UserMacro? macro,
}) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (BuildContext context) {
      return _MacroEditor(macro: macro);
    },
  );
}

class _MacroEditor extends ConsumerStatefulWidget {
  const _MacroEditor({this.macro});

  final UserMacro? macro;

  @override
  ConsumerState<_MacroEditor> createState() => _MacroEditorState();
}

class _MacroEditorState extends ConsumerState<_MacroEditor> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _keywordController;
  late final TextEditingController _latController;
  late final TextEditingController _lngController;

  @override
  void initState() {
    super.initState();
    _keywordController = TextEditingController(text: widget.macro?.keyword ?? '');
    _latController = TextEditingController(
      text: (widget.macro?.latitude ?? 10.7769).toStringAsFixed(5),
    );
    _lngController = TextEditingController(
      text: (widget.macro?.longitude ?? 106.7009).toStringAsFixed(5),
    );
  }

  @override
  void dispose() {
    _keywordController.dispose();
    _latController.dispose();
    _lngController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final EdgeInsets viewInsets = MediaQuery.viewInsetsOf(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(20, 8, 20, viewInsets.bottom + 24),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              widget.macro == null ? 'Thêm vị trí' : 'Sửa vị trí',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _keywordController,
              decoration: const InputDecoration(
                labelText: 'Từ khóa',
                prefixIcon: Icon(Icons.record_voice_over),
              ),
              validator: (String? value) =>
                  value == null || value.trim().isEmpty ? 'Nhập từ khóa' : null,
            ),
            const SizedBox(height: 10),
            Row(
              children: <Widget>[
                Expanded(
                  child: TextFormField(
                    controller: _latController,
                    decoration: const InputDecoration(
                      labelText: 'Lat',
                      prefixIcon: Icon(Icons.north),
                    ),
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                      signed: true,
                    ),
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp(r'[-0-9.]')),
                    ],
                    validator: _coordinateValidator,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    controller: _lngController,
                    decoration: const InputDecoration(
                      labelText: 'Lng',
                      prefixIcon: Icon(Icons.east),
                    ),
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                      signed: true,
                    ),
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp(r'[-0-9.]')),
                    ],
                    validator: _coordinateValidator,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 118,
              child: Card(
                child: Stack(
                  children: <Widget>[
                    Positioned.fill(child: CustomPaint(painter: _PinMapPainter())),
                    const Center(
                      child: Icon(
                        Icons.add_location_alt,
                        color: Color(0xFFD7263D),
                        size: 38,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),
            FilledButton.icon(
              onPressed: _save,
              icon: const Icon(Icons.save),
              label: const Text('Lưu và chờ đồng bộ'),
            ),
          ],
        ),
      ),
    );
  }

  String? _coordinateValidator(String? value) {
    final double? parsed = double.tryParse(value ?? '');
    if (parsed == null) {
      return 'Sai định dạng';
    }
    return null;
  }

  void _save() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    ref.read(relapAppControllerProvider.notifier).upsertMacro(
          id: widget.macro?.id,
          keyword: _keywordController.text,
          latitude: double.parse(_latController.text),
          longitude: double.parse(_lngController.text),
        );
    Navigator.of(context).pop();
  }
}

class _PinMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Offset.zero & size,
      Paint()..color = const Color(0xFFEFF7F5),
    );
    final Paint road = Paint()
      ..color = Colors.white
      ..strokeWidth = 7
      ..style = PaintingStyle.stroke;
    canvas.drawLine(Offset(0, 24), Offset(size.width, size.height - 18), road);
    canvas.drawLine(Offset(size.width * 0.2, size.height), Offset(size.width, 12), road);
    canvas.drawLine(
      Offset(0, size.height * 0.62),
      Offset(size.width, size.height * 0.5),
      road,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
