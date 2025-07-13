import 'package:equatable/equatable.dart';

abstract class KaryaEvent extends Equatable {
  const KaryaEvent();

  @override
  List<Object?> get props => [];
}

class FetchKaryaList extends KaryaEvent {}
