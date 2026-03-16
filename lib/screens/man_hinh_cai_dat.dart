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
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            leading: const Icon(Icons.language_rounded),
            title: Text(laTiengViet ? 'Ngôn ngữ' : 'Language'),
            subtitle: Text(laTiengViet ? 'Tiếng Việt' : 'English'),
            trailing: Switch(
              value: laTiengViet,
              onChanged: (giaTri) => quanLy.doiNgonNgu(),
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.dark_mode_rounded),
            title: Text(laTiengViet ? 'Chế độ tối' : 'Dark Mode'),
            trailing: Switch(
              value: quanLy.laCheDoToi,
              onChanged: (giaTri) => quanLy.doiCheDoToi(),
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.color_lens_rounded),
            title: Text(laTiengViet ? 'Màu chủ đạo' : 'Primary Color'),
            trailing: CircleAvatar(
              backgroundColor: quanLy.mauChuDao,
              radius: 15,
            ),
            onTap: () {
              // Hiển thị hộp thoại chọn màu
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(laTiengViet ? 'Chọn màu' : 'Select Color'),
                  content: Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      Colors.blue,
                      Colors.red,
                      Colors.green,
                      Colors.orange,
                      Colors.purple,
                      Colors.pink,
                      Colors.teal,
                    ].map((mau) {
                      return GestureDetector(
                        onTap: () {
                          quanLy.doiMauChuDao(mau);
                          Navigator.pop(context);
                        },
                        child: CircleAvatar(
                          backgroundColor: mau,
                          radius: 20,
                          child: quanLy.mauChuDao == mau
                              ? const Icon(Icons.check, color: Colors.white)
                              : null,
                        ),
                      );
                    }).toList(),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
