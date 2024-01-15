import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:capstone_catatan_keuangan/components/styles.dart';
import 'package:capstone_catatan_keuangan/models/laporan.dart';

class StatusDialog extends StatefulWidget {
  final Laporan laporan;

  const StatusDialog({
    required this.laporan,
  });

  @override
  _StatusDialogState createState() => _StatusDialogState();
}

class _StatusDialogState extends State<StatusDialog> {
  final _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: primaryColor,
      content: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        padding: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              widget.laporan.judul,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            // RadioListTile<String>(
            //   title: const Text('Posted'),
            //   value: 'Posted',
            //   groupValue: status,
            //   onChanged: (value) {
            //     setState(() {
            //       status = value!;
            //     });
            //   },
            // ),
            // const SizedBox(height: 20),
            // ElevatedButton(
            //   onPressed: () {
            //     print(status);
            //     updateStatus();
            //   },
            //   style: TextButton.styleFrom(
            //     foregroundColor: Colors.white,
            //     backgroundColor: primaryColor,
            //     shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(10),
            //     ),
            //   ),
            //   child: Text('Simpan Status'),
            // ),
          ],
        ),
      ),
    );
  }
}
