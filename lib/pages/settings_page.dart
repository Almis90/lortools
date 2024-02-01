import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lortools/bloc/settings_bloc.dart';
import 'package:motion_toast/motion_toast.dart';
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
  bool isUpdatingProgrammatically = false;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocConsumer<SettingsBloc, SettingsState>(
          buildWhen: (previous, current) {
            return current is SettingsLoadingState ||
                current is SettingsLoadedState;
          },
          builder: (context, state) {
            if (state is SettingsLoadingState) {
              return _buildProgressIndicator();
            } else if (state is SettingsLoadedState) {
              return _buildSettingsLoaded(state);
            } else {
              return Container();
            }
          },
          listener: (BuildContext context, SettingsState state) {
            if (state is SettingsUpdatedState) {
              MotionToast.success(
                description: Text(state.successMessage),
              ).show(context);
            } else if (state is SettingsErrorState) {
              MotionToast.error(
                description: Text(state.errorMessage),
              ).show(context);
            }
          },
        ),
      ),
    );
  }

  Center _buildProgressIndicator() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  SingleChildScrollView _buildSettingsLoaded(SettingsLoadedState state) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Sources:'),
          _buildSourcesDropDown(state.sources),
          const Text('Regions:'),
          _buildRegionsDropDown(state.region),
          const Text('Format:'),
          _buildFormatDropDown(state.format),
          const Text('Time Period:'),
          _buildTimePeriodDropDown(state.timePeriod),
          const Text('Ranks:'),
          _buildRanksDropDown(state.rank),
        ],
      ),
    );
  }

  MultiSelectDropDown<String> _buildSourcesDropDown(List<String> sources) {
    return MultiSelectDropDown<String>(
      hint: 'Select Source',
      controller: _sourcesController,
      selectedOptions:
          sources.map((e) => ValueItem(label: e, value: e)).toList(),
      onOptionSelected: _onSourcesSelected,
      options: ['Mastering Runeterra']
          .map((e) => ValueItem(label: e, value: e))
          .toList(),
      selectionType: SelectionType.multi,
      chipConfig: const ChipConfig(wrapType: WrapType.wrap),
      dropdownHeight: 300,
      optionTextStyle: const TextStyle(fontSize: 16),
      selectedOptionIcon: const Icon(Icons.check_circle),
      showClearIcon: false,
    );
  }

  MultiSelectDropDown<String> _buildRegionsDropDown(String region) {
    return MultiSelectDropDown<String>(
      hint: 'Select Region',
      controller: _regionsController,
      selectedOptions: [ValueItem(label: region, value: region)],
      onOptionSelected: _onRegionSelected,
      options: ['Everyone', 'Americas', 'Europe', 'APAC']
          .map((e) => ValueItem(label: e, value: e))
          .toList(),
      selectionType: SelectionType.single,
      chipConfig: const ChipConfig(wrapType: WrapType.wrap),
      dropdownHeight: 300,
      optionTextStyle: const TextStyle(fontSize: 16),
      selectedOptionIcon: const Icon(Icons.check_circle),
      showClearIcon: false,
    );
  }

  MultiSelectDropDown<String> _buildFormatDropDown(String format) {
    return MultiSelectDropDown<String>(
      hint: 'Select Format',
      controller: _formatController,
      selectedOptions: [ValueItem(label: format, value: format)],
      onOptionSelected: _onFormatSelected,
      options: ['Standard', 'Eternal']
          .map((e) => ValueItem(label: e, value: e))
          .toList(),
      selectionType: SelectionType.single,
      chipConfig: const ChipConfig(wrapType: WrapType.wrap),
      dropdownHeight: 300,
      optionTextStyle: const TextStyle(fontSize: 16),
      selectedOptionIcon: const Icon(Icons.check_circle),
      showClearIcon: false,
    );
  }

  MultiSelectDropDown<String> _buildTimePeriodDropDown(String timePeriod) {
    return MultiSelectDropDown<String>(
      hint: 'Select Time Period',
      controller: _timePeriodController,
      selectedOptions: [ValueItem(label: timePeriod, value: timePeriod)],
      onOptionSelected: _onTimePeriodSelected,
      options: ['Current Patch', 'Last 3 days', 'Last 7 Days']
          .map((e) => ValueItem(label: e, value: e))
          .toList(),
      selectionType: SelectionType.single,
      chipConfig: const ChipConfig(wrapType: WrapType.wrap),
      dropdownHeight: 300,
      optionTextStyle: const TextStyle(fontSize: 16),
      selectedOptionIcon: const Icon(Icons.check_circle),
      showClearIcon: false,
    );
  }

  Widget _buildRanksDropDown(String rank) {
    return MultiSelectDropDown<String>(
      hint: 'Select Rank',
      controller: _ranksController,
      selectedOptions: [ValueItem(label: rank, value: rank)],
      onOptionSelected: _onRankSelected,
      options: ['All Ranks', 'Master']
          .map((e) => ValueItem(label: e, value: e))
          .toList(),
      selectionType: SelectionType.single,
      chipConfig: const ChipConfig(wrapType: WrapType.wrap),
      dropdownHeight: 300,
      optionTextStyle: const TextStyle(fontSize: 16),
      selectedOptionIcon: const Icon(Icons.check_circle),
      showClearIcon: false,
    );
  }

  void _onSourcesSelected(List<ValueItem<String>> selectedOptions) {
    if (!isUpdatingProgrammatically) {
      if (selectedOptions.isEmpty) {
        isUpdatingProgrammatically = true;
        _sourcesController.setSelectedOptions(_sourcesController.options);
        isUpdatingProgrammatically = false;
      } else {
        context.read<SettingsBloc>().add(UpdateSourcesEvent(selectedOptions
            .where((valueItem) => valueItem.value != null)
            .map((valueItem) => valueItem.value!)
            .toList()));
      }
    }
  }

  void _onRegionSelected(List<ValueItem<String>> selectedOptions) {
    var region = selectedOptions
        .where((valueItem) => valueItem.value != null)
        .map((valueItem) => valueItem.value!)
        .firstOrNull;

    if (region != null) {
      context.read<SettingsBloc>().add(UpdateRegionEvent(region));
    }
  }

  void _onFormatSelected(List<ValueItem<String>> selectedOptions) {
    var format = selectedOptions
        .where((valueItem) => valueItem.value != null)
        .map((valueItem) => valueItem.value!)
        .firstOrNull;

    if (format != null) {
      context.read<SettingsBloc>().add(UpdateFormatEvent(format));
    }
  }

  void _onRankSelected(List<ValueItem<String>> selectedOptions) {
    var rank = selectedOptions
        .where((valueItem) => valueItem.value != null)
        .map((valueItem) => valueItem.value!)
        .firstOrNull;

    if (rank != null) {
      context.read<SettingsBloc>().add(UpdateRankEvent(rank));
    }
  }

  void _onTimePeriodSelected(List<ValueItem<String>> selectedOptions) {
    var timePeriod = selectedOptions
        .where((valueItem) => valueItem.value != null)
        .map((valueItem) => valueItem.value!)
        .firstOrNull;

    if (timePeriod != null) {
      context.read<SettingsBloc>().add(UpdateTimePeriodEvent(timePeriod));
    }
  }
}
