class Laporan {
  final String uid;
  final String docId;

  final String judul;
  final String kategori;
  String? deskripsi;
  String? gambar;
  final DateTime tanggal;
  final String jumlah;

  Laporan(
      {required this.uid,
      required this.docId,
      required this.judul,
      required this.kategori,
      this.deskripsi,
      this.gambar,
      required this.tanggal,
      required this.jumlah});
}
