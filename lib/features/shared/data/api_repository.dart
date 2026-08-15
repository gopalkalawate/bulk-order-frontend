import 'package:bulk_order_frontend/core/constants/string_constants.dart';
import 'package:bulk_order_frontend/core/network/api_client.dart';
import 'package:bulk_order_frontend/core/network/api_paths.dart';

class ApiRepository {
  const ApiRepository(this._client);
  final ApiClient _client;
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async => _map(
    await _client.post(
      ApiPaths.login,
      body: {'email': email, 'password': password},
    ),
  );
  Future<Map<String, dynamic>> refresh(String token) async =>
      _map(await _client.post(ApiPaths.refresh, body: {'refresh': token}));
  Future<Map<String, dynamic>> currentCycle() async =>
      _map(await _client.get(ApiPaths.currentCycle));
  Future<List<Map<String, dynamic>>> searchItems({
    String query = '',
    int limit = 20,
  }) async => _list(
    await _client.get(
      ApiPaths.itemsSearch,
      query: {
        StringConstants.query: query,
        StringConstants.activeQuery: 'true',
        StringConstants.limitQuery: '$limit',
      },
    ),
  );
  Future<Map<String, dynamic>> cart(int cycleId) async =>
      _map(await _client.get(ApiPaths.cycleCart(cycleId)));
  Future<Map<String, dynamic>> addCartItem(
    int cycleId, {
    required int itemId,
    required String quantity,
    String notes = '',
  }) async => _map(
    await _client.post(
      ApiPaths.cartItems(cycleId),
      body: {'item_id': itemId, 'quantity': quantity, 'notes': notes},
    ),
  );
  Future<Map<String, dynamic>> updateCartItem(
    int cycleId,
    int itemId,
    String quantity,
  ) async => _map(
    await _client.patch(
      ApiPaths.cartItem(cycleId, itemId),
      body: {'quantity': quantity},
    ),
  );
  Future<void> removeCartItem(int cycleId, int itemId) =>
      _client.delete(ApiPaths.cartItem(cycleId, itemId));
  Future<Map<String, dynamic>> checkout(int cycleId) async =>
      _map(await _client.post(ApiPaths.checkout(cycleId)));
  Future<List<Map<String, dynamic>>> orders({int? cycleId}) async => _list(
    await _client.get(
      ApiPaths.orders,
      query: cycleId == null
          ? null
          : {StringConstants.cycleIdQuery: '$cycleId'},
    ),
  );
  Future<Map<String, dynamic>> createOrderCycle(
    Map<String, dynamic> body,
  ) async => _map(await _client.post(ApiPaths.orderCycles, body: body));
  Future<Map<String, dynamic>> cycle(int id) async =>
      _map(await _client.get(ApiPaths.cycle(id)));
  Future<Map<String, dynamic>> closeCycle(int id) async =>
      _map(await _client.post('${ApiPaths.cycle(id)}/close'));
  Future<Map<String, dynamic>> selectLowestQuotes(int id) async =>
      _map(await _client.post('${ApiPaths.cycle(id)}/select-lowest-quotes'));
  Future<Map<String, dynamic>> createCategory(String name) async =>
      _map(await _client.post('items/create-category', body: {'name': name}));
  Future<Map<String, dynamic>> createItem(Map<String, dynamic> body) async =>
      _map(await _client.post('items/create-item', body: body));
  Future<Map<String, dynamic>> updateItem(
    int id,
    Map<String, dynamic> body,
  ) async => _map(await _client.patch(ApiPaths.item(id), body: body));
  Future<List<Map<String, dynamic>>> vendorQuotes() async =>
      _list(await _client.get(ApiPaths.vendorQuotes));
  Future<Map<String, dynamic>> vendorQuote(int id) async =>
      _map(await _client.get(ApiPaths.quote(id)));
  Future<Map<String, dynamic>> setQuoteItems(
    int id,
    List<Map<String, dynamic>> items,
  ) async => _map(await _client.put(ApiPaths.quoteItems(id), body: items));
  Future<Map<String, dynamic>> submitQuote(int id) async =>
      _map(await _client.post(ApiPaths.submitQuote(id)));
  Future<List<Map<String, dynamic>>> purchaseOrders() async =>
      _list(await _client.get(ApiPaths.purchaseOrders));
  Future<Map<String, dynamic>> createVendor(Map<String, dynamic> body) async =>
      _map(await _client.post(ApiPaths.createVendor, body: body));
  Future<Map<String, dynamic>> setVendorLocation(
    Map<String, dynamic> body,
  ) async => _map(await _client.post(ApiPaths.setVendorLocation, body: body));
  Future<List<Map<String, dynamic>>> vendorServiceLocations(
    int vendorId,
  ) async => _list(
    await _client.get(
      ApiPaths.vendorServiceLocations,
      query: {'vendor_id': '$vendorId'},
    ),
  );
  Future<Map<String, dynamic>> addServiceableLocation(
    Map<String, dynamic> body,
  ) async =>
      _map(await _client.post(ApiPaths.addServiceableLocation, body: body));
  Future<void> removeServiceableLocation(Map<String, dynamic> body) =>
      _client.post(ApiPaths.removeServiceableLocation, body: body);
  Future<Map<String, dynamic>> linkVendorPartner(
    int vendorId,
    String userId,
  ) async => _map(
    await _client.post(
      ApiPaths.vendorPartner(vendorId),
      body: {'partner_user_id': userId},
    ),
  );
  Future<Map<String, dynamic>> addVendorItem(int vendorId, int itemId) async =>
      _map(
        await _client.post(
          ApiPaths.vendorItems(vendorId),
          body: {'item_id': itemId},
        ),
      );
  Future<void> removeVendorItem(int vendorId, int itemId) =>
      _client.delete(ApiPaths.vendorItem(vendorId, itemId));
  static Map<String, dynamic> _map(dynamic value) =>
      Map<String, dynamic>.from(value as Map);
  static List<Map<String, dynamic>> _list(dynamic value) => (value as List)
      .map((entry) => Map<String, dynamic>.from(entry as Map))
      .toList();
}
