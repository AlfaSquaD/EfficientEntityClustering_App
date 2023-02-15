part of '../../data_page.dart';

final entityProvider =
    StateNotifierProvider<EntityPageController, EntityPageState>(
        (ref) => EntityPageController(ref: ref));

class _EntityPage extends ConsumerStatefulWidget {
  const _EntityPage({super.key});

  @override
  _EntityPageState createState() => _EntityPageState();
}

class _EntityPageState extends ConsumerState<_EntityPage> {
  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
        smallScreen: _EntityPageSmall(
          onSearch: _onSearch,
          onRefresh: _onRefresh,
          onImport: _onImport,
          onAdd: _onAdd,
          onDeleteSelected: _onDeleteSelected,
          onExport: _onExport,
        ),
        mediumScreen: _EntityPageMedium(
          onSearch: _onSearch,
          onRefresh: _onRefresh,
          onImport: _onImport,
          onAdd: _onAdd,
          onDeleteSelected: _onDeleteSelected,
          onExport: _onExport,
        ),
        largeScreen: _EntityPageLarge(
          onSearch: _onSearch,
          onRefresh: _onRefresh,
          onImport: _onImport,
          onAdd: _onAdd,
          onDeleteSelected: _onDeleteSelected,
          onExport: _onExport,
        ));
  }

  void _onSearch(String? value) {
    ref.read(entityProvider.notifier).search(value);
  }

  void _onRefresh() {
    ref.read(entityProvider.notifier).fetchEntities();
  }

  void _onImport() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );
    if (result == null) return;
    final csv = await CsvService.readCsv(result.files.first);
    showDialog(
        context: context,
        builder: (context) => _ImportEntityDialog(csvModel: csv));
  }

  void _onAdd() {
    showDialog(
        context: context, builder: (context) => const _AddEntityDialog());
  }

  void _onDeleteSelected() async {
    final bool? result = await showDialog<bool>(
        context: context,
        builder: (context) => DestructiveAlert(
              title: 'Delete entity',
              content:
                  'Are you sure you want to delete ${ref.read(entityProvider).selectedEntityIds.length} entity?',
              cancelText: 'Cancel',
              destructiveText: 'Delete',
            ));
    if (result ?? false) {
      ref.read(entityProvider.notifier).deleteSelected();
    }
  }

  void _onExport() {}
}