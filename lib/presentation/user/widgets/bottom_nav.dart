import 'package:adiloka/presentation/user/profil_page_user.dart';
import 'package:adiloka/presentation/user/tambah_karya_page.dart';
import 'package:adiloka/presentation/user/profil_page_user.dart'; // <- pastikan ini di-import
import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  const BottomNavBar({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: const Color(0xFF5C4033),
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
        BottomNavigationBarItem(icon: Icon(Icons.category), label: 'Kategori'),
        BottomNavigationBarItem(
          icon: Icon(Icons.add_box_rounded),
          label: 'Karya',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.bookmark), label: 'Bookmark'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
      ],
      onTap: (index) {
        if (index == 2) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const TambahKaryaPage()),
          );
        } else if (index == 4) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ProfilUserPage()),
          );
        }
        // Tambahkan navigasi lainnya sesuai kebutuhan
      },
    );
  }
}
