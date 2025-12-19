import 'dart:async';
import 'package:flutter_boilerplate/constants.dart';
import 'package:flutter_boilerplate/data/models/chat_model.dart';
import 'package:flutter_boilerplate/ui/app/tables/entity_list.dart';
import 'package:flutter_boilerplate/ui/chat/chat_list_item.dart';
import 'package:flutter_boilerplate/ui/chat/chat_presenter.dart';
import 'package:redux/redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:built_collection/built_collection.dart';
import 'package:flutter_boilerplate/redux/ui/list_ui_state.dart';
import 'package:flutter_boilerplate/redux/chat/chat_selectors.dart';
import 'package:flutter_boilerplate/data/models/models.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:flutter_boilerplate/redux/chat/chat_actions.dart';

class ChatListBuilder extends StatelessWidget {
  const ChatListBuilder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ChatListVM>(
      converter: ChatListVM.fromStore,
      builder: (context, viewModel) {
        return EntityList(
          entityType: EntityType.chat,
          presenter: ChatPresenter(),
          state: viewModel.state,
          entityList: viewModel.chatList,
          tableColumns: viewModel.tableColumns,
          onRefreshed: viewModel.onRefreshed,
          onSortColumn: viewModel.onSortColumn,
          viewType: ViewType.list,
          onClearMultiselect: viewModel.onClearMultiselect,
          itemBuilder: (BuildContext context, index) {
            final state = viewModel.state;
            final chatId = viewModel.chatList[index];
            final chat = viewModel.chatMap[chatId]!;
            final listState = state.getListState(EntityType.chat);
            final isInMultiselect = listState.isInMultiselect();

            return ChatListItem(
              user: viewModel.state.user,
              filter: viewModel.filter,
              chat: chat,
              isChecked: isInMultiselect && listState.isSelected(chat.id),
            );
          },
        );
      },
    );
  }
}

class ChatListVM {
  ChatListVM({
    required this.state,
    required this.userCompany,
    required this.chatList,
    required this.chatMap,
    required this.filter,
    required this.isLoading,
    required this.listState,
    required this.onRefreshed,
    required this.onEntityAction,
    required this.tableColumns,
    required this.onSortColumn,
    required this.onClearMultiselect,
  });

  static ChatListVM fromStore(Store<AppState> store) {
    Future<void> _handleRefresh(BuildContext context) {
      if (store.state.isLoading) {
        return Future<void>.value();
      }

      final completer = Completer<void>();

      store.dispatch(LoadChats(
          completer: completer, filter: store.state.chatState.filter));

      return completer.future;
    }

    final state = store.state;

    return ChatListVM(
      state: state,
      userCompany: state.userCompany,
      listState: state.chatListState,
      chatList: memoizedFilteredChatList(
        state.getUISelection(EntityType.chat),
        state.chatState.map,
        state.chatState.list,
        state.chatListState,
      ),
      chatMap: state.chatState.map,
      isLoading: state.isLoading,
      filter: state.chatState.filter.searchTerm,
      onEntityAction:
          (BuildContext context, List<BaseEntity> chats, EntityAction action) =>
              handleChatAction(context, chats, action),
      onRefreshed: (context) => _handleRefresh(context),
      tableColumns:
          state.userCompany.settings.getTableColumns(EntityType.chat) ??
              ChatPresenter.getDefaultTableFields(state.userCompany),
      onSortColumn: (field) => store.dispatch(UpdateChatFilter(
        state.chatState.filter.rebuild((b) => b
          ..sortField = field
          ..sortAscending = state.chatState.filter.sortField == field
              ? !state.chatState.filter.sortAscending
              : false),
      )),
      onClearMultiselect: () => store.dispatch(ClearChatMultiselect()),
    );
  }

  final AppState state;
  final UserCompanyEntity userCompany;
  final List<String> chatList;
  final BuiltMap<String, ChatEntity> chatMap;
  final ListUIState listState;
  final String? filter;
  final bool isLoading;
  final Function(BuildContext) onRefreshed;
  final Function(BuildContext, List<BaseEntity>, EntityAction) onEntityAction;
  final List<String> tableColumns;
  final Function(String) onSortColumn;
  final Function onClearMultiselect;
}
