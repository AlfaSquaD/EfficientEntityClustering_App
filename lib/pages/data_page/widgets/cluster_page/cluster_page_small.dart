part of '../../data_page.dart';

class _ClusterPageSmall extends ConsumerWidget {
  const _ClusterPageSmall({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(clusterProvider);
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
                        ref.read(clusterProvider.notifier).search(value);
                      },
                      prefixIcon: const Icon(Icons.search),
                    )),
                const Expanded(child: SizedBox()),
                PopupMenuButton(
                    itemBuilder: (context) => [
                          PopupMenuItem(
                            child: Text('Refresh'),
                            onTap: () {
                              ref
                                  .read(clusterProvider.notifier)
                                  .fetchClusters();
                            },
                          ),
                          PopupMenuItem(
                            child: Text('Delete selected'),
                            enabled: state.selectedClusterIds.isNotEmpty,
                            onTap: () async {
                              final bool? result = await showDialog<bool>(
                                  context: context,
                                  builder: (context) => DestructiveAlert(
                                        title: 'Delete cluster',
                                        content:
                                            'Are you sure you want to delete ${state.selectedClusterIds.length} cluster?',
                                        cancelText: 'Cancel',
                                        destructiveText: 'Delete',
                                      ));
                              if (result ?? false) {
                                ref
                                    .read(clusterProvider.notifier)
                                    .deleteSelected();
                              }
                            },
                          ),
                          PopupMenuItem(
                            child: Text('Add'),
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (context) =>
                                      const _AddClusterDialog());
                            },
                          ),
                          PopupMenuItem(
                            child: Text('Import'),
                            value: 'import',
                          ),
                          PopupMenuItem(
                            child: Text('Export'),
                            value: 'export',
                          ),
                        ]),
              ],
            ),
          ),
          const Divider(
            indent: 16,
            endIndent: 16,
          ),
          _ClusterDataTable(),
          const Divider(indent: 16, endIndent: 16),
          _ClusterTableFoot(),
        ],
      ),
    );
  }
}

