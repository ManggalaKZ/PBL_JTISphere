import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hyper_ui/core.dart';
import 'package:http/http.dart' as http;
import 'package:hyper_ui/model/user_data.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DashboardDosenController extends State<DashboardDosenView> {
  static late DashboardDosenController instance;
  late DashboardDosenView view;

  String? username, level, token, user_id;
  List<ActivityData2> activities = [];
  bool isLoading = false;
  late Future<List<dynamic>> kegiatanList;
  List<dynamic> filteredKegiatan = [];
  final ApiService _apiService = ApiService();
  List<dynamic> allKegiatanList = [];

  String? userId;
  String selectedMonth = DateFormat.MMMM('id_ID').format(DateTime.now());
  Map<String, int> selectedData = {
    'Total': 7,
    'Selesai': 2,
    'Berjalan': 5,
    'Belum': 0,
  };

  @override
  void initState() {
    instance = this;
    getUserDetails();
    super.initState();
    fetchActivities();
    kegiatanList = fetchKegiatan();
  }

  Future<void> getUserDetails() async {
    Map<String, String?> userDetails = await SessionManager.getUserData();
    setState(() {
      userId = (userDetails['user_id']);

      username = userDetails['username'] ?? 'Unknown';
    });
    print("userid di controller $userId");
  }

  Future<void> fetchActivities() async {
    setState(() {
      isLoading = true;
    });
    if (userId == null)
      try {
        final response = await http.get(
          Uri.parse(Endpoints.getKegiatan),
        );

        if (response.statusCode == 200) {
          print("Fetching activities...");
          final responseData = jsonDecode(response.body);
          print("Response Data: $responseData");

          if (responseData['status'] == 'success') {
            print("Parsing activities...");
            activities = ActivityData2.fromJsonList(responseData['data']);
            print("Activities parsed: $activities");

            setState(() {
              filteredKegiatan = activities.where((activity) {
                print("Filtering activity: $activity");
                print("userId: $userId, userId type: ${userId.runtimeType}");
                print("listdosen type: ${activity.listdosen.runtimeType}");
                return activity.listdosen != null &&
                    activity.listdosen!.contains(int.parse(userId ?? "99"));
              }).toList();
              isLoading = false;
              print("Filtered Kegiatan: $filteredKegiatan");
            });
          } else {
            print('API response status: ${responseData['status']}');
          }
        } else {
          print('Failed to fetch data: ${response.statusCode}');
        }
      } catch (e) {
        print('Error fetching kegiatan: $e');
      }
  }

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

    for (final activity in filteredKegiatan) {
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

    final sortedMonthlyData = Map.fromEntries(
      bulanUrut.where((bulan) => monthlyData.containsKey(bulan)).map(
            (bulan) => MapEntry(bulan, monthlyData[bulan]!),
          ),
    );

    return sortedMonthlyData;
  }

  List<AgendaData> getAllAgendasForUser() {
    List<AgendaData> allAgendas = [];

    final currentYear = DateTime.now().year;

    final filteredByYear = filteredKegiatan.where((activity) {
      return activity.periode != null &&
          int.tryParse(activity.periode!) == currentYear;
    }).toList();

    for (var activity in filteredByYear) {
      if (activity.agenda != null) {
        allAgendas.addAll(activity.agenda!);
      }
    }

    allAgendas.sort((a, b) {
      final today = DateTime.now();
      final startA = a.tanggal_mulai != null
          ? DateFormat("yyyy-MM-dd").parse(a.tanggal_mulai!)
          : today;
      final startB = b.tanggal_mulai != null
          ? DateFormat("yyyy-MM-dd").parse(b.tanggal_mulai!)
          : today;

      return startA.compareTo(startB);
    });

    return allAgendas;
  }

  Future<void> onChartPointTap(ChartPointDetails details) async {
    final chartIndex = details.pointIndex;
    final sortedMonthlyData = calculateMonthlyActivities();
    final String? selectedKey = details.dataPoints?[chartIndex!].x.toString();
    if (selectedKey != null && sortedMonthlyData.containsKey(selectedKey)) {
      setState(() {
        selectedMonth = selectedKey;
        selectedData = {
          'Total': sortedMonthlyData[selectedKey]!['Berjalan']! +
              sortedMonthlyData[selectedKey]!['Selesai']! +
              sortedMonthlyData[selectedKey]!['Belum']!,
          'Berjalan': sortedMonthlyData[selectedKey]!['Berjalan']!,
          'Selesai': sortedMonthlyData[selectedKey]!['Selesai']!,
          'Belum': sortedMonthlyData[selectedKey]!['Belum']!,
        };
      });
    }
  }

  Future<List<dynamic>> fetchKegiatan() async {
    final response = await _apiService.getRequest(Endpoints.getKegiatan);
    print(response); 

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
