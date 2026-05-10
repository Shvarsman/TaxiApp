import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:taxi_app/blocs/booking/booking_bloc.dart';
import 'package:taxi_app/blocs/booking/booking_event.dart';
import 'package:taxi_app/blocs/booking/booking_state.dart';
import 'package:taxi_app/l10n/app_localizations.dart';
import 'package:taxi_app/widgets/tariff_card.dart';
import 'package:taxi_app/widgets/weather_banner.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final _fromController = TextEditingController(text: 'Минск, ул. Ленина');
  final _toController = TextEditingController(text: 'Минск, пр. Независимости');

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isWide = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.orderTaxi)),
      body: BlocConsumer<BookingBloc, BookingState>(
        listener: (context, state) {
          if (state.status == BookingStatus.found) {
            context.go('/map');
          }
          if (state.error != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error!)),
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: isWide ? 100 : 16, vertical: 16),
            child: isWide
                ? Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Expanded(child: _buildForm(context, state)),
              const SizedBox(width: 24),
              Expanded(child: _buildWeatherAndSubmit(context, state)),
            ])
                : Column(children: [
              _buildForm(context, state),
              const SizedBox(height: 24),
              _buildWeatherAndSubmit(context, state),
            ]),
          );
        },
      ),
    );
  }

  // Методы _buildForm и _buildWeatherAndSubmit остаются теми же, что и ранее
  Widget _buildForm(BuildContext context, BookingState state) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(l10n.from),
        TextField(controller: _fromController),
        const SizedBox(height: 10),
        Text(l10n.to),
        TextField(controller: _toController),
        const SizedBox(height: 20),
        Text(l10n.selectTariff, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 10),
        Row(children: [
          TariffCard(title: l10n.economy, price: '10', isSelected: state.tariff == 'economy', onTap: () => context.read<BookingBloc>().add(const SelectTariff('economy'))),
          TariffCard(title: l10n.comfort, price: '20', isSelected: state.tariff == 'comfort', onTap: () => context.read<BookingBloc>().add(const SelectTariff('comfort'))),
          TariffCard(title: l10n.business, price: '35', isSelected: state.tariff == 'business', onTap: () => context.read<BookingBloc>().add(const SelectTariff('business'))),
        ]),
      ],
    );
  }

  Widget _buildWeatherAndSubmit(BuildContext context, BookingState state) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (state.weather != null) WeatherBanner(weather: state.weather!),
        if (state.status == BookingStatus.searching)
          const Padding(padding: EdgeInsets.only(top: 10), child: Center(child: CircularProgressIndicator())),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: state.tariff != null && _fromController.text.isNotEmpty && _toController.text.isNotEmpty && state.status != BookingStatus.searching
              ? () => context.read<BookingBloc>().add(SubmitOrder(from: _fromController.text, to: _toController.text))
              : null,
          child: Text(l10n.order),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _fromController.dispose();
    _toController.dispose();
    super.dispose();
  }
}