class CodeScannedModel {
  String codeCart;
  int cartType;
  // 0  : Mobilis 2000 , 1  : Mobilis 1000 ,  2  : Mobilis 500 ,
  // 3  : Mobilis 200 (1 line) ,  4  : Mobilis 200 (2 lines) ,
  CodeScannedModel({required this.codeCart, required this.cartType});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CodeScannedModel &&
          runtimeType == other.runtimeType &&
          codeCart == other.codeCart &&
          cartType == other.cartType;

  // Override hashCode to ensure hash-based collections work correctly
  @override
  int get hashCode => codeCart.hashCode ^ cartType.hashCode;
}
