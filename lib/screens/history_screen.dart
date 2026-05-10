import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:taxi_app/blocs/history/history_bloc.dart';
import 'package:taxi_app/blocs/history/history_event.dart';
import 'package:taxi_app/blocs/history/history_state.dart';
import 'package:taxi_app/l10n/app_localizations.dart';
import 'package:taxi_app/models/ride.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.history)),
      body: BlocBuilder<HistoryBloc, HistoryState>(
        builder: (context, state) {
          if (state is HistoryLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is HistoryLoaded) {
            final rides = state.rides;
            if (rides.isEmpty) {
              return Center(child: Text(l10n.noHistory));
            }
            return ListView.builder(
              itemCount: rides.length,
              itemBuilder: (_, idx) {
                final ride = rides[idx];
                return Dismissible(
                  key: ValueKey(ride.id),
                  direction: DismissDirection.endToStart,
                  background: Container(color: Colors.red, alignment: Alignment.centerRight, padding: const EdgeInsets.only(right: 20), child: const Icon(Icons.delete, color: Colors.white)),
                  confirmDismiss: (_) async {
                    return await showDialog<bool>(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text('Удалить поездку?'),
                        actions: [
                          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Отмена')),
                          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Удалить')),
                        ],
                      ),
                    );
                  },
                  onDismissed: (_) {
                    context.read<HistoryBloc>().add(DeleteRide(ride.id!));
                  },
                  child: Card(
                    child: ListTile(
                      title: Text('${ride.fromLocation} → ${ride.toLocation}'),
                      subtitle: Text('${ride.tariff} - \$${ride.price}'),
                      trailing: ride.rating != null
                          ? Row(mainAxisSize: MainAxisSize.min, children: List.generate(ride.rating!, (_) => const Icon(Icons.star, size: 16)))
                          : null,
                      onTap: () => context.go('/ride/${ride.id}'),
                    ),
                  ),
                );
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}