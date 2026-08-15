import 'package:bulk_order_frontend/features/shared/data/api_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

sealed class OrdersState {
  const OrdersState();
}

class OrdersLoading extends OrdersState {
  const OrdersLoading();
}

class OrdersLoaded extends OrdersState {
  const OrdersLoaded(this.orders);
  final List<Map<String, dynamic>> orders;
}

class OrdersFailure extends OrdersState {
  const OrdersFailure(this.message);
  final String message;
}

class OrdersBloc extends Cubit<OrdersState> {
  OrdersBloc(this._repository) : super(const OrdersLoading());
  final ApiRepository _repository;
  Future<void> load() async {
    emit(const OrdersLoading());
    try {
      emit(OrdersLoaded(await _repository.orders()));
    } catch (error) {
      emit(OrdersFailure(error.toString()));
    }
  }
}
