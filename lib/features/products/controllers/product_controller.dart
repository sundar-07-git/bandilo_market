import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../config/supabase_config.dart';
import '../models/product.dart';

class ProductFilterState {
  final String search;
  final String selectedCategory;
  ProductFilterState({this.search = '', this.selectedCategory = 'All'});

  ProductFilterState copyWith({String? search, String? selectedCategory}) {
    return ProductFilterState(
      search: search ?? this.search,
      selectedCategory: selectedCategory ?? this.selectedCategory,
    );
  }
}

final productFilterProvider = StateProvider<ProductFilterState>((ref) => ProductFilterState());

final productsProvider = FutureProvider.autoDispose<List<Product>>((ref) async {
  final filter = ref.watch(productFilterProvider);
  
  var query = supabase.from('products').select('*');
  
  if (filter.selectedCategory != 'All') {
    // Extracts the first keyword (e.g., "Leafy" or "Vegetables") to match database variations flexibly
    final cleanCategory = filter.selectedCategory.split(' ').first;
    query = query.ilike('category', '%$cleanCategory%');
  }
  
  if (filter.search.isNotEmpty) {
    query = query.ilike('name', '%${filter.search}%');
  }

  final response = await query;
  return (response as List).map((json) => Product.fromJson(json)).toList();
});