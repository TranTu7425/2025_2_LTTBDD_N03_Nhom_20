import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/quan_ly_ghi_chu.dart';

class ManHinhThongTinNhom extends StatelessWidget {
  const ManHinhThongTinNhom({super.key});

  @override
  Widget build(BuildContext context) {
    final quanLy = Provider.of<QuanLyGhiChu>(context);
    final laTiengViet = quanLy.laTiengViet;

    return Scaffold(
      appBar: AppBar(
        title: Text(laTiengViet ? 'Thông tin nhóm' : 'Team Info'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 60,
              child: Icon(Icons.group, size: 60),
            ),
            const SizedBox(height: 20),
            Text(
              laTiengViet ? 'Nhóm 20' : 'Team 20',
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            _XayDungTheThanhVien(
              laTiengViet ? 'Nguyễn Văn A' : 'Nguyen Van A',
              '20210001',
              laTiengViet ? 'Trưởng nhóm' : 'Team Leader',
            ),
            _XayDungTheThanhVien(
              laTiengViet ? 'Trần Thị B' : 'Tran Thi B',
              '20210002',
              laTiengViet ? 'Lập trình viên' : 'Developer',
            ),
            _XayDungTheThanhVien(
              laTiengViet ? 'Lê Văn C' : 'Le Van C',
              '20210003',
              laTiengViet ? 'Thiết kế UI/UX' : 'UI/UX Designer',
            ),
          ],
        ),
      ),
    );
  }

  Widget _XayDungTheThanhVien(String ten, String mssv, String vaiTro) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        leading: const CircleAvatar(child: Icon(Icons.person)),
        title: Text(ten, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('MSSV: $mssv'),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            vaiTro,
            style: const TextStyle(fontSize: 12, color: Colors.blue),
          ),
        ),
      ),
    );
  }
}
