import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:capstone_catatan_keuangan/components/styles.dart';
import 'package:capstone_catatan_keuangan/components/vars.dart';
import 'package:capstone_catatan_keuangan/models/akun.dart';
import 'package:capstone_catatan_keuangan/models/laporan.dart';
import '../components/input_widget.dart';
import '../components/validators.dart';

class AddFormPage extends StatefulWidget {
  // final Laporan laporan;

  // const AddFormPage({super.key, required this.laporan});
  @override
  State<StatefulWidget> createState() => AddFormState();
}

class AddFormState extends State<AddFormPage> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;
  Laporan? laporan;
  bool _isLoading = false;

  TextEditingController _datecontroller = TextEditingController();
  // var judul;
  // var nominal;
  // var tanggal;
  // var kategori;
  // var deskripsi;
  // var url = '';
  String? judul;
  String? nominal;
  Timestamp? tanggal;
  String? kategori;
  String? deskripsi;
  String url = '';
  String? changedDate;

  ImagePicker picker = ImagePicker();
  XFile? file;

  Image imagePreview() {
    if (file == null) {
      return Image.asset('assets/default.jpeg', width: 180, height: 180);
    } else {
      return Image.file(File(file!.path), width: 180, height: 180);
    }
  }

  Future<dynamic> uploadDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext) {
          return AlertDialog(
            title: Text('Pilih sumber '),
            actions: [
              TextButton(
                onPressed: () async {
                  XFile? upload =
                      await picker.pickImage(source: ImageSource.camera);

                  setState(() {
                    file = upload;
                  });

                  Navigator.of(context).pop();
                },
                child: const Icon(Icons.camera_alt),
              ),
              TextButton(
                onPressed: () async {
                  XFile? upload =
                      await picker.pickImage(source: ImageSource.gallery);
                  setState(() {
                    file = upload;
                  });

                  Navigator.of(context).pop();
                },
                child: const Icon(Icons.photo_library),
              ),
            ],
          );
        });
  }

  Future<String> uploadImage() async {
    if (file == null) return '';

    String uniqueFilename = DateTime.now().millisecondsSinceEpoch.toString();

    try {
      Reference dirUpload =
          _storage.ref().child('upload/${_auth.currentUser!.uid}');
      Reference storedDir = dirUpload.child(uniqueFilename);

      await storedDir.putFile(File(file!.path));

      return await storedDir.getDownloadURL();
    } catch (e) {
      return '';
    }
  }

  void addTransaksi() async {
    setState(() {
      _isLoading = true;
    });
    try {
      CollectionReference laporanCollection = _firestore.collection('laporan');

      // Convert DateTime to Firestore Timestamp
      // Timestamp timestamp = Timestamp.fromDate(DateTime.now());

      url = await uploadImage();

      final id = laporanCollection.doc().id;

      await laporanCollection.doc(id).set({
        'uid': _auth.currentUser!.uid,
        'docId': id,
        'judul': judul,
        'kategori': kategori,
        'deskripsi': deskripsi,
        'gambar': url,
        'tanggal': tanggal,
        'jumlah': nominal,
      }).catchError((e) {
        throw e;
      });
      Navigator.pop(context);
    } catch (e) {
      final snackbar = SnackBar(content: Text(e.toString()));
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void editTransaksi(String id) async {
    setState(() {
      _isLoading = true;
    });
    try {
      CollectionReference laporanCollection = _firestore.collection('laporan');

      if (file == null) {
        await laporanCollection.doc(id).update({
          'judul': judul,
          'kategori': kategori,
          'deskripsi': deskripsi,
          'tanggal': tanggal,
          'jumlah': nominal,
        }).catchError((e) {
          throw e;
        });
        Navigator.pop(context);
      } else {
        String url = await uploadImage();
        if (laporan!.gambar != '') {
          await _storage.refFromURL(laporan!.gambar!).delete();
        }
        await laporanCollection.doc(id).update({
          'judul': judul,
          'kategori': kategori,
          'deskripsi': deskripsi,
          'gambar': url,
          'tanggal': tanggal,
          'jumlah': nominal,
        }).catchError((e) {
          throw e;
        });
        Navigator.pop(context);
      }
    } catch (e) {
      final snackbar = SnackBar(content: Text(e.toString()));
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _selectDate() async {
    DateTime? _picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2100));

    if (_picked != null) {
      setState(() {
        _datecontroller.text = _picked.toString().split(" ")[0];
        tanggal = Timestamp.fromDate(_picked);
        // print(_datecontroller.text);
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    final widgetsBinding = WidgetsBinding.instance;
    widgetsBinding.addPostFrameCallback((callback) {
      if (ModalRoute.of(context)!.settings.arguments != null) {
        final arguments =
            ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

        laporan = arguments['laporan'];
        tanggal = Timestamp.fromDate(laporan!.tanggal);
        _datecontroller.text = laporan!.tanggal.toString().substring(0, 10);
        kategori = laporan!.kategori;
        judul = laporan!.judul;
        deskripsi = laporan!.deskripsi;
        nominal = laporan!.jumlah;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic>? arguments;
    Laporan? laporan;
    if (ModalRoute.of(context)!.settings.arguments != null) {
      arguments =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      laporan = arguments['laporan'];
    }

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
        title: Text('Tambah Laporan',
            style: headerStyle(level: 3, color: Colors.white)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Form(
                  child: Container(
                    margin: EdgeInsets.all(40),
                    child: Column(
                      children: [
                        InputLayout(
                            'Judul Laporan',
                            TextFormField(
                                initialValue:
                                    laporan == null ? '' : laporan.judul,
                                onChanged: (String value) => setState(() {
                                      judul = value;
                                    }),
                                validator: notEmptyValidator,
                                decoration:
                                    customInputDecoration("Judul laporan"))),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 10),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 10),
                          child: imagePreview(),
                        ),
                        Container(
                          width: double.infinity,
                          margin: EdgeInsets.only(bottom: 10),
                          child: ElevatedButton(
                              onPressed: () {
                                uploadDialog(context);
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.photo_camera),
                                  Text(' Foto Pendukung',
                                      style: headerStyle(level: 3)),
                                ],
                              )),
                        ),
                        InputLayout(
                            'Nominal',
                            TextFormField(
                                initialValue:
                                    laporan == null ? '' : laporan.jumlah,
                                onChanged: (String value) => setState(() {
                                      nominal = value;
                                    }),
                                keyboardType: TextInputType.number,
                                validator: notEmptyValidator,
                                decoration: customInputDecoration("Nominal"))),
                        InputLayout(
                            'Tanggal',
                            TextFormField(
                                readOnly: true,
                                controller: _datecontroller,
                                // onChanged: (value) {
                                //   _datecontroller.selection =
                                //       TextSelection.fromPosition(
                                //           TextPosition(offset: value.length));
                                // },
                                onTap: () {
                                  _selectDate();
                                },
                                validator: notEmptyValidator,
                                decoration: customInputDecoration("Tanggal"))),
                        InputLayout(
                            'Kategori',
                            DropdownButtonFormField<String>(
                                value: kategori,
                                decoration: customInputDecoration('Kategori'),
                                items: dataKategori.map((e) {
                                  return DropdownMenuItem<String>(
                                      child: Text(e), value: e);
                                }).toList(),
                                onChanged: (selected) {
                                  setState(() {
                                    kategori = selected;
                                  });
                                })),
                        InputLayout(
                            "Deskripsi laporan",
                            TextFormField(
                              initialValue:
                                  laporan == null ? '' : laporan.deskripsi,
                              onChanged: (String value) => setState(() {
                                deskripsi = value;
                              }),
                              keyboardType: TextInputType.multiline,
                              minLines: 3,
                              maxLines: 5,
                              decoration: customInputDecoration(
                                  'Deskripsikan semua di sini'),
                            )),
                        SizedBox(height: 30),
                        Container(
                          width: double.infinity,
                          child: FilledButton(
                              style: buttonStyle,
                              onPressed: () {
                                if (laporan != null) {
                                  editTransaksi(laporan.docId);
                                } else {
                                  addTransaksi();
                                }
                              },
                              child: Text(
                                'Kirim Laporan',
                                style:
                                    headerStyle(level: 3, color: Colors.white),
                              )),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
