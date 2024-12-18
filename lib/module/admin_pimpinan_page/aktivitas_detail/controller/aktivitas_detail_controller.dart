import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:hyper_ui/core.dart';
import '../view/aktivitas_detail_view.dart';

class AktivitasDetailController extends State<AktivitasDetailView> {
  static late AktivitasDetailController instance;
  late AktivitasDetailView view;

  @override
  void initState() {
    super.initState();
    instance = this;
    WidgetsBinding.instance.addPostFrameCallback((_) => onReady());
  }

  void onReady() {}

  @override
  void dispose() {
    super.dispose();
  }

  Future<List<Map<String, dynamic>>> fetchDosenKegiatan(int kegiatanId) async {
    final url = Uri.parse(
        'https://jti-sphere.ngrok.app/api/kegiatan/get_kegiatan_detail/$kegiatanId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final dosenKegiatan = data['kegiatan'][0]['dosen_kegiatan'] as List;
      return dosenKegiatan
          .map((item) => item['dosen'] as Map<String, dynamic>)
          .toList();
    } else {
      throw Exception('Failed to load kegiatan detail');
    }
  }

  @override
  Widget build(BuildContext context) => widget.build(context, this);
}
