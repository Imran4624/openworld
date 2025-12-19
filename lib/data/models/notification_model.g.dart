// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_model.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<NotificationFilter> _$notificationFilterSerializer =
    new _$NotificationFilterSerializer();
Serializer<NotificationListResponse> _$notificationListResponseSerializer =
    new _$NotificationListResponseSerializer();
Serializer<NotificationItemResponse> _$notificationItemResponseSerializer =
    new _$NotificationItemResponseSerializer();
Serializer<NotificationEntity> _$notificationEntitySerializer =
    new _$NotificationEntitySerializer();

class _$NotificationFilterSerializer
    implements StructuredSerializer<NotificationFilter> {
  @override
  final Iterable<Type> types = const [NotificationFilter, _$NotificationFilter];
  @override
  final String wireName = 'NotificationFilter';

  @override
  Iterable<Object?> serialize(
      Serializers serializers, NotificationFilter object,
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
  NotificationFilter deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new NotificationFilterBuilder();

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

class _$NotificationListResponseSerializer
    implements StructuredSerializer<NotificationListResponse> {
  @override
  final Iterable<Type> types = const [
    NotificationListResponse,
    _$NotificationListResponse
  ];
  @override
  final String wireName = 'NotificationListResponse';

  @override
  Iterable<Object?> serialize(
      Serializers serializers, NotificationListResponse object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'data',
      serializers.serialize(object.data,
          specifiedType: const FullType(
              BuiltList, const [const FullType(NotificationEntity)])),
    ];

    return result;
  }

  @override
  NotificationListResponse deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new NotificationListResponseBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'data':
          result.data.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(NotificationEntity)]))!
              as BuiltList<Object?>);
          break;
      }
    }

    return result.build();
  }
}

class _$NotificationItemResponseSerializer
    implements StructuredSerializer<NotificationItemResponse> {
  @override
  final Iterable<Type> types = const [
    NotificationItemResponse,
    _$NotificationItemResponse
  ];
  @override
  final String wireName = 'NotificationItemResponse';

  @override
  Iterable<Object?> serialize(
      Serializers serializers, NotificationItemResponse object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'data',
      serializers.serialize(object.data,
          specifiedType: const FullType(NotificationEntity)),
    ];

    return result;
  }

  @override
  NotificationItemResponse deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new NotificationItemResponseBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'data':
          result.data.replace(serializers.deserialize(value,
                  specifiedType: const FullType(NotificationEntity))!
              as NotificationEntity);
          break;
      }
    }

    return result.build();
  }
}

class _$NotificationEntitySerializer
    implements StructuredSerializer<NotificationEntity> {
  @override
  final Iterable<Type> types = const [NotificationEntity, _$NotificationEntity];
  @override
  final String wireName = 'NotificationEntity';

  @override
  Iterable<Object?> serialize(
      Serializers serializers, NotificationEntity object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'title',
      serializers.serialize(object.title,
          specifiedType: const FullType(String)),
      'body',
      serializers.serialize(object.body, specifiedType: const FullType(String)),
      'type',
      serializers.serialize(object.type, specifiedType: const FullType(String)),
      'channel',
      serializers.serialize(object.channel,
          specifiedType: const FullType(String)),
      'actionUrl',
      serializers.serialize(object.actionUrl,
          specifiedType: const FullType(String)),
      'payload',
      serializers.serialize(object.payload,
          specifiedType: const FullType(String)),
      'priority',
      serializers.serialize(object.priority,
          specifiedType: const FullType(String)),
      'created_at',
      serializers.serialize(object.createdAt,
          specifiedType: const FullType(int)),
      'updated_at',
      serializers.serialize(object.updatedAt,
          specifiedType: const FullType(int)),
      'archived_at',
      serializers.serialize(object.archivedAt,
          specifiedType: const FullType(int)),
      'id',
      serializers.serialize(object.id, specifiedType: const FullType(String)),
    ];
    Object? value;
    value = object.isChanged;
    if (value != null) {
      result
        ..add('isChanged')
        ..add(
            serializers.serialize(value, specifiedType: const FullType(bool)));
    }
    value = object.isDeleted;
    if (value != null) {
      result
        ..add('is_deleted')
        ..add(
            serializers.serialize(value, specifiedType: const FullType(bool)));
    }
    value = object.isReported;
    if (value != null) {
      result
        ..add('reported')
        ..add(
            serializers.serialize(value, specifiedType: const FullType(bool)));
    }
    value = object.createdUserId;
    if (value != null) {
      result
        ..add('user_id')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.assignedUserId;
    if (value != null) {
      result
        ..add('assigned_user_id')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    return result;
  }

  @override
  NotificationEntity deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new NotificationEntityBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'title':
          result.title = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'body':
          result.body = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'type':
          result.type = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'channel':
          result.channel = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'actionUrl':
          result.actionUrl = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'payload':
          result.payload = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'priority':
          result.priority = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'isChanged':
          result.isChanged = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool?;
          break;
        case 'created_at':
          result.createdAt = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
        case 'updated_at':
          result.updatedAt = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
        case 'archived_at':
          result.archivedAt = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
        case 'is_deleted':
          result.isDeleted = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool?;
          break;
        case 'reported':
          result.isReported = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool?;
          break;
        case 'user_id':
          result.createdUserId = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'assigned_user_id':
          result.assignedUserId = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'id':
          result.id = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
      }
    }

    return result.build();
  }
}

class _$NotificationFilter extends NotificationFilter {
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

  factory _$NotificationFilter(
          [void Function(NotificationFilterBuilder)? updates]) =>
      (new NotificationFilterBuilder()..update(updates))._build();

  _$NotificationFilter._(
      {required this.searchTerm,
      required this.stateFilter,
      required this.sortField,
      required this.sortAscending,
      required this.limit})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        searchTerm, r'NotificationFilter', 'searchTerm');
    BuiltValueNullFieldError.checkNotNull(
        stateFilter, r'NotificationFilter', 'stateFilter');
    BuiltValueNullFieldError.checkNotNull(
        sortField, r'NotificationFilter', 'sortField');
    BuiltValueNullFieldError.checkNotNull(
        sortAscending, r'NotificationFilter', 'sortAscending');
    BuiltValueNullFieldError.checkNotNull(
        limit, r'NotificationFilter', 'limit');
  }

  @override
  NotificationFilter rebuild(
          void Function(NotificationFilterBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  NotificationFilterBuilder toBuilder() =>
      new NotificationFilterBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is NotificationFilter &&
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
    return (newBuiltValueToStringHelper(r'NotificationFilter')
          ..add('searchTerm', searchTerm)
          ..add('stateFilter', stateFilter)
          ..add('sortField', sortField)
          ..add('sortAscending', sortAscending)
          ..add('limit', limit))
        .toString();
  }
}

class NotificationFilterBuilder
    implements Builder<NotificationFilter, NotificationFilterBuilder> {
  _$NotificationFilter? _$v;

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

  NotificationFilterBuilder();

  NotificationFilterBuilder get _$this {
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
  void replace(NotificationFilter other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$NotificationFilter;
  }

  @override
  void update(void Function(NotificationFilterBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  NotificationFilter build() => _build();

  _$NotificationFilter _build() {
    final _$result = _$v ??
        new _$NotificationFilter._(
            searchTerm: BuiltValueNullFieldError.checkNotNull(
                searchTerm, r'NotificationFilter', 'searchTerm'),
            stateFilter: BuiltValueNullFieldError.checkNotNull(
                stateFilter, r'NotificationFilter', 'stateFilter'),
            sortField: BuiltValueNullFieldError.checkNotNull(
                sortField, r'NotificationFilter', 'sortField'),
            sortAscending: BuiltValueNullFieldError.checkNotNull(
                sortAscending, r'NotificationFilter', 'sortAscending'),
            limit: BuiltValueNullFieldError.checkNotNull(
                limit, r'NotificationFilter', 'limit'));
    replace(_$result);
    return _$result;
  }
}

class _$NotificationListResponse extends NotificationListResponse {
  @override
  final BuiltList<NotificationEntity> data;

  factory _$NotificationListResponse(
          [void Function(NotificationListResponseBuilder)? updates]) =>
      (new NotificationListResponseBuilder()..update(updates))._build();

  _$NotificationListResponse._({required this.data}) : super._() {
    BuiltValueNullFieldError.checkNotNull(
        data, r'NotificationListResponse', 'data');
  }

  @override
  NotificationListResponse rebuild(
          void Function(NotificationListResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  NotificationListResponseBuilder toBuilder() =>
      new NotificationListResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is NotificationListResponse && data == other.data;
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
    return (newBuiltValueToStringHelper(r'NotificationListResponse')
          ..add('data', data))
        .toString();
  }
}

class NotificationListResponseBuilder
    implements
        Builder<NotificationListResponse, NotificationListResponseBuilder> {
  _$NotificationListResponse? _$v;

  ListBuilder<NotificationEntity>? _data;
  ListBuilder<NotificationEntity> get data =>
      _$this._data ??= new ListBuilder<NotificationEntity>();
  set data(ListBuilder<NotificationEntity>? data) => _$this._data = data;

  NotificationListResponseBuilder();

  NotificationListResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _data = $v.data.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(NotificationListResponse other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$NotificationListResponse;
  }

  @override
  void update(void Function(NotificationListResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  NotificationListResponse build() => _build();

  _$NotificationListResponse _build() {
    _$NotificationListResponse _$result;
    try {
      _$result = _$v ?? new _$NotificationListResponse._(data: data.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'data';
        data.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'NotificationListResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$NotificationItemResponse extends NotificationItemResponse {
  @override
  final NotificationEntity data;

  factory _$NotificationItemResponse(
          [void Function(NotificationItemResponseBuilder)? updates]) =>
      (new NotificationItemResponseBuilder()..update(updates))._build();

  _$NotificationItemResponse._({required this.data}) : super._() {
    BuiltValueNullFieldError.checkNotNull(
        data, r'NotificationItemResponse', 'data');
  }

  @override
  NotificationItemResponse rebuild(
          void Function(NotificationItemResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  NotificationItemResponseBuilder toBuilder() =>
      new NotificationItemResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is NotificationItemResponse && data == other.data;
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
    return (newBuiltValueToStringHelper(r'NotificationItemResponse')
          ..add('data', data))
        .toString();
  }
}

class NotificationItemResponseBuilder
    implements
        Builder<NotificationItemResponse, NotificationItemResponseBuilder> {
  _$NotificationItemResponse? _$v;

  NotificationEntityBuilder? _data;
  NotificationEntityBuilder get data =>
      _$this._data ??= new NotificationEntityBuilder();
  set data(NotificationEntityBuilder? data) => _$this._data = data;

  NotificationItemResponseBuilder();

  NotificationItemResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _data = $v.data.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(NotificationItemResponse other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$NotificationItemResponse;
  }

  @override
  void update(void Function(NotificationItemResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  NotificationItemResponse build() => _build();

  _$NotificationItemResponse _build() {
    _$NotificationItemResponse _$result;
    try {
      _$result = _$v ?? new _$NotificationItemResponse._(data: data.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'data';
        data.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'NotificationItemResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$NotificationEntity extends NotificationEntity {
  @override
  final String title;
  @override
  final String body;
  @override
  final String type;
  @override
  final String channel;
  @override
  final String actionUrl;
  @override
  final String payload;
  @override
  final String priority;
  @override
  final bool? isChanged;
  @override
  final int createdAt;
  @override
  final int updatedAt;
  @override
  final int archivedAt;
  @override
  final bool? isDeleted;
  @override
  final bool? isReported;
  @override
  final String? createdUserId;
  @override
  final String? assignedUserId;
  @override
  final String id;

  factory _$NotificationEntity(
          [void Function(NotificationEntityBuilder)? updates]) =>
      (new NotificationEntityBuilder()..update(updates))._build();

  _$NotificationEntity._(
      {required this.title,
      required this.body,
      required this.type,
      required this.channel,
      required this.actionUrl,
      required this.payload,
      required this.priority,
      this.isChanged,
      required this.createdAt,
      required this.updatedAt,
      required this.archivedAt,
      this.isDeleted,
      this.isReported,
      this.createdUserId,
      this.assignedUserId,
      required this.id})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        title, r'NotificationEntity', 'title');
    BuiltValueNullFieldError.checkNotNull(body, r'NotificationEntity', 'body');
    BuiltValueNullFieldError.checkNotNull(type, r'NotificationEntity', 'type');
    BuiltValueNullFieldError.checkNotNull(
        channel, r'NotificationEntity', 'channel');
    BuiltValueNullFieldError.checkNotNull(
        actionUrl, r'NotificationEntity', 'actionUrl');
    BuiltValueNullFieldError.checkNotNull(
        payload, r'NotificationEntity', 'payload');
    BuiltValueNullFieldError.checkNotNull(
        priority, r'NotificationEntity', 'priority');
    BuiltValueNullFieldError.checkNotNull(
        createdAt, r'NotificationEntity', 'createdAt');
    BuiltValueNullFieldError.checkNotNull(
        updatedAt, r'NotificationEntity', 'updatedAt');
    BuiltValueNullFieldError.checkNotNull(
        archivedAt, r'NotificationEntity', 'archivedAt');
    BuiltValueNullFieldError.checkNotNull(id, r'NotificationEntity', 'id');
  }

  @override
  NotificationEntity rebuild(
          void Function(NotificationEntityBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  NotificationEntityBuilder toBuilder() =>
      new NotificationEntityBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is NotificationEntity &&
        title == other.title &&
        body == other.body &&
        type == other.type &&
        channel == other.channel &&
        actionUrl == other.actionUrl &&
        payload == other.payload &&
        priority == other.priority &&
        isChanged == other.isChanged &&
        createdAt == other.createdAt &&
        updatedAt == other.updatedAt &&
        archivedAt == other.archivedAt &&
        isDeleted == other.isDeleted &&
        isReported == other.isReported &&
        createdUserId == other.createdUserId &&
        assignedUserId == other.assignedUserId &&
        id == other.id;
  }

  int? __hashCode;
  @override
  int get hashCode {
    if (__hashCode != null) return __hashCode!;
    var _$hash = 0;
    _$hash = $jc(_$hash, title.hashCode);
    _$hash = $jc(_$hash, body.hashCode);
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jc(_$hash, channel.hashCode);
    _$hash = $jc(_$hash, actionUrl.hashCode);
    _$hash = $jc(_$hash, payload.hashCode);
    _$hash = $jc(_$hash, priority.hashCode);
    _$hash = $jc(_$hash, isChanged.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jc(_$hash, archivedAt.hashCode);
    _$hash = $jc(_$hash, isDeleted.hashCode);
    _$hash = $jc(_$hash, isReported.hashCode);
    _$hash = $jc(_$hash, createdUserId.hashCode);
    _$hash = $jc(_$hash, assignedUserId.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jf(_$hash);
    return __hashCode ??= _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'NotificationEntity')
          ..add('title', title)
          ..add('body', body)
          ..add('type', type)
          ..add('channel', channel)
          ..add('actionUrl', actionUrl)
          ..add('payload', payload)
          ..add('priority', priority)
          ..add('isChanged', isChanged)
          ..add('createdAt', createdAt)
          ..add('updatedAt', updatedAt)
          ..add('archivedAt', archivedAt)
          ..add('isDeleted', isDeleted)
          ..add('isReported', isReported)
          ..add('createdUserId', createdUserId)
          ..add('assignedUserId', assignedUserId)
          ..add('id', id))
        .toString();
  }
}

class NotificationEntityBuilder
    implements Builder<NotificationEntity, NotificationEntityBuilder> {
  _$NotificationEntity? _$v;

  String? _title;
  String? get title => _$this._title;
  set title(String? title) => _$this._title = title;

  String? _body;
  String? get body => _$this._body;
  set body(String? body) => _$this._body = body;

  String? _type;
  String? get type => _$this._type;
  set type(String? type) => _$this._type = type;

  String? _channel;
  String? get channel => _$this._channel;
  set channel(String? channel) => _$this._channel = channel;

  String? _actionUrl;
  String? get actionUrl => _$this._actionUrl;
  set actionUrl(String? actionUrl) => _$this._actionUrl = actionUrl;

  String? _payload;
  String? get payload => _$this._payload;
  set payload(String? payload) => _$this._payload = payload;

  String? _priority;
  String? get priority => _$this._priority;
  set priority(String? priority) => _$this._priority = priority;

  bool? _isChanged;
  bool? get isChanged => _$this._isChanged;
  set isChanged(bool? isChanged) => _$this._isChanged = isChanged;

  int? _createdAt;
  int? get createdAt => _$this._createdAt;
  set createdAt(int? createdAt) => _$this._createdAt = createdAt;

  int? _updatedAt;
  int? get updatedAt => _$this._updatedAt;
  set updatedAt(int? updatedAt) => _$this._updatedAt = updatedAt;

  int? _archivedAt;
  int? get archivedAt => _$this._archivedAt;
  set archivedAt(int? archivedAt) => _$this._archivedAt = archivedAt;

  bool? _isDeleted;
  bool? get isDeleted => _$this._isDeleted;
  set isDeleted(bool? isDeleted) => _$this._isDeleted = isDeleted;

  bool? _isReported;
  bool? get isReported => _$this._isReported;
  set isReported(bool? isReported) => _$this._isReported = isReported;

  String? _createdUserId;
  String? get createdUserId => _$this._createdUserId;
  set createdUserId(String? createdUserId) =>
      _$this._createdUserId = createdUserId;

  String? _assignedUserId;
  String? get assignedUserId => _$this._assignedUserId;
  set assignedUserId(String? assignedUserId) =>
      _$this._assignedUserId = assignedUserId;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  NotificationEntityBuilder();

  NotificationEntityBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _title = $v.title;
      _body = $v.body;
      _type = $v.type;
      _channel = $v.channel;
      _actionUrl = $v.actionUrl;
      _payload = $v.payload;
      _priority = $v.priority;
      _isChanged = $v.isChanged;
      _createdAt = $v.createdAt;
      _updatedAt = $v.updatedAt;
      _archivedAt = $v.archivedAt;
      _isDeleted = $v.isDeleted;
      _isReported = $v.isReported;
      _createdUserId = $v.createdUserId;
      _assignedUserId = $v.assignedUserId;
      _id = $v.id;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(NotificationEntity other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$NotificationEntity;
  }

  @override
  void update(void Function(NotificationEntityBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  NotificationEntity build() => _build();

  _$NotificationEntity _build() {
    final _$result = _$v ??
        new _$NotificationEntity._(
            title: BuiltValueNullFieldError.checkNotNull(
                title, r'NotificationEntity', 'title'),
            body: BuiltValueNullFieldError.checkNotNull(
                body, r'NotificationEntity', 'body'),
            type: BuiltValueNullFieldError.checkNotNull(
                type, r'NotificationEntity', 'type'),
            channel: BuiltValueNullFieldError.checkNotNull(
                channel, r'NotificationEntity', 'channel'),
            actionUrl: BuiltValueNullFieldError.checkNotNull(
                actionUrl, r'NotificationEntity', 'actionUrl'),
            payload: BuiltValueNullFieldError.checkNotNull(
                payload, r'NotificationEntity', 'payload'),
            priority: BuiltValueNullFieldError.checkNotNull(
                priority, r'NotificationEntity', 'priority'),
            isChanged: isChanged,
            createdAt: BuiltValueNullFieldError.checkNotNull(
                createdAt, r'NotificationEntity', 'createdAt'),
            updatedAt: BuiltValueNullFieldError.checkNotNull(
                updatedAt, r'NotificationEntity', 'updatedAt'),
            archivedAt: BuiltValueNullFieldError.checkNotNull(archivedAt, r'NotificationEntity', 'archivedAt'),
            isDeleted: isDeleted,
            isReported: isReported,
            createdUserId: createdUserId,
            assignedUserId: assignedUserId,
            id: BuiltValueNullFieldError.checkNotNull(id, r'NotificationEntity', 'id'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
