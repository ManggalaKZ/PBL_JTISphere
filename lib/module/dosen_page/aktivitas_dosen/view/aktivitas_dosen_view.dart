import 'package:flutter/material.dart';
import 'package:hyper_ui/core.dart';
import 'package:hyper_ui/model/user_data.dart';
import '../controller/aktivitas_dosen_controller.dart';

class AktivitasDosenView extends StatefulWidget {
  const AktivitasDosenView({super.key});

  Widget build(context, AktivitasDosenController controller) {
    controller.view = this;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Kegiatan"),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Row(
              children: [
                Flexible(
                  flex: 25,
                  child: Container(
                    height: 50,
                    child: DropdownButtonFormField<String>(
                      value: controller.selectedPeriode,
                      items: [
                        DropdownMenuItem(
                          value: null,
                          child: Text(
                            "Periode",
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                        ...controller.availablePeriode
                            .map((periode) => DropdownMenuItem(
                                  value: periode,
                                  child: Text(
                                    periode,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontSize: 14),
                                  ),
                                )),
                      ],
                      onChanged: (value) {
                        controller.selectedPeriode = value;
                        controller.onFilterChanged();
                      },
                      decoration: const InputDecoration(
                        labelText: "Periode",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8.0),
                Flexible(
                  flex: 25,
                  child: Container(
                    height: 50,
                    child: DropdownButtonFormField<String>(
                      value: controller.selectedBulan,
                      items: [
                        DropdownMenuItem(
                          value: null,
                          child: Text(
                            "Bulan",
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                        ...controller.availableBulan
                            .map((bulan) => DropdownMenuItem(
                                  value: bulan,
                                  child: Text(
                                    "Bulan ${int.parse(bulan).toString().padLeft(2, '0')}",
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontSize: 14),
                                  ),
                                )),
                      ],
                      onChanged: (value) {
                        if (value == null) {
                          controller.selectedBulan = null;
                        } else {
                          controller.selectedBulan = value;
                        }
                        controller.onFilterChanged();
                      },
                      decoration: const InputDecoration(
                        labelText: "Bulan",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8.0),
                Flexible(
                  flex: 30,
                  child: Container(
                    height: 50,
                    child: DropdownButtonFormField<String>(
                      value: controller.selectedKategori,
                      items: [
                        DropdownMenuItem(
                          value: null,
                          child: Text(
                            "Kategori",
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                        ...controller.availableKategori
                            .map((kategori) => DropdownMenuItem(
                                  value: kategori,
                                  child: Text(
                                    kategori,
                                    style: TextStyle(fontSize: 12),
                                  ),
                                )),
                      ],
                      onChanged: (value) {
                        controller.selectedKategori = value;
                        controller.onFilterChanged();
                      },
                      decoration: const InputDecoration(
                        labelText: "Kategori",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 5, 18, 5),
            child: TextField(
              controller: controller.searchController,
              decoration: const InputDecoration(
                hintText: "Cari kegiatan berdasarkan Nama...",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          // Daftar kegiatan
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 5, 12, 5),
              child: FutureBuilder<List<ActivityData2>>(
                future: controller.kegiatanList,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Errossr: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('Tidak ada data'));
                  }

                  final kegiatanList = controller.filteredKegiatanList;
                  if (kegiatanList.isEmpty) {
                    return const Center(
                        child: Text('Tidak ada hasil untuk filter Anda.'));
                  }
                  return ListView.builder(
                    itemCount: kegiatanList.length,
                    itemBuilder: (context, index) {
                      final kegiatan = kegiatanList[index];
                      return Card(
                        margin: const EdgeInsets.all(8.0),
                        child: ListTile(
                          title: Text(kegiatan.kegiatanNama ?? "null"),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Periode: ${kegiatan.periode}'),
                              Text('Kategori: ${kegiatan.kategoriNama}'),
                              Text(
                                  'Tanggal: ${kegiatan.tanggal_mulai} - ${kegiatan.tanggalSelesai}'),
                            ],
                          ),
                          trailing: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12.0, vertical: 8.0),
                            decoration: BoxDecoration(
                              color:
                                  _getStatusColor(kegiatan.status ?? "kosong"),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Text(
                                kegiatan.status ?? "kosong",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      AktivitasDetailDosenView(
                                          kegiatan: kegiatan)),
                            );
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
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
  State<AktivitasDosenView> createState() => AktivitasDosenController();
}
