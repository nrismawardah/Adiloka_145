import 'package:equatable/equatable.dart';
import 'package:adiloka/data/models/response/karya_response.dart';

abstract class KaryaState extends Equatable {
  const KaryaState();

  @override
  List<Object?> get props => [];
}

class KaryaInitial extends KaryaState {}

class KaryaUploading extends KaryaState {}

class KaryaLoading extends KaryaState {}

class KaryaLoaded extends KaryaState {
  final List<KaryaModel> karyaList;

  const KaryaLoaded(this.karyaList);

  @override
  List<Object?> get props => [karyaList];
}

class KaryaUploaded extends KaryaState {}

class KaryaError extends KaryaState {
  final String message;

  const KaryaError(this.message);

  @override
  List<Object?> get props => [message];
}
