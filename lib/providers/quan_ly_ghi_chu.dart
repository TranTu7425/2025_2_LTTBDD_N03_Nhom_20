import 'package:flutter/material.dart';
import '../models/ghi_chu.dart';

class QuanLyGhiChu with ChangeNotifier {
  List<GhiChu> _danhSachGhiChu = [];
  bool _laTiengViet = true;
  bool _laCheDoToi = false;
  Color _mauChuDao = Colors.blue;
  bool _hienLuoi = true;

  List<GhiChu> get danhSachGhiChu {
    final danhSach = _danhSachGhiChu.where((gc) => !gc.daXoa).toList();
    danhSach.sort((a, b) {
      if (a.daGhim && !b.daGhim) return -1;
      if (!a.daGhim && b.daGhim) return 1;
      return b.ngayTao.compareTo(a.ngayTao);
    });
    return danhSach;
  }

  bool get laTiengViet => _laTiengViet;
  bool get laCheDoToi => _laCheDoToi;
  Color get mauChuDao => _mauChuDao;
  bool get hienLuoi => _hienLuoi;

  void themGhiChu(String tieuDe, String noiDung) {
    final ghiChuMoi = GhiChu(
      id: DateTime.now().toString(),
      tieuDe: tieuDe,
      noiDung: noiDung,
      ngayTao: DateTime.now(),
    );
    _danhSachGhiChu.add(ghiChuMoi);
    notifyListeners();
  }

  void doiTrangThaiGhim(String id) {
    final chiSo = _danhSachGhiChu.indexWhere((gc) => gc.id == id);
    if (chiSo >= 0) {
      _danhSachGhiChu[chiSo].daGhim = !_danhSachGhiChu[chiSo].daGhim;
      notifyListeners();
    }
  }

  void suaGhiChu(String id, String tieuDeMoi, String noiDungMoi) {
    final chiSo = _danhSachGhiChu.indexWhere((gc) => gc.id == id);
    if (chiSo >= 0) {
      _danhSachGhiChu[chiSo].tieuDe = tieuDeMoi;
      _danhSachGhiChu[chiSo].noiDung = noiDungMoi;
      notifyListeners();
    }
  }

  void xoaGhiChu(String id) {
    _danhSachGhiChu.removeWhere((gc) => gc.id == id);
    notifyListeners();
  }

  void doiNgonNgu() {
    _laTiengViet = !_laTiengViet;
    notifyListeners();
  }

  void doiCheDoToi() {
    _laCheDoToi = !_laCheDoToi;
    notifyListeners();
  }

  void doiMauChuDao(Color mauMoi) {
    _mauChuDao = mauMoi;
    notifyListeners();
  }

  void doiCachHienThi() {
    _hienLuoi = !_hienLuoi;
    notifyListeners();
  }

  List<GhiChu> timKiem(String tuKhoa) {
    if (tuKhoa.isEmpty) return danhSachGhiChu;
    return danhSachGhiChu.where((gc) {
      return gc.tieuDe.toLowerCase().contains(tuKhoa.toLowerCase()) ||
             gc.noiDung.toLowerCase().contains(tuKhoa.toLowerCase());
    }).toList();
  }
}
