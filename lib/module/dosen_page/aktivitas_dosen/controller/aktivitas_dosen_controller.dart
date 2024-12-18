import 'package:flutter/material.dart';
import 'package:hyper_ui/core.dart';
import 'package:hyper_ui/model/user_data.dart';

class AktivitasDosenController extends State<AktivitasDosenView> {
  static late AktivitasDosenController instance;
  final ApiService _apiService = ApiService();
  String? userId;
  bool isLoading = false;

  late Future<List<ActivityData2>> kegiatanList;
  List<ActivityData2> allKegiatanList = [];
  List<ActivityData2> activities = [];
  List<ActivityData2> filteredKegiatanList = [];

  List<ActivityData2> filteredKegiatan = [];
  TextEditingController searchController = TextEditingController();

  String? selectedPeriode;
  String? selectedBulan;
  String? selectedKategori;

  List<String> availablePeriode = [];
  List<String> availableBulan = [];
  List<String> availableKategori = [];
  late AktivitasDosenView view;

  @override
  void initState() {
    super.initState();
    getUserDetails();
    instance = this;
    WidgetsBinding.instance.addPostFrameCallback((_) => onReady());
    kegiatanList = fetchKegiatan(); // Initialize kegiatanList
    searchController.addListener(onSearchChanged);
  }

  void onReady() {
    // Any additional setup after the view is built
  }

  @override
  void dispose() {
    instance = this;
    super.dispose();
    searchController.dispose();
    _apiService.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.build(context, this);

  Future<void> getUserDetails() async {
    // Dapatkan data pengguna dari SessionManager
    Map<String, String?> userDetails = await SessionManager.getUserData();
    setState(() {
      userId = (userDetails['user_id']);
    });
    print("userid di aktivitas $userId");
  }

  Future<List<ActivityData2>> fetchKegiatan() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await Dio().get(Endpoints.getKegiatan);
      var responseData = response.data;

      if (responseData['status'] == 'success') {
        // Parse response data to ActivityData2 list
        activities = ActivityData2.fromJsonList(responseData['data']);

        // Filtering activities for the current user
        print("data activities yang diambil$activities");
        print("userid dosen $userId");
        setState(() {
          filteredKegiatan = activities.where((activity) {
            return activity.listdosen != null &&
                activity.listdosen!.contains(int.parse(userId ?? "99"));
          }).toList();
          isLoading = false;
        });
        filteredKegiatanList = filteredKegiatan;
        print("data filteredkegiatan $filteredKegiatan");
        // Update dropdown values based on filtered kegiatan
        availablePeriode = filteredKegiatan
            .map((kegiatan) => kegiatan.periode.toString())
            .toSet()
            .toList();
        availableBulan = filteredKegiatan
            .map((kegiatan) =>
                DateTime.parse(kegiatan.tanggal_mulai ?? "1970-01-01")
                    .month
                    .toString())
            .toSet()
            .toList();
        availableKategori = filteredKegiatan
            .map((kegiatan) => kegiatan.kategoriNama.toString())
            .toSet()
            .toList();

        return filteredKegiatanList;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print("Error fetching kegiatan: $e");
      throw Exception('Gagal memuat data kegiatan');
    }
  }

  void onSearchChanged() {
    filterKegiatan();
  }

  void filterKegiatan() {
    final query = searchController.text.toLowerCase();

    setState(() {
      filteredKegiatanList = filteredKegiatan.where((kegiatan) {
        final matchesSearch =
            kegiatan.kegiatanNama.toString().toLowerCase().contains(query);
        final matchesPeriode = selectedPeriode == null ||
            kegiatan.periode.toString() == selectedPeriode;
        final matchesBulan = selectedBulan == null ||
            DateTime.parse(kegiatan.tanggal_mulai?? "12").month.toString() ==
                selectedBulan;
        final matchesKategori = selectedKategori == null ||
            kegiatan.kategoriNama.toString() == selectedKategori;

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
