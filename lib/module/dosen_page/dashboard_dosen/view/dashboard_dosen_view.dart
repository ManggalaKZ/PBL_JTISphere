import 'package:flutter/material.dart';
import 'package:hyper_ui/core.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DashboardDosenView extends StatefulWidget {
  const DashboardDosenView({super.key});

  Widget build(context, DashboardDosenController controller) {
    controller.view = this;
    String? username = controller.username;
    final agendas = controller.getAllAgendasForUser();

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

    if (controller.filteredKegiatan.isEmpty) {
      return Center(child: Text("Tidak ada data kegiatanss"));
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Haloo $username "),
        backgroundColor: Color(0xFF003F62),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NotifikasiView(),
                ),
              );
            },
            icon: const Icon(
              Icons.notifications_active_sharp,
              size: 24.0,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        controller: ScrollController(),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Container(
                  height: MediaQuery.of(context).size.height * 0.37,
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
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      children: controller.selectedData.entries.map((entry) {
                        return Expanded(
                          child: Column(
                            children: [
                              Text(
                                entry.key,
                                style: const TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black54,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "${entry.value}",
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
                            "Agenda Anda",
                            style: TextStyle(
                                fontSize: 21.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                      height: 360,
                      child: ListView.builder(
                        controller: ScrollController(),
                        itemCount: 4,
                        itemBuilder: (context, index) {
                          final agenda = agendas[index];
                          return Card(
                            margin: EdgeInsets.all(8),
                            child: ListTile(
                              title: Text(
                                agenda.nama ?? "Agenda Tanpa Nama",
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                "Mulai: ${agenda.tanggal_mulai ?? '-'}\nSelesai: ${agenda.tanggalSelesai ?? '-'}",
                              ),
                              trailing: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0, vertical: 8.0),
                                decoration: BoxDecoration(
                                  color: _getStatusColor(
                                      agenda.status ?? "kosong"),
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Text(
                                    agenda.status ?? "kosong",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      )),
                ],
              ),
            ],
          ),
        ),
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
  State<DashboardDosenView> createState() => DashboardDosenController();
}
