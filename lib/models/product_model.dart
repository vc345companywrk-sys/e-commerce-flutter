// Add this Product model
class Product {
  final String id;
  final String name;
  final double price;
  final String image;
  final String category;
  final String description;
  final bool inStock;
  //final double rating;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    required this.category,
    required this.description,
    required this.inStock,
    //required this.rating,
  });
}
