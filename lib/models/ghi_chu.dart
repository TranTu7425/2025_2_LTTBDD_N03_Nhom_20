class GhiChu {
  String id;
  String tieuDe;
  String noiDung;
  DateTime ngayTao;
  bool daXoa;

  GhiChu({
    required this.id,
    required this.tieuDe,
    required this.noiDung,
    required this.ngayTao,
    this.daXoa = false,
  });
}
