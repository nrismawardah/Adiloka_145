import 'dart:io';
import 'package:equatable/equatable.dart';

abstract class KaryaEvent extends Equatable {
  const KaryaEvent();

  @override
  List<Object?> get props => [];
}

class FetchKaryaList extends KaryaEvent {}

class CreateKaryaEvent extends KaryaEvent {
  final String judul;
  final String deskripsi;
  final int kategori;
  final int daerah;
  final File imageFile;
  final double latitude;
  final double longitude;

  const CreateKaryaEvent({
    required this.judul,
    required this.deskripsi,
    required this.kategori,
    required this.daerah,
    required this.imageFile,
    required this.latitude,
    required this.longitude,
  });

  @override
  List<Object?> get props => [
    judul,
    deskripsi,
    kategori,
    daerah,
    imageFile,
    latitude,
    longitude,
  ];
}
