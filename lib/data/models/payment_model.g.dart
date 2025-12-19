// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_model.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<PaymentFilter> _$paymentFilterSerializer =
    new _$PaymentFilterSerializer();
Serializer<PaymentListResponse> _$paymentListResponseSerializer =
    new _$PaymentListResponseSerializer();
Serializer<PaymentItemResponse> _$paymentItemResponseSerializer =
    new _$PaymentItemResponseSerializer();
Serializer<PaymentEntity> _$paymentEntitySerializer =
    new _$PaymentEntitySerializer();

class _$PaymentFilterSerializer implements StructuredSerializer<PaymentFilter> {
  @override
  final Iterable<Type> types = const [PaymentFilter, _$PaymentFilter];
  @override
  final String wireName = 'PaymentFilter';

  @override
  Iterable<Object?> serialize(Serializers serializers, PaymentFilter object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'searchTerm',
      serializers.serialize(object.searchTerm,
          specifiedType: const FullType(String)),
      'stateFilter',
      serializers.serialize(object.stateFilter,
          specifiedType: const FullType(EntityState)),
      'sortField',
      serializers.serialize(object.sortField,
          specifiedType: const FullType(String)),
      'sortAscending',
      serializers.serialize(object.sortAscending,
          specifiedType: const FullType(bool)),
      'limit',
      serializers.serialize(object.limit, specifiedType: const FullType(int)),
    ];

    return result;
  }

  @override
  PaymentFilter deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new PaymentFilterBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'searchTerm':
          result.searchTerm = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'stateFilter':
          result.stateFilter = serializers.deserialize(value,
              specifiedType: const FullType(EntityState))! as EntityState;
          break;
        case 'sortField':
          result.sortField = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'sortAscending':
          result.sortAscending = serializers.deserialize(value,
              specifiedType: const FullType(bool))! as bool;
          break;
        case 'limit':
          result.limit = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
      }
    }

    return result.build();
  }
}

class _$PaymentListResponseSerializer
    implements StructuredSerializer<PaymentListResponse> {
  @override
  final Iterable<Type> types = const [
    PaymentListResponse,
    _$PaymentListResponse
  ];
  @override
  final String wireName = 'PaymentListResponse';

  @override
  Iterable<Object?> serialize(
      Serializers serializers, PaymentListResponse object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'data',
      serializers.serialize(object.data,
          specifiedType:
              const FullType(BuiltList, const [const FullType(PaymentEntity)])),
    ];

    return result;
  }

  @override
  PaymentListResponse deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new PaymentListResponseBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'data':
          result.data.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(PaymentEntity)]))!
              as BuiltList<Object?>);
          break;
      }
    }

    return result.build();
  }
}

class _$PaymentItemResponseSerializer
    implements StructuredSerializer<PaymentItemResponse> {
  @override
  final Iterable<Type> types = const [
    PaymentItemResponse,
    _$PaymentItemResponse
  ];
  @override
  final String wireName = 'PaymentItemResponse';

  @override
  Iterable<Object?> serialize(
      Serializers serializers, PaymentItemResponse object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'data',
      serializers.serialize(object.data,
          specifiedType: const FullType(PaymentEntity)),
    ];

    return result;
  }

  @override
  PaymentItemResponse deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new PaymentItemResponseBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'data':
          result.data.replace(serializers.deserialize(value,
              specifiedType: const FullType(PaymentEntity))! as PaymentEntity);
          break;
      }
    }

    return result.build();
  }
}

class _$PaymentEntitySerializer implements StructuredSerializer<PaymentEntity> {
  @override
  final Iterable<Type> types = const [PaymentEntity, _$PaymentEntity];
  @override
  final String wireName = 'PaymentEntity';

  @override
  Iterable<Object?> serialize(Serializers serializers, PaymentEntity object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'id',
      serializers.serialize(object.id, specifiedType: const FullType(String)),
      'idempotencyKey',
      serializers.serialize(object.idempotencyKey,
          specifiedType: const FullType(String)),
      'isChanged',
      serializers.serialize(object.isChanged,
          specifiedType: const FullType(bool)),
      'amount',
      serializers.serialize(object.amount,
          specifiedType: const FullType(double)),
      'transactionReference',
      serializers.serialize(object.transactionReference,
          specifiedType: const FullType(String)),
      'date',
      serializers.serialize(object.date, specifiedType: const FullType(String)),
      'typeId',
      serializers.serialize(object.typeId,
          specifiedType: const FullType(String)),
      'privateNotes',
      serializers.serialize(object.privateNotes,
          specifiedType: const FullType(String)),
      'exchangeRate',
      serializers.serialize(object.exchangeRate,
          specifiedType: const FullType(double)),
      'exchangeCurrencyId',
      serializers.serialize(object.exchangeCurrencyId,
          specifiedType: const FullType(String)),
      'refunded',
      serializers.serialize(object.refunded,
          specifiedType: const FullType(double)),
      'applied',
      serializers.serialize(object.applied,
          specifiedType: const FullType(double)),
      'statusId',
      serializers.serialize(object.statusId,
          specifiedType: const FullType(String)),
      'updatedAt',
      serializers.serialize(object.updatedAt,
          specifiedType: const FullType(int)),
      'archivedAt',
      serializers.serialize(object.archivedAt,
          specifiedType: const FullType(int)),
      'isDeleted',
      serializers.serialize(object.isDeleted,
          specifiedType: const FullType(bool)),
      'isManual',
      serializers.serialize(object.isManual,
          specifiedType: const FullType(bool)),
      'paymentables',
      serializers.serialize(object.paymentables,
          specifiedType: const FullType(String)),
      'invoices',
      serializers.serialize(object.invoices,
          specifiedType: const FullType(String)),
      'assignedUserId',
      serializers.serialize(object.assignedUserId,
          specifiedType: const FullType(String)),
      'createdAt',
      serializers.serialize(object.createdAt,
          specifiedType: const FullType(int)),
      'createdUserId',
      serializers.serialize(object.createdUserId,
          specifiedType: const FullType(String)),
      'number',
      serializers.serialize(object.number,
          specifiedType: const FullType(String)),
      'sendEmail',
      serializers.serialize(object.sendEmail,
          specifiedType: const FullType(bool)),
      'companyGatewayId',
      serializers.serialize(object.companyGatewayId,
          specifiedType: const FullType(String)),
      'clientContactId',
      serializers.serialize(object.clientContactId,
          specifiedType: const FullType(String)),
      'currencyId',
      serializers.serialize(object.currencyId,
          specifiedType: const FullType(String)),
      'transactionId',
      serializers.serialize(object.transactionId,
          specifiedType: const FullType(String)),
      'invitationId',
      serializers.serialize(object.invitationId,
          specifiedType: const FullType(String)),
      'isApplying',
      serializers.serialize(object.isApplying,
          specifiedType: const FullType(bool)),
    ];
    Object? value;
    value = object.isReported;
    if (value != null) {
      result
        ..add('reported')
        ..add(
            serializers.serialize(value, specifiedType: const FullType(bool)));
    }
    return result;
  }

  @override
  PaymentEntity deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new PaymentEntityBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'id':
          result.id = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'idempotencyKey':
          result.idempotencyKey = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'isChanged':
          result.isChanged = serializers.deserialize(value,
              specifiedType: const FullType(bool))! as bool;
          break;
        case 'amount':
          result.amount = serializers.deserialize(value,
              specifiedType: const FullType(double))! as double;
          break;
        case 'transactionReference':
          result.transactionReference = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'date':
          result.date = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'typeId':
          result.typeId = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'privateNotes':
          result.privateNotes = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'exchangeRate':
          result.exchangeRate = serializers.deserialize(value,
              specifiedType: const FullType(double))! as double;
          break;
        case 'exchangeCurrencyId':
          result.exchangeCurrencyId = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'refunded':
          result.refunded = serializers.deserialize(value,
              specifiedType: const FullType(double))! as double;
          break;
        case 'applied':
          result.applied = serializers.deserialize(value,
              specifiedType: const FullType(double))! as double;
          break;
        case 'statusId':
          result.statusId = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'updatedAt':
          result.updatedAt = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
        case 'archivedAt':
          result.archivedAt = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
        case 'isDeleted':
          result.isDeleted = serializers.deserialize(value,
              specifiedType: const FullType(bool))! as bool;
          break;
        case 'isManual':
          result.isManual = serializers.deserialize(value,
              specifiedType: const FullType(bool))! as bool;
          break;
        case 'paymentables':
          result.paymentables = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'invoices':
          result.invoices = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'assignedUserId':
          result.assignedUserId = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'createdAt':
          result.createdAt = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
        case 'createdUserId':
          result.createdUserId = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'number':
          result.number = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'sendEmail':
          result.sendEmail = serializers.deserialize(value,
              specifiedType: const FullType(bool))! as bool;
          break;
        case 'companyGatewayId':
          result.companyGatewayId = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'clientContactId':
          result.clientContactId = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'currencyId':
          result.currencyId = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'transactionId':
          result.transactionId = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'invitationId':
          result.invitationId = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'isApplying':
          result.isApplying = serializers.deserialize(value,
              specifiedType: const FullType(bool))! as bool;
          break;
        case 'reported':
          result.isReported = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool?;
          break;
      }
    }

    return result.build();
  }
}

class _$PaymentFilter extends PaymentFilter {
  @override
  final String searchTerm;
  @override
  final EntityState stateFilter;
  @override
  final String sortField;
  @override
  final bool sortAscending;
  @override
  final int limit;

  factory _$PaymentFilter([void Function(PaymentFilterBuilder)? updates]) =>
      (new PaymentFilterBuilder()..update(updates))._build();

  _$PaymentFilter._(
      {required this.searchTerm,
      required this.stateFilter,
      required this.sortField,
      required this.sortAscending,
      required this.limit})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        searchTerm, r'PaymentFilter', 'searchTerm');
    BuiltValueNullFieldError.checkNotNull(
        stateFilter, r'PaymentFilter', 'stateFilter');
    BuiltValueNullFieldError.checkNotNull(
        sortField, r'PaymentFilter', 'sortField');
    BuiltValueNullFieldError.checkNotNull(
        sortAscending, r'PaymentFilter', 'sortAscending');
    BuiltValueNullFieldError.checkNotNull(limit, r'PaymentFilter', 'limit');
  }

  @override
  PaymentFilter rebuild(void Function(PaymentFilterBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PaymentFilterBuilder toBuilder() => new PaymentFilterBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PaymentFilter &&
        searchTerm == other.searchTerm &&
        stateFilter == other.stateFilter &&
        sortField == other.sortField &&
        sortAscending == other.sortAscending &&
        limit == other.limit;
  }

  int? __hashCode;
  @override
  int get hashCode {
    if (__hashCode != null) return __hashCode!;
    var _$hash = 0;
    _$hash = $jc(_$hash, searchTerm.hashCode);
    _$hash = $jc(_$hash, stateFilter.hashCode);
    _$hash = $jc(_$hash, sortField.hashCode);
    _$hash = $jc(_$hash, sortAscending.hashCode);
    _$hash = $jc(_$hash, limit.hashCode);
    _$hash = $jf(_$hash);
    return __hashCode ??= _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PaymentFilter')
          ..add('searchTerm', searchTerm)
          ..add('stateFilter', stateFilter)
          ..add('sortField', sortField)
          ..add('sortAscending', sortAscending)
          ..add('limit', limit))
        .toString();
  }
}

class PaymentFilterBuilder
    implements Builder<PaymentFilter, PaymentFilterBuilder> {
  _$PaymentFilter? _$v;

  String? _searchTerm;
  String? get searchTerm => _$this._searchTerm;
  set searchTerm(String? searchTerm) => _$this._searchTerm = searchTerm;

  EntityState? _stateFilter;
  EntityState? get stateFilter => _$this._stateFilter;
  set stateFilter(EntityState? stateFilter) =>
      _$this._stateFilter = stateFilter;

  String? _sortField;
  String? get sortField => _$this._sortField;
  set sortField(String? sortField) => _$this._sortField = sortField;

  bool? _sortAscending;
  bool? get sortAscending => _$this._sortAscending;
  set sortAscending(bool? sortAscending) =>
      _$this._sortAscending = sortAscending;

  int? _limit;
  int? get limit => _$this._limit;
  set limit(int? limit) => _$this._limit = limit;

  PaymentFilterBuilder();

  PaymentFilterBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _searchTerm = $v.searchTerm;
      _stateFilter = $v.stateFilter;
      _sortField = $v.sortField;
      _sortAscending = $v.sortAscending;
      _limit = $v.limit;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PaymentFilter other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$PaymentFilter;
  }

  @override
  void update(void Function(PaymentFilterBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PaymentFilter build() => _build();

  _$PaymentFilter _build() {
    final _$result = _$v ??
        new _$PaymentFilter._(
            searchTerm: BuiltValueNullFieldError.checkNotNull(
                searchTerm, r'PaymentFilter', 'searchTerm'),
            stateFilter: BuiltValueNullFieldError.checkNotNull(
                stateFilter, r'PaymentFilter', 'stateFilter'),
            sortField: BuiltValueNullFieldError.checkNotNull(
                sortField, r'PaymentFilter', 'sortField'),
            sortAscending: BuiltValueNullFieldError.checkNotNull(
                sortAscending, r'PaymentFilter', 'sortAscending'),
            limit: BuiltValueNullFieldError.checkNotNull(
                limit, r'PaymentFilter', 'limit'));
    replace(_$result);
    return _$result;
  }
}

class _$PaymentListResponse extends PaymentListResponse {
  @override
  final BuiltList<PaymentEntity> data;

  factory _$PaymentListResponse(
          [void Function(PaymentListResponseBuilder)? updates]) =>
      (new PaymentListResponseBuilder()..update(updates))._build();

  _$PaymentListResponse._({required this.data}) : super._() {
    BuiltValueNullFieldError.checkNotNull(data, r'PaymentListResponse', 'data');
  }

  @override
  PaymentListResponse rebuild(
          void Function(PaymentListResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PaymentListResponseBuilder toBuilder() =>
      new PaymentListResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PaymentListResponse && data == other.data;
  }

  int? __hashCode;
  @override
  int get hashCode {
    if (__hashCode != null) return __hashCode!;
    var _$hash = 0;
    _$hash = $jc(_$hash, data.hashCode);
    _$hash = $jf(_$hash);
    return __hashCode ??= _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PaymentListResponse')
          ..add('data', data))
        .toString();
  }
}

class PaymentListResponseBuilder
    implements Builder<PaymentListResponse, PaymentListResponseBuilder> {
  _$PaymentListResponse? _$v;

  ListBuilder<PaymentEntity>? _data;
  ListBuilder<PaymentEntity> get data =>
      _$this._data ??= new ListBuilder<PaymentEntity>();
  set data(ListBuilder<PaymentEntity>? data) => _$this._data = data;

  PaymentListResponseBuilder();

  PaymentListResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _data = $v.data.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PaymentListResponse other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$PaymentListResponse;
  }

  @override
  void update(void Function(PaymentListResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PaymentListResponse build() => _build();

  _$PaymentListResponse _build() {
    _$PaymentListResponse _$result;
    try {
      _$result = _$v ?? new _$PaymentListResponse._(data: data.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'data';
        data.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'PaymentListResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$PaymentItemResponse extends PaymentItemResponse {
  @override
  final PaymentEntity data;

  factory _$PaymentItemResponse(
          [void Function(PaymentItemResponseBuilder)? updates]) =>
      (new PaymentItemResponseBuilder()..update(updates))._build();

  _$PaymentItemResponse._({required this.data}) : super._() {
    BuiltValueNullFieldError.checkNotNull(data, r'PaymentItemResponse', 'data');
  }

  @override
  PaymentItemResponse rebuild(
          void Function(PaymentItemResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PaymentItemResponseBuilder toBuilder() =>
      new PaymentItemResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PaymentItemResponse && data == other.data;
  }

  int? __hashCode;
  @override
  int get hashCode {
    if (__hashCode != null) return __hashCode!;
    var _$hash = 0;
    _$hash = $jc(_$hash, data.hashCode);
    _$hash = $jf(_$hash);
    return __hashCode ??= _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PaymentItemResponse')
          ..add('data', data))
        .toString();
  }
}

class PaymentItemResponseBuilder
    implements Builder<PaymentItemResponse, PaymentItemResponseBuilder> {
  _$PaymentItemResponse? _$v;

  PaymentEntityBuilder? _data;
  PaymentEntityBuilder get data => _$this._data ??= new PaymentEntityBuilder();
  set data(PaymentEntityBuilder? data) => _$this._data = data;

  PaymentItemResponseBuilder();

  PaymentItemResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _data = $v.data.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PaymentItemResponse other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$PaymentItemResponse;
  }

  @override
  void update(void Function(PaymentItemResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PaymentItemResponse build() => _build();

  _$PaymentItemResponse _build() {
    _$PaymentItemResponse _$result;
    try {
      _$result = _$v ?? new _$PaymentItemResponse._(data: data.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'data';
        data.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'PaymentItemResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$PaymentEntity extends PaymentEntity {
  @override
  final String id;
  @override
  final String idempotencyKey;
  @override
  final bool isChanged;
  @override
  final double amount;
  @override
  final String transactionReference;
  @override
  final String date;
  @override
  final String typeId;
  @override
  final String privateNotes;
  @override
  final double exchangeRate;
  @override
  final String exchangeCurrencyId;
  @override
  final double refunded;
  @override
  final double applied;
  @override
  final String statusId;
  @override
  final int updatedAt;
  @override
  final int archivedAt;
  @override
  final bool isDeleted;
  @override
  final bool isManual;
  @override
  final String paymentables;
  @override
  final String invoices;
  @override
  final String assignedUserId;
  @override
  final int createdAt;
  @override
  final String createdUserId;
  @override
  final String number;
  @override
  final bool sendEmail;
  @override
  final String companyGatewayId;
  @override
  final String clientContactId;
  @override
  final String currencyId;
  @override
  final String transactionId;
  @override
  final String invitationId;
  @override
  final bool isApplying;
  @override
  final bool? isReported;

  factory _$PaymentEntity([void Function(PaymentEntityBuilder)? updates]) =>
      (new PaymentEntityBuilder()..update(updates))._build();

  _$PaymentEntity._(
      {required this.id,
      required this.idempotencyKey,
      required this.isChanged,
      required this.amount,
      required this.transactionReference,
      required this.date,
      required this.typeId,
      required this.privateNotes,
      required this.exchangeRate,
      required this.exchangeCurrencyId,
      required this.refunded,
      required this.applied,
      required this.statusId,
      required this.updatedAt,
      required this.archivedAt,
      required this.isDeleted,
      required this.isManual,
      required this.paymentables,
      required this.invoices,
      required this.assignedUserId,
      required this.createdAt,
      required this.createdUserId,
      required this.number,
      required this.sendEmail,
      required this.companyGatewayId,
      required this.clientContactId,
      required this.currencyId,
      required this.transactionId,
      required this.invitationId,
      required this.isApplying,
      this.isReported})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(id, r'PaymentEntity', 'id');
    BuiltValueNullFieldError.checkNotNull(
        idempotencyKey, r'PaymentEntity', 'idempotencyKey');
    BuiltValueNullFieldError.checkNotNull(
        isChanged, r'PaymentEntity', 'isChanged');
    BuiltValueNullFieldError.checkNotNull(amount, r'PaymentEntity', 'amount');
    BuiltValueNullFieldError.checkNotNull(
        transactionReference, r'PaymentEntity', 'transactionReference');
    BuiltValueNullFieldError.checkNotNull(date, r'PaymentEntity', 'date');
    BuiltValueNullFieldError.checkNotNull(typeId, r'PaymentEntity', 'typeId');
    BuiltValueNullFieldError.checkNotNull(
        privateNotes, r'PaymentEntity', 'privateNotes');
    BuiltValueNullFieldError.checkNotNull(
        exchangeRate, r'PaymentEntity', 'exchangeRate');
    BuiltValueNullFieldError.checkNotNull(
        exchangeCurrencyId, r'PaymentEntity', 'exchangeCurrencyId');
    BuiltValueNullFieldError.checkNotNull(
        refunded, r'PaymentEntity', 'refunded');
    BuiltValueNullFieldError.checkNotNull(applied, r'PaymentEntity', 'applied');
    BuiltValueNullFieldError.checkNotNull(
        statusId, r'PaymentEntity', 'statusId');
    BuiltValueNullFieldError.checkNotNull(
        updatedAt, r'PaymentEntity', 'updatedAt');
    BuiltValueNullFieldError.checkNotNull(
        archivedAt, r'PaymentEntity', 'archivedAt');
    BuiltValueNullFieldError.checkNotNull(
        isDeleted, r'PaymentEntity', 'isDeleted');
    BuiltValueNullFieldError.checkNotNull(
        isManual, r'PaymentEntity', 'isManual');
    BuiltValueNullFieldError.checkNotNull(
        paymentables, r'PaymentEntity', 'paymentables');
    BuiltValueNullFieldError.checkNotNull(
        invoices, r'PaymentEntity', 'invoices');
    BuiltValueNullFieldError.checkNotNull(
        assignedUserId, r'PaymentEntity', 'assignedUserId');
    BuiltValueNullFieldError.checkNotNull(
        createdAt, r'PaymentEntity', 'createdAt');
    BuiltValueNullFieldError.checkNotNull(
        createdUserId, r'PaymentEntity', 'createdUserId');
    BuiltValueNullFieldError.checkNotNull(number, r'PaymentEntity', 'number');
    BuiltValueNullFieldError.checkNotNull(
        sendEmail, r'PaymentEntity', 'sendEmail');
    BuiltValueNullFieldError.checkNotNull(
        companyGatewayId, r'PaymentEntity', 'companyGatewayId');
    BuiltValueNullFieldError.checkNotNull(
        clientContactId, r'PaymentEntity', 'clientContactId');
    BuiltValueNullFieldError.checkNotNull(
        currencyId, r'PaymentEntity', 'currencyId');
    BuiltValueNullFieldError.checkNotNull(
        transactionId, r'PaymentEntity', 'transactionId');
    BuiltValueNullFieldError.checkNotNull(
        invitationId, r'PaymentEntity', 'invitationId');
    BuiltValueNullFieldError.checkNotNull(
        isApplying, r'PaymentEntity', 'isApplying');
  }

  @override
  PaymentEntity rebuild(void Function(PaymentEntityBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PaymentEntityBuilder toBuilder() => new PaymentEntityBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PaymentEntity &&
        id == other.id &&
        idempotencyKey == other.idempotencyKey &&
        isChanged == other.isChanged &&
        amount == other.amount &&
        transactionReference == other.transactionReference &&
        date == other.date &&
        typeId == other.typeId &&
        privateNotes == other.privateNotes &&
        exchangeRate == other.exchangeRate &&
        exchangeCurrencyId == other.exchangeCurrencyId &&
        refunded == other.refunded &&
        applied == other.applied &&
        statusId == other.statusId &&
        updatedAt == other.updatedAt &&
        archivedAt == other.archivedAt &&
        isDeleted == other.isDeleted &&
        isManual == other.isManual &&
        paymentables == other.paymentables &&
        invoices == other.invoices &&
        assignedUserId == other.assignedUserId &&
        createdAt == other.createdAt &&
        createdUserId == other.createdUserId &&
        number == other.number &&
        sendEmail == other.sendEmail &&
        companyGatewayId == other.companyGatewayId &&
        clientContactId == other.clientContactId &&
        currencyId == other.currencyId &&
        transactionId == other.transactionId &&
        invitationId == other.invitationId &&
        isApplying == other.isApplying &&
        isReported == other.isReported;
  }

  int? __hashCode;
  @override
  int get hashCode {
    if (__hashCode != null) return __hashCode!;
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, idempotencyKey.hashCode);
    _$hash = $jc(_$hash, isChanged.hashCode);
    _$hash = $jc(_$hash, amount.hashCode);
    _$hash = $jc(_$hash, transactionReference.hashCode);
    _$hash = $jc(_$hash, date.hashCode);
    _$hash = $jc(_$hash, typeId.hashCode);
    _$hash = $jc(_$hash, privateNotes.hashCode);
    _$hash = $jc(_$hash, exchangeRate.hashCode);
    _$hash = $jc(_$hash, exchangeCurrencyId.hashCode);
    _$hash = $jc(_$hash, refunded.hashCode);
    _$hash = $jc(_$hash, applied.hashCode);
    _$hash = $jc(_$hash, statusId.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jc(_$hash, archivedAt.hashCode);
    _$hash = $jc(_$hash, isDeleted.hashCode);
    _$hash = $jc(_$hash, isManual.hashCode);
    _$hash = $jc(_$hash, paymentables.hashCode);
    _$hash = $jc(_$hash, invoices.hashCode);
    _$hash = $jc(_$hash, assignedUserId.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, createdUserId.hashCode);
    _$hash = $jc(_$hash, number.hashCode);
    _$hash = $jc(_$hash, sendEmail.hashCode);
    _$hash = $jc(_$hash, companyGatewayId.hashCode);
    _$hash = $jc(_$hash, clientContactId.hashCode);
    _$hash = $jc(_$hash, currencyId.hashCode);
    _$hash = $jc(_$hash, transactionId.hashCode);
    _$hash = $jc(_$hash, invitationId.hashCode);
    _$hash = $jc(_$hash, isApplying.hashCode);
    _$hash = $jc(_$hash, isReported.hashCode);
    _$hash = $jf(_$hash);
    return __hashCode ??= _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PaymentEntity')
          ..add('id', id)
          ..add('idempotencyKey', idempotencyKey)
          ..add('isChanged', isChanged)
          ..add('amount', amount)
          ..add('transactionReference', transactionReference)
          ..add('date', date)
          ..add('typeId', typeId)
          ..add('privateNotes', privateNotes)
          ..add('exchangeRate', exchangeRate)
          ..add('exchangeCurrencyId', exchangeCurrencyId)
          ..add('refunded', refunded)
          ..add('applied', applied)
          ..add('statusId', statusId)
          ..add('updatedAt', updatedAt)
          ..add('archivedAt', archivedAt)
          ..add('isDeleted', isDeleted)
          ..add('isManual', isManual)
          ..add('paymentables', paymentables)
          ..add('invoices', invoices)
          ..add('assignedUserId', assignedUserId)
          ..add('createdAt', createdAt)
          ..add('createdUserId', createdUserId)
          ..add('number', number)
          ..add('sendEmail', sendEmail)
          ..add('companyGatewayId', companyGatewayId)
          ..add('clientContactId', clientContactId)
          ..add('currencyId', currencyId)
          ..add('transactionId', transactionId)
          ..add('invitationId', invitationId)
          ..add('isApplying', isApplying)
          ..add('isReported', isReported))
        .toString();
  }
}

class PaymentEntityBuilder
    implements Builder<PaymentEntity, PaymentEntityBuilder> {
  _$PaymentEntity? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _idempotencyKey;
  String? get idempotencyKey => _$this._idempotencyKey;
  set idempotencyKey(String? idempotencyKey) =>
      _$this._idempotencyKey = idempotencyKey;

  bool? _isChanged;
  bool? get isChanged => _$this._isChanged;
  set isChanged(bool? isChanged) => _$this._isChanged = isChanged;

  double? _amount;
  double? get amount => _$this._amount;
  set amount(double? amount) => _$this._amount = amount;

  String? _transactionReference;
  String? get transactionReference => _$this._transactionReference;
  set transactionReference(String? transactionReference) =>
      _$this._transactionReference = transactionReference;

  String? _date;
  String? get date => _$this._date;
  set date(String? date) => _$this._date = date;

  String? _typeId;
  String? get typeId => _$this._typeId;
  set typeId(String? typeId) => _$this._typeId = typeId;

  String? _privateNotes;
  String? get privateNotes => _$this._privateNotes;
  set privateNotes(String? privateNotes) => _$this._privateNotes = privateNotes;

  double? _exchangeRate;
  double? get exchangeRate => _$this._exchangeRate;
  set exchangeRate(double? exchangeRate) => _$this._exchangeRate = exchangeRate;

  String? _exchangeCurrencyId;
  String? get exchangeCurrencyId => _$this._exchangeCurrencyId;
  set exchangeCurrencyId(String? exchangeCurrencyId) =>
      _$this._exchangeCurrencyId = exchangeCurrencyId;

  double? _refunded;
  double? get refunded => _$this._refunded;
  set refunded(double? refunded) => _$this._refunded = refunded;

  double? _applied;
  double? get applied => _$this._applied;
  set applied(double? applied) => _$this._applied = applied;

  String? _statusId;
  String? get statusId => _$this._statusId;
  set statusId(String? statusId) => _$this._statusId = statusId;

  int? _updatedAt;
  int? get updatedAt => _$this._updatedAt;
  set updatedAt(int? updatedAt) => _$this._updatedAt = updatedAt;

  int? _archivedAt;
  int? get archivedAt => _$this._archivedAt;
  set archivedAt(int? archivedAt) => _$this._archivedAt = archivedAt;

  bool? _isDeleted;
  bool? get isDeleted => _$this._isDeleted;
  set isDeleted(bool? isDeleted) => _$this._isDeleted = isDeleted;

  bool? _isManual;
  bool? get isManual => _$this._isManual;
  set isManual(bool? isManual) => _$this._isManual = isManual;

  String? _paymentables;
  String? get paymentables => _$this._paymentables;
  set paymentables(String? paymentables) => _$this._paymentables = paymentables;

  String? _invoices;
  String? get invoices => _$this._invoices;
  set invoices(String? invoices) => _$this._invoices = invoices;

  String? _assignedUserId;
  String? get assignedUserId => _$this._assignedUserId;
  set assignedUserId(String? assignedUserId) =>
      _$this._assignedUserId = assignedUserId;

  int? _createdAt;
  int? get createdAt => _$this._createdAt;
  set createdAt(int? createdAt) => _$this._createdAt = createdAt;

  String? _createdUserId;
  String? get createdUserId => _$this._createdUserId;
  set createdUserId(String? createdUserId) =>
      _$this._createdUserId = createdUserId;

  String? _number;
  String? get number => _$this._number;
  set number(String? number) => _$this._number = number;

  bool? _sendEmail;
  bool? get sendEmail => _$this._sendEmail;
  set sendEmail(bool? sendEmail) => _$this._sendEmail = sendEmail;

  String? _companyGatewayId;
  String? get companyGatewayId => _$this._companyGatewayId;
  set companyGatewayId(String? companyGatewayId) =>
      _$this._companyGatewayId = companyGatewayId;

  String? _clientContactId;
  String? get clientContactId => _$this._clientContactId;
  set clientContactId(String? clientContactId) =>
      _$this._clientContactId = clientContactId;

  String? _currencyId;
  String? get currencyId => _$this._currencyId;
  set currencyId(String? currencyId) => _$this._currencyId = currencyId;

  String? _transactionId;
  String? get transactionId => _$this._transactionId;
  set transactionId(String? transactionId) =>
      _$this._transactionId = transactionId;

  String? _invitationId;
  String? get invitationId => _$this._invitationId;
  set invitationId(String? invitationId) => _$this._invitationId = invitationId;

  bool? _isApplying;
  bool? get isApplying => _$this._isApplying;
  set isApplying(bool? isApplying) => _$this._isApplying = isApplying;

  bool? _isReported;
  bool? get isReported => _$this._isReported;
  set isReported(bool? isReported) => _$this._isReported = isReported;

  PaymentEntityBuilder();

  PaymentEntityBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _idempotencyKey = $v.idempotencyKey;
      _isChanged = $v.isChanged;
      _amount = $v.amount;
      _transactionReference = $v.transactionReference;
      _date = $v.date;
      _typeId = $v.typeId;
      _privateNotes = $v.privateNotes;
      _exchangeRate = $v.exchangeRate;
      _exchangeCurrencyId = $v.exchangeCurrencyId;
      _refunded = $v.refunded;
      _applied = $v.applied;
      _statusId = $v.statusId;
      _updatedAt = $v.updatedAt;
      _archivedAt = $v.archivedAt;
      _isDeleted = $v.isDeleted;
      _isManual = $v.isManual;
      _paymentables = $v.paymentables;
      _invoices = $v.invoices;
      _assignedUserId = $v.assignedUserId;
      _createdAt = $v.createdAt;
      _createdUserId = $v.createdUserId;
      _number = $v.number;
      _sendEmail = $v.sendEmail;
      _companyGatewayId = $v.companyGatewayId;
      _clientContactId = $v.clientContactId;
      _currencyId = $v.currencyId;
      _transactionId = $v.transactionId;
      _invitationId = $v.invitationId;
      _isApplying = $v.isApplying;
      _isReported = $v.isReported;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PaymentEntity other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$PaymentEntity;
  }

  @override
  void update(void Function(PaymentEntityBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PaymentEntity build() => _build();

  _$PaymentEntity _build() {
    final _$result = _$v ??
        new _$PaymentEntity._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'PaymentEntity', 'id'),
            idempotencyKey: BuiltValueNullFieldError.checkNotNull(
                idempotencyKey, r'PaymentEntity', 'idempotencyKey'),
            isChanged: BuiltValueNullFieldError.checkNotNull(
                isChanged, r'PaymentEntity', 'isChanged'),
            amount: BuiltValueNullFieldError.checkNotNull(
                amount, r'PaymentEntity', 'amount'),
            transactionReference: BuiltValueNullFieldError.checkNotNull(
                transactionReference, r'PaymentEntity', 'transactionReference'),
            date: BuiltValueNullFieldError.checkNotNull(
                date, r'PaymentEntity', 'date'),
            typeId: BuiltValueNullFieldError.checkNotNull(
                typeId, r'PaymentEntity', 'typeId'),
            privateNotes: BuiltValueNullFieldError.checkNotNull(
                privateNotes, r'PaymentEntity', 'privateNotes'),
            exchangeRate:
                BuiltValueNullFieldError.checkNotNull(exchangeRate, r'PaymentEntity', 'exchangeRate'),
            exchangeCurrencyId: BuiltValueNullFieldError.checkNotNull(exchangeCurrencyId, r'PaymentEntity', 'exchangeCurrencyId'),
            refunded: BuiltValueNullFieldError.checkNotNull(refunded, r'PaymentEntity', 'refunded'),
            applied: BuiltValueNullFieldError.checkNotNull(applied, r'PaymentEntity', 'applied'),
            statusId: BuiltValueNullFieldError.checkNotNull(statusId, r'PaymentEntity', 'statusId'),
            updatedAt: BuiltValueNullFieldError.checkNotNull(updatedAt, r'PaymentEntity', 'updatedAt'),
            archivedAt: BuiltValueNullFieldError.checkNotNull(archivedAt, r'PaymentEntity', 'archivedAt'),
            isDeleted: BuiltValueNullFieldError.checkNotNull(isDeleted, r'PaymentEntity', 'isDeleted'),
            isManual: BuiltValueNullFieldError.checkNotNull(isManual, r'PaymentEntity', 'isManual'),
            paymentables: BuiltValueNullFieldError.checkNotNull(paymentables, r'PaymentEntity', 'paymentables'),
            invoices: BuiltValueNullFieldError.checkNotNull(invoices, r'PaymentEntity', 'invoices'),
            assignedUserId: BuiltValueNullFieldError.checkNotNull(assignedUserId, r'PaymentEntity', 'assignedUserId'),
            createdAt: BuiltValueNullFieldError.checkNotNull(createdAt, r'PaymentEntity', 'createdAt'),
            createdUserId: BuiltValueNullFieldError.checkNotNull(createdUserId, r'PaymentEntity', 'createdUserId'),
            number: BuiltValueNullFieldError.checkNotNull(number, r'PaymentEntity', 'number'),
            sendEmail: BuiltValueNullFieldError.checkNotNull(sendEmail, r'PaymentEntity', 'sendEmail'),
            companyGatewayId: BuiltValueNullFieldError.checkNotNull(companyGatewayId, r'PaymentEntity', 'companyGatewayId'),
            clientContactId: BuiltValueNullFieldError.checkNotNull(clientContactId, r'PaymentEntity', 'clientContactId'),
            currencyId: BuiltValueNullFieldError.checkNotNull(currencyId, r'PaymentEntity', 'currencyId'),
            transactionId: BuiltValueNullFieldError.checkNotNull(transactionId, r'PaymentEntity', 'transactionId'),
            invitationId: BuiltValueNullFieldError.checkNotNull(invitationId, r'PaymentEntity', 'invitationId'),
            isApplying: BuiltValueNullFieldError.checkNotNull(isApplying, r'PaymentEntity', 'isApplying'),
            isReported: isReported);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
