import 'package:adiloka/data/models/response/karya_response.dart';
import 'package:adiloka/presentation/user/detail_karya_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class KaryaCard extends StatefulWidget {
  final int idKarya;
  final String nama;
  final String judul;
  final String deskripsi;
  final String gambar;
  final String achievement;
  final String kategori;
  final String daerah;
  final String lokasi;

  const KaryaCard({
    super.key,
    required this.idKarya,
    required this.nama,
    required this.judul,
    required this.deskripsi,
    required this.gambar,
    required this.achievement,
    required this.kategori,
    required this.daerah,
    required this.lokasi,
  });

  @override
  State<KaryaCard> createState() => _KaryaCardState();
}

class _KaryaCardState extends State<KaryaCard> {
  Map<String, int> apresiasi = {'👍': 0, '❤️': 0};

  Set<String> emojiUserSudahBerikan = {};

  @override
  void initState() {
    super.initState();
    fetchApresiasi();
    fetchUserApresiasi();
  }

  Future<void> fetchApresiasi() async {
    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:5000/api/apresiasi/${widget.idKarya}'),
      );

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        setState(() {
          apresiasi = {'👍': 0, '❤️': 0};

          for (var item in data) {
            final emoji = item['emoji'];
            final total = item['total'];
            if (apresiasi.containsKey(emoji)) {
              apresiasi[emoji] = total;
            }
          }
        });
      }
    } catch (e) {
      print('Error fetchApresiasi: $e');
    }
  }

  Future<void> fetchUserApresiasi() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('http://10.0.2.2:5000/api/apresiasi/check/${widget.idKarya}'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      setState(() {
        emojiUserSudahBerikan = Set<String>.from(data);
      });
    } else {
      print('Gagal ambil apresiasi user');
    }
  }

  Future<void> giveApresiasi(String emoji) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Token tidak ditemukan. Silakan login kembali.'),
        ),
      );
      return;
    }

    print('Sending emoji: $emoji');
    final response = await http.post(
      Uri.parse('http://10.0.2.2:5000/api/apresiasi/${widget.idKarya}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'emoji': emoji}),
    );
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      await fetchApresiasi();
      await fetchUserApresiasi();
    } else {
      final body = jsonDecode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memberi apresiasi: ${body['message']}')),
      );
    }
  }

  Future<void> deleteApresiasi(String emoji) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.delete(
      Uri.parse('http://10.0.2.2:5000/api/apresiasi/${widget.idKarya}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'emoji': emoji}),
    );

    if (response.statusCode == 200) {
      await fetchApresiasi();
      await fetchUserApresiasi();
    } else {
      final body = jsonDecode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal membatalkan apresiasi: ${body['message']}'),
        ),
      );
    }
  }

  void handleEmojiTap(String emoji) async {
    if (emojiUserSudahBerikan.contains(emoji)) {
      await deleteApresiasi(emoji);
    } else if (emojiUserSudahBerikan.isNotEmpty) {
      final oldEmoji = emojiUserSudahBerikan.first;
      await deleteApresiasi(oldEmoji);
      await giveApresiasi(emoji);
    } else {
      await giveApresiasi(emoji);
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<String> emojis = ['👍', '❤️'];
    return GestureDetector(
      onTap: () {
        print("Lokasi yang dikirim dari KaryaCard: ${widget.lokasi}");

        final karya = KaryaModel(
          idKarya: widget.idKarya,
          judul: widget.judul,
          deskripsi: widget.deskripsi,
          mimeType: '', // bisa diisi kalau tersedia
          kategori: widget.kategori,
          daerah: widget.daerah,
          idUser: 0, // isi jika tahu ID user
          nama: widget.nama,
          achievement: widget.achievement,
          lokasi: widget.lokasi, // bisa diset jika ada lokasi
        );

        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => DetailKaryaPage(karya: karya)),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
        color: const Color(0xFFFf5e2cd),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const CircleAvatar(
                    radius: 18,
                    backgroundImage: AssetImage(
                      'assets/images/ava_default.jpg',
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.nama,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        if (widget.achievement.isNotEmpty)
                          Text(
                            widget.achievement,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.brown,
                            ),
                          ),
                      ],
                    ),
                  ),
                  const Icon(Icons.report),
                ],
              ),
              Divider(
                color: Colors.brown.withOpacity(0.5),
                thickness: 1,
                height: 24,
              ),
              Text(
                widget.judul,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                widget.deskripsi,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  widget.gambar,
                  fit: BoxFit.cover,
                  height: 200,
                  width: double.infinity,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                '${widget.kategori} • ${widget.daerah}',
                style: const TextStyle(fontSize: 13, color: Colors.brown),
              ),
              const SizedBox(height: 12),
              Row(
                children: emojis.map((emoji) {
                  final count = apresiasi[emoji] ?? 0;

                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: GestureDetector(
                      onTap: () {
                        print("Clicked emoji: $emoji");
                        handleEmojiTap(emoji);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: emojiUserSudahBerikan.contains(emoji)
                              ? Colors.brown.withOpacity(0.2)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: emojiUserSudahBerikan.contains(emoji)
                                ? Colors.brown
                                : Colors.transparent,
                          ),
                        ),
                        child: Row(
                          children: [
                            Text(emoji, style: const TextStyle(fontSize: 16)),
                            const SizedBox(width: 4),
                            Text(
                              '$count',
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
