import 'package:flutter/material.dart';
import 'package:hyper_ui/module/login/controller/sessionManager.dart';
import 'package:hyper_ui/service/api_servive.dart';
import 'package:hyper_ui/service/endpoints.dart';
import 'package:intl/intl.dart';
import 'package:dio/dio.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:hyper_ui/module/admin_pimpinan_page/dashboard/view/dashboard_view.dart';

class DashboardController extends State<DashboardView> {
  static late DashboardController instance;
  late DashboardView view;

  String? username, level, token, user_id;
  List<ActivityData> activities = [];
  bool isLoading = false;
  late Future<List<dynamic>> kegiatanList;
  final ApiService _apiService = ApiService();

  List<dynamic> allKegiatanList = [];

  String selectedMonth = DateFormat.MMMM('id_ID').format(DateTime.now());
  Map<String, int> selectedData = {
    'Total': 11,
    'Selesai': 3,
    'Berjalan': 7,
    'Belum': 1,
  };

  @override
  void initState() {
    instance = this;
    super.initState();
    getUserDetails();
    fetchActivities();
    kegiatanList = fetchKegiatan();
  }

  Future<void> getUserDetails() async {
    // Dapatkan data pengguna dari SessionManager
    Map<String, String?> userDetails = await SessionManager.getUserData();
    setState(() {
      username = userDetails['username'] ?? 'Unknown';
    });
  }

  Future<void> fetchActivities() async {
    setState(() {
      isLoading = true;
    });
    try {
      final response = await Dio().get(Endpoints.getKegiatan);

      if (response.statusCode == 200) {
        activities = ActivityData.fromJsonList(response.data['data']);
        setState(() {
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load activities');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error fetching activities: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Terjadi kesalahan saat mengambil data kegiatan')),
      );
    }
  }

  /// Fungsi untuk menghitung data kegiatan bulanan
  Map<String, Map<String, int>> calculateMonthlyActivities() {
    Map<String, Map<String, int>> monthlyData = {};
    const List<String> bulanUrut = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember'
    ];

    for (final activity in activities) {
      if (activity.tanggal_mulai == null || activity.tanggal_mulai!.isEmpty) {
        continue;
      }

      try {
        final parsedDate = DateTime.parse(activity.tanggal_mulai!);
        final month = DateFormat.MMMM('id_ID').format(parsedDate);

        monthlyData[month] ??= {'Berjalan': 0, 'Selesai': 0, 'Belum': 0};

        final status = activity.status ?? '';
        if (status == 'Berjalan') {
          monthlyData[month]!['Berjalan'] =
              (monthlyData[month]!['Berjalan'] ?? 0) + 1;
        } else if (status == 'Selesai') {
          monthlyData[month]!['Selesai'] =
              (monthlyData[month]!['Selesai'] ?? 0) + 1;
        } else {
          monthlyData[month]!['Belum'] =
              (monthlyData[month]!['Belum'] ?? 0) + 1;
        }
      } catch (e) {
        print(
            "Error parsing date for activity: ${activity.tanggal_mulai}, Error: $e");
      }
    }

    // Mengurutkan berdasarkan bulan
    final sortedMonthlyData = Map.fromEntries(
      bulanUrut.where((bulan) => monthlyData.containsKey(bulan)).map(
            (bulan) => MapEntry(bulan, monthlyData[bulan]!),
          ),
    );

    return sortedMonthlyData;
  }

  /// Fungsi untuk menangani saat poin grafik ditekan
  void onChartPointTap(ChartPointDetails details) {
    final chartIndex = details.pointIndex;
    final sortedMonthlyData = calculateMonthlyActivities();
    final String? selectedKey = details.dataPoints?[chartIndex!].x.toString();

    if (selectedKey != null && sortedMonthlyData.containsKey(selectedKey)) {
      selectedMonth = selectedKey;
      selectedData = {
        'Total': sortedMonthlyData[selectedKey]!['Berjalan']! +
            sortedMonthlyData[selectedKey]!['Selesai']! +
            sortedMonthlyData[selectedKey]!['Belum']!,
        'Berjalan': sortedMonthlyData[selectedKey]!['Berjalan']!,
        'Selesai': sortedMonthlyData[selectedKey]!['Selesai']!,
        'Belum': sortedMonthlyData[selectedKey]!['Belum']!,
      };
      setState(() {});
    }
  }

  Future<List<dynamic>> fetchKegiatan() async {
    final response = await _apiService.getRequest(Endpoints.getKegiatan);
    print(response); // Debug respon API

    if (response['status'] == 'success') {
      allKegiatanList = response['data'] as List<dynamic>;
      return allKegiatanList;
    } else {
      throw Exception('Gagal memuat data kegiatan');
    }
  }

  @override
  Widget build(BuildContext context) => widget.build(context, this);
}

class ActivityData {
  String? tanggal_mulai;
  String? status;

  ActivityData({this.tanggal_mulai, this.status});

  static List<ActivityData> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => ActivityData.fromJson(json)).toList();
  }

  factory ActivityData.fromJson(Map<String, dynamic> json) {
    return ActivityData(
      tanggal_mulai: json['tanggal_mulai'],
      status: json['status'],
    );
  }
}
