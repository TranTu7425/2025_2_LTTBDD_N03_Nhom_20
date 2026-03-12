import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/quan_ly_ghi_chu.dart';

class ManHinhCaiDat extends StatelessWidget {
  const ManHinhCaiDat({super.key});

  @override
  Widget build(BuildContext context) {
    final quanLy = Provider.of<QuanLyGhiChu>(context);
    final laTiengViet = quanLy.laTiengViet;

    return Scaffold(
      appBar: AppBar(
        title: Text(laTiengViet ? 'Cài đặt' : 'Settings'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text(laTiengViet ? 'Ngôn ngữ' : 'Language'),
            subtitle: Text(laTiengViet ? 'Tiếng Việt' : 'English'),
            trailing: Switch(
              value: laTiengViet,
              onChanged: (giaTri) => quanLy.doiNgonNgu(),
            ),
          ),
          const Divider(),
          ListTile(
            title: Text(laTiengViet ? 'Chế độ tối' : 'Dark Mode'),
            trailing: Switch(
              value: quanLy.laCheDoToi,
              onChanged: (giaTri) => quanLy.doiCheDoToi(),
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              laTiengViet ? 'Màu chủ đạo' : 'Primary Color',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 60,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _XayDungOChonMau(Colors.blue, quanLy),
                _XayDungOChonMau(Colors.red, quanLy),
                _XayDungOChonMau(Colors.green, quanLy),
                _XayDungOChonMau(Colors.orange, quanLy),
                _XayDungOChonMau(Colors.purple, quanLy),
                _XayDungOChonMau(Colors.pink, quanLy),
                _XayDungOChonMau(Colors.teal, quanLy),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _XayDungOChonMau(Color mau, QuanLyGhiChu quanLy) {
    final laMauDangChon = quanLy.mauChuDao == mau;
    return GestureDetector(
      onTap: () => quanLy.doiMauChuDao(mau),
      child: Container(
        width: 50,
        height: 50,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: mau,
          shape: BoxShape.circle,
          border: laMauDangChon 
            ? Border.all(color: Colors.black, width: 3) 
            : null,
        ),
        child: laMauDangChon 
          ? const Icon(Icons.check, color: Colors.white) 
          : null,
      ),
    );
  }
}
