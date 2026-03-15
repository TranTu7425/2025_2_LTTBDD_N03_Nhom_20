import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/quan_ly_ghi_chu.dart';
import '../models/ghi_chu.dart';

class ManHinhSoanThao extends StatefulWidget {
  final GhiChu? ghiChu;
  const ManHinhSoanThao({super.key, this.ghiChu});

  @override
  State<ManHinhSoanThao> createState() => _ManHinhSoanThaoState();
}

class _ManHinhSoanThaoState extends State<ManHinhSoanThao> {
  late TextEditingController _boDieuKhienTieuDe;
  late TextEditingController _boDieuKhienNoiDung;
  String? _nhanDuocChon;

  @override
  void initState() {
    super.initState();
    _boDieuKhienTieuDe = TextEditingController(text: widget.ghiChu?.tieuDe ?? '');
    _boDieuKhienNoiDung = TextEditingController(text: widget.ghiChu?.noiDung ?? '');
    _nhanDuocChon = widget.ghiChu?.nhan;
  }

  @override
  void dispose() {
    _boDieuKhienTieuDe.dispose();
    _boDieuKhienNoiDung.dispose();
    super.dispose();
  }

  void _luuGhiChu() {
    final tieuDe = _boDieuKhienTieuDe.text.trim();
    final noiDung = _boDieuKhienNoiDung.text.trim();
    final quanLy = Provider.of<QuanLyGhiChu>(context, listen: false);

    if (tieuDe.isEmpty && noiDung.isEmpty) {
      Navigator.pop(context);
      return;
    }

    if (widget.ghiChu == null) {
      quanLy.themGhiChu(tieuDe, noiDung, nhan: _nhanDuocChon);
    } else {
      quanLy.suaGhiChu(widget.ghiChu!.id, tieuDe, noiDung, nhanMoi: _nhanDuocChon);
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final quanLy = Provider.of<QuanLyGhiChu>(context);
    final laTiengViet = quanLy.laTiengViet;
    final danhSachNhan = quanLy.danhSachNhan;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.ghiChu == null 
            ? (laTiengViet ? 'Thêm ghi chú' : 'Add Note') 
            : (laTiengViet ? 'Sửa ghi chú' : 'Edit Note')
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _luuGhiChu,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _boDieuKhienTieuDe,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                hintText: laTiengViet ? 'Tiêu đề' : 'Title',
                border: InputBorder.none,
              ),
            ),
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ChoiceChip(
                    label: Text(laTiengViet ? 'Không nhãn' : 'No Tag'),
                    selected: _nhanDuocChon == null,
                    onSelected: (selected) {
                      setState(() {
                        _nhanDuocChon = null;
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                  ...danhSachNhan.entries.map((entry) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ChoiceChip(
                        label: Text(entry.key),
                        selected: _nhanDuocChon == entry.key,
                        selectedColor: entry.value.withOpacity(0.3),
                        labelStyle: TextStyle(
                          color: _nhanDuocChon == entry.key ? entry.value : null,
                          fontWeight: _nhanDuocChon == entry.key ? FontWeight.bold : null,
                        ),
                        onSelected: (selected) {
                          setState(() {
                            _nhanDuocChon = selected ? entry.key : null;
                          });
                        },
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
            const Divider(),
            Expanded(
              child: TextField(
                controller: _boDieuKhienNoiDung,
                maxLines: null,
                style: const TextStyle(fontSize: 18),
                decoration: InputDecoration(
                  hintText: laTiengViet ? 'Nội dung ghi chú...' : 'Note content...',
                  border: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
