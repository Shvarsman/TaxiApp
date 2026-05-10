import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taxi_app/blocs/addresses/addresses_bloc.dart';
import 'package:taxi_app/blocs/addresses/addresses_event.dart';
import 'package:taxi_app/blocs/addresses/addresses_state.dart';
import 'package:taxi_app/l10n/app_localizations.dart';

class AddressesScreen extends StatefulWidget {
  const AddressesScreen({super.key});

  @override
  State<AddressesScreen> createState() => _AddressesScreenState();
}

class _AddressesScreenState extends State<AddressesScreen> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<AddressesBloc>().add(LoadAddresses());
  }

  void _addAddress() {
    final address = _controller.text.trim();
    if (address.isNotEmpty) {
      context.read<AddressesBloc>().add(AddAddress(address));
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isWide = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.savedAddresses)),
      body: Padding(
        padding: EdgeInsets.all(isWide ? 32 : 16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      labelText: l10n.newAddress,
                      border: const OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _addAddress(),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _addAddress,
                  child: Text(l10n.add),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: BlocBuilder<AddressesBloc, AddressesState>(
                builder: (context, state) {
                  if (state is AddressesLoaded) {
                    if (state.addresses.isEmpty) {
                      return Center(child: Text(l10n.noAddresses));
                    }
                    return ListView.builder(
                      itemCount: state.addresses.length,
                      itemBuilder: (context, index) {
                        final address = state.addresses[index];
                        return Dismissible(
                          key: ValueKey(address),
                          direction: DismissDirection.endToStart,
                          background: Container(color: Colors.red, alignment: Alignment.centerRight, padding: const EdgeInsets.only(right: 20), child: const Icon(Icons.delete, color: Colors.white)),
                          onDismissed: (_) {
                            context.read<AddressesBloc>().add(DeleteAddress(index));
                          },
                          child: ListTile(
                            leading: const Icon(Icons.location_on),
                            title: Text(address),
                          ),
                        );
                      },
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}