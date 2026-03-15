import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/quan_ly_ghi_chu.dart';
import '../models/ghi_chu.dart';
import 'man_hinh_soan_thao.dart';
import 'man_hinh_cai_dat.dart';
import 'man_hinh_thong_tin_nhom.dart';

class ManHinhDanhSach extends StatefulWidget {
  const ManHinhDanhSach({super.key});

  @override
  State<ManHinhDanhSach> createState() => _ManHinhDanhSachState();
}

class _ManHinhDanhSachState extends State<ManHinhDanhSach> {
  String _tuKhoaTimKiem = '';

  @override
  Widget build(BuildContext context) {
    final quanLy = Provider.of<QuanLyGhiChu>(context);
    final laTiengViet = quanLy.laTiengViet;
    final danhSachHienThi = quanLy.timKiem(_tuKhoaTimKiem);
    final danhSachNhan = quanLy.danhSachNhan;

    return Scaffold(
      appBar: AppBar(
        title: Text(laTiengViet ? 'Ghi chú của tôi' : 'My Notes'),
        actions: [
          IconButton(
            icon: Icon(quanLy.hienLuoi ? Icons.view_list : Icons.grid_view),
            onPressed: () => quanLy.doiCachHienThi(),
          ),
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ManHinhThongTinNhom()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ManHinhCaiDat()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            child: TextField(
              onChanged: (giaTri) {
                setState(() {
                  _tuKhoaTimKiem = giaTri;
                });
              },
              decoration: InputDecoration(
                hintText: laTiengViet ? 'Tìm kiếm ghi chú...' : 'Search notes...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                filled: true,
                fillColor: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
              ),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
            child: Row(
              children: [
                FilterChip(
                  label: Text(laTiengViet ? 'Tất cả' : 'All'),
                  selected: quanLy.nhanDangLoc == null,
                  onSelected: (selected) {
                    quanLy.locTheoNhan(null);
                  },
                ),
                const SizedBox(width: 8),
                ...danhSachNhan.entries.map((entry) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: FilterChip(
                      label: Text(entry.key),
                      selected: quanLy.nhanDangLoc == entry.key,
                      onSelected: (selected) {
                        quanLy.locTheoNhan(selected ? entry.key : null);
                      },
                      selectedColor: entry.value.withOpacity(0.3),
                      labelStyle: TextStyle(
                        color: quanLy.nhanDangLoc == entry.key ? entry.value : null,
                        fontWeight: quanLy.nhanDangLoc == entry.key ? FontWeight.bold : null,
                      ),
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
          Expanded(
            child: danhSachHienThi.isEmpty
                ? Center(
                    child: Text(
                      laTiengViet ? 'Chưa có ghi chú nào' : 'No notes yet',
                      style: const TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  )
                : quanLy.hienLuoi
                    ? GridView.builder(
                        padding: const EdgeInsets.all(12),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                        itemCount: danhSachHienThi.length,
                        itemBuilder: (context, chiSo) => _XayDungTheGhiChu(danhSachHienThi[chiSo]),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(12),
                        itemCount: danhSachHienThi.length,
                        itemBuilder: (context, chiSo) => _XayDungTheGhiChu(danhSachHienThi[chiSo]),
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ManHinhSoanThao()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _XayDungTheGhiChu extends StatelessWidget {
  final GhiChu ghiChu;
  const _XayDungTheGhiChu(this.ghiChu);

  @override
  Widget build(BuildContext context) {
    final quanLy = Provider.of<QuanLyGhiChu>(context, listen: false);
    final mauNhan = ghiChu.nhan != null ? quanLy.danhSachNhan[ghiChu.nhan] : null;

    return Dismissible(
      key: Key(ghiChu.id),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: Colors.red,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (huong) {
        quanLy.xoaGhiChu(ghiChu.id);
      },
      child: GestureDetector(
        onLongPress: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ManHinhSoanThao(ghiChu: ghiChu),
            ),
          );
        },
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: mauNhan != null 
              ? BorderSide(color: mauNhan.withOpacity(0.5), width: 2) 
              : BorderSide.none,
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        ghiChu.tieuDe,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => quanLy.doiTrangThaiGhim(ghiChu.id),
                      child: Icon(
                        ghiChu.daGhim ? Icons.push_pin : Icons.push_pin_outlined,
                        size: 18,
                        color: ghiChu.daGhim ? quanLy.mauChuDao : Colors.grey,
                      ),
                    ),
                  ],
                ),
                if (ghiChu.nhan != null) ...[
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: mauNhan?.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      ghiChu.nhan!,
                      style: TextStyle(
                        fontSize: 10, 
                        color: mauNhan,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 8),
                Expanded(
                  child: Text(
                    ghiChu.noiDung,
                    style: const TextStyle(fontSize: 14),
                    maxLines: ghiChu.nhan != null ? 3 : 4,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
