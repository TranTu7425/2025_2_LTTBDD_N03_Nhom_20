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
    _boDieuKhienTieuDe = TextEditingController(
      text: widget.ghiChu?.tieuDe ?? '',
    );
    _boDieuKhienNoiDung = TextEditingController(
      text: widget.ghiChu?.noiDung ?? '',
    );
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
      quanLy.themGhiChu(
        tieuDe,
        noiDung,
        nhan: _nhanDuocChon,
        duongDanAnh: _duongDanAnh,
      );
    } else {
      quanLy.suaGhiChu(
        widget.ghiChu!.id,
        tieuDe,
        noiDung,
        nhanMoi: _nhanDuocChon,
        duongDanAnhMoi: _duongDanAnh,
      );
    }
    Navigator.pop(context);
  }

  Widget _XayDungLoiAnh() {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Icon(
        Icons.broken_image_rounded,
        color: Colors.grey,
        size: 40,
      ),
    );
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
              : (laTiengViet ? 'Sửa ghi chú' : 'Edit Note'),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(
              widget.ghiChu?.daGhim ?? false
                  ? Icons.push_pin_rounded
                  : Icons.push_pin_outlined,
              color: widget.ghiChu?.daGhim ?? false ? quanLy.mauChuDao : null,
            ),
            onPressed: () {
              if (widget.ghiChu != null) {
                quanLy.doiTrangThaiGhim(widget.ghiChu!.id);
                setState(() {});
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.add_photo_alternate_rounded),
            onPressed: _chonAnh,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 10.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _boDieuKhienTieuDe,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    decoration: InputDecoration(
                      hintText: laTiengViet ? 'Tiêu đề' : 'Title',
                      hintStyle: TextStyle(color: Colors.grey.withOpacity(0.4)),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  const SizedBox(height: 20),
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
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          backgroundColor: Theme.of(context).colorScheme.surface,
                          selectedColor: Theme.of(context).colorScheme.primary.withOpacity(0.15),
                        ),
                        const SizedBox(width: 10),
                        ...danhSachNhan.entries.map((entry) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 10.0),
                            child: ChoiceChip(
                              label: Text(entry.key),
                              selected: _nhanDuocChon == entry.key,
                              selectedColor: entry.value.withOpacity(0.2),
                              checkmarkColor: entry.value,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              labelStyle: TextStyle(
                                color: _nhanDuocChon == entry.key
                                    ? entry.value
                                    : null,
                                fontWeight: _nhanDuocChon == entry.key
                                    ? FontWeight.bold
                                    : null,
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
                  const SizedBox(height: 16),
                  Divider(
                    height: 1,
                    thickness: 1,
                    color: Theme.of(context).colorScheme.outlineVariant.withOpacity(0.5),
                  ),
                  const SizedBox(height: 20),
                  if (_duongDanAnh != null && _duongDanAnh!.isNotEmpty) ...[
                    Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: Theme.of(context).colorScheme.outlineVariant.withOpacity(0.5),
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.15),
                                blurRadius: 15,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(24),
                            child: kIsWeb
                                ? Image.network(
                                    _duongDanAnh!,
                                    width: double.infinity,
                                    fit: BoxFit.fitWidth,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            _XayDungLoiAnh(),
                                  )
                                : Image.file(
                                    File(_duongDanAnh!),
                                    width: double.infinity,
                                    fit: BoxFit.fitWidth,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            _XayDungLoiAnh(),
                                  ),
                          ),
                        ),
                        Positioned(
                          top: 12,
                          right: 12,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _duongDanAnh = null;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.7),
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white24, width: 1),
                              ),
                              child: const Icon(
                                Icons.close_rounded,
                                color: Colors.white,
                                size: 22,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                  ],
                  TextField(
                    controller: _boDieuKhienNoiDung,
                    maxLines: null,
                    style: TextStyle(
                      fontSize: 19,
                      height: 1.6,
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.9),
                    ),
                    decoration: InputDecoration(
                      hintText: laTiengViet
                          ? 'Nội dung ghi chú...'
                          : 'Note content...',
                      hintStyle: TextStyle(color: Colors.grey.withOpacity(0.4)),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _luuGhiChu,
        label: Text(laTiengViet ? 'Lưu' : 'Save'),
        icon: const Icon(Icons.save_as_rounded),
        extendedPadding: const EdgeInsets.symmetric(horizontal: 24),
      ),
    );
  }
}
