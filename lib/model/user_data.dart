class ActivityData2 {
  int? kegiatanId;
  String? periode;
  String? kategoriNama;
  String? kegiatanNama;
  String? deskripsi;
  String? skala;
  int? anggaran;
  String? tanggal_mulai;
  String? tanggalSelesai;
  String? status;
  String? suratTugas;
  List<int>? listdosen;
  List<AgendaData>? agenda;

  ActivityData2({
    this.kegiatanId,
    this.periode,
    this.kategoriNama,
    this.kegiatanNama,
    this.deskripsi,
    this.skala,
    this.anggaran,
    this.tanggal_mulai,
    this.tanggalSelesai,
    this.status,
    this.suratTugas,
    this.listdosen,
    this.agenda,
  });

  static List<ActivityData2> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => ActivityData2.fromJson(json)).toList();
  }

  factory ActivityData2.fromJson(Map<String, dynamic> json) {
    return ActivityData2(
      kegiatanId: json['kegiatan_id'],
      periode: json['periode'],
      kategoriNama: json['kategori_nama'],
      kegiatanNama: json['kegiatan_nama'],
      deskripsi: json['deskripsi'],
      skala: json['skala'],
      anggaran: json['anggaran'],
      tanggal_mulai: json['tanggal_mulai'],
      tanggalSelesai: json['tanggal_selesai'],
      status: json['status'],
      suratTugas: json['surat_tugas'],
      listdosen: json['dosen'] != null ? List<int>.from(json['dosen']) : null,
      agenda: json['agenda'] != null
          ? AgendaData.fromJsonList(json['agenda'])
          : null,
    );
  }
}

class AgendaData {
  int? agendaId;
  String? nama;
  String? tanggal_mulai;
  String? status;
  String? tanggalSelesai;

  AgendaData({
    this.agendaId,
    this.nama,
    this.tanggal_mulai,
    this.status,
    this.tanggalSelesai,
  });

  static List<AgendaData> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => AgendaData.fromJson(json)).toList();
  }

  factory AgendaData.fromJson(Map<String, dynamic> json) {
    return AgendaData(
      agendaId: json['agenda_id'],
      nama: json['nama'],
      tanggal_mulai: json['tanggal_mulai'],
      status: json['status'],
      tanggalSelesai: json['tanggal_selesai'],
    );
  }
}
