// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'serializers.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializers _$serializers = (new Serializers().toBuilder()
      ..add(AccountEntity.serializer)
      ..add(ActivityEntity.serializer)
      ..add(AppLayout.serializer)
      ..add(AppSidebarMode.serializer)
      ..add(AppState.serializer)
      ..add(AppVersionEntity.serializer)
      ..add(AuthState.serializer)
      ..add(BuyerDetails.serializer)
      ..add(ChatEntity.serializer)
      ..add(ChatFilter.serializer)
      ..add(ChatItemResponse.serializer)
      ..add(ChatListResponse.serializer)
      ..add(ChatMessageAttachment.serializer)
      ..add(ChatMessageEntity.serializer)
      ..add(ChatParticipantEntity.serializer)
      ..add(ChatState.serializer)
      ..add(ChatUIState.serializer)
      ..add(CompanyEntity.serializer)
      ..add(CompanyItemResponse.serializer)
      ..add(CompanyPrefState.serializer)
      ..add(CountryEntity.serializer)
      ..add(CountryItemResponse.serializer)
      ..add(CountryListResponse.serializer)
      ..add(CurrencyEntity.serializer)
      ..add(CurrencyItemResponse.serializer)
      ..add(CurrencyListResponse.serializer)
      ..add(DashboardUISettings.serializer)
      ..add(DashboardUIState.serializer)
      ..add(DateFormatEntity.serializer)
      ..add(DateFormatItemResponse.serializer)
      ..add(DateFormatListResponse.serializer)
      ..add(DateRange.serializer)
      ..add(DateRangeComparison.serializer)
      ..add(DatetimeFormatEntity.serializer)
      ..add(DatetimeFormatItemResponse.serializer)
      ..add(DatetimeFormatListResponse.serializer)
      ..add(DesignEntity.serializer)
      ..add(DesignItemResponse.serializer)
      ..add(DesignListResponse.serializer)
      ..add(DesignPreviewRequest.serializer)
      ..add(DesignState.serializer)
      ..add(DesignUIState.serializer)
      ..add(DynamicFieldState.serializer)
      ..add(EmailTemplate.serializer)
      ..add(EntityState.serializer)
      ..add(EntityType.serializer)
      ..add(EventEntity.serializer)
      ..add(EventFilter.serializer)
      ..add(EventInteraction.serializer)
      ..add(EventItemResponse.serializer)
      ..add(EventListResponse.serializer)
      ..add(EventLocationData.serializer)
      ..add(EventState.serializer)
      ..add(EventUIState.serializer)
      ..add(HistoryRecord.serializer)
      ..add(Images.serializer)
      ..add(IndustryEntity.serializer)
      ..add(IndustryItemResponse.serializer)
      ..add(IndustryListResponse.serializer)
      ..add(InvoiceStatusEntity.serializer)
      ..add(IssuedTicket.serializer)
      ..add(JoinRequest.serializer)
      ..add(LanguageEntity.serializer)
      ..add(LanguageItemResponse.serializer)
      ..add(LanguageListResponse.serializer)
      ..add(LastMessageEntity.serializer)
      ..add(LineItem.serializer)
      ..add(ListUIState.serializer)
      ..add(LoginResponse.serializer)
      ..add(MessageState.serializer)
      ..add(ModuleLayout.serializer)
      ..add(NotificationEntity.serializer)
      ..add(NotificationFilter.serializer)
      ..add(NotificationItemResponse.serializer)
      ..add(NotificationListResponse.serializer)
      ..add(NotificationState.serializer)
      ..add(NotificationUIState.serializer)
      ..add(OrderEntity.serializer)
      ..add(PaymentEntity.serializer)
      ..add(PaymentFilter.serializer)
      ..add(PaymentItemResponse.serializer)
      ..add(PaymentListResponse.serializer)
      ..add(PaymentState.serializer)
      ..add(PaymentUIState.serializer)
      ..add(PdfPreviewRequest.serializer)
      ..add(PhotoEntity.serializer)
      ..add(PhotoFilter.serializer)
      ..add(PhotoItemResponse.serializer)
      ..add(PhotoListResponse.serializer)
      ..add(PhotoState.serializer)
      ..add(PhotoUIState.serializer)
      ..add(PrefState.serializer)
      ..add(PrefStateSortField.serializer)
      ..add(ProductEntity.serializer)
      ..add(ProductFilter.serializer)
      ..add(ProductItemResponse.serializer)
      ..add(ProductListResponse.serializer)
      ..add(ProductState.serializer)
      ..add(ProductUIState.serializer)
      ..add(ProfileEntity.serializer)
      ..add(ProfileFilter.serializer)
      ..add(ProfileItemResponse.serializer)
      ..add(ProfileListResponse.serializer)
      ..add(ProfileOperationEntity.serializer)
      ..add(ProfileOperationFilter.serializer)
      ..add(ProfileOperationItemResponse.serializer)
      ..add(ProfileOperationListResponse.serializer)
      ..add(ProfileOperationState.serializer)
      ..add(ProfileOperationUIState.serializer)
      ..add(ProfileReport.serializer)
      ..add(ProfileState.serializer)
      ..add(ProfileUIState.serializer)
      ..add(SettingsEntity.serializer)
      ..add(SettingsUIState.serializer)
      ..add(SizeEntity.serializer)
      ..add(SizeItemResponse.serializer)
      ..add(SizeListResponse.serializer)
      ..add(StaticDataEntity.serializer)
      ..add(StaticDataItemResponse.serializer)
      ..add(StaticState.serializer)
      ..add(TemplateEntity.serializer)
      ..add(TicketGroup.serializer)
      ..add(TicketType.serializer)
      ..add(TimezoneEntity.serializer)
      ..add(TimezoneItemResponse.serializer)
      ..add(TimezoneListResponse.serializer)
      ..add(UIState.serializer)
      ..add(UserCompanyEntity.serializer)
      ..add(UserCompanyItemResponse.serializer)
      ..add(UserCompanyState.serializer)
      ..add(UserEntity.serializer)
      ..add(UserFilter.serializer)
      ..add(UserItemResponse.serializer)
      ..add(UserListResponse.serializer)
      ..add(UserSettingsEntity.serializer)
      ..add(UserState.serializer)
      ..add(UserTwoFactorData.serializer)
      ..add(UserTwoFactorResponse.serializer)
      ..add(UserUIState.serializer)
      ..add(Venue.serializer)
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(ActivityEntity)]),
          () => new ListBuilder<ActivityEntity>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(UserEntity)]),
          () => new ListBuilder<UserEntity>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(DesignEntity)]),
          () => new ListBuilder<DesignEntity>())
      ..addBuilderFactory(
          const FullType(
              BuiltMap, const [const FullType(String), const FullType(String)]),
          () => new MapBuilder<String, String>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(ChatEntity)]),
          () => new ListBuilder<ChatEntity>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(ChatMessageAttachment)]),
          () => new ListBuilder<ChatMessageAttachment>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(ChatMessageAttachment)]),
          () => new ListBuilder<ChatMessageAttachment>())
      ..addBuilderFactory(
          const FullType(
              BuiltMap, const [const FullType(String), const FullType(bool)]),
          () => new MapBuilder<String, bool>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(CountryEntity)]),
          () => new ListBuilder<CountryEntity>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(CurrencyEntity)]),
          () => new ListBuilder<CurrencyEntity>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(CurrencyEntity)]),
          () => new ListBuilder<CurrencyEntity>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(SizeEntity)]),
          () => new ListBuilder<SizeEntity>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(IndustryEntity)]),
          () => new ListBuilder<IndustryEntity>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(TimezoneEntity)]),
          () => new ListBuilder<TimezoneEntity>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(DateFormatEntity)]),
          () => new ListBuilder<DateFormatEntity>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(LanguageEntity)]),
          () => new ListBuilder<LanguageEntity>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(CountryEntity)]),
          () => new ListBuilder<CountryEntity>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(InvoiceStatusEntity)]),
          () => new ListBuilder<InvoiceStatusEntity>())
      ..addBuilderFactory(
          const FullType(BuiltMap, const [
            const FullType(String),
            const FullType(BuiltList, const [const FullType(String)])
          ]),
          () => new MapBuilder<String, BuiltList<String>>())
      ..addBuilderFactory(
          const FullType(BuiltMap,
              const [const FullType(String), const FullType(TemplateEntity)]),
          () => new MapBuilder<String, TemplateEntity>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(DateFormatEntity)]),
          () => new ListBuilder<DateFormatEntity>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(DatetimeFormatEntity)]),
          () => new ListBuilder<DatetimeFormatEntity>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(DesignEntity)]),
          () => new ListBuilder<DesignEntity>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(EntityState)]),
          () => new ListBuilder<EntityState>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(EntityStatus)]),
          () => new ListBuilder<EntityStatus>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(String)]),
          () => new ListBuilder<String>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(String)]),
          () => new ListBuilder<String>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(String)]),
          () => new ListBuilder<String>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(String)]),
          () => new ListBuilder<String>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(String)]),
          () => new ListBuilder<String>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(EntityType)]),
          () => new ListBuilder<EntityType>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(BaseEntity)]),
          () => new ListBuilder<BaseEntity>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(EventEntity)]),
          () => new ListBuilder<EventEntity>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(HistoryRecord)]),
          () => new ListBuilder<HistoryRecord>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(IndustryEntity)]),
          () => new ListBuilder<IndustryEntity>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(IssuedTicket)]),
          () => new ListBuilder<IssuedTicket>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(LineItem)]),
          () => new ListBuilder<LineItem>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(LanguageEntity)]),
          () => new ListBuilder<LanguageEntity>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(NotificationEntity)]),
          () => new ListBuilder<NotificationEntity>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(OrderEntity)]),
          () => new ListBuilder<OrderEntity>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(TicketGroup)]),
          () => new ListBuilder<TicketGroup>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(TicketType)]),
          () => new ListBuilder<TicketType>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(PaymentEntity)]),
          () => new ListBuilder<PaymentEntity>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(PhotoEntity)]),
          () => new ListBuilder<PhotoEntity>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(ProductEntity)]),
          () => new ListBuilder<ProductEntity>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(ProfileEntity)]),
          () => new ListBuilder<ProfileEntity>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(ProfileOperationEntity)]),
          () => new ListBuilder<ProfileOperationEntity>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(QuestionGroupModel)]),
          () => new ListBuilder<QuestionGroupModel>())
      ..addBuilderFactory(
          const FullType(BuiltMap, const [
            const FullType(String),
            const FullType(BuiltMap,
                const [const FullType(String), const FullType(dynamic)])
          ]),
          () => new MapBuilder<String, BuiltMap<String, dynamic>>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(SizeEntity)]),
          () => new ListBuilder<SizeEntity>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(String)]),
          () => new ListBuilder<String>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(String)]),
          () => new ListBuilder<String>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(String)]),
          () => new ListBuilder<String>())
      ..addBuilderFactory(
          const FullType(BuiltMap,
              const [const FullType(String), const FullType(dynamic)]),
          () => new MapBuilder<String, dynamic>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(TimezoneEntity)]),
          () => new ListBuilder<TimezoneEntity>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(UserCompanyEntity)]),
          () => new ListBuilder<UserCompanyEntity>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(UserCompanyState)]),
          () => new ListBuilder<UserCompanyState>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(CompanyEntity)]),
          () => new ListBuilder<CompanyEntity>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(UserEntity)]),
          () => new ListBuilder<UserEntity>())
      ..addBuilderFactory(
          const FullType(BuiltMap,
              const [const FullType(EntityType), const FullType(bool)]),
          () => new MapBuilder<EntityType, bool>())
      ..addBuilderFactory(
          const FullType(BuiltMap,
              const [const FullType(EntityType), const FullType(bool)]),
          () => new MapBuilder<EntityType, bool>())
      ..addBuilderFactory(
          const FullType(
              BuiltMap, const [const FullType(String), const FullType(String)]),
          () => new MapBuilder<String, String>())
      ..addBuilderFactory(
          const FullType(
              BuiltMap, const [const FullType(String), const FullType(String)]),
          () => new MapBuilder<String, String>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(String)]),
          () => new ListBuilder<String>())
      ..addBuilderFactory(
          const FullType(BuiltMap, const [
            const FullType(EntityType),
            const FullType(PrefStateSortField)
          ]),
          () => new MapBuilder<EntityType, PrefStateSortField>())
      ..addBuilderFactory(
          const FullType(BuiltMap,
              const [const FullType(String), const FullType(CompanyPrefState)]),
          () => new MapBuilder<String, CompanyPrefState>())
      ..addBuilderFactory(
          const FullType(BuiltMap, const [
            const FullType(String),
            const FullType(BuiltList, const [const FullType(String)])
          ]),
          () => new MapBuilder<String, BuiltList<String>>())
      ..addBuilderFactory(
          const FullType(BuiltMap, const [
            const FullType(String),
            const FullType(BuiltList, const [const FullType(String)])
          ]),
          () => new MapBuilder<String, BuiltList<String>>())
      ..addBuilderFactory(
          const FullType(BuiltMap,
              const [const FullType(String), const FullType(ChatEntity)]),
          () => new MapBuilder<String, ChatEntity>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(String)]),
          () => new ListBuilder<String>())
      ..addBuilderFactory(
          const FullType(BuiltMap, const [
            const FullType(String),
            const FullType(ChatMessageEntity)
          ]),
          () => new MapBuilder<String, ChatMessageEntity>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(String)]),
          () => new ListBuilder<String>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(ChatMessageEntity)]),
          () => new ListBuilder<ChatMessageEntity>())
      ..addBuilderFactory(
          const FullType(BuiltMap,
              const [const FullType(String), const FullType(CurrencyEntity)]),
          () => new MapBuilder<String, CurrencyEntity>())
      ..addBuilderFactory(
          const FullType(BuiltMap,
              const [const FullType(String), const FullType(SizeEntity)]),
          () => new MapBuilder<String, SizeEntity>())
      ..addBuilderFactory(
          const FullType(BuiltMap,
              const [const FullType(String), const FullType(IndustryEntity)]),
          () => new MapBuilder<String, IndustryEntity>())
      ..addBuilderFactory(
          const FullType(BuiltMap,
              const [const FullType(String), const FullType(TimezoneEntity)]),
          () => new MapBuilder<String, TimezoneEntity>())
      ..addBuilderFactory(
          const FullType(BuiltMap,
              const [const FullType(String), const FullType(DateFormatEntity)]),
          () => new MapBuilder<String, DateFormatEntity>())
      ..addBuilderFactory(
          const FullType(BuiltMap,
              const [const FullType(String), const FullType(LanguageEntity)]),
          () => new MapBuilder<String, LanguageEntity>())
      ..addBuilderFactory(
          const FullType(BuiltMap,
              const [const FullType(String), const FullType(CountryEntity)]),
          () => new MapBuilder<String, CountryEntity>())
      ..addBuilderFactory(
          const FullType(BuiltMap,
              const [const FullType(String), const FullType(TemplateEntity)]),
          () => new MapBuilder<String, TemplateEntity>())
      ..addBuilderFactory(
          const FullType(BuiltMap, const [
            const FullType(String),
            const FullType(BuiltList, const [const FullType(String)])
          ]),
          () => new MapBuilder<String, BuiltList<String>>())
      ..addBuilderFactory(
          const FullType(BuiltMap,
              const [const FullType(String), const FullType(DesignEntity)]),
          () => new MapBuilder<String, DesignEntity>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(String)]),
          () => new ListBuilder<String>())
      ..addBuilderFactory(
          const FullType(BuiltMap,
              const [const FullType(String), const FullType(EventEntity)]),
          () => new MapBuilder<String, EventEntity>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(String)]),
          () => new ListBuilder<String>())
      ..addBuilderFactory(
          const FullType(BuiltMap, const [
            const FullType(String),
            const FullType(NotificationEntity)
          ]),
          () => new MapBuilder<String, NotificationEntity>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(String)]),
          () => new ListBuilder<String>())
      ..addBuilderFactory(
          const FullType(BuiltMap,
              const [const FullType(String), const FullType(PaymentEntity)]),
          () => new MapBuilder<String, PaymentEntity>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(String)]),
          () => new ListBuilder<String>())
      ..addBuilderFactory(
          const FullType(BuiltMap,
              const [const FullType(String), const FullType(PhotoEntity)]),
          () => new MapBuilder<String, PhotoEntity>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(String)]),
          () => new ListBuilder<String>())
      ..addBuilderFactory(
          const FullType(BuiltMap,
              const [const FullType(String), const FullType(ProductEntity)]),
          () => new MapBuilder<String, ProductEntity>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(String)]),
          () => new ListBuilder<String>())
      ..addBuilderFactory(
          const FullType(BuiltMap,
              const [const FullType(String), const FullType(ProfileEntity)]),
          () => new MapBuilder<String, ProfileEntity>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(String)]),
          () => new ListBuilder<String>())
      ..addBuilderFactory(
          const FullType(
              BuiltMap, const [const FullType(String), const FullType(String)]),
          () => new MapBuilder<String, String>())
      ..addBuilderFactory(
          const FullType(BuiltMap, const [
            const FullType(String),
            const FullType(ProfileOperationEntity)
          ]),
          () => new MapBuilder<String, ProfileOperationEntity>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(String)]),
          () => new ListBuilder<String>())
      ..addBuilderFactory(
          const FullType(BuiltMap, const [
            const FullType(String),
            const FullType.nullable(
                DocumentSnapshot, const [const FullType.nullable(Object)])
          ]),
          () => new MapBuilder<String, DocumentSnapshot<Object?>?>())
      ..addBuilderFactory(
          const FullType(BuiltMap, const [
            const FullType(String),
            const FullType(ProfileOperationEntity)
          ]),
          () => new MapBuilder<String, ProfileOperationEntity>())
      ..addBuilderFactory(
          const FullType(BuiltMap, const [
            const FullType(String),
            const FullType(ProfileOperationEntity)
          ]),
          () => new MapBuilder<String, ProfileOperationEntity>())
      ..addBuilderFactory(
          const FullType(BuiltMap, const [
            const FullType(String),
            const FullType(ProfileOperationEntity)
          ]),
          () => new MapBuilder<String, ProfileOperationEntity>())
      ..addBuilderFactory(
          const FullType(BuiltMap, const [
            const FullType(String),
            const FullType(ProfileOperationEntity)
          ]),
          () => new MapBuilder<String, ProfileOperationEntity>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(String)]),
          () => new ListBuilder<String>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(String)]),
          () => new ListBuilder<String>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(String)]),
          () => new ListBuilder<String>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(String)]),
          () => new ListBuilder<String>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(String)]),
          () => new ListBuilder<String>())
      ..addBuilderFactory(
          const FullType(
              BuiltMap, const [const FullType(String), const FullType(String)]),
          () => new MapBuilder<String, String>())
      ..addBuilderFactory(
          const FullType(BuiltMap,
              const [const FullType(String), const FullType(UserEntity)]),
          () => new MapBuilder<String, UserEntity>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(String)]),
          () => new ListBuilder<String>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(String)]),
          () => new ListBuilder<String>())
      ..addBuilderFactory(
          const FullType(BuiltMap,
              const [const FullType(String), const FullType(dynamic)]),
          () => new MapBuilder<String, dynamic>())
      ..addBuilderFactory(
          const FullType(BuiltMap,
              const [const FullType(String), const FullType(dynamic)]),
          () => new MapBuilder<String, dynamic>())
      ..addBuilderFactory(
          const FullType(BuiltMap,
              const [const FullType(String), const FullType(dynamic)]),
          () => new MapBuilder<String, dynamic>())
      ..addBuilderFactory(
          const FullType(BuiltMap,
              const [const FullType(String), const FullType(dynamic)]),
          () => new MapBuilder<String, dynamic>())
      ..addBuilderFactory(
          const FullType(BuiltMap,
              const [const FullType(String), const FullType(dynamic)]),
          () => new MapBuilder<String, dynamic>())
      ..addBuilderFactory(
          const FullType(BuiltMap,
              const [const FullType(String), const FullType(dynamic)]),
          () => new MapBuilder<String, dynamic>())
      ..addBuilderFactory(
          const FullType(
              BuiltMap, const [const FullType(String), const FullType(int)]),
          () => new MapBuilder<String, int>())
      ..addBuilderFactory(
          const FullType(
              BuiltMap, const [const FullType(String), const FullType(int)]),
          () => new MapBuilder<String, int>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(String)]),
          () => new ListBuilder<String>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(ChatParticipantEntity)]),
          () => new ListBuilder<ChatParticipantEntity>())
      ..addBuilderFactory(
          const FullType(BuiltMap, const [
            const FullType.nullable(EntityType),
            const FullType(BuiltList, const [const FullType(String)])
          ]),
          () => new MapBuilder<EntityType?, BuiltList<String>>())
      ..addBuilderFactory(
          const FullType(BuiltMap,
              const [const FullType.nullable(String), const FullType(String)]),
          () => new MapBuilder<String?, String>())
      ..addBuilderFactory(
          const FullType(BuiltMap, const [
            const FullType(String),
            const FullType(BuiltList, const [const FullType(String)])
          ]),
          () => new MapBuilder<String, BuiltList<String>>()))
    .build();

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
