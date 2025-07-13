import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:adiloka/logic/blocs/karya/karya_event.dart';
import 'package:adiloka/logic/blocs/karya/karya_state.dart';
import 'package:adiloka/data/repository/karya_repository.dart';

class KaryaBloc extends Bloc<KaryaEvent, KaryaState> {
  final KaryaRepository repository;

  KaryaBloc({required this.repository}) : super(KaryaInitial()) {
    on<FetchKaryaList>(_onFetchKaryaList);
  }

  Future<void> _onFetchKaryaList(
    FetchKaryaList event,
    Emitter<KaryaState> emit,
  ) async {
    emit(KaryaLoading());
    try {
      final karyaList = await repository.fetchKaryaList();
      emit(KaryaLoaded(karyaList));
    } catch (e) {
      emit(KaryaError('Gagal memuat karya: ${e.toString()}'));
    }
  }
}
