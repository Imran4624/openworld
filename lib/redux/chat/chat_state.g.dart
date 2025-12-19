// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_state.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<ChatState> _$chatStateSerializer = new _$ChatStateSerializer();
Serializer<MessageState> _$messageStateSerializer =
    new _$MessageStateSerializer();
Serializer<ChatUIState> _$chatUIStateSerializer = new _$ChatUIStateSerializer();

class _$ChatStateSerializer implements StructuredSerializer<ChatState> {
  @override
  final Iterable<Type> types = const [ChatState, _$ChatState];
  @override
  final String wireName = 'ChatState';

  @override
  Iterable<Object?> serialize(Serializers serializers, ChatState object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'map',
      serializers.serialize(object.map,
          specifiedType: const FullType(BuiltMap,
              const [const FullType(String), const FullType(ChatEntity)])),
      'list',
      serializers.serialize(object.list,
          specifiedType:
              const FullType(BuiltList, const [const FullType(String)])),
      'filter',
      serializers.serialize(object.filter,
          specifiedType: const FullType(ChatFilter)),
      'messageState',
      serializers.serialize(object.messageState,
          specifiedType: const FullType(MessageState)),
    ];
    Object? value;
    value = object.lastDocument;
    if (value != null) {
      result
        ..add('lastDocument')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(
                DocumentSnapshot, const [const FullType.nullable(Object)])));
    }
    return result;
  }

  @override
  ChatState deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new ChatStateBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'map':
          result.map.replace(serializers.deserialize(value,
              specifiedType: const FullType(BuiltMap, const [
                const FullType(String),
                const FullType(ChatEntity)
              ]))!);
          break;
        case 'list':
          result.list.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(String)]))!
              as BuiltList<Object?>);
          break;
        case 'lastDocument':
          result.lastDocument = serializers.deserialize(value,
              specifiedType: const FullType(DocumentSnapshot, const [
                const FullType.nullable(Object)
              ])) as DocumentSnapshot<Object?>?;
          break;
        case 'filter':
          result.filter.replace(serializers.deserialize(value,
              specifiedType: const FullType(ChatFilter))! as ChatFilter);
          break;
        case 'messageState':
          result.messageState.replace(serializers.deserialize(value,
              specifiedType: const FullType(MessageState))! as MessageState);
          break;
      }
    }

    return result.build();
  }
}

class _$MessageStateSerializer implements StructuredSerializer<MessageState> {
  @override
  final Iterable<Type> types = const [MessageState, _$MessageState];
  @override
  final String wireName = 'MessageState';

  @override
  Iterable<Object?> serialize(Serializers serializers, MessageState object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'map',
      serializers.serialize(object.map,
          specifiedType: const FullType(BuiltMap, const [
            const FullType(String),
            const FullType(ChatMessageEntity)
          ])),
      'list',
      serializers.serialize(object.list,
          specifiedType:
              const FullType(BuiltList, const [const FullType(String)])),
      'streamedMessages',
      serializers.serialize(object.streamedMessages,
          specifiedType: const FullType(
              BuiltList, const [const FullType(ChatMessageEntity)])),
    ];
    Object? value;
    value = object.lastMessageDocument;
    if (value != null) {
      result
        ..add('lastMessageDocument')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(
                DocumentSnapshot, const [const FullType.nullable(Object)])));
    }
    return result;
  }

  @override
  MessageState deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new MessageStateBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'lastMessageDocument':
          result.lastMessageDocument = serializers.deserialize(value,
              specifiedType: const FullType(DocumentSnapshot, const [
                const FullType.nullable(Object)
              ])) as DocumentSnapshot<Object?>?;
          break;
        case 'map':
          result.map.replace(serializers.deserialize(value,
              specifiedType: const FullType(BuiltMap, const [
                const FullType(String),
                const FullType(ChatMessageEntity)
              ]))!);
          break;
        case 'list':
          result.list.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(String)]))!
              as BuiltList<Object?>);
          break;
        case 'streamedMessages':
          result.streamedMessages.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(ChatMessageEntity)]))!
              as BuiltList<Object?>);
          break;
      }
    }

    return result.build();
  }
}

class _$ChatUIStateSerializer implements StructuredSerializer<ChatUIState> {
  @override
  final Iterable<Type> types = const [ChatUIState, _$ChatUIState];
  @override
  final String wireName = 'ChatUIState';

  @override
  Iterable<Object?> serialize(Serializers serializers, ChatUIState object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'messageIds',
      serializers.serialize(object.messageIds,
          specifiedType:
              const FullType(BuiltList, const [const FullType(String)])),
      'listUIState',
      serializers.serialize(object.listUIState,
          specifiedType: const FullType(ListUIState)),
      'tabIndex',
      serializers.serialize(object.tabIndex,
          specifiedType: const FullType(int)),
    ];
    Object? value;
    value = object.editing;
    if (value != null) {
      result
        ..add('editing')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(ChatEntity)));
    }
    value = object.selectedId;
    if (value != null) {
      result
        ..add('selectedId')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.forceSelected;
    if (value != null) {
      result
        ..add('forceSelected')
        ..add(
            serializers.serialize(value, specifiedType: const FullType(bool)));
    }
    return result;
  }

  @override
  ChatUIState deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new ChatUIStateBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'editing':
          result.editing.replace(serializers.deserialize(value,
              specifiedType: const FullType(ChatEntity))! as ChatEntity);
          break;
        case 'messageIds':
          result.messageIds.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(String)]))!
              as BuiltList<Object?>);
          break;
        case 'listUIState':
          result.listUIState.replace(serializers.deserialize(value,
              specifiedType: const FullType(ListUIState))! as ListUIState);
          break;
        case 'selectedId':
          result.selectedId = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'forceSelected':
          result.forceSelected = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool?;
          break;
        case 'tabIndex':
          result.tabIndex = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
      }
    }

    return result.build();
  }
}

class _$ChatState extends ChatState {
  @override
  final BuiltMap<String, ChatEntity> map;
  @override
  final BuiltList<String> list;
  @override
  final DocumentSnapshot<Object?>? lastDocument;
  @override
  final ChatFilter filter;
  @override
  final MessageState messageState;

  factory _$ChatState([void Function(ChatStateBuilder)? updates]) =>
      (new ChatStateBuilder()..update(updates))._build();

  _$ChatState._(
      {required this.map,
      required this.list,
      this.lastDocument,
      required this.filter,
      required this.messageState})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(map, r'ChatState', 'map');
    BuiltValueNullFieldError.checkNotNull(list, r'ChatState', 'list');
    BuiltValueNullFieldError.checkNotNull(filter, r'ChatState', 'filter');
    BuiltValueNullFieldError.checkNotNull(
        messageState, r'ChatState', 'messageState');
  }

  @override
  ChatState rebuild(void Function(ChatStateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ChatStateBuilder toBuilder() => new ChatStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ChatState &&
        map == other.map &&
        list == other.list &&
        lastDocument == other.lastDocument &&
        filter == other.filter &&
        messageState == other.messageState;
  }

  int? __hashCode;
  @override
  int get hashCode {
    if (__hashCode != null) return __hashCode!;
    var _$hash = 0;
    _$hash = $jc(_$hash, map.hashCode);
    _$hash = $jc(_$hash, list.hashCode);
    _$hash = $jc(_$hash, lastDocument.hashCode);
    _$hash = $jc(_$hash, filter.hashCode);
    _$hash = $jc(_$hash, messageState.hashCode);
    _$hash = $jf(_$hash);
    return __hashCode ??= _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ChatState')
          ..add('map', map)
          ..add('list', list)
          ..add('lastDocument', lastDocument)
          ..add('filter', filter)
          ..add('messageState', messageState))
        .toString();
  }
}

class ChatStateBuilder implements Builder<ChatState, ChatStateBuilder> {
  _$ChatState? _$v;

  MapBuilder<String, ChatEntity>? _map;
  MapBuilder<String, ChatEntity> get map =>
      _$this._map ??= new MapBuilder<String, ChatEntity>();
  set map(MapBuilder<String, ChatEntity>? map) => _$this._map = map;

  ListBuilder<String>? _list;
  ListBuilder<String> get list => _$this._list ??= new ListBuilder<String>();
  set list(ListBuilder<String>? list) => _$this._list = list;

  DocumentSnapshot<Object?>? _lastDocument;
  DocumentSnapshot<Object?>? get lastDocument => _$this._lastDocument;
  set lastDocument(DocumentSnapshot<Object?>? lastDocument) =>
      _$this._lastDocument = lastDocument;

  ChatFilterBuilder? _filter;
  ChatFilterBuilder get filter => _$this._filter ??= new ChatFilterBuilder();
  set filter(ChatFilterBuilder? filter) => _$this._filter = filter;

  MessageStateBuilder? _messageState;
  MessageStateBuilder get messageState =>
      _$this._messageState ??= new MessageStateBuilder();
  set messageState(MessageStateBuilder? messageState) =>
      _$this._messageState = messageState;

  ChatStateBuilder();

  ChatStateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _map = $v.map.toBuilder();
      _list = $v.list.toBuilder();
      _lastDocument = $v.lastDocument;
      _filter = $v.filter.toBuilder();
      _messageState = $v.messageState.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ChatState other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$ChatState;
  }

  @override
  void update(void Function(ChatStateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ChatState build() => _build();

  _$ChatState _build() {
    _$ChatState _$result;
    try {
      _$result = _$v ??
          new _$ChatState._(
              map: map.build(),
              list: list.build(),
              lastDocument: lastDocument,
              filter: filter.build(),
              messageState: messageState.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'map';
        map.build();
        _$failedField = 'list';
        list.build();

        _$failedField = 'filter';
        filter.build();
        _$failedField = 'messageState';
        messageState.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'ChatState', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$MessageState extends MessageState {
  @override
  final DocumentSnapshot<Object?>? lastMessageDocument;
  @override
  final BuiltMap<String, ChatMessageEntity> map;
  @override
  final BuiltList<String> list;
  @override
  final Stream<List<ChatMessageEntity>>? messageStream;
  @override
  final BuiltList<ChatMessageEntity> streamedMessages;

  factory _$MessageState([void Function(MessageStateBuilder)? updates]) =>
      (new MessageStateBuilder()..update(updates))._build();

  _$MessageState._(
      {this.lastMessageDocument,
      required this.map,
      required this.list,
      this.messageStream,
      required this.streamedMessages})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(map, r'MessageState', 'map');
    BuiltValueNullFieldError.checkNotNull(list, r'MessageState', 'list');
    BuiltValueNullFieldError.checkNotNull(
        streamedMessages, r'MessageState', 'streamedMessages');
  }

  @override
  MessageState rebuild(void Function(MessageStateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  MessageStateBuilder toBuilder() => new MessageStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MessageState &&
        lastMessageDocument == other.lastMessageDocument &&
        map == other.map &&
        list == other.list &&
        messageStream == other.messageStream &&
        streamedMessages == other.streamedMessages;
  }

  int? __hashCode;
  @override
  int get hashCode {
    if (__hashCode != null) return __hashCode!;
    var _$hash = 0;
    _$hash = $jc(_$hash, lastMessageDocument.hashCode);
    _$hash = $jc(_$hash, map.hashCode);
    _$hash = $jc(_$hash, list.hashCode);
    _$hash = $jc(_$hash, messageStream.hashCode);
    _$hash = $jc(_$hash, streamedMessages.hashCode);
    _$hash = $jf(_$hash);
    return __hashCode ??= _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MessageState')
          ..add('lastMessageDocument', lastMessageDocument)
          ..add('map', map)
          ..add('list', list)
          ..add('messageStream', messageStream)
          ..add('streamedMessages', streamedMessages))
        .toString();
  }
}

class MessageStateBuilder
    implements Builder<MessageState, MessageStateBuilder> {
  _$MessageState? _$v;

  DocumentSnapshot<Object?>? _lastMessageDocument;
  DocumentSnapshot<Object?>? get lastMessageDocument =>
      _$this._lastMessageDocument;
  set lastMessageDocument(DocumentSnapshot<Object?>? lastMessageDocument) =>
      _$this._lastMessageDocument = lastMessageDocument;

  MapBuilder<String, ChatMessageEntity>? _map;
  MapBuilder<String, ChatMessageEntity> get map =>
      _$this._map ??= new MapBuilder<String, ChatMessageEntity>();
  set map(MapBuilder<String, ChatMessageEntity>? map) => _$this._map = map;

  ListBuilder<String>? _list;
  ListBuilder<String> get list => _$this._list ??= new ListBuilder<String>();
  set list(ListBuilder<String>? list) => _$this._list = list;

  Stream<List<ChatMessageEntity>>? _messageStream;
  Stream<List<ChatMessageEntity>>? get messageStream => _$this._messageStream;
  set messageStream(Stream<List<ChatMessageEntity>>? messageStream) =>
      _$this._messageStream = messageStream;

  ListBuilder<ChatMessageEntity>? _streamedMessages;
  ListBuilder<ChatMessageEntity> get streamedMessages =>
      _$this._streamedMessages ??= new ListBuilder<ChatMessageEntity>();
  set streamedMessages(ListBuilder<ChatMessageEntity>? streamedMessages) =>
      _$this._streamedMessages = streamedMessages;

  MessageStateBuilder();

  MessageStateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _lastMessageDocument = $v.lastMessageDocument;
      _map = $v.map.toBuilder();
      _list = $v.list.toBuilder();
      _messageStream = $v.messageStream;
      _streamedMessages = $v.streamedMessages.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MessageState other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$MessageState;
  }

  @override
  void update(void Function(MessageStateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MessageState build() => _build();

  _$MessageState _build() {
    _$MessageState _$result;
    try {
      _$result = _$v ??
          new _$MessageState._(
              lastMessageDocument: lastMessageDocument,
              map: map.build(),
              list: list.build(),
              messageStream: messageStream,
              streamedMessages: streamedMessages.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'map';
        map.build();
        _$failedField = 'list';
        list.build();

        _$failedField = 'streamedMessages';
        streamedMessages.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'MessageState', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$ChatUIState extends ChatUIState {
  @override
  final ChatEntity? editing;
  @override
  final BuiltList<String> messageIds;
  @override
  final ListUIState listUIState;
  @override
  final String? selectedId;
  @override
  final bool? forceSelected;
  @override
  final int tabIndex;
  @override
  final Completer<SelectableEntity>? saveCompleter;
  @override
  final Completer<Null>? cancelCompleter;

  factory _$ChatUIState([void Function(ChatUIStateBuilder)? updates]) =>
      (new ChatUIStateBuilder()..update(updates))._build();

  _$ChatUIState._(
      {this.editing,
      required this.messageIds,
      required this.listUIState,
      this.selectedId,
      this.forceSelected,
      required this.tabIndex,
      this.saveCompleter,
      this.cancelCompleter})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        messageIds, r'ChatUIState', 'messageIds');
    BuiltValueNullFieldError.checkNotNull(
        listUIState, r'ChatUIState', 'listUIState');
    BuiltValueNullFieldError.checkNotNull(tabIndex, r'ChatUIState', 'tabIndex');
  }

  @override
  ChatUIState rebuild(void Function(ChatUIStateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ChatUIStateBuilder toBuilder() => new ChatUIStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ChatUIState &&
        editing == other.editing &&
        messageIds == other.messageIds &&
        listUIState == other.listUIState &&
        selectedId == other.selectedId &&
        forceSelected == other.forceSelected &&
        tabIndex == other.tabIndex &&
        saveCompleter == other.saveCompleter &&
        cancelCompleter == other.cancelCompleter;
  }

  int? __hashCode;
  @override
  int get hashCode {
    if (__hashCode != null) return __hashCode!;
    var _$hash = 0;
    _$hash = $jc(_$hash, editing.hashCode);
    _$hash = $jc(_$hash, messageIds.hashCode);
    _$hash = $jc(_$hash, listUIState.hashCode);
    _$hash = $jc(_$hash, selectedId.hashCode);
    _$hash = $jc(_$hash, forceSelected.hashCode);
    _$hash = $jc(_$hash, tabIndex.hashCode);
    _$hash = $jc(_$hash, saveCompleter.hashCode);
    _$hash = $jc(_$hash, cancelCompleter.hashCode);
    _$hash = $jf(_$hash);
    return __hashCode ??= _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ChatUIState')
          ..add('editing', editing)
          ..add('messageIds', messageIds)
          ..add('listUIState', listUIState)
          ..add('selectedId', selectedId)
          ..add('forceSelected', forceSelected)
          ..add('tabIndex', tabIndex)
          ..add('saveCompleter', saveCompleter)
          ..add('cancelCompleter', cancelCompleter))
        .toString();
  }
}

class ChatUIStateBuilder implements Builder<ChatUIState, ChatUIStateBuilder> {
  _$ChatUIState? _$v;

  ChatEntityBuilder? _editing;
  ChatEntityBuilder get editing => _$this._editing ??= new ChatEntityBuilder();
  set editing(ChatEntityBuilder? editing) => _$this._editing = editing;

  ListBuilder<String>? _messageIds;
  ListBuilder<String> get messageIds =>
      _$this._messageIds ??= new ListBuilder<String>();
  set messageIds(ListBuilder<String>? messageIds) =>
      _$this._messageIds = messageIds;

  ListUIStateBuilder? _listUIState;
  ListUIStateBuilder get listUIState =>
      _$this._listUIState ??= new ListUIStateBuilder();
  set listUIState(ListUIStateBuilder? listUIState) =>
      _$this._listUIState = listUIState;

  String? _selectedId;
  String? get selectedId => _$this._selectedId;
  set selectedId(String? selectedId) => _$this._selectedId = selectedId;

  bool? _forceSelected;
  bool? get forceSelected => _$this._forceSelected;
  set forceSelected(bool? forceSelected) =>
      _$this._forceSelected = forceSelected;

  int? _tabIndex;
  int? get tabIndex => _$this._tabIndex;
  set tabIndex(int? tabIndex) => _$this._tabIndex = tabIndex;

  Completer<SelectableEntity>? _saveCompleter;
  Completer<SelectableEntity>? get saveCompleter => _$this._saveCompleter;
  set saveCompleter(Completer<SelectableEntity>? saveCompleter) =>
      _$this._saveCompleter = saveCompleter;

  Completer<Null>? _cancelCompleter;
  Completer<Null>? get cancelCompleter => _$this._cancelCompleter;
  set cancelCompleter(Completer<Null>? cancelCompleter) =>
      _$this._cancelCompleter = cancelCompleter;

  ChatUIStateBuilder();

  ChatUIStateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _editing = $v.editing?.toBuilder();
      _messageIds = $v.messageIds.toBuilder();
      _listUIState = $v.listUIState.toBuilder();
      _selectedId = $v.selectedId;
      _forceSelected = $v.forceSelected;
      _tabIndex = $v.tabIndex;
      _saveCompleter = $v.saveCompleter;
      _cancelCompleter = $v.cancelCompleter;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ChatUIState other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$ChatUIState;
  }

  @override
  void update(void Function(ChatUIStateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ChatUIState build() => _build();

  _$ChatUIState _build() {
    _$ChatUIState _$result;
    try {
      _$result = _$v ??
          new _$ChatUIState._(
              editing: _editing?.build(),
              messageIds: messageIds.build(),
              listUIState: listUIState.build(),
              selectedId: selectedId,
              forceSelected: forceSelected,
              tabIndex: BuiltValueNullFieldError.checkNotNull(
                  tabIndex, r'ChatUIState', 'tabIndex'),
              saveCompleter: saveCompleter,
              cancelCompleter: cancelCompleter);
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'editing';
        _editing?.build();
        _$failedField = 'messageIds';
        messageIds.build();
        _$failedField = 'listUIState';
        listUIState.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'ChatUIState', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
