import 'package:adiloka/data/repository/karya_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:adiloka/logic/blocs/karya/karya_event.dart';
import 'package:adiloka/logic/blocs/karya/karya_state.dart';

class KaryaBloc extends Bloc<KaryaEvent, KaryaState> {
  final KaryaRepository repository;

  KaryaBloc({required this.repository}) : super(KaryaInitial()) {
    on<FetchKaryaList>(_onFetchKaryaList);
    on<CreateKaryaEvent>(_onCreateKarya);
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

  Future<void> _onCreateKarya(
    CreateKaryaEvent event,
    Emitter<KaryaState> emit,
  ) async {
    emit(KaryaUploading());
    try {
      await repository.createKarya(
        judul: event.judul,
        deskripsi: event.deskripsi,
        kategoriId: event.kategori,
        daerahId: event.daerah,
        filePath: event.imageFile.path,
        latitude: event.latitude,
        longitude: event.longitude,
      );
      emit(KaryaUploaded());
    } catch (e) {
      emit(KaryaError('Gagal mengunggah karya: ${e.toString()}'));
    }
  }
}
