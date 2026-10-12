import 'package:flutter/material.dart';

void main() {
  runApp(const PendaftaranPelatihanApp());
}

class PendaftaranPelatihanApp extends StatelessWidget {
  const PendaftaranPelatihanApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Form Pendaftaran Peserta Pelatihan',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const PendaftaranPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class PendaftaranPage extends StatefulWidget {
  const PendaftaranPage({Key? key}) : super(key: key);

  @override
  State<PendaftaranPage> createState() => _PendaftaranPageState();
}

class _PendaftaranPageState extends State<PendaftaranPage> {
  // GlobalKey untuk validasi form
  final _formKey = GlobalKey<FormState>();

  // Controller untuk teks input
  final _namaController = TextEditingController();
  final _nimController = TextEditingController();
  final _emailController = TextEditingController();
  final _teleponController = TextEditingController();

  // Variabel pilihan pelatihan
  String? _pilihanPelatihan;
  final List<String> _opsiPelatihan = [
    'Flutter Mobile Development',
    'Laravel Web API Development',
    'UI/UX Design Fundamental',
    'Data Science & Analytics',
  ];

  // Variabel untuk mengontrol status tampil ringkasan data
  bool _isSubmitted = false;
  String _namaResult = '';
  String _nimResult = '';
  String _emailResult = '';
  String _teleponResult = '';
  String _pelatihanResult = '';

  @override
  void dispose() {
    _namaController.dispose();
    _nimController.dispose();
    _emailController.dispose();
    _teleponController.dispose();
    super.dispose();
  }

  // Fungsi submit dan validasi
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSubmitted = true;
        _namaResult = _namaController.text;
        _nimResult = _nimController.text;
        _emailResult = _emailController.text;
        _teleponResult = _teleponController.text;
        _pelatihanResult = _pilihanPelatihan ?? '';
      });
    } else {
      setState(() {
        _isSubmitted = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pendaftaran Mahasiswa'),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Lengkapi data berikut',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 16),

              // 1. Input Nama Mahasiswa
              TextFormField(
                controller: _namaController,
                decoration: const InputDecoration(
                  labelText: 'Nama Mahasiswa',
                  hintText: 'Masukkan nama lengkap',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama mahasiswa wajib diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // 2. Input NIM
              TextFormField(
                controller: _nimController,
                decoration: const InputDecoration(
                  labelText: 'NIM',
                  hintText: 'Masukkan NIM',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'NIM wajib diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // 3. Input Email
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  hintText: 'Masukkan email',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email wajib diisi';
                  }
                  // Pemeriksaan format email sederhana
                  if (!value.contains('@') || !value.contains('.')) {
                    return 'Format email tidak valid (harus mengandung @ dan .)';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // 4. Input Nomor Telepon
              TextFormField(
                controller: _teleponController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Nomor Telepon',
                  hintText: 'Masukkan nomor telepon',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nomor telepon wajib diisi';
                  }
                  // Memastikan hanya berisi angka
                  if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                    return 'Nomor telepon hanya boleh berisi angka';
                  }
                  // Minimal 10 digit
                  if (value.length < 10) {
                    return 'Nomor telepon minimal 10 digit';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // 5. Dropdown Pilihan Pelatihan
              DropdownButtonFormField<String>(
                value: _pilihanPelatihan,
                decoration: const InputDecoration(
                  labelText: 'Pilihan Pelatihan',
                  hintText: 'Pilih jenis pelatihan',
                  border: OutlineInputBorder(),
                ),
                items: _opsiPelatihan.map((String pelatihan) {
                  return DropdownMenuItem<String>(
                    value: pelatihan,
                    child: Text(pelatihan),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _pilihanPelatihan = newValue;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Pilihan pelatihan harus ditentukan';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Tombol Daftar
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text(
                    'Daftar',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Ringkasan Data (Hanya tampil jika semua data valid)
              if (_isSubmitted) ...[
                const Divider(thickness: 2),
                const SizedBox(height: 12),
                const Text(
                  'Ringkasan Pendaftaran Peserta',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 8),
                Card(
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Nama Mahasiswa : $_namaResult'),
                        const SizedBox(height: 6),
                        Text('NIM / Identitas : $_nimResult'),
                        const SizedBox(height: 6),
                        Text('Email          : $_emailResult'),
                        const SizedBox(height: 6),
                        Text('Nomor Telepon  : $_teleponResult'),
                        const SizedBox(height: 6),
                        Text('Pilihan Pelatihan: $_pelatihanResult'),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}