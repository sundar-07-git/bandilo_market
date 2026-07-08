import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'config/supabase_config.dart';
import 'features/products/views/product_list_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // Add this temporary import

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseConfig.initialize();

  // 🚨 THIS WILL PRINT THE EXACT KEYS IN YOUR TERMINAL
  try {
    final data = await Supabase.instance.client.from('products').select('*').limit(1);
    print("--- 🚨 ACTUAL DATABASE COLUMNS ARE: 🚨 ---");
    print(data);
    print("-----------------------------------------");
  } catch (e) {
    print("Error checking columns: $e");
  }

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bandilo Produce Market',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const ProductListScreen(),
    );
  }
}