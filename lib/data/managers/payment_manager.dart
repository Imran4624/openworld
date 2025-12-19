import 'package:flutter_boilerplate/data/models/payment_provider_models.dart';
import 'package:flutter_boilerplate/data/providers/payment_provider.dart';

class PaymentManager {
  final Map<PaymentProviderType, PaymentProvider> _providers;

  PaymentManager(this._providers);

  PaymentProvider getProvider(PaymentProviderType type) {
    final provider = _providers[type];
    if (provider == null) {
      throw Exception('Payment provider $type is not configured');
    }
    return provider;
  }

  bool hasProvider(PaymentProviderType type) {
    return _providers.containsKey(type);
  }

  List<PaymentProviderType> get availableProviders => _providers.keys.toList();

  void addProvider(PaymentProviderType type, PaymentProvider provider) {
    _providers[type] = provider;
  }

  void removeProvider(PaymentProviderType type) {
    _providers.remove(type);
  }
}
