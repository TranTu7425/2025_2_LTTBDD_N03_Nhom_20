import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/quan_ly_ghi_chu.dart';
import 'man_hinh_danh_sach.dart';

class ManHinhChao extends StatelessWidget {
  const ManHinhChao({super.key});

  @override
  Widget build(BuildContext context) {
    final quanLy = Provider.of<QuanLyGhiChu>(context);
    final laTiengViet = quanLy.laTiengViet;

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              quanLy.mauChuDao.withOpacity(0.8),
              quanLy.mauChuDao,
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.note_alt_rounded,
              size: 100,
              color: Colors.white,
            ),
            const SizedBox(height: 20),
            Text(
              laTiengViet ? 'Chào mừng bạn!' : 'Welcome!',
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              laTiengViet 
                ? 'Ứng dụng ghi chú đơn giản và hiệu quả' 
                : 'Simple and effective note-taking app',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const ManHinhDanhSach()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: quanLy.mauChuDao,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                laTiengViet ? 'Bắt đầu ngay' : 'Get Started',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
