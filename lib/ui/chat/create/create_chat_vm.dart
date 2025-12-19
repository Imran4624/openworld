import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_boilerplate/data/models/chat_model.dart';
import 'package:flutter_boilerplate/data/models/company_model.dart';
import 'package:flutter_boilerplate/redux/app/app_actions.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:flutter_boilerplate/redux/chat/chat_actions.dart';
import 'package:flutter_boilerplate/redux/ui/ui_actions.dart';
import 'package:flutter_boilerplate/ui/chat/create/create_chat.dart';
import 'package:redux/redux.dart';

class CreateChatScreen extends StatelessWidget {
  const CreateChatScreen({Key? key}) : super(key: key);

  static const String route = '/chat/edit';

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, CreateChatVM>(
      converter: (Store<AppState> store) {
        return CreateChatVM.fromStore(store);
      },
      builder: (context, vm) {
        return ChatEdit(
          viewModel: vm,
        );
      },
    );
  }
}

class CreateChatVM {
  CreateChatVM({
    required this.state,
    required this.company,
    required this.chat,
    required this.onChanged,
    required this.onSavePressed,
    required this.onCancelPressed,
    required this.isSaving,
    required this.origChat,
    required this.isLoading,
  });

  factory CreateChatVM.fromStore(Store<AppState> store) {
    final state = store.state;
    final chat = state.chatUIState.editing;

    return CreateChatVM(
      state: state,
      company: state.company,
      isSaving: state.isSaving,
      isLoading: state.isLoading,
      origChat: chat!,
      chat: chat,
      onChanged: (ChatEntity chat) {
        store.dispatch(UpdateChat(chat));
      },
      onCancelPressed: (BuildContext context) {
        createEntity(entity: ChatEntity());
        store.dispatch(UpdateCurrentRoute(state.uiState.previousRoute));
      },
      onSavePressed: (BuildContext context) async {
        final chat = store.state.chatUIState.editing;

        final userEmail = chat!.groupName;
        final completer = Completer<void>();
        store.dispatch(CreateOrOpenChatRequest(
            context: context, targetEmail: userEmail, completer: completer));
        await completer.future;
      },
    );
  }

  final AppState state;
  final CompanyEntity company;
  final ChatEntity chat;
  final ChatEntity origChat;
  final Function(ChatEntity) onChanged;
  final Function(BuildContext) onSavePressed;
  final Function(BuildContext) onCancelPressed;
  final bool isSaving;
  final bool isLoading;
}
