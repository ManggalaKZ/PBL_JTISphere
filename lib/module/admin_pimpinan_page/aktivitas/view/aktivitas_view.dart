import 'package:flutter/material.dart';
import 'package:hyper_ui/core.dart';

class AktivitasView extends StatefulWidget {
  const AktivitasView({super.key});

  Widget build(context, AktivitasController controller) {
    controller.view = this;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Kegiatan"),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          // Dropdown Filter
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                // Dropdown Periode
                Flexible(
                  flex: 22,
                  child: Container(
                    height: 50,
                    child: DropdownButtonFormField<String>(
                      value: controller.selectedPeriode,
                      items: [
                        DropdownMenuItem(
                          value: null, // Opsi "Tidak Memilih" menggunakan null
                          child: Text(
                            "Batal",
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
                // Dropdown Bulan
                Flexible(
                  flex: 30,
                  child: Container(
                    height: 50,
                    child: DropdownButtonFormField<String>(
                      value: controller.selectedBulan,
                      items: [
                        DropdownMenuItem(
                          value: null, // Opsi "Tidak Memilih" menggunakan null
                          child: Text(
                            "Batal",
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
                          // Reset filter jika tidak memilih
                          controller.selectedBulan = null;
                        } else {
                          // Atur filter sesuai pilihan
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
                // Dropdown Kategori
                Flexible(
                  flex: 30,
                  child: Container(
                    height: 50,
                    child: DropdownButtonFormField<String>(
                      value: controller.selectedKategori,
                      items: [
                        DropdownMenuItem(
                          value: null, // Opsi "Tidak Memilih" menggunakan null
                          child: Text(
                            "Batal",
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
          // Input pencarian
          Padding(
            padding: const EdgeInsets.all(8.0),
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
            child: FutureBuilder<List<dynamic>>(
              future: controller.kegiatanList,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
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
                        title: Text(kegiatan['kegiatan_nama']),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Periode: ${kegiatan['periode']}'),
                            Text('Kategori: ${kegiatan['kategori_nama']}'),
                            Text('Skala: ${kegiatan['skala']}'),
                            Text(
                                'Tanggal: ${kegiatan['tanggal_mulai']} - ${kegiatan['tanggal_selesai']}'),
                          ],
                        ),
                        trailing: Text(
                          'Rp ${kegiatan['anggaran'].toString()}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  AktivitasDetailView(kegiatan: kegiatan),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  State<AktivitasView> createState() => AktivitasController();
}
