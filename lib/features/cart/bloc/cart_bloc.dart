import 'package:bulk_order_frontend/features/cart/bloc/cart_event.dart';
import 'package:bulk_order_frontend/features/cart/bloc/cart_state.dart';
import 'package:bulk_order_frontend/features/shared/data/api_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

export 'cart_event.dart';
export 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc(this._repository) : super(const CartInitial()) {
    on<CartRequested>(_onRequested);
    on<CurrentCycleCartRequested>(_onCurrentCycleRequested);
    on<CartItemAdded>(_onItemAdded);
    on<CartItemRemoved>(_onItemRemoved);
    on<CartItemQuantityUpdated>(_onQuantityUpdated);
    on<CartCheckoutRequested>(_onCheckoutRequested);
  }
  final ApiRepository _repository;

  Future<void> _onCurrentCycleRequested(
    CurrentCycleCartRequested event,
    Emitter<CartState> emit,
  ) async {
    emit(const CartLoading());
    try {
      final cycle = await _repository.currentCycle();
      await _load((cycle['id'] as num).toInt(), emit);
    } catch (error) {
      emit(CartFailure(error.toString()));
    }
  }

  Future<void> _onRequested(
    CartRequested event,
    Emitter<CartState> emit,
  ) async {
    emit(const CartLoading());
    await _load(event.cycleId, emit);
  }

  Future<void> _onItemAdded(
    CartItemAdded event,
    Emitter<CartState> emit,
  ) async {
    try {
      await _repository.addCartItem(
        event.cycleId,
        itemId: event.itemId,
        quantity: event.quantity,
        notes: event.notes,
      );
      await _load(event.cycleId, emit);
    } catch (error) {
      emit(CartFailure(error.toString()));
    }
  }

  Future<void> _onItemRemoved(
    CartItemRemoved event,
    Emitter<CartState> emit,
  ) async {
    try {
      await _repository.removeCartItem(event.cycleId, event.itemId);
      await _load(event.cycleId, emit);
    } catch (error) {
      emit(CartFailure(error.toString()));
    }
  }

  Future<void> _onQuantityUpdated(
    CartItemQuantityUpdated event,
    Emitter<CartState> emit,
  ) async {
    try {
      await _repository.updateCartItem(
        event.cycleId,
        event.itemId,
        event.quantity,
      );
      await _load(event.cycleId, emit);
    } catch (error) {
      emit(CartFailure(error.toString()));
    }
  }

  Future<void> _onCheckoutRequested(CartCheckoutRequested event, Emitter<CartState> emit) async {
    try {
      final order = await _repository.checkout(event.cycleId);
      emit(CartCheckoutSuccess(order));
      await _load(event.cycleId, emit);
    } catch (error) {
      emit(CartFailure(error.toString()));
    }
  }

  Future<void> _load(int cycleId, Emitter<CartState> emit) async {
    try {
      emit(CartLoaded(await _repository.cart(cycleId)));
    } catch (error) {
      emit(CartFailure(error.toString()));
    }
  }
}
