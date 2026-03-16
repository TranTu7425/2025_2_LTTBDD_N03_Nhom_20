import 'package:flutter/material.dart';
import '../models/ghi_chu.dart';

class QuanLyGhiChu with ChangeNotifier {
  List<GhiChu> _danhSachGhiChu = [];
  bool _laTiengViet = true;
  bool _laCheDoToi = false;
  Color _mauChuDao = Colors.blue;
  bool _hienLuoi = true;
  String? _nhanDangLoc;

  final Map<String, Color> _danhSachNhan = {
    'Công việc': Colors.red,
    'Học tập': Colors.green,
    'Cá nhân': Colors.blue,
    'Quan trọng': Colors.orange,
  };

  final Map<String, Color> _danhSachNhanTiengAnh = {
    'Work': Colors.red,
    'Study': Colors.green,
    'Personal': Colors.blue,
    'Important': Colors.orange,
  };

  List<GhiChu> get danhSachGhiChu {
    var danhSach = _danhSachGhiChu.where((gc) => !gc.daXoa).toList();
    
    if (_nhanDangLoc != null) {
      danhSach = danhSach.where((gc) => gc.nhan == _nhanDangLoc).toList();
    }

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
  String? get nhanDangLoc => _nhanDangLoc;
  Map<String, Color> get danhSachNhan => _laTiengViet ? _danhSachNhan : _danhSachNhanTiengAnh;

  void themGhiChu(String tieuDe, String noiDung, {String? nhan, String? duongDanAnh}) {
    final ghiChuMoi = GhiChu(
      id: DateTime.now().toString(),
      tieuDe: tieuDe,
      noiDung: noiDung,
      ngayTao: DateTime.now(),
      nhan: nhan,
      duongDanAnh: duongDanAnh,
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

  void suaGhiChu(String id, String tieuDeMoi, String noiDungMoi, {String? nhanMoi, String? duongDanAnhMoi}) {
    final chiSo = _danhSachGhiChu.indexWhere((gc) => gc.id == id);
    if (chiSo >= 0) {
      _danhSachGhiChu[chiSo].tieuDe = tieuDeMoi;
      _danhSachGhiChu[chiSo].noiDung = noiDungMoi;
      _danhSachGhiChu[chiSo].nhan = nhanMoi;
      _danhSachGhiChu[chiSo].duongDanAnh = duongDanAnhMoi;
      notifyListeners();
    }
  }

  void xoaGhiChu(String id) {
    _danhSachGhiChu.removeWhere((gc) => gc.id == id);
    notifyListeners();
  }

  void khoiPhucGhiChu(GhiChu ghiChu) {
    _danhSachGhiChu.add(ghiChu);
    notifyListeners();
  }

  void xoaNhieuGhiChu(List<String> danhSachId) {
    _danhSachGhiChu.removeWhere((gc) => danhSachId.contains(gc.id));
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

  void locTheoNhan(String? nhan) {
    _nhanDangLoc = nhan;
    notifyListeners();
  }

  List<GhiChu> timKiem(String tuKhoa) {
    var danhSach = danhSachGhiChu;
    if (tuKhoa.isEmpty) return danhSach;
    return danhSach.where((gc) {
      return gc.tieuDe.toLowerCase().contains(tuKhoa.toLowerCase()) ||
             gc.noiDung.toLowerCase().contains(tuKhoa.toLowerCase());
    }).toList();
  }
}
