import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/quan_ly_ghi_chu.dart';
import 'screens/man_hinh_chao.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => QuanLyGhiChu(),
      child: const TakeNoteApp(),
    ),
  );
}

class TakeNoteApp extends StatelessWidget {
  const TakeNoteApp({super.key});

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
        cardTheme: CardThemeData(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
            side: BorderSide(
              color: quanLy.laCheDoToi ? Colors.white10 : Colors.black.withOpacity(0.05),
              width: 1,
            ),
          ),
          color: quanLy.laCheDoToi ? const Color(0xFF1E1E1E) : Colors.white,
        ),
        appBarTheme: AppBarTheme(
          centerTitle: false,
          elevation: 0,
          scrolledUnderElevation: 0,
          titleTextStyle: TextStyle(
            color: quanLy.laCheDoToi ? Colors.white : Colors.black87,
            fontSize: 24,
            fontWeight: FontWeight.w900,
          ),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      home: const ManHinhChao(),
    );
  }
}
