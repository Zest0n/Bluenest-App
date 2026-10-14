import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../core/property_options.dart';
import '../../models/property.dart';
import '../../services/property_service.dart';

/// Screen 8 (landlord): Add / Edit Property.
/// property == null -> Add (POST create), otherwise Edit (PATCH partial-update).
/// Pops with `true` when saved so My Properties refreshes.
class AddEditPropertyScreen extends StatefulWidget {
  final Property? property;
  const AddEditPropertyScreen({super.key, this.property});

  @override
  State<AddEditPropertyScreen> createState() => _AddEditPropertyScreenState();
}

class _AddEditPropertyScreenState extends State<AddEditPropertyScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _title;
  late final TextEditingController _description;
  late final TextEditingController _address;
  late final TextEditingController _city;
  late final TextEditingController _locality;
  late final TextEditingController _size;
  late final TextEditingController _floor;
  late final TextEditingController _rent;

  late String _type;
  late String _furnishing;
  late String _tenantPref;
  int _bhk = 2;
  int _bathrooms = 1;
  bool _saving = false;

  bool get _isEdit => widget.property != null;

  @override
  void initState() {
    super.initState();
    final p = widget.property;
    _title = TextEditingController(text: p?.title ?? '');
    _description = TextEditingController(text: p?.description ?? '');
    _address = TextEditingController(text: p?.address ?? '');
    _city = TextEditingController(text: p?.city ?? '');
    _locality = TextEditingController(text: p?.locality ?? '');
    _size = TextEditingController(
        text: p?.sizeSqft != null ? p!.sizeSqft!.round().toString() : '');
    _floor = TextEditingController(text: p?.floor?.toString() ?? '');
    _rent = TextEditingController(
        text: p?.askingRent != null ? p!.askingRent!.round().toString() : '');

    _type = (p?.propertyType.isNotEmpty ?? false)
        ? p!.propertyType
        : PropertyOptions.propertyTypes.first;
    _furnishing = (p?.furnishingStatus.isNotEmpty ?? false)
        ? p!.furnishingStatus
        : PropertyOptions.furnishing.first;
    _tenantPref = (p?.tenantPreference.isNotEmpty ?? false)
        ? p!.tenantPreference
        : PropertyOptions.tenantPreference.first;
    if (p?.bhk != null && p!.bhk! >= 1 && p.bhk! <= 6) _bhk = p.bhk!;
    if (p?.bathrooms != null && p!.bathrooms! >= 1 && p.bathrooms! <= 6) {
      _bathrooms = p.bathrooms!;
    }
  }

  @override
  void dispose() {
    for (final c in [_title, _description, _address, _city, _locality, _size, _floor, _rent]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);

    final body = <String, dynamic>{
      'title': _title.text.trim(),
      'description': _description.text.trim(),
      'property_type': _type,
      'address': _address.text.trim(),
      'city': _city.text.trim(),
      'locality': _locality.text.trim(),
      'bhk': _bhk,
      'bathrooms': _bathrooms,
      'size_sqft': num.parse(_size.text.trim()),
      'floor': int.parse(_floor.text.trim()),
      'furnishing_status': _furnishing,
      'tenant_preference': _tenantPref,
      'asking_rent': num.parse(_rent.text.trim()),
    };
    // Image upload isn't built yet; the Postman create example sends null.
    if (!_isEdit) body['image'] = null;

    final res = _isEdit
        ? await PropertyService.partialUpdate(widget.property!.id, body)
        : await PropertyService.create(body);

    if (!mounted) return;
    setState(() => _saving = false);

    if (res.ok) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(_isEdit ? 'Property updated' : 'Property listed')));
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(res.error ?? 'Could not save'),
          backgroundColor: AppColors.danger));
    }
  }

  String? _required(String? v) =>
      (v == null || v.trim().isEmpty) ? 'Required' : null;

  String? _number(String? v) =>
      (num.tryParse(v?.trim() ?? '') == null) ? 'Enter a number' : null;

  String? _wholeNumber(String? v) =>
      (int.tryParse(v?.trim() ?? '') == null) ? 'Enter a whole number' : null;

  Widget _dropdown(String label, String value, List<String> options,
      ValueChanged<String> onChanged) {
    final items = PropertyOptions.withCurrent(options, value);
    return DropdownButtonFormField<String>(
      initialValue: value,
      isExpanded: true,
      decoration: InputDecoration(labelText: label),
      items: [
        for (final o in items)
          DropdownMenuItem(value: o, child: Text(PropertyOptions.label(o))),
      ],
      onChanged: (v) => onChanged(v ?? value),
    );
  }

  Widget _intDropdown(String label, int value, String suffix, ValueChanged<int> onChanged) {
    return DropdownButtonFormField<int>(
      initialValue: value,
      decoration: InputDecoration(labelText: label),
      items: [
        for (var i = 1; i <= 6; i++) DropdownMenuItem(value: i, child: Text('$i $suffix')),
      ],
      onChanged: (v) => onChanged(v ?? value),
    );
  }

  @override
  Widget build(BuildContext context) {
    const gap = SizedBox(height: 14);
    const hGap = SizedBox(width: 12);
    return Scaffold(
      appBar: AppBar(title: Text(_isEdit ? 'Edit Property' : 'Add Property')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _title,
                    decoration: const InputDecoration(
                        labelText: 'Title', hintText: 'e.g. 2 BHK Flat in Noida'),
                    validator: _required,
                  ),
                  gap,
                  TextFormField(
                    controller: _description,
                    maxLines: 4,
                    decoration: const InputDecoration(
                        labelText: 'Description', alignLabelWithHint: true),
                    validator: _required,
                  ),
                  gap,
                  _dropdown('Property type', _type, PropertyOptions.propertyTypes,
                      (v) => setState(() => _type = v)),
                  gap,
                  TextFormField(
                    controller: _address,
                    decoration: const InputDecoration(labelText: 'Address'),
                    validator: _required,
                  ),
                  gap,
                  Row(children: [
                    Expanded(
                      child: TextFormField(
                          controller: _city,
                          decoration: const InputDecoration(labelText: 'City'),
                          validator: _required),
                    ),
                    hGap,
                    Expanded(
                      child: TextFormField(
                          controller: _locality,
                          decoration: const InputDecoration(labelText: 'Locality'),
                          validator: _required),
                    ),
                  ]),
                  gap,
                  Row(children: [
                    Expanded(child: _intDropdown('BHK', _bhk, 'BHK', (v) => setState(() => _bhk = v))),
                    hGap,
                    Expanded(
                        child: _intDropdown('Bathrooms', _bathrooms, 'bath',
                            (v) => setState(() => _bathrooms = v))),
                  ]),
                  gap,
                  Row(children: [
                    Expanded(
                      child: TextFormField(
                        controller: _size,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: const InputDecoration(labelText: 'Size (sq ft)'),
                        validator: _number,
                      ),
                    ),
                    hGap,
                    Expanded(
                      child: TextFormField(
                        controller: _floor,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: 'Floor'),
                        validator: _wholeNumber,
                      ),
                    ),
                  ]),
                  gap,
                  Row(children: [
                    Expanded(
                      child: _dropdown('Furnishing', _furnishing, PropertyOptions.furnishing,
                          (v) => setState(() => _furnishing = v)),
                    ),
                    hGap,
                    Expanded(
                      child: _dropdown('Preferred tenants', _tenantPref,
                          PropertyOptions.tenantPreference,
                          (v) => setState(() => _tenantPref = v)),
                    ),
                  ]),
                  gap,
                  TextFormField(
                    controller: _rent,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                        labelText: 'Asking rent (₹ / month)', prefixText: '₹ '),
                    validator: _number,
                  ),
                  const SizedBox(height: 28),
                  Row(children: [
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                            minimumSize: const Size.fromHeight(52),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14))),
                        onPressed: _saving ? null : () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                    ),
                    hGap,
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _saving ? null : _save,
                        child: _saving
                            ? const SizedBox(
                                height: 22,
                                width: 22,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2, color: Colors.white))
                            : Text(_isEdit ? 'Save changes' : 'Save Property'),
                      ),
                    ),
                  ]),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
