import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
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
  int _chiSoHienTai = 0;

  @override
  Widget build(BuildContext context) {
    final quanLy = Provider.of<QuanLyGhiChu>(context);
    final laTiengViet = quanLy.laTiengViet;
    final danhSachHienThi = quanLy.timKiem(_tuKhoaTimKiem);
    final danhSachNhan = quanLy.danhSachNhan;

    return Scaffold(
      appBar: AppBar(
        title: Text(laTiengViet ? 'Ghi chú của tôi' : 'My Notes'),
        actions: const [
          SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: SearchBar(
              elevation: WidgetStateProperty.all(0),
              backgroundColor: WidgetStateProperty.all(
                Theme.of(
                  context,
                ).colorScheme.surfaceContainerHighest.withOpacity(0.3),
              ),
              hintText: laTiengViet ? 'Tìm kiếm ghi chú...' : 'Search notes...',
              padding: const WidgetStatePropertyAll<EdgeInsets>(
                EdgeInsets.symmetric(horizontal: 16.0),
              ),
              onChanged: (giaTri) {
                setState(() {
                  _tuKhoaTimKiem = giaTri;
                });
              },
              leading: Icon(Icons.search_rounded, color: quanLy.mauChuDao),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 4.0,
            ),
            child: Row(
              children: [
                FilterChip(
                  label: Text(laTiengViet ? 'Tất cả' : 'All'),
                  selected: quanLy.nhanDangLoc == null,
                  onSelected: (selected) {
                    quanLy.locTheoNhan(null);
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
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
                      selectedColor: entry.value.withOpacity(0.2),
                      checkmarkColor: entry.value,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      labelStyle: TextStyle(
                        color: quanLy.nhanDangLoc == entry.key
                            ? entry.value
                            : null,
                        fontWeight: quanLy.nhanDangLoc == entry.key
                            ? FontWeight.bold
                            : null,
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
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.note_alt_outlined,
                          size: 80,
                          color: Colors.grey.withOpacity(0.5),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          laTiengViet ? 'Chưa có ghi chú nào' : 'No notes yet',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey.withOpacity(0.8),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: danhSachHienThi.length,
                    itemBuilder: (context, chiSo) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _XayDungTheGhiChu(danhSachHienThi[chiSo]),
                    ),
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
        child: const Icon(Icons.note_add_rounded, size: 28),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _chiSoHienTai,
        onDestinationSelected: (chiSo) {
          setState(() {
            _chiSoHienTai = chiSo;
          });
          if (chiSo == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ManHinhThongTinNhom()),
            ).then((_) => setState(() => _chiSoHienTai = 0));
          } else if (chiSo == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ManHinhCaiDat()),
            ).then((_) => setState(() => _chiSoHienTai = 0));
          }
        },
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.edit_note_outlined),
            selectedIcon: const Icon(Icons.edit_note_rounded),
            label: laTiengViet ? 'Ghi chú' : 'Notes',
          ),
          NavigationDestination(
            icon: const Icon(Icons.people_outline_rounded),
            selectedIcon: const Icon(Icons.people_rounded),
            label: laTiengViet ? 'Nhóm' : 'Team',
          ),
          NavigationDestination(
            icon: const Icon(Icons.settings_suggest_outlined),
            selectedIcon: const Icon(Icons.settings_suggest_rounded),
            label: laTiengViet ? 'Cài đặt' : 'Settings',
          ),
        ],
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
    final mauNhan = ghiChu.nhan != null
        ? quanLy.danhSachNhan[ghiChu.nhan]
        : null;

    return Dismissible(
      key: Key(ghiChu.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        decoration: BoxDecoration(
          color: Colors.redAccent.withOpacity(0.9),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Icon(
          Icons.delete_sweep_rounded,
          color: Colors.white,
          size: 28,
        ),
      ),
      onDismissed: (huong) {
        quanLy.xoaGhiChu(ghiChu.id);
      },
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => ManHinhSoanThao(ghiChu: ghiChu)),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: mauNhan?.withOpacity(0.1) ?? Theme.of(context).cardTheme.color,
            border: Border.all(
              color:
                  mauNhan?.withOpacity(0.4) ??
                  Theme.of(context).colorScheme.outlineVariant.withOpacity(0.3),
              width: 1.5,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (ghiChu.duongDanAnh != null &&
                    ghiChu.duongDanAnh!.isNotEmpty)
                  SizedBox(
                    height: 130,
                    width: double.infinity,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        kIsWeb
                            ? Image.network(
                                ghiChu.duongDanAnh!,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    _XayDungLoiAnh(),
                              )
                            : Image.file(
                                File(ghiChu.duongDanAnh!),
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    _XayDungLoiAnh(),
                              ),
                        if (mauNhan != null)
                          Positioned(
                            top: 0,
                            left: 0,
                            right: 0,
                            height: 4,
                            child: Container(color: mauNhan),
                          ),
                      ],
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              ghiChu.tieuDe.isEmpty
                                  ? (quanLy.laTiengViet
                                        ? 'Không tiêu đề'
                                        : 'No Title')
                                  : ghiChu.tieuDe,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                                color: ghiChu.tieuDe.isEmpty
                                    ? Colors.grey
                                    : Theme.of(context).colorScheme.onSurface,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (ghiChu.daGhim)
                            Icon(
                              Icons.push_pin_rounded,
                              size: 18,
                              color: quanLy.mauChuDao,
                            ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        ghiChu.noiDung,
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.9),
                          height: 1.4,
                        ),
                        maxLines: ghiChu.duongDanAnh != null ? 2 : 5,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (ghiChu.nhan != null)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: mauNhan?.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: mauNhan?.withOpacity(0.3) ?? Colors.transparent,
                                ),
                              ),
                              child: Text(
                                ghiChu.nhan!,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: mauNhan,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          else
                            const SizedBox(),
                          Text(
                            _dinhDangThoiGian(ghiChu.ngayTao, quanLy.laTiengViet),
                            style: TextStyle(
                              fontSize: 11,
                              color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _XayDungLoiAnh() {
    return Container(
      color: Colors.grey[200],
      child: const Icon(
        Icons.broken_image_rounded,
        color: Colors.grey,
        size: 30,
      ),
    );
  }

  String _dinhDangThoiGian(DateTime thoiGian, bool laTiengViet) {
    final gio = thoiGian.hour.toString().padLeft(2, '0');
    final phut = thoiGian.minute.toString().padLeft(2, '0');
    final ngay = thoiGian.day.toString().padLeft(2, '0');
    final thang = thoiGian.month.toString().padLeft(2, '0');
    final nam = thoiGian.year;

    if (laTiengViet) {
      return '$gio:$phut, $ngay/$thang/$nam';
    } else {
      return '$gio:$phut, $thang/$ngay/$nam';
    }
  }
}
