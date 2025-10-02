import 'package:flutter/material.dart';
import '../../core/helpers/dialog_helper.dart';

class CustomFilterButton extends StatelessWidget {
  final TextEditingController filterController;
  final Widget filterDialog;
  final VoidCallback resetFilter;

  const CustomFilterButton({
    super.key,
    required this.filterController,
    required this.filterDialog,
    required this.resetFilter,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: TextField(
        readOnly: true,
        focusNode: FocusNode(canRequestFocus: false),
        controller: filterController,
        onTap: () {
          DialogHelper.showCustomDialog(dialog: filterDialog, context: context);
        },
        decoration: InputDecoration(
          hintText: 'Фильтр',
          prefixIcon: Icon(Icons.search),
          suffixIcon: IconButton(
            onPressed: () {
              resetFilter();
              filterController.text = '';
            },
            icon: Icon(Icons.close),
          ),
        ),
      ),
    );
  }
}
