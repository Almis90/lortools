import 'package:flutter/material.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final MultiSelectController<String> _sourcesController =
      MultiSelectController<String>();
  final MultiSelectController<String> _regionsController =
      MultiSelectController<String>();
  final MultiSelectController<String> _timePeriodController =
      MultiSelectController<String>();
  final MultiSelectController<String> _formatController =
      MultiSelectController<String>();
  final MultiSelectController<String> _ranksController =
      MultiSelectController<String>();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Sources:'),
              MultiSelectDropDown<String>(
                hint: 'Select Source',
                controller: _sourcesController,
                onOptionSelected: _onSourcesSelected,
                options: ['Mastering Runeterra']
                    .map((e) => ValueItem(label: e, value: e))
                    .toList(),
                selectionType: SelectionType.multi,
                chipConfig: const ChipConfig(wrapType: WrapType.wrap),
                dropdownHeight: 300,
                optionTextStyle: const TextStyle(fontSize: 16),
                selectedOptionIcon: const Icon(Icons.check_circle),
              ),
              const Text('Regions:'),
              MultiSelectDropDown<String>(
                hint: 'Select Regions',
                controller: _regionsController,
                onOptionSelected: _onRegionsSelected,
                options: ['Everyone', 'Americas', 'Europe', 'APAC']
                    .map((e) => ValueItem(label: e, value: e))
                    .toList(),
                selectionType: SelectionType.single,
                chipConfig: const ChipConfig(wrapType: WrapType.wrap),
                dropdownHeight: 300,
                optionTextStyle: const TextStyle(fontSize: 16),
                selectedOptionIcon: const Icon(Icons.check_circle),
              ),
              const Text('Format:'),
              MultiSelectDropDown<String>(
                hint: 'Select Format',
                controller: _formatController,
                onOptionSelected: _onFormatSelected,
                options: ['Standard', 'Eternal']
                    .map((e) => ValueItem(label: e, value: e))
                    .toList(),
                selectionType: SelectionType.single,
                chipConfig: const ChipConfig(wrapType: WrapType.wrap),
                dropdownHeight: 300,
                optionTextStyle: const TextStyle(fontSize: 16),
                selectedOptionIcon: const Icon(Icons.check_circle),
              ),
              const Text('Time Period:'),
              MultiSelectDropDown<String>(
                hint: 'Select Time Period',
                controller: _timePeriodController,
                onOptionSelected: _onTimePeriodSelected,
                options: ['Current Patch', 'Last 3 days', 'Last 7 Days']
                    .map((e) => ValueItem(label: e, value: e))
                    .toList(),
                selectionType: SelectionType.single,
                chipConfig: const ChipConfig(wrapType: WrapType.wrap),
                dropdownHeight: 300,
                optionTextStyle: const TextStyle(fontSize: 16),
                selectedOptionIcon: const Icon(Icons.check_circle),
              ),
              const Text('Ranks:'),
              MultiSelectDropDown<String>(
                hint: 'Select Ranks',
                controller: _ranksController,
                onOptionSelected: _onRanksSelected,
                options: ['All Ranks', 'Master']
                    .map((e) => ValueItem(label: e, value: e))
                    .toList(),
                selectionType: SelectionType.single,
                chipConfig: const ChipConfig(wrapType: WrapType.wrap),
                dropdownHeight: 300,
                optionTextStyle: const TextStyle(fontSize: 16),
                selectedOptionIcon: const Icon(Icons.check_circle),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onSourcesSelected(List<ValueItem<String>> selectedOptions) {}

  void _onRegionsSelected(List<ValueItem<String>> selectedOptions) {}

  void _onFormatSelected(List<ValueItem<String>> selectedOptions) {}

  void _onRanksSelected(List<ValueItem<String>> selectedOptions) {}

  void _onTimePeriodSelected(List<ValueItem<String>> selectedOptions) {}
}
