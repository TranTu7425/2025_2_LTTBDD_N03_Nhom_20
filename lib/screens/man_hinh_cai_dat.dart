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
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info_outline_rounded),
            title: Text(laTiengViet ? 'Giới thiệu' : 'About'),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ManHinhThongTinNhom()),
              );
            },
          ),
        ],
      ),
    );
  }
}

class ManHinhThongTinNhom extends StatelessWidget {
  const ManHinhThongTinNhom({super.key});

  @override
  Widget build(BuildContext context) {
    final quanLy = Provider.of<QuanLyGhiChu>(context);
    final laTiengViet = quanLy.laTiengViet;

    return Scaffold(
      appBar: AppBar(
        title: Text(laTiengViet ? 'Giới thiệu' : 'About'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: quanLy.mauChuDao.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.note_alt_rounded,
                      size: 64,
                      color: quanLy.mauChuDao,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'TakeNote',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Version 1.0.0',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey,
                        ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Text(
              laTiengViet ? 'Tổng quan' : 'Overview',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            Text(
              laTiengViet
                  ? 'Ứng dụng ghi chú hiện đại, giúp bạn lưu trữ ý tưởng, công việc và hình ảnh một cách nhanh chóng và tiện lợi. Hỗ trợ phân loại theo nhãn, ghim ghi chú quan trọng và tùy chỉnh giao diện cá nhân hóa.'
                  : 'A modern note-taking app that helps you quickly and conveniently store ideas, tasks, and images. Supports tag classification, pinning important notes, and personalized interface customization.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    height: 1.5,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 32),
            Text(
              laTiengViet ? 'Thành viên nhóm' : 'Team Members',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            _XayDungTheThanhVien(
              context,
              'Trần Anh Tú',
              '23010332',
              quanLy.mauChuDao,
            ),
            _XayDungTheThanhVien(
              context,
              'Cung Đỗ Hải Phong',
              '23010341',
              quanLy.mauChuDao,
            ),
          ],
        ),
      ),
    );
  }

  Widget _XayDungTheThanhVien(
      BuildContext context, String ten, String mssv, Color mauChuDao) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: Theme.of(context).colorScheme.outlineVariant.withOpacity(0.5),
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: mauChuDao.withOpacity(0.1),
          child: Icon(Icons.person_rounded, color: mauChuDao),
        ),
        title: Text(
          ten,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('MSSV: $mssv'),
      ),
    );
  }
}
