import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:hyper_ui/core.dart';
import 'package:hyper_ui/model/user_data.dart';
import '../view/notifikasi_view.dart';

class NotifikasiController extends State<NotifikasiView> {
  static late NotifikasiController instance;
  late NotifikasiView view;
  late Future<List<ActivityData2>> kegiatanList;

  List<ActivityData2> activities = [];
  List<ActivityData2> filteredKegiatan = [];

  String? userId;

  @override
  void initState() {
    super.initState();
    instance = this;
    getUserDetails();
    kegiatanList = fetchNotifikasi();
    WidgetsBinding.instance.addPostFrameCallback((_) => onReady());
  }

  void onReady() {}

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.build(context, this);
  Future<void> getUserDetails() async {
    Map<String, String?> userDetails = await SessionManager.getUserData();
    setState(() {
      userId = userDetails['user_id'];
    });
    print("userid di notifikasi $userId");
  }

  Future<List<ActivityData2>> fetchNotifikasi() async {
    final response = await Dio().get(Endpoints.getKegiatan);
    var responseData = response.data;

    if (response.statusCode == 200) {
      activities = ActivityData2.fromJsonList(responseData['data']);

      if (userId == null) {
        throw Exception('User ID is not set.');
      }

      setState(() {
        filteredKegiatan = activities.where((activity) {
          return activity.listdosen != null &&
              activity.listdosen!.contains(int.parse(userId!));
        }).toList();
      });

      final now =
          DateTime.now().toUtc().add(Duration(hours: 7)); // Konversi ke WITA

      // Filter kegiatan yang valid (besok hingga 7 hari ke depan)
      List<ActivityData2> validKegiatan = filteredKegiatan.where((kegiatan) {
        final tanggalMulai = DateTime.parse(kegiatan.tanggal_mulai!)
            .toUtc()
            .add(Duration(hours: 7)); // Konversi ke WITA

        final nowDate = DateTime(now.year, now.month, now.day);
        final tanggalMulaiDate =
            DateTime(tanggalMulai.year, tanggalMulai.month, tanggalMulai.day);

        final diff = tanggalMulaiDate.difference(nowDate).inDays;

        // Debugging log
        print('Now: $nowDate, Tanggal mulai: $tanggalMulaiDate, diff: $diff');

        // Hanya kegiatan mulai besok hingga 7 hari ke depan
        return diff > 0 && diff <= 7;
      }).toList();

      // Urutkan kegiatan berdasarkan tanggal mulai terdekat
      validKegiatan.sort((a, b) {
        final aTanggalMulai = DateTime.parse(a.tanggal_mulai!).toUtc();
        final bTanggalMulai = DateTime.parse(b.tanggal_mulai!).toUtc();

        final aTanggalDate = DateTime(
            aTanggalMulai.year, aTanggalMulai.month, aTanggalMulai.day);
        final bTanggalDate = DateTime(
            bTanggalMulai.year, bTanggalMulai.month, bTanggalMulai.day);

        return aTanggalDate.compareTo(bTanggalDate);
      });

      print("Notifikasi akhir: $validKegiatan");

      // Mengembalikan list kegiatan yang valid
      return validKegiatan;
    } else {
      throw Exception('Failed to load notifikasi');
    }
  }
}
