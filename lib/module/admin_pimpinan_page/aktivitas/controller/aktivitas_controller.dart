import 'package:flutter/material.dart';
import 'package:hyper_ui/core.dart';

class AktivitasController extends State<AktivitasView> {
  static late AktivitasController instance;
  final ApiService _apiService = ApiService();
  late Future<List<dynamic>> kegiatanList;
  List<dynamic> allKegiatanList = [];
  List<dynamic> filteredKegiatanList = [];
  TextEditingController searchController = TextEditingController();

  String? selectedPeriode;
  String? selectedBulan;
  String? selectedKategori;

  List<String> availablePeriode = [];
  List<String> availableBulan = [];
  List<String> availableKategori = [];

  late AktivitasView view;

  @override
  void initState() {
    super.initState();
    instance = this;
    WidgetsBinding.instance.addPostFrameCallback((_) => onReady());
    kegiatanList = fetchKegiatan();
    searchController.addListener(onSearchChanged);
  }

  void onReady() {}

  @override
  void dispose() {
    instance = this;
    super.dispose();

    searchController.dispose();
    _apiService.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.build(context, this);

  Future<List<dynamic>> fetchKegiatan() async {
    final response = await _apiService.getRequest(Endpoints.getKegiatan);

    if (response['status'] == 'success') {
      allKegiatanList = response['data'] as List<dynamic>;
      filteredKegiatanList = allKegiatanList;

      // Ambil daftar unik untuk dropdown
      availablePeriode = allKegiatanList
          .map((kegiatan) => kegiatan['periode'].toString())
          .toSet()
          .toList();
      availableBulan = allKegiatanList
          .map((kegiatan) =>
              DateTime.parse(kegiatan['tanggal_mulai']).month.toString())
          .toSet()
          .toList();
      availableKategori = allKegiatanList
          .map((kegiatan) => kegiatan['kategori_nama'].toString())
          .toSet()
          .toList();

      return filteredKegiatanList;
    } else {
      throw Exception('Gagal memuat data kegiatan');
    }
  }

  void onSearchChanged() {
    filterKegiatan();
  }

  void filterKegiatan() {
    final query = searchController.text.toLowerCase();

    setState(() {
      filteredKegiatanList = allKegiatanList.where((kegiatan) {
        final matchesSearch =
            kegiatan['kegiatan_nama'].toString().toLowerCase().contains(query);
        final matchesPeriode = selectedPeriode == null ||
            kegiatan['periode'].toString() == selectedPeriode;
        final matchesBulan = selectedBulan == null ||
            DateTime.parse(kegiatan['tanggal_mulai']).month.toString() ==
                selectedBulan;
        final matchesKategori = selectedKategori == null ||
            kegiatan['kategori_nama'].toString() == selectedKategori;

        return matchesSearch &&
            matchesPeriode &&
            matchesBulan &&
            matchesKategori;
      }).toList();
    });
  }

  void onFilterChanged() {
    filterKegiatan();
  }
}
