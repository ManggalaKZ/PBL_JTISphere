import 'package:flutter/material.dart';
import 'package:hyper_ui/core.dart';
import 'package:hyper_ui/model/user_data.dart';
import '../controller/notifikasi_controller.dart';

class NotifikasiView extends StatefulWidget {
  const NotifikasiView({super.key});

  Widget build(context, NotifikasiController controller) {
    controller.view = this;
    return Scaffold(
      appBar: AppBar(
        title: Text("Notifikasi"),
        actions: const [],
      ),
      body: FutureBuilder<List<ActivityData2>>(
        future: controller.kegiatanList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Tidak ada notifikasi kegiatan'));
          }

          final notifikasiList = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: ListView.builder(
              itemCount: notifikasiList.length,
              itemBuilder: (context, index) {
                final kegiatan = notifikasiList[index];
                final now = DateTime.now().toUtc();
                final tanggalMulai = DateTime.parse(kegiatan.tanggal_mulai!)
                    .toUtc()
                    .add(Duration(hours: 7));
                final nowDate = DateTime(now.year, now.month, now.day);
                final tanggalMulaiDate = DateTime(
                    tanggalMulai.year, tanggalMulai.month, tanggalMulai.day);
                final diff = tanggalMulaiDate.difference(nowDate).inDays;
                
                bool hariH = false;
                if (diff == 0) {
                  hariH = true;
                }
                return Card(
                  margin: const EdgeInsets.all(5.0),
                  child: ListTile(
                    title: Text(
                      kegiatan.kegiatanNama!,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 7,
                        ),
                        Text('Tanggal Pelaksanaan: ${kegiatan.tanggal_mulai}'),
                        Text('Kategori: ${kegiatan.kategoriNama}'),
                      ],
                    ),
                    trailing: Text(hariH ? 'Hari ini' : '$diff Hari lagi'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              AktivitasDetailDosenView(kegiatan: kegiatan),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  @override
  State<NotifikasiView> createState() => NotifikasiController();
}
