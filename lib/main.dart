import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/quan_ly_ghi_chu.dart';
import 'screens/man_hinh_chao.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => QuanLyGhiChu(),
      child: const UngDungGhiChu(),
    ),
  );
}

class UngDungGhiChu extends StatelessWidget {
  const UngDungGhiChu({super.key});

  @override
  Widget build(BuildContext context) {
    final quanLy = Provider.of<QuanLyGhiChu>(context);
    
    return MaterialApp(
      title: 'TakeNote',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: quanLy.mauChuDao,
          brightness: quanLy.laCheDoToi ? Brightness.dark : Brightness.light,
        ),
      ),
      home: const ManHinhChao(),
    );
  }
}
