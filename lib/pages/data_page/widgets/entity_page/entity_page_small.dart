part of '../../data_page.dart';

class _EntityPageSmall extends ConsumerWidget {
  const _EntityPageSmall({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(entityProvider);
    return Card(
      margin: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                    width: 300,
                    child: CustomTextField(
                      hintText: 'Search',
                      onChanged: (value) {
                        ref.read(entityProvider.notifier).search(value);
                      },
                      prefixIcon: const Icon(Icons.search),
                    )),
                Expanded(child: SizedBox()),
                PopupMenuButton(
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      child: Text('Refresh'),
                      onTap: () {
                        ref.read(entityProvider.notifier).fetchEntities();
                      },
                    ),
                    PopupMenuItem(
                      child: Text('Delete Selected'),
                      enabled: state.selectedEntityIds.isNotEmpty,
                      onTap: () async {
                        final bool? result = await showDialog<bool>(
                            context: context,
                            builder: (context) => DestructiveAlert(
                                  title: 'Delete entity',
                                  content:
                                      'Are you sure you want to delete ${state.selectedEntityIds.length} entity?',
                                  cancelText: 'Cancel',
                                  destructiveText: 'Delete',
                                ));
                        if (result ?? false) {
                          ref.read(entityProvider.notifier).deleteSelected();
                        }
                      },
                    ),
                    PopupMenuItem(
                      child: Text('Add entity'),
                      onTap: () async {
                        showDialog(
                            context: context,
                            builder: (context) => const _AddEntityDialog());
                      },
                    ),
                    PopupMenuItem(
                      child: Text('Import'),
                      onTap: () async {
                        FilePickerResult? result =
                            await FilePicker.platform.pickFiles(
                          type: FileType.custom,
                          allowedExtensions: ['csv'],
                        );
                        if (result == null) return;
                        final csv =
                            await CsvService.readCsv(result.files.first);
                        showDialog(
                            context: context,
                            builder: (context) =>
                                _ImportEntityDialog(csvModel: csv));
                      },
                    ),
                    PopupMenuItem(
                      child: Text('Export'),
                      onTap: () {},
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(
            indent: 16,
            endIndent: 16,
          ),
          _EntityDataTable(),
          const Divider(indent: 16, endIndent: 16),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: IntrinsicHeight(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('Total: ${state.entityList.length}'),
                    const VerticalDivider(
                      width: 16,
                    ),
                    Text('Selected: ${state.selectedEntityIds.length}'),
                    const VerticalDivider(
                      width: 16,
                    ),
                    Text(
                      'In cluster: ${state.entityList.where((e) => e.in_cluster).length}',
                    ),
                    const VerticalDivider(
                      width: 16,
                    ),
                    Text(
                      'Not in cluster: ${state.entityList.where((e) => !e.in_cluster).length}',
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
