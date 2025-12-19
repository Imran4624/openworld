import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_boilerplate/constants.dart';
import 'package:flutter_boilerplate/data/models/static/app_theme.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';

class SearchText extends StatelessWidget {
  const SearchText({
    Key? key,
    this.filterController,
    this.focusNode,
    this.placeholder,
    this.onChanged,
    this.onCleared,
  }) : super(key: key);

  final Function(String)? onChanged;
  final Function? onCleared;
  final TextEditingController? filterController;
  final FocusNode? focusNode;
  final String? placeholder;

  @override
  Widget build(BuildContext context) {
    final store = StoreProvider.of<AppState>(context);
    final state = store.state;
    final enableDarkMode = state.prefState.enableDarkMode;
    final themeColors = enableDarkMode ? AppTheme.dark : AppTheme.light;

    return Container(
      padding: const EdgeInsets.only(left: 8.0),
      height: 40,
      margin: EdgeInsets.only(bottom: 2.0),
      decoration: BoxDecoration(
        color: themeColors.background,
        borderRadius: BorderRadius.all(Radius.circular(kBorderRadius)),
      ),
      child: TextField(
        focusNode: focusNode,
        textAlign: filterController!.text.isNotEmpty || focusNode!.hasFocus
            ? TextAlign.start
            : TextAlign.center,
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(left: 8, right: 8, bottom: 6),
          suffixIcon: filterController!.text.isNotEmpty || focusNode!.hasFocus
              ? IconButton(
                  icon: Icon(
                    Icons.clear,
                    color: themeColors.text,
                  ),
                  onPressed: () {
                    filterController!.text = '';
                    focusNode!.unfocus(
                        disposition: UnfocusDisposition.previouslyFocusedChild);
                    onCleared!();
                  },
                )
              : Icon(Icons.search, color: themeColors.text),
          border: InputBorder.none,
          hintText: focusNode!.hasFocus ? '' : placeholder,
        ),
        autocorrect: false,
        onChanged: (value) => onChanged!(value),
        controller: filterController,
      ),
    );
  }
}
