import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:taxi_app/blocs/settings/settings_bloc.dart';
import 'package:taxi_app/blocs/settings/settings_event.dart';
import 'package:taxi_app/blocs/settings/settings_state.dart';
import 'package:taxi_app/l10n/app_localizations.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _appVersion = '';

  @override
  void initState() {
    super.initState();
    _loadVersion();
  }

  Future<void> _loadVersion() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _appVersion = '${info.version} (${info.buildNumber})';
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = context.watch<SettingsBloc>().state;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SwitchListTile(
            title: Text(l10n.darkTheme),
            value: state.themeMode == ThemeMode.dark,
            onChanged: (val) {
              context.read<SettingsBloc>().add(ChangeTheme(val));
            },
          ),
          ListTile(
            title: Text(l10n.language),
            trailing: DropdownButton<String>(
              value: state.locale.languageCode,
              items: [
                DropdownMenuItem(value: 'en', child: Text(l10n.english)),
                DropdownMenuItem(value: 'ru', child: Text(l10n.russian)),
                DropdownMenuItem(value: 'be', child: Text(l10n.belarusian)),
              ],
              onChanged: (code) {
                if (code != null) {
                  context.read<SettingsBloc>().add(ChangeLanguage(code));
                }
              },
            ),
          ),
          ListTile(
            title: Text(l10n.clearCache),
            trailing: const Icon(Icons.delete_forever),
            onTap: () {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: Text(l10n.clearCacheConfirm),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(context), child: Text(l10n.cancel)),
                    TextButton(onPressed: () {
                      context.read<SettingsBloc>().add(ClearCache());
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.cacheCleared)));
                    }, child: Text(l10n.clear)),
                  ],
                ),
              );
            },
          ),
          ListTile(title: Text(l10n.version), subtitle: Text(_appVersion)),
        ],
      ),
    );
  }
}