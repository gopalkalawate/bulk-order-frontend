abstract final class ApiPaths {
  static const login = 'auth/login';
  static const refresh = 'auth/refresh';
  static const currentCycle = 'order-cycles/current';
  static const orderCycles = 'order-cycles';
  static const itemsSearch = 'items/search';
  static const items = 'items';
  static const orders = 'orders';
  static const vendorQuotes = 'vendor-quotes';
  static const purchaseOrders = 'purchase-orders';
  static const vendors = 'vendors';
  static const createVendor = 'vendors/create_vendor';
  static const setVendorLocation = 'vendors/set-vendor-location';
  static const vendorServiceLocations = 'vendors/get-service-locations';
  static const addServiceableLocation = 'vendors/add-serviceable-location';
  static const removeServiceableLocation =
      'vendors/remove-serviceable-location';
  static String cycle(int cycleId) => 'order-cycles/$cycleId';
  static String cycleCart(int cycleId) => '${cycle(cycleId)}/cart';
  static String cartItems(int cycleId) => '${cycleCart(cycleId)}/items';
  static String cartItem(int cycleId, int itemId) =>
      '${cartItems(cycleId)}/$itemId';
  static String checkout(int cycleId) => '${cycle(cycleId)}/checkout';
  static String item(int itemId) => '$items/$itemId';
  static String quote(int quoteId) => '$vendorQuotes/$quoteId';
  static String quoteItems(int quoteId) => '${quote(quoteId)}/items';
  static String submitQuote(int quoteId) => '${quote(quoteId)}/submit';
  static String vendorPartner(int vendorId) => '$vendors/$vendorId/partner';
  static String vendorItems(int vendorId) => '$vendors/$vendorId/items';
  static String vendorItem(int vendorId, int itemId) =>
      '$vendors/$vendorId/items/$itemId';
}
