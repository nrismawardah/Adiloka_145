// 📁 lib/presentation/user/home_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:adiloka/logic/blocs/karya/karya_bloc.dart';
import 'package:adiloka/logic/blocs/karya/karya_event.dart';
import 'package:adiloka/logic/blocs/karya/karya_state.dart';
import 'package:adiloka/data/models/response/user_response.dart';
import 'package:adiloka/data/models/response/karya_response.dart';
import 'widgets/karya_card.dart';
import 'widgets/bottom_nav.dart';

class HomePage extends StatefulWidget {
  final UserModel user;
  const HomePage({super.key, required this.user});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final searchController = TextEditingController();
  String query = '';

  @override
  void initState() {
    super.initState();
    context.read<KaryaBloc>().add(FetchKaryaList());
  }

  List<KaryaModel> _filteredAndSorted(List<KaryaModel> list) {
    final filtered = list.where((karya) {
      final q = query.toLowerCase();
      return karya.judul.toLowerCase().contains(q) ||
          karya.deskripsi.toLowerCase().contains(q);
    }).toList();

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF7F2),
      appBar: AppBar(
        backgroundColor: const Color(0xFF301f17),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 0),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const CircleAvatar(
                    backgroundImage: AssetImage(
                      'assets/images/ava_default.jpg',
                    ),
                    radius: 24,
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Halo, ${widget.user.nama}!',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        'Selamat datang kembali.',
                        style: TextStyle(fontSize: 14, color: Colors.black87),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Center(
                child: SizedBox(
                  width: 350,
                  child: TextField(
                    controller: searchController,
                    onChanged: (value) {
                      setState(() {
                        query = value;
                      });
                    },
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      hintText: 'Apa karya yang kamu cari?',
                      prefixIcon: const Icon(Icons.search),
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 0,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: const BorderSide(color: Color(0xff8f664a)),
                      ),
                      prefixIconConstraints: const BoxConstraints(
                        minWidth: 36,
                        minHeight: 36,
                        maxWidth: 40,
                        maxHeight: 40,
                      ),
                      suffixIcon: Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Icon(Icons.clear),
                      ),
                      suffixIconConstraints: const BoxConstraints(
                        minWidth: 24,
                        minHeight: 24,
                        maxWidth: 32,
                        maxHeight: 32,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: BlocBuilder<KaryaBloc, KaryaState>(
                  builder: (context, state) {
                    if (state is KaryaLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is KaryaLoaded) {
                      final filteredList = _filteredAndSorted(state.karyaList);
                      if (filteredList.isEmpty) {
                        return const Center(
                          child: Text('Tidak ada karya ditemukan'),
                        );
                      }
                      return ListView.builder(
                        itemCount: filteredList.length,
                        itemBuilder: (context, index) {
                          final karya = filteredList[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: KaryaCard(
                              idKarya: karya.idKarya,
                              nama: karya.nama,
                              judul: karya.judul,
                              deskripsi: karya.deskripsi,
                              gambar: karya.gambarUrl,
                              achievement: karya.achievement ?? '',
                              kategori: karya.kategori,
                              daerah: karya.daerah,
                              lokasi: karya.lokasi ?? '',
                            ),
                          );
                        },
                      );
                    } else if (state is KaryaError) {
                      return Center(child: Text(state.message));
                    } else {
                      return const SizedBox();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
