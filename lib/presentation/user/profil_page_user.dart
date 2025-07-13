import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilUserPage extends StatefulWidget {
  const ProfilUserPage({super.key});

  @override
  State<ProfilUserPage> createState() => _ProfilUserPageState();
}

class _ProfilUserPageState extends State<ProfilUserPage> {
  String nama = '';
  String email = '';
  int totalKarya = 0;
  int totalApresiasi = 0;
  List<dynamic> achievements = [];
  List<dynamic> karyaSaya = [];

  @override
  void initState() {
    super.initState();
    fetchProfileData();
  }

  Future<void> fetchProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    print("TOKEN: $token");
    if (token == null) return;
    final headers = {'Authorization': 'Bearer $token'};

    try {
      // 1. Ambil profil user
      final userRes = await http.get(
        Uri.parse('http://10.0.2.2:5000/api/user/profile'),
        headers: headers,
      );
      final userData = jsonDecode(userRes.body);
      setState(() {
        nama = userData['nama'];
        email = userData['email'];
      });

      // 2. Ambil statistik
      final statRes = await http.get(
        Uri.parse('http://10.0.2.2:5000/api/user/statistik'),
        headers: headers,
      );
      final statData = jsonDecode(statRes.body);
      setState(() {
        totalKarya = statData['total_karya_disetujui'];
        totalApresiasi = statData['total_apresiasi'];
      });

      // 3. Ambil achievement
      final achRes = await http.get(
        Uri.parse('http://10.0.2.2:5000/api/achievement'),
        headers: headers,
      );
      final achData = jsonDecode(achRes.body);
      setState(() {
        achievements = achData;
      });

      // 4. Ambil karya saya
      final karyaRes = await http.get(
        Uri.parse('http://10.0.2.2:5000/api/karya/user'),
        headers: headers,
      );
      final karyaData = jsonDecode(karyaRes.body);
      setState(() {
        karyaSaya = karyaData;
      });
    } catch (e) {
      print('Gagal ambil data profil: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profil Saya')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Profil
            Row(
              children: [
                const CircleAvatar(
                  radius: 36,
                  backgroundImage: AssetImage('assets/images/ava_default.jpg'),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        nama,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        email,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color.fromARGB(255, 0, 0, 0),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    Navigator.pushNamed(context, '/edit-profil');
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Achievement & Statistik
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Text(
                      'Achievement',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      children: achievements
                          .map((a) => Chip(label: Text(a['nama'])))
                          .toList(),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            Text('$totalKarya'),
                            const Text('Karya Disetujui'),
                          ],
                        ),
                        Column(
                          children: [
                            Text('$totalApresiasi'),
                            const Text('Total Apresiasi'),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Karya Saya
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Karya Saya',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            ...karyaSaya.map((karya) {
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  title: Text(karya['judul']),
                  subtitle: Text('Status: ${karya['status']}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            '/edit-karya',
                            arguments: karya,
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          // TODO: Hapus karya
                        },
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
