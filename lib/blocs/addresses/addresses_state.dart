import 'package:equatable/equatable.dart';

abstract class AddressesState extends Equatable {
  const AddressesState();
  @override
  List<Object?> get props => [];
}

class AddressesInitial extends AddressesState {}

class AddressesLoaded extends AddressesState {
  final List<String> addresses;
  const AddressesLoaded(this.addresses);
  @override
  List<Object?> get props => [addresses];
}