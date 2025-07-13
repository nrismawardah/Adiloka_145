import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:adiloka/data/models/response/karya_response.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class DetailKaryaPage extends StatefulWidget {
  final KaryaModel karya;

  const DetailKaryaPage({super.key, required this.karya});

  @override
  State<DetailKaryaPage> createState() => _DetailKaryaPageState();
}

class _DetailKaryaPageState extends State<DetailKaryaPage> {
  Set<String> emojiUserSudahBerikan = {};
  Map<String, int> apresiasi = {'👍': 0, '❤️': 0};
  final List<String> emojis = ['👍', '❤️'];

  @override
  void initState() {
    super.initState();

    print("Lokasi diterima di DetailKaryaPage: ${widget.karya.lokasi}");

    fetchApresiasi();
    fetchUserApresiasi();

    // Debug lokasi
    print("Diterima di DetailKaryaPage, lokasi: ${widget.karya.lokasi}");
  }

  Future<void> fetchApresiasi() async {
    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:5000/api/apresiasi/${widget.karya.idKarya}'),
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
      Uri.parse(
        'http://10.0.2.2:5000/api/apresiasi/check/${widget.karya.idKarya}',
      ),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      setState(() {
        emojiUserSudahBerikan = Set<String>.from(data);
      });
    }
  }

  Future<void> giveApresiasi(String emoji) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.post(
      Uri.parse('http://10.0.2.2:5000/api/apresiasi/${widget.karya.idKarya}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'emoji': emoji}),
    );

    if (response.statusCode == 200) {
      await fetchApresiasi();
      await fetchUserApresiasi();
    }
  }

  void handleEmojiTap(String emoji) async {
    await giveApresiasi(emoji);
  }

  void openGoogleMaps() {
    final rawLokasi = widget.karya.lokasi;
    print("Lokasi mentah: $rawLokasi");

    if (rawLokasi == null || rawLokasi.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lokasi karya tidak tersedia')),
      );
      return;
    }

    final parts = rawLokasi.split(',');
    if (parts.length == 2) {
      final lat = double.tryParse(parts[0].trim());
      final lng = double.tryParse(parts[1].trim());

      if (lat != null && lng != null) {
        final url = 'https://www.google.com/maps/search/?api=1&query=$lat,$lng';
        launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Format koordinat tidak valid')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Format lokasi tidak valid')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF7F2),
      appBar: AppBar(
        backgroundColor: const Color(0xFF301f17),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.notifications_none, color: Colors.white),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (widget.karya.gambarUrl.isNotEmpty)
              Image.network(
                widget.karya.gambarUrl,
                width: double.infinity,
                height: 220,
                fit: BoxFit.cover,
              ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.karya.judul,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Chip(
                        label: Text(widget.karya.kategori),
                        backgroundColor: Colors.brown.shade100,
                      ),
                      const SizedBox(width: 8),
                      Chip(
                        label: Text(widget.karya.daerah),
                        backgroundColor: Colors.orange.shade100,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (widget.karya.achievement != null &&
                      widget.karya.achievement!.isNotEmpty)
                    Row(
                      children: [
                        const Icon(Icons.emoji_events, color: Colors.amber),
                        const SizedBox(width: 6),
                        Text(
                          widget.karya.achievement!,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 16),
                  const Text(
                    'Deskripsi:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(widget.karya.deskripsi),
                  const SizedBox(height: 24),
                  const Text(
                    'Berikan Apresiasi:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: emojis.map((emoji) {
                      final count = apresiasi[emoji] ?? 0;
                      return Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: GestureDetector(
                          onTap: () => handleEmojiTap(emoji),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.brown.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.brown),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  emoji,
                                  style: const TextStyle(fontSize: 16),
                                ),
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
                  const SizedBox(height: 24),
                  const Text(
                    'Lihat Lokasi:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    onPressed: openGoogleMaps,
                    icon: const Icon(Icons.map),
                    label: const Text('Buka di Google Maps'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.brown,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
