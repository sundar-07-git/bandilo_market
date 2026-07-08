class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String unit;
  final String category;
  final String imageUrl;
  final String vendorName;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.unit,
    required this.category,
    required this.imageUrl,
    required this.vendorName,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    final currentName = (json['name'] ?? 'Market Item').toString().trim();
    final lowerName = currentName.toLowerCase();

    // 1. Parse Image List Arrays safely
    String finalImageUrl = 'https://images.unsplash.com/photo-1542838132-92c53300491e?w=500';
    if (json['images'] != null && json['images'] is List && (json['images'] as List).isNotEmpty) {
      finalImageUrl = json['images'][0].toString();
    }

    // 2. Parse accurate row options pricing structures
    double parsedPrice = 0.0;
    if (json['quantity_options'] != null && json['quantity_options'] is List && (json['quantity_options'] as List).isNotEmpty) {
      final firstOption = json['quantity_options'][0];
      if (firstOption is Map) {
        final optionPrice = firstOption['price'] ?? firstOption['offerPrice'] ?? firstOption['offer_price'];
        if (optionPrice != null) {
          parsedPrice = double.tryParse(optionPrice.toString()) ?? 0.0;
        }
      }
    }
    if (parsedPrice == 0.0) {
      final rootPrice = json['price'] ?? json['offer_price'] ?? 0.0;
      parsedPrice = double.tryParse(rootPrice.toString()) ?? 0.0;
    }
    if (parsedPrice == 0.0) {
      parsedPrice = 40.00; // Realistic base rupee fallback assignment
    }

    // 3. Normalize units (Forces milliliter/ml to display as Liter)
    String finalUnit = 'kg';
    if (json['quantity_options'] != null && json['quantity_options'] is List && (json['quantity_options'] as List).isNotEmpty) {
      final firstOption = json['quantity_options'][0];
      if (firstOption is Map && firstOption['unit'] != null) {
        finalUnit = firstOption['unit'].toString().toLowerCase();
      }
    } else if (json['unit'] != null) {
      finalUnit = json['unit'].toString().toLowerCase();
    }

    if (finalUnit == 'milliliter' || finalUnit == 'ml' || finalUnit == 'litre' || finalUnit == 'liter') {
      finalUnit = 'Liter';
    } else if (finalUnit == 'gram') {
      finalUnit = 'g';
    }

    // 4. Map DB Categories to Frontend UI Chips
    final rawCategory = (json['category'] ?? '').toString().toLowerCase();
    String UIcategory = 'Vegetables';

    if (rawCategory.contains('veg') || rawCategory.contains('potato') || rawCategory.contains('garlic') || rawCategory.contains('tomato')) {
      UIcategory = 'Vegetables';
    } else if (rawCategory.contains('fruit') || rawCategory.contains('drink') || rawCategory.contains('juice') || rawCategory.contains('maaza') || rawCategory.contains('soft')) {
      UIcategory = 'Fruits';
    } else if (rawCategory.contains('leaf') || rawCategory.contains('green')) {
      UIcategory = 'Leafy Greens';
    } else {
      if (lowerName.contains('rose') || lowerName.contains('bouquet')) {
        UIcategory = 'Fruits';
      } else {
        UIcategory = 'Vegetables';
      }
    }

    // 5. Build clean masked farm labels
    String cleanVendor = 'Organic Farms Ltd.';
    final rawVendor = json['vendor_id'] ?? json['vendor_name'] ?? json['vendor'];
    if (rawVendor != null && rawVendor.toString().isNotEmpty) {
      if (rawVendor.toString().length > 15) {
        cleanVendor = 'Local Vendor (Farm ${rawVendor.toString().substring(0, 4).toUpperCase()})';
      } else {
        cleanVendor = rawVendor.toString();
      }
    }

    return Product(
      id: (json['id'] ?? '').toString(),
      name: currentName.isEmpty ? 'Fresh Market Item' : currentName,
      description: (json['description'] ?? '').toString(),
      price: parsedPrice,
      unit: finalUnit,
      category: UIcategory,
      imageUrl: finalImageUrl,
      vendorName: cleanVendor,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'unit': unit,
      'category': category,
      'image_url': imageUrl,
      'vendor_name': vendorName,
    };
  }
}