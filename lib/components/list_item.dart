import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:capstone_catatan_keuangan/models/akun.dart';
import 'package:intl/intl.dart';
import 'package:capstone_catatan_keuangan/components/styles.dart';
import 'package:capstone_catatan_keuangan/models/laporan.dart';
import 'package:capstone_catatan_keuangan/util/CurrencyFormat.dart';

class ListItem extends StatefulWidget {
  final Laporan laporan;
  ListItem({super.key, required this.laporan});

  @override
  State<ListItem> createState() => _ListItemState();
}

class _ListItemState extends State<ListItem> {
  final _firestore = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;

  void deleteLaporan() async {
    try {
      await _firestore.collection('laporan').doc(widget.laporan.docId).delete();

      // menghapus gambar dari storage
      if (widget.laporan.gambar != '') {
        await _storage.refFromURL(widget.laporan.gambar!).delete();
      }
      // Navigator.popAndPushNamed(context, '/reports');
    } catch (e) {
      print(e);
    }
  }

  void showDeleteDialogue() {
    showDialog(
        context: context,
        builder: (BuildContext) {
          return AlertDialog(
            title: Text('Delete ${widget.laporan.judul}?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Batal'),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  deleteLaporan();
                },
                child: Text('Hapus'),
              ),
            ],
          );
        });
  }

  void showActionDialogue() {
    showDialog(
        context: context,
        builder: (BuildContext) {
          return AlertDialog(
            title: Text('Pilih Aksi?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/add',
                      arguments: {'laporan': widget.laporan});
                },
                child: Text('Edit'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  showDeleteDialogue();
                },
                child: Text('Hapus'),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
          border: Border.all(width: 2),
          borderRadius: BorderRadius.circular(10)),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, '/detail', arguments: {
            'laporan': widget.laporan,
          });
        },
        onLongPress: () {
          showActionDialogue();
        },
        child: ListTile(
          leading: Icon(Icons.request_quote_outlined),
          title: Text(widget.laporan.judul),
          subtitle: Text(widget.laporan.deskripsi ?? ''),
          trailing: Text(CurrencyFormat.convertToIdr(widget.laporan.jumlah, 2)),
        ),
      ),
    );
  }
}
