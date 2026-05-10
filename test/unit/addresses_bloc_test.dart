import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:taxi_app/blocs/addresses/addresses_bloc.dart';
import 'package:taxi_app/blocs/addresses/addresses_event.dart';
import 'package:taxi_app/blocs/addresses/addresses_state.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() {
  late Box box;
  late AddressesBloc bloc;

  setUp(() async {
    // Создаём временный Hive Box для теста
    Hive.init('test_temp');
    box = await Hive.openBox('test_addresses');
    bloc = AddressesBloc(box);
  });

  tearDown(() async {
    await box.clear();
    await box.close();
    await bloc.close();
  });

  blocTest<AddressesBloc, AddressesState>(
    'load addresses from empty box',
    build: () => bloc,
    act: (bloc) => bloc.add(LoadAddresses()),
    expect: () => [const AddressesLoaded([])],
  );

  blocTest<AddressesBloc, AddressesState>(
    'add address and load',
    build: () => bloc,
    act: (bloc) {
      bloc.add(const AddAddress('Минск'));
      bloc.add(LoadAddresses());
    },
    expect: () => [
      const AddressesLoaded(['Минск']),
    ],
  );

  blocTest<AddressesBloc, AddressesState>(
    'delete address',
    seed: () => const AddressesLoaded(['Минск', 'Брест']),
    build: () => bloc,
    act: (bloc) {
      bloc.add(const DeleteAddress(0));
      bloc.add(LoadAddresses());
    },
    expect: () => [
      const AddressesLoaded(['Брест']),
    ],
  );
}