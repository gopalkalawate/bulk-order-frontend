sealed class CartEvent {
  const CartEvent();
}

class CartRequested extends CartEvent {
  const CartRequested(this.cycleId);
  final int cycleId;
}

class CurrentCycleCartRequested extends CartEvent {
  const CurrentCycleCartRequested();
}

class CartItemAdded extends CartEvent {
  const CartItemAdded({
    required this.cycleId,
    required this.itemId,
    required this.quantity,
    this.notes = '',
  });
  final int cycleId;
  final int itemId;
  final String quantity;
  final String notes;
}

class CartItemRemoved extends CartEvent {
  const CartItemRemoved({required this.cycleId, required this.itemId});
  final int cycleId;
  final int itemId;
}

class CartItemQuantityUpdated extends CartEvent {
  const CartItemQuantityUpdated({
    required this.cycleId,
    required this.itemId,
    required this.quantity,
  });
  final int cycleId;
  final int itemId;
  final String quantity;
}

class CartCheckoutRequested extends CartEvent {
  const CartCheckoutRequested(this.cycleId);
  final int cycleId;
}
