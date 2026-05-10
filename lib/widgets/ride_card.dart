import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:taxi_app/models/ride.dart';

import '../screens/ride_detail_screen.dart';

class RideCard extends StatelessWidget {
  final Ride ride;
  const RideCard({super.key, required this.ride});

  @override
  Widget build(BuildContext context) {
    return OpenContainer(
      closedElevation: 1,
      closedBuilder: (context, open) => Card(
        child: InkWell(
          onTap: open,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('${ride.fromLocation} → ${ride.toLocation}',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                Text('${ride.tariff} - \$${ride.price}'),
                if (ride.rating != null)
                  Row(children: List.generate(ride.rating!, (_) => const Icon(Icons.star, size: 16))),
              ],
            ),
          ),
        ),
      ),
      openBuilder: (context, close) => RideDetailScreen(rideId: ride.id!),
    );
  }
}