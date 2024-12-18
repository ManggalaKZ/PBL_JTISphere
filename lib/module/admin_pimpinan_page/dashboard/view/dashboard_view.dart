import 'package:flutter/material.dart';
import 'package:hyper_ui/core.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DashboardView extends StatefulWidget {
  DashboardView({Key? key}) : super(key: key);

  Widget build(context, DashboardController controller) {
    controller.view = this;
    String? username = controller.username;
    final chartData = controller.calculateMonthlyActivities().entries.map(
      (entry) {
        final month = entry.key;
        final data = entry.value;
        return ChartData(
          month: month,
          berjalan: data['Berjalan']!,
          selesai: data['Selesai']!,
          belum: data['Belum']!,
        );
      },
    ).toList();

    if (controller.isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (controller.activities.isEmpty) {
      return Center(child: Text("Tidak ada data kegiatan"));
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Haloo $username! "),
        backgroundColor: Color(0xFF003F62),
        automaticallyImplyLeading: false,
        actions: [],
      ),
      body: SingleChildScrollView(
        controller: ScrollController(),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Container(
                  height: MediaQuery.of(context).size.height * 0.4,
                  child: SfCartesianChart(
                    title: ChartTitle(
                        text: 'Kegiatan ada di Polinema',
                        alignment: ChartAlignment.near,
                        textStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                        )),
                    enableAxisAnimation: false,
                    zoomPanBehavior: ZoomPanBehavior(
                      enablePanning: true,
                      enablePinching: true,
                      maximumZoomLevel: 0.1,
                      zoomMode: ZoomMode.x,
                    ),
                    legend: Legend(
                      isVisible: true,
                      shouldAlwaysShowScrollbar: true,
                    ),
                    primaryXAxis: CategoryAxis(
                      labelStyle: TextStyle(fontSize: 12),
                      initialVisibleMaximum: 5,
                      initialVisibleMinimum: 0,
                      majorGridLines:
                          MajorGridLines(width: 0, color: Colors.grey),
                    ),
                    primaryYAxis: NumericAxis(
                      edgeLabelPlacement: EdgeLabelPlacement.shift,
                      interval: 2,
                      majorGridLines:
                          MajorGridLines(width: 0, color: Colors.grey),
                    ),
                    series: <StackedColumnSeries<ChartData, String>>[
                      StackedColumnSeries<ChartData, String>(
                        dataSource: chartData,
                        xValueMapper: (ChartData data, _) => data.month,
                        yValueMapper: (ChartData data, _) => data.berjalan,
                        name: 'Berjalan',
                        animationDuration: 0,
                        animationDelay: 0,
                        onPointTap: (ChartPointDetails details) {
                          controller.onChartPointTap(details);
                        },
                      ),
                      StackedColumnSeries<ChartData, String>(
                        dataSource: chartData,
                        xValueMapper: (ChartData data, _) => data.month,
                        yValueMapper: (ChartData data, _) => data.selesai,
                        name: 'Selesai',
                        animationDuration: 0,
                        animationDelay: 0,
                        onPointTap: (ChartPointDetails details) {
                          controller.onChartPointTap(details);
                        },
                      ),
                      StackedColumnSeries<ChartData, String>(
                        dataSource: chartData,
                        xValueMapper: (ChartData data, _) => data.month,
                        yValueMapper: (ChartData data, _) => data.belum,
                        name: 'Belum',
                        animationDuration: 0,
                        animationDelay: 0,
                        onPointTap: (ChartPointDetails details) {
                          controller.onChartPointTap(details);
                        },
                      ),
                    ],
                  )),
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.blue[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      "Bulan: ${controller.selectedMonth}",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(
                      height: 16), // Spasi antara header dan konten data
                  // Data detail dari kegiatan yang dipilih
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[100], // Latar belakang kontainer
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey
                              .withOpacity(0.5), // Bayangan untuk tampilan 3D
                          blurRadius: 5,
                          offset: const Offset(0, 3), // Posisi bayangan
                        ),
                      ],
                    ),
                    child: Row(
                      children: controller.selectedData.entries.map((entry) {
                        return Expanded(
                          child: Column(
                            children: [
                              Text(
                                entry
                                    .key, // Judul data ('Total', 'Selesai', dll.)
                                style: const TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black54,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "${entry.value}", // Nilai data
                                style: const TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Column(
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(9, 0, 9, 0),
                    height: 45,
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            "Daftar Kegiatan",
                            style: TextStyle(
                                fontSize: 21.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ),
                        Center(
                          child: InkWell(
                            onTap: () {},
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  "Lihat Semua",
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    color: Color(0xFF003F62),
                                  ),
                                ),
                                Icon(
                                  Icons.keyboard_arrow_right_outlined,
                                  color: Color(0xFF003F62),
                                  size: 25.0,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 500,
                    child: FutureBuilder<List<dynamic>>(
                      future: controller.kegiatanList,
                      builder: (context, snapshot) {
                        print('Snapshot State: ${snapshot.connectionState}');
                        print('Snapshot Data: ${snapshot.data}');
                        print('Snapshot Error: ${snapshot.error}');

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Text('Error: ${snapshot.error}'),
                          );
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return const Center(
                            child: Text('Tidak ada data'),
                          );
                        }

                        // Jika data ada, tampilkan dalam ListView
                        return ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            final kegiatan =
                                snapshot.data![index]; // Ambil data kegiatan
                            return Card(
                              margin: const EdgeInsets.all(8.0),
                              child: ListTile(
                                title: Text(
                                    kegiatan['kegiatan_nama']), // Nama Kegiatan
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        'Periode: ${kegiatan['periode']}'), // Periode
                                    Text(
                                        'Kategori: ${kegiatan['kategori_nama']}'), // Kategori
                                    Text(
                                        'Skala: ${kegiatan['skala']}'), // Skala
                                    Text(
                                      'Tanggal: ${kegiatan['tanggal_mulai']} - ${kegiatan['tanggal_selesai']}',
                                    ), // Tanggal
                                  ],
                                ),
                                trailing: Text(
                                  'Rp ${kegiatan['anggaran']}', // Anggaran
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                onTap: () {
                                  // Navigasi ke halaman detail
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AktivitasDetailView(
                                          kegiatan: kegiatan),
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
            ],
          ),
        ),
      ),
    );
  }

  @override
  State<DashboardView> createState() => DashboardController();
}

class ChartData {
  final String month;
  final int berjalan;
  final int selesai;
  final int belum;

  ChartData({
    required this.month,
    required this.berjalan,
    required this.selesai,
    required this.belum,
  });
}
