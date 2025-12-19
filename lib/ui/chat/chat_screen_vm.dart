import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_boilerplate/data/models/chat_model.dart';
import 'package:flutter_boilerplate/data/models/models.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:flutter_boilerplate/redux/chat/chat_actions.dart';
import 'package:flutter_boilerplate/redux/chat/chat_selectors.dart';
import 'package:redux/redux.dart';

import 'chat_screen.dart';

class ChatScreenBuilder extends StatelessWidget {
  const ChatScreenBuilder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ChatScreenVM>(
      converter: ChatScreenVM.fromStore,
      onInit: (store) {
        store.dispatch(LoadChats(isRefresh: true));
      },
      builder: (context, vm) {
        return ChatScreen(
          viewModel: vm,
        );
      },
    );
  }
}

class ChatScreenVM {
  ChatScreenVM({
    required this.isInMultiselect,
    required this.chatList,
    required this.userCompany,
    required this.onEntityAction,
    required this.chatMap,
  });

  final bool isInMultiselect;
  final UserCompanyEntity userCompany;
  final List<String> chatList;
  final Function(BuildContext, List<BaseEntity>, EntityAction) onEntityAction;
  final BuiltMap<String, ChatEntity> chatMap;

  static ChatScreenVM fromStore(Store<AppState> store) {
    final state = store.state;

    return ChatScreenVM(
      chatMap: state.chatState.map,
      chatList: memoizedFilteredChatList(
        state.getUISelection(EntityType.chat),
        state.chatState.map,
        state.chatState.list,
        state.chatListState,
      ),
      userCompany: state.userCompany,
      isInMultiselect: state.chatListState.isInMultiselect(),
      onEntityAction:
          (BuildContext context, List<BaseEntity> chats, EntityAction action) =>
              handleChatAction(context, chats, action),
    );
  }
}
