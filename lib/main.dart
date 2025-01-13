import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app_flutter/screens/splash_screen.dart';
import 'viewmodels/task_viewmodel.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void toggleTheme() {
    setState(() {
      _themeMode =
          _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TaskViewModel(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Notrix',
        themeMode: _themeMode,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF6366F1),
            secondary: const Color(0xFFF43F5E),
            brightness: Brightness.light,
          ),
          scaffoldBackgroundColor: const Color(0xFFF8FAFC),
          useMaterial3: true,
          textTheme: GoogleFonts.interTextTheme(),
          appBarTheme: AppBarTheme(
            elevation: 0,
            centerTitle: true,
            backgroundColor: Colors.transparent,
            titleTextStyle: GoogleFonts.inter(
              color: const Color(0xFF1E293B),
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
          cardTheme: CardTheme(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: const Color(0xFF6366F1),
            foregroundColor: Colors.white,
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          checkboxTheme: CheckboxThemeData(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
            fillColor: MaterialStateProperty.resolveWith<Color>((states) {
              if (states.contains(MaterialState.selected)) {
                return const Color(0xFF6366F1);
              }
              return Colors.transparent;
            }),
          ),
        ),
        darkTheme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF6366F1),
            secondary: const Color(0xFFF43F5E),
            brightness: Brightness.dark,
            background: const Color(0xFF0F1117),
            surface: const Color(0xFF1A1C25),
            onSurface: Colors.grey[300],
          ),
          scaffoldBackgroundColor: const Color(0xFF0F1117),
          useMaterial3: true,
          textTheme:
              GoogleFonts.interTextTheme(ThemeData.dark().textTheme).apply(
            bodyColor: Colors.grey[300],
            displayColor: Colors.white,
          ),
          appBarTheme: AppBarTheme(
            elevation: 0,
            centerTitle: true,
            backgroundColor: Colors.transparent,
            titleTextStyle: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
            iconTheme: const IconThemeData(
              color: Colors.white,
            ),
          ),
          cardTheme: CardTheme(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            color: const Color(0xFF1A1C25),
          ),
          dialogTheme: DialogTheme(
            backgroundColor: const Color(0xFF1A1C25),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 0,
          ),
          bottomSheetTheme: const BottomSheetThemeData(
            backgroundColor: Color(0xFF1A1C25),
            modalBackgroundColor: Color(0xFF1A1C25),
          ),
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: const Color(0xFF6366F1),
            foregroundColor: Colors.white,
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          checkboxTheme: CheckboxThemeData(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
            fillColor: MaterialStateProperty.resolveWith<Color>((states) {
              if (states.contains(MaterialState.selected)) {
                return const Color(0xFF6366F1);
              }
              return Colors.transparent;
            }),
            side: const BorderSide(
              color: Color(0xFF6366F1),
              width: 1.5,
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: const Color(0xFF262931),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            hintStyle: TextStyle(color: Colors.grey[500]),
            labelStyle: TextStyle(color: Colors.grey[400]),
          ),
          popupMenuTheme: PopupMenuThemeData(
            color: const Color(0xFF1A1C25),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 8,
          ),
          dividerTheme: DividerThemeData(
            color: Colors.grey[800],
            thickness: 1,
          ),
          chipTheme: ChipThemeData(
            backgroundColor: const Color(0xFF262931),
            disabledColor: Colors.grey[800],
            selectedColor: const Color(0xFF6366F1),
            secondarySelectedColor: const Color(0xFF6366F1),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            labelStyle: TextStyle(color: Colors.grey[300]),
            secondaryLabelStyle: const TextStyle(color: Colors.white),
            brightness: Brightness.dark,
          ),
        ),
        home: SplashScreen(toggleTheme: toggleTheme),
      ),
    );
  }
}
