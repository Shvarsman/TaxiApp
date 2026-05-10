import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'addresses_event.dart';
import 'addresses_state.dart';

class AddressesBloc extends Bloc<AddressesEvent, AddressesState> {
  final Box _box;

  AddressesBloc(this._box) : super(AddressesInitial()) {
    on<LoadAddresses>(_onLoad);
    on<AddAddress>(_onAdd);
    on<DeleteAddress>(_onDelete);
  }

  void _onLoad(LoadAddresses event, Emitter<AddressesState> emit) {
    final addresses = List<String>.from(_box.get('addresses', defaultValue: []) ?? []);
    emit(AddressesLoaded(addresses));
  }

  void _onAdd(AddAddress event, Emitter<AddressesState> emit) {
    if (state is AddressesLoaded) {
      final updated = List<String>.from((state as AddressesLoaded).addresses)
        ..add(event.address);
      _box.put('addresses', updated);
      emit(AddressesLoaded(updated));
    }
  }

  void _onDelete(DeleteAddress event, Emitter<AddressesState> emit) {
    if (state is AddressesLoaded) {
      final updated = List<String>.from((state as AddressesLoaded).addresses)
        ..removeAt(event.index);
      _box.put('addresses', updated);
      emit(AddressesLoaded(updated));
    }
  }
}