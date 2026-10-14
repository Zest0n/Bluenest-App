import 'package:flutter/material.dart';
import '../../widgets/screen_placeholder.dart';

/// Screen 8 (landlord): Add / Edit Property.
/// propertyId == null  -> Add mode,  otherwise Edit mode.
/// When saved, call Navigator.pop(context) to return to My Properties.
class AddEditPropertyScreen extends StatelessWidget {
  final int? propertyId;
  const AddEditPropertyScreen({super.key, this.propertyId});

  bool get isEdit => propertyId != null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'Edit Property' : 'Add Property')),
      body: ScreenPlaceholder(
        icon: isEdit ? Icons.edit_outlined : Icons.add_home_work_outlined,
        title: isEdit ? 'Edit Property' : 'Add Property',
        note: isEdit
            ? 'Property #$propertyId - UI coming soon'
            : 'UI coming soon',
      ),
    );
  }
}
