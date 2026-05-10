import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taxi_app/blocs/history/history_bloc.dart';
import 'package:taxi_app/blocs/history/history_event.dart';
import 'package:taxi_app/blocs/history/history_state.dart';
import 'package:taxi_app/l10n/app_localizations.dart';
import 'package:taxi_app/models/ride.dart';
import 'package:taxi_app/widgets/ride_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Загружаем историю, если она ещё не загружена
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.read<HistoryBloc>().state is HistoryInitial) {
        context.read<HistoryBloc>().add(LoadHistory());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.recentRides)),
      body: BlocBuilder<HistoryBloc, HistoryState>(
        builder: (context, state) {
          if (state is HistoryInitial || state is HistoryLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is HistoryError) {
            return Center(child: Text(l10n.error));
          }
          final rides = (state is HistoryLoaded) ? state.rides : <Ride>[];
          if (rides.isEmpty) {
            return Center(child: Text(l10n.noHistory));
          }
          return ListView.builder(
            itemCount: rides.length,
            itemBuilder: (_, i) => RideCard(ride: rides[i]),
          );
        },
      ),
    );
  }
}