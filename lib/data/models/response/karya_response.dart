class KaryaModel {
  final int idKarya;
  final String judul;
  final String deskripsi;
  final String mimeType;
  final String kategori;
  final String daerah;
  final int idUser;
  final String nama;
  final String? achievement;
  final String? lokasi;

  KaryaModel({
    required this.idKarya,
    required this.judul,
    required this.deskripsi,
    required this.mimeType,
    required this.idUser,
    required this.nama,
    required this.kategori,
    required this.daerah,
    this.lokasi,
    this.achievement,
  });

  factory KaryaModel.fromJson(Map<String, dynamic> json) {
    return KaryaModel(
      idKarya: json['id_karya'],
      judul: json['judul'],
      deskripsi: json['deskripsi'],
      mimeType: json['mime_type'],
      idUser: json['id_user'],
      nama: json['nama'],
      kategori: json['kategori'],
      daerah: json['daerah'],
      lokasi: json['lokasi'],
      achievement: json['achievement'],
    );
  }

  String get gambarUrl => 'http://10.0.2.2:5000/api/karya/$idKarya';
}
