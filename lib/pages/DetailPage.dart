import 'package:flutter/material.dart';
import 'package:intl/number_symbols_data.dart';
// import 'package:capstone_catatan_keuangan/components/komen_dialog.dart';
import 'package:capstone_catatan_keuangan/components/status_dialog.dart';
import 'package:capstone_catatan_keuangan/components/styles.dart';
import 'package:capstone_catatan_keuangan/models/akun.dart';
import 'package:capstone_catatan_keuangan/models/laporan.dart';
import 'package:intl/intl.dart';
import 'package:capstone_catatan_keuangan/util/CurrencyFormat.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailPage extends StatefulWidget {
  DetailPage({super.key});
  @override
  State<StatefulWidget> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  bool _isLoading = false;

  String? status;

  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    Laporan laporan = arguments['laporan'];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: primaryColor,
        title: Text('Detail Laporan',
            style: headerStyle(level: 3, color: Colors.white)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      int.parse(laporan.jumlah) <= 0
                          ? Text('Transaksi Keluar',
                              style: headerStyle(
                                  level: 2, color: Colors.redAccent))
                          : Text('Transaksi Masuk',
                              style: headerStyle(
                                  level: 2, color: Colors.greenAccent)),
                      SizedBox(height: 15),
                      Text(
                        CurrencyFormat.convertToIdr(laporan.jumlah, 2),
                        style: headerStyle(level: 3),
                      ),
                      SizedBox(height: 20),
                      laporan.gambar != ''
                          ? Image.network(laporan.gambar!)
                          : Image.asset('assets/default.jpeg'),
                      Text(
                        laporan.judul,
                        style: headerStyle(level: 3),
                      ),
                      SizedBox(height: 20),
                      ListTile(
                        leading: Icon(Icons.date_range),
                        title: Center(child: Text('Tanggal Laporan')),
                        subtitle: Center(
                            child: Text(DateFormat('dd MMMM yyyy')
                                .format(laporan.tanggal))),
                        trailing: SizedBox(width: 45),
                      ),
                      SizedBox(height: 10),
                      ListTile(
                        leading: Icon(Icons.category_rounded),
                        title: Center(child: Text('Kategori')),
                        subtitle: Center(child: Text(laporan.kategori)),
                        trailing: SizedBox(width: 45),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Deskripsi Laporan',
                        style: headerStyle(level: 3),
                      ),
                      SizedBox(height: 20),
                      Container(
                        width: double.infinity,
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        child: Text(laporan.deskripsi ?? ''),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
