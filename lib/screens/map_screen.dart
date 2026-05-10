import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:taxi_app/blocs/booking/booking_bloc.dart';
import 'package:taxi_app/blocs/booking/booking_event.dart';
import 'package:taxi_app/l10n/app_localizations.dart';
import 'package:taxi_app/services/map_service.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapService _mapService = MapService();
  LatLng _driverPosition = const LatLng(53.9045, 27.5615);

  @override
  void initState() {
    super.initState();
    _mapService.simulateDriverMovement().listen((pos) {
      setState(() {
        _driverPosition = pos;
      });
    });
  }

  void _completeRide() {
    final outerContext = context; // сохраняем внешний контекст
    showDialog(
      context: outerContext,
      builder: (dialogCtx) {
        int rating = 5;
        return StatefulBuilder(
          builder: (builderCtx, setDialogState) {
            return AlertDialog(
              title: Text(AppLocalizations.of(builderCtx)!.rateRide),
              content: Slider(
                value: rating.toDouble(),
                min: 1,
                max: 5,
                divisions: 4,
                label: rating.toString(),
                onChanged: (val) => setDialogState(() => rating = val.round()),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    outerContext.read<BookingBloc>().add(SetRating(rating));
                    outerContext.read<BookingBloc>().add(FinishRide());
                    Navigator.pop(dialogCtx);               // закрываем диалог
                    outerContext.go('/home');               // переходим на главный экран с оболочкой
                  },
                  child: Text(AppLocalizations.of(builderCtx)!.submit),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.trackRide)),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _mapService.endPoint,
              zoom: 14,
            ),
            markers: {
              Marker(
                markerId: const MarkerId('driver'),
                position: _driverPosition,
                icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
              ),
              Marker(
                markerId: const MarkerId('destination'),
                position: _mapService.endPoint,
                icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
              ),
            },
          ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: ElevatedButton(
              onPressed: _completeRide,
              child: Text(l10n.finishRide),
            ),
          ),
        ],
      ),
    );
  }
}