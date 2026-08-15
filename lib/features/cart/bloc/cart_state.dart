sealed class CartState {
  const CartState();
}

class CartInitial extends CartState {
  const CartInitial();
}

class CartLoading extends CartState {
  const CartLoading();
}

class CartLoaded extends CartState {
  const CartLoaded(this.cart);
  final Map<String, dynamic> cart;
}

class CartCheckoutSuccess extends CartState {
  const CartCheckoutSuccess(this.order);
  final Map<String, dynamic> order;
}

class CartFailure extends CartState {
  const CartFailure(this.message);
  final String message;
}
