enum PaymentProviderType {
  stripe,
  paypal,
  razorpay,
}

enum PaymentStatus { 
  pending, 
  succeeded, 
  failed, 
  refunded, 
  cancelled 
}

enum PaymentMethodType {
  card,
  bankAccount,
  wallet,
}

extension PaymentStatusX on PaymentStatus {
  static PaymentStatus fromString(String value) {
    switch (value.toLowerCase()) {
      case 'succeeded':
        return PaymentStatus.succeeded;
      case 'failed':
        return PaymentStatus.failed;
      case 'refunded':
        return PaymentStatus.refunded;
      case 'cancelled':
        return PaymentStatus.cancelled;
      default:
        return PaymentStatus.pending;
    }
  }

  String get value {
    switch (this) {
      case PaymentStatus.pending:
        return 'pending';
      case PaymentStatus.succeeded:
        return 'succeeded';
      case PaymentStatus.failed:
        return 'failed';
      case PaymentStatus.refunded:
        return 'refunded';
      case PaymentStatus.cancelled:
        return 'cancelled';
    }
  }
}

class PaymentIntent {
  final String id;
  final double amount;
  final String currency;
  final String clientSecret;
  final PaymentStatus status;
  final Map<String, dynamic>? metadata;

  PaymentIntent({
    required this.id,
    required this.amount,
    required this.currency,
    required this.clientSecret,
    required this.status,
    this.metadata,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'currency': currency,
      'clientSecret': clientSecret,
      'status': status.value,
      'metadata': metadata,
    };
  }

  factory PaymentIntent.fromMap(Map<String, dynamic> map) {
    return PaymentIntent(
      id: map['id'] ?? '',
      amount: (map['amount'] ?? 0).toDouble(),
      currency: map['currency'] ?? '',
      clientSecret: map['clientSecret'] ?? '',
      status: PaymentStatusX.fromString(map['status'] ?? ''),
      metadata: map['metadata'],
    );
  }
}

class PaymentMethod {
  final String id;
  final PaymentMethodType type;
  final Map<String, dynamic>? card;
  final Map<String, dynamic>? billingDetails;
  final DateTime? created;
  final bool? livemode;

  PaymentMethod({
    required this.id,
    required this.type,
    this.card,
    this.billingDetails,
    this.created,
    this.livemode,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type.name,
      'card': card,
      'billing_details': billingDetails,
      'created': created?.millisecondsSinceEpoch,
      'livemode': livemode,
    };
  }

  factory PaymentMethod.fromMap(Map<String, dynamic> map) {
    PaymentMethodType type;
    switch (map['type']) {
      case 'bankAccount':
        type = PaymentMethodType.bankAccount;
        break;
      case 'wallet':
        type = PaymentMethodType.wallet;
        break;
      default:
        type = PaymentMethodType.card;
    }

    return PaymentMethod(
      id: map['id'] ?? '',
      type: type,
      card: map['card'],
      billingDetails: map['billing_details'],
      created: map['created'] != null 
          ? DateTime.fromMillisecondsSinceEpoch(map['created'] * 1000)
          : null,
      livemode: map['livemode'],
    );
  }
}

class Payment {
  final String id;
  final double amount;
  final String currency;
  final PaymentStatus status;
  final PaymentMethod method;
  final PaymentProviderType provider;
  final DateTime createdAt;
  final String? description;
  final Map<String, dynamic>? metadata;

  Payment({
    required this.id,
    required this.amount,
    required this.currency,
    required this.status,
    required this.method,
    required this.provider,
    required this.createdAt,
    this.description,
    this.metadata,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'currency': currency,
      'status': status.value,
      'method': method.toMap(),
      'provider': provider.name,
      'createdAt': createdAt.toIso8601String(),
      'description': description,
      'metadata': metadata,
    };
  }

  factory Payment.fromMap(Map<String, dynamic> map) {
    PaymentProviderType provider;
    switch (map['provider']) {
      case 'paypal':
        provider = PaymentProviderType.paypal;
        break;
      case 'razorpay':
        provider = PaymentProviderType.razorpay;
        break;
      default:
        provider = PaymentProviderType.stripe;
    }

    return Payment(
      id: map['id'] ?? '',
      amount: (map['amount'] ?? 0).toDouble(),
      currency: map['currency'] ?? '',
      status: PaymentStatusX.fromString(map['status'] ?? ''),
      method: PaymentMethod.fromMap(map['method'] ?? {}),
      provider: provider,
      createdAt: DateTime.parse(map['createdAt'] ?? DateTime.now().toIso8601String()),
      description: map['description'],
      metadata: map['metadata'],
    );
  }
}

class PaymentEvent {
  final String paymentId;
  final PaymentStatus status;
  final Map<String, dynamic>? data;

  PaymentEvent(this.paymentId, this.status, {this.data});

  Map<String, dynamic> toMap() {
    return {
      'paymentId': paymentId,
      'status': status.value,
      'data': data,
    };
  }

  factory PaymentEvent.fromMap(Map<String, dynamic> map) {
    return PaymentEvent(
      map['paymentId'] ?? '',
      PaymentStatusX.fromString(map['status'] ?? ''),
      data: map['data'],
    );
  }
}
