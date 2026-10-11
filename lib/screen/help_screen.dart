import 'package:flutter/material.dart';

/// Bantuan & Dukungan: pertanyaan yang sering diajukan.
class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  static const _faq = [
    ['Bagaimana cara menambah menu?',
        'Tekan tombol + hijau di tengah bawah, pilih resep, lalu tentukan tanggal dan waktu makan. Kamu juga bisa menekan "Tambah" pada slot kosong di tab Rencana.'],
    ['Bagaimana daftar belanja dibuat?',
        'Daftar belanja otomatis terisi dari bahan resep pada rencana menu hari ini dan seterusnya. Bahan yang sama dijumlahkan. Kamu juga bisa menambah bahan manual dengan tombol + di halaman Daftar Belanja.'],
    ['Apa fungsi Checkout?',
        'Centang bahan yang sudah dibeli, lalu tekan Checkout untuk menyelesaikannya. Bahan tersebut akan hilang dari daftar.'],
    ['Bagaimana mengubah target nutrisi?',
        'Buka Profil > Pengaturan > Tujuan & Target, lalu isi target kalori, protein, karbohidrat, dan lemak harianmu.'],
    ['Apakah data saya aman?',
        'Data tersimpan di perangkat ini. Kata sandi disimpan dalam bentuk hash, bukan teks asli.'],
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bantuan & Dukungan')),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            for (final f in _faq)
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE0E0E0)),
                ),
                child: Theme(
                  data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    title: Text(f[0], style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                    childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
                    expandedCrossAxisAlignment: CrossAxisAlignment.start,
                    children: [Text(f[1], style: TextStyle(color: Colors.grey.shade700, height: 1.4))],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
