import 'package:equatable/equatable.dart';

abstract class AddressesEvent extends Equatable {
  const AddressesEvent();
  @override
  List<Object?> get props => [];
}

class LoadAddresses extends AddressesEvent {}

class AddAddress extends AddressesEvent {
  final String address;
  const AddAddress(this.address);
  @override
  List<Object?> get props => [address];
}

class DeleteAddress extends AddressesEvent {
  final int index;
  const DeleteAddress(this.index);
  @override
  List<Object?> get props => [index];
}