import 'package:flutter/material.dart';
import 'package:hyper_ui/core.dart';
import 'package:hyper_ui/model/user_data.dart';
import '../controller/aktivitas_detail_dosen_controller.dart';

class AktivitasDetailDosenView extends StatefulWidget {
  final ActivityData2 kegiatan;

  const AktivitasDetailDosenView({super.key, required this.kegiatan});

  Widget build(context, AktivitasDetailDosenController controller) {
    controller.view = this;
    int? kegiatan_id = kegiatan.kegiatanId;
    return Scaffold(
        appBar: AppBar(
          title: const Text("Aktivitas Detail"),
          automaticallyImplyLeading: false,
          actions: const [],
        ),
        body: FutureBuilder<List<Map<String, dynamic>>>(
            future: controller.fetchDosenKegiatan(kegiatan_id!),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(
                    child: Text('Tidak ada dosen yang terdaftar'));
              }

              final dosenList = snapshot.data!;

              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 50.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start, // Teks rata kiri
                              children: [
                                Text(
                                  kegiatan.kegiatanNama ?? "kosong",
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Tanggal: ${kegiatan.tanggal_mulai} - ${kegiatan.tanggalSelesai}',
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12.0, vertical: 8.0),
                            decoration: BoxDecoration(
                              color:
                                  _getStatusColor(kegiatan.status ?? "kosong"),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                kegiatan.status ?? "kosong",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Info Kegiatan",
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Periode:',
                                style: TextStyle(fontSize: 18),
                              ),
                              Text(
                                kegiatan.periode ?? '',
                                style: TextStyle(fontSize: 18),
                              ),
                            ],
                          ),
                          const SizedBox(height: 3),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Kategori:',
                                style: TextStyle(fontSize: 18),
                              ),
                              Text(
                                kegiatan.kategoriNama ?? '',
                                style: TextStyle(fontSize: 18),
                              ),
                            ],
                          ),
                          const SizedBox(height: 3),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Skala:',
                                style: TextStyle(fontSize: 18),
                              ),
                              Text(
                                kegiatan.skala ?? '',
                                style: TextStyle(fontSize: 18),
                              ),
                            ],
                          ),
                          const SizedBox(height: 3),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Tanggal:',
                                style: TextStyle(fontSize: 18),
                              ),
                              Text(
                                '${kegiatan.tanggal_mulai} - ${kegiatan.tanggalSelesai}',
                                style: TextStyle(fontSize: 18),
                              ),
                            ],
                          ),
                          const SizedBox(height: 3),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Anggaran:',
                                style: TextStyle(fontSize: 18),
                              ),
                              Text(
                                'Rp ${kegiatan.anggaran.toString()}',
                                style: const TextStyle(fontSize: 18),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          Text(
                            "Daftar Anggota",
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Expanded(
                            child: ListView.builder(
                              itemCount: dosenList.length,
                              itemBuilder: (context, index) {
                                final dosen = dosenList[index];
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(children: [
                                      Text(
                                        dosen['nama'],
                                        style: const TextStyle(fontSize: 18),
                                      ),
                                      // Text(
                                      //   dosen['peran'],
                                      //   style: TextStyle(
                                      //     fontSize: 18.0,
                                      //   ),
                                      // ),
                                    ]),
                                    const SizedBox(height: 2),
                                    Text(
                                      'NIP: ${dosen['nip']}',
                                      style: const TextStyle(fontSize: 18),
                                    ),
                                    const SizedBox(height: 11),
                                  ],
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }));
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'berjalan':
        return Colors.blue;
      case 'selesai':
        return Color.fromARGB(255, 0, 185, 65);
      case 'belum':
        return Colors.grey;
      default:
        return Colors.black; // Warna default jika status tidak valid
    }
  }

  @override
  State<AktivitasDetailDosenView> createState() =>
      AktivitasDetailDosenController();
}
