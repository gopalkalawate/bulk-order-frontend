import 'package:bulk_order_frontend/features/shared/data/api_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

sealed class CatalogState {
  const CatalogState();
}

class CatalogLoading extends CatalogState {
  const CatalogLoading();
}

class CatalogLoaded extends CatalogState {
  const CatalogLoaded({required this.cycle, required this.items});
  final Map<String, dynamic> cycle;
  final List<Map<String, dynamic>> items;
}

class CatalogFailure extends CatalogState {
  const CatalogFailure(this.message);
  final String message;
}

class CatalogBloc extends Cubit<CatalogState> {
  CatalogBloc(this._repository) : super(const CatalogLoading());
  final ApiRepository _repository;
  Future<void> load({String query = ''}) async {
    emit(const CatalogLoading());
    try {
      final values = await Future.wait([
        _repository.currentCycle(),
        _repository.searchItems(query: query),
      ]);
      emit(
        CatalogLoaded(
          cycle: values[0] as Map<String, dynamic>,
          items: values[1] as List<Map<String, dynamic>>,
        ),
      );
    } catch (error) {
      emit(CatalogFailure(error.toString()));
    }
  }
}
