import 'dart:io';

import 'package:adiloka/logic/blocs/karya/karya_bloc.dart';
import 'package:adiloka/logic/blocs/karya/karya_event.dart';
import 'package:adiloka/logic/blocs/karya/karya_state.dart';
import 'package:adiloka/presentation/user/widgets/location_picker_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';

class TambahKaryaPage extends StatefulWidget {
  const TambahKaryaPage({super.key});

  @override
  State<TambahKaryaPage> createState() => _TambahKaryaPageState();
}

class _TambahKaryaPageState extends State<TambahKaryaPage> {
  final _judulController = TextEditingController();
  final _deskripsiController = TextEditingController();
  int? _selectedKategori;
  int? _selectedDaerah;
  File? _imageFile;
  LatLng? _selectedLocation;

  final _kategoriList = [
    {'id': 1, 'nama': 'Tari'},
    {'id': 2, 'nama': 'Musik'},
    {'id': 3, 'nama': 'Kerajinan'},
  ];

  final _daerahList = [
    {'id': 1, 'nama': 'Bali'},
    {'id': 2, 'nama': 'Sumatera Barat'},
    {'id': 3, 'nama': 'Papua'},
  ];

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    showModalBottomSheet(
      context: context,
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text('Ambil dari Kamera'),
            onTap: () async {
              final picked = await _picker.pickImage(
                source: ImageSource.camera,
              );
              if (picked != null) {
                setState(() {
                  _imageFile = File(picked.path);
                });
              }
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.image),
            title: const Text('Pilih dari Galeri'),
            onTap: () async {
              final picked = await _picker.pickImage(
                source: ImageSource.gallery,
              );
              if (picked != null) {
                setState(() {
                  _imageFile = File(picked.path);
                });
              }
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Future<void> _pilihLokasi() async {
    final picked = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LocationPickerPage()),
    );

    if (picked != null && picked is LatLng) {
      setState(() {
        _selectedLocation = picked;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Lokasi berhasil dipilih')));
    }
  }

  void _submit() {
    if (_judulController.text.isEmpty ||
        _deskripsiController.text.isEmpty ||
        _selectedKategori == null ||
        _selectedDaerah == null ||
        _imageFile == null ||
        _selectedLocation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lengkapi semua data terlebih dahulu')),
      );
      return;
    }

    context.read<KaryaBloc>().add(
      CreateKaryaEvent(
        judul: _judulController.text,
        deskripsi: _deskripsiController.text,
        kategori: _selectedKategori!,
        daerah: _selectedDaerah!,
        imageFile: _imageFile!,
        latitude: _selectedLocation!.latitude,
        longitude: _selectedLocation!.longitude,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF7F2),
      appBar: AppBar(
        backgroundColor: const Color(0xFF301f17),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.notifications, color: Colors.white),
          ),
        ],
      ),
      body: BlocListener<KaryaBloc, KaryaState>(
        listener: (context, state) {
          if (state is KaryaUploading) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => const Center(child: CircularProgressIndicator()),
            );
          } else if (state is KaryaError) {
            Navigator.pop(context); // close loading dialog
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          } else if (state is KaryaUploaded) {
            Navigator.pop(context); // close loading dialog
            Navigator.pop(context); // back to home
            context.read<KaryaBloc>().add(FetchKaryaList());

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Karya berhasil diunggah')),
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Tambah Karya',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.brown,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Unggah karya tradisionalmu dan jadi bagian dari pelestarian budaya Indonesia',
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 16),

              TextField(
                controller: _judulController,
                decoration: const InputDecoration(
                  hintText: 'Masukkan judul karya',
                  prefixIcon: Icon(Icons.title),
                  filled: true,
                  fillColor: Color(0xFFFFEED9),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              TextField(
                controller: _deskripsiController,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'Masukkan deskripsi karya',
                  prefixIcon: Icon(Icons.description),
                  filled: true,
                  fillColor: Color(0xFFFFEED9),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<int>(
                      isExpanded: true,
                      value: _selectedKategori,
                      onChanged: (value) =>
                          setState(() => _selectedKategori = value),
                      items: _kategoriList
                          .map(
                            (item) => DropdownMenuItem<int>(
                              value: item['id'] as int,
                              child: Text(item['nama'] as String),
                            ),
                          )
                          .toList(),
                      decoration: const InputDecoration(
                        hintText: 'Pilih kategori karya',
                        filled: true,
                        fillColor: Color(0xFFFFEED9),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: DropdownButtonFormField<int>(
                      isExpanded: true,
                      value: _selectedDaerah,
                      onChanged: (value) =>
                          setState(() => _selectedDaerah = value),
                      items: _daerahList
                          .map(
                            (item) => DropdownMenuItem<int>(
                              value: item['id'] as int,
                              child: Text(item['nama'] as String),
                            ),
                          )
                          .toList(),
                      decoration: const InputDecoration(
                        hintText: 'Pilih daerah karya',
                        filled: true,
                        fillColor: Color(0xFFFFEED9),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_imageFile != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        _imageFile!,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    )
                  else
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.image, size: 40),
                    ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _pickImage,
                      icon: const Icon(Icons.upload_file),
                      label: const Text('Upload gambar'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.brown,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _pilihLokasi,
                icon: const Icon(Icons.location_on),
                label: Text(
                  _selectedLocation == null
                      ? 'Pilih Lokasi'
                      : 'Lokasi: ${_selectedLocation!.latitude.toStringAsFixed(4)}, ${_selectedLocation!.longitude.toStringAsFixed(4)}',
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown,
                  foregroundColor: Colors.white,
                ),
              ),

              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: const Center(child: Text('Upload')),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown.shade300,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: const Center(child: Text('Batal')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
