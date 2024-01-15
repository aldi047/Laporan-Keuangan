import 'dart:ffi';

import 'package:capstone_catatan_keuangan/components/styles.dart';
import 'package:capstone_catatan_keuangan/pages/ProfilePage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:capstone_catatan_keuangan/components/list_item.dart';
import 'package:capstone_catatan_keuangan/models/akun.dart';
import 'package:capstone_catatan_keuangan/models/laporan.dart';
import 'package:capstone_catatan_keuangan/util/CurrencyFormat.dart';

class Reports extends StatefulWidget {
  Reports({super.key});

  @override
  State<Reports> createState() => _ReportsState();
}

class _ReportsState extends State<Reports> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  Akun akun = Akun(
    uid: '',
    docId: '',
    nama: '',
    noHP: '',
    email: '',
  );
  List<Laporan> listLaporan = [];
  String total = '0';
  void getTransaksi() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await _firestore.collection('laporan').get();

      setState(() {
        listLaporan.clear();
        for (var documents in querySnapshot.docs) {
          listLaporan.add(
            Laporan(
              uid: documents.data()['uid'],
              docId: documents.data()['docId'],
              judul: documents.data()['judul'],
              kategori: documents.data()['kategori'],
              deskripsi: documents.data()['deskripsi'],
              gambar: documents.data()['gambar'],
              tanggal: documents['tanggal'].toDate(),
              jumlah: documents.data()['jumlah'],
            ),
          );
        }
      });
    } catch (e) {
      // final snackbar = SnackBar(content: Text(e.toString()));
      // ScaffoldMessenger.of(context).showSnackBar(snackbar);
      print(e);
    }
  }

  void getAkun() async {
    try {
      await _firestore
          .collection('akun')
          .where(FieldPath.documentId, isEqualTo: _auth.currentUser!.uid)
          .get()
          .then((value) {
        Map<String, dynamic>? userData = value.docs.first.data();
        setState(() {
          akun = Akun(
            uid: userData['uid'],
            nama: userData['nama'],
            noHP: userData['noHP'],
            email: userData['email'],
            docId: userData['docId'],
          );
        });
      });
    } catch (e) {
      final snackbar = SnackBar(content: Text(e.toString() + 'Ini dari user'));
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
      print(e);
    }
  }

  getTotal() {
    var total_transaksi = 0;
    for (var data in listLaporan) {
      total_transaksi += int.parse(data.jumlah);
    }
    setState(() {
      if (total == '0') {
        total = 'Rp 0,00';
      } else {
        total = CurrencyFormat.convertToIdr(total_transaksi.toString(), 2);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getAkun();
  }

  @override
  Widget build(BuildContext context) {
    getTransaksi();
    getTotal();
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        child: Icon(Icons.add, size: 35),
        onPressed: () {
          Navigator.pushNamed(context, '/add');
        },
      ),
      appBar: AppBar(backgroundColor: primaryColor, actions: [
        IconButton(
          icon: const Icon(Icons.account_circle_rounded),
          tooltip: 'Profile',
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => Profile(akun: akun)));
          },
        ),
      ]),
      body: SafeArea(
          child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                children: [
                  SizedBox(
                    height: 70,
                    child: Container(
                      decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            'Saldo anda saat ini',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            total,
                            style: TextStyle(color: Colors.black, fontSize: 18),
                          )
                        ],
                      )),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Expanded(
                      child: ListView.builder(
                          itemCount: listLaporan.length,
                          itemBuilder: (context, index) {
                            return ListItem(laporan: listLaporan[index]);
                          }))
                ],
              ))),
    );
  }
}
