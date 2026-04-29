class ProductResponse {
  List<ProductModel>? products;
  ProductResponse.fromJson(Map<String, dynamic> json) {
    if (json["products"] != null) {
      products = <ProductModel>[];
      json["products"].forEache((v) {
        products!.add(ProductModel.fromJson(v));
      });
    }
  }
}

class ProductModel {
  String? name;
  String? quantity;
  String? descripion;
  String? minQuan;

  ProductModel.fromJson(Map<String, dynamic> json) {
    name = json["name"];
    quantity = json["quantity"];
    descripion = json["descripion"];
    minQuan = json["minQuan"];
  }
}
