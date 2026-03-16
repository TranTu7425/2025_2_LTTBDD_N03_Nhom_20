import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
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
  String? _duongDanAnh;

  @override
  void initState() {
    super.initState();
    _boDieuKhienTieuDe = TextEditingController(text: widget.ghiChu?.tieuDe ?? '');
    _boDieuKhienNoiDung = TextEditingController(text: widget.ghiChu?.noiDung ?? '');
    _nhanDuocChon = widget.ghiChu?.nhan;
    _duongDanAnh = widget.ghiChu?.duongDanAnh;
  }

  @override
  void dispose() {
    _boDieuKhienTieuDe.dispose();
    _boDieuKhienNoiDung.dispose();
    super.dispose();
  }

  Future<void> _chonAnh() async {
    final boChonAnh = ImagePicker();
    final anhDaChon = await boChonAnh.pickImage(source: ImageSource.gallery);
    
    if (anhDaChon != null) {
      setState(() {
        _duongDanAnh = anhDaChon.path;
      });
    }
  }

  void _luuGhiChu() {
    final tieuDe = _boDieuKhienTieuDe.text.trim();
    final noiDung = _boDieuKhienNoiDung.text.trim();
    final quanLy = Provider.of<QuanLyGhiChu>(context, listen: false);

    if (tieuDe.isEmpty && noiDung.isEmpty && _duongDanAnh == null) {
      Navigator.pop(context);
      return;
    }

    if (widget.ghiChu == null) {
      quanLy.themGhiChu(tieuDe, noiDung, nhan: _nhanDuocChon, duongDanAnh: _duongDanAnh);
    } else {
      quanLy.suaGhiChu(
        widget.ghiChu!.id, 
        tieuDe, 
        noiDung, 
        nhanMoi: _nhanDuocChon, 
        duongDanAnhMoi: _duongDanAnh
      );
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
            icon: const Icon(Icons.image_outlined),
            onPressed: _chonAnh,
          ),
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _luuGhiChu,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
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
              if (_duongDanAnh != null && _duongDanAnh!.isNotEmpty) ...[
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: kIsWeb
                          ? Image.network(
                              _duongDanAnh!,
                              width: double.infinity,
                              height: 200,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  height: 200,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Icon(Icons.broken_image, color: Colors.grey),
                                );
                              },
                            )
                          : Image.file(
                              File(_duongDanAnh!),
                              width: double.infinity,
                              height: 200,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  height: 200,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Icon(Icons.broken_image, color: Colors.grey),
                                );
                              },
                            ),
                    ),
                    Positioned(
                      top: 5,
                      right: 5,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _duongDanAnh = null;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.black54,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.close, color: Colors.white, size: 20),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
              ],
              TextField(
                controller: _boDieuKhienNoiDung,
                maxLines: null,
                style: const TextStyle(fontSize: 18),
                decoration: InputDecoration(
                  hintText: laTiengViet ? 'Nội dung ghi chú...' : 'Note content...',
                  border: InputBorder.none,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
