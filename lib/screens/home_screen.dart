import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/todo_provider.dart';
import '../widgets/add_task_sheet.dart';
import '../widgets/task_card.dart';
import '../widgets/lightning_blast.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  bool _showBlast = false;

  void _triggerBlast() {
    setState(() {
      _showBlast = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: () async {
              await Provider.of<TodoProvider>(context, listen: false).reloadTasks();
            },
            color: colorScheme.primary,
            backgroundColor: colorScheme.surface,
            child: CustomScrollView(
              slivers: [
                SliverAppBar.large(
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  title: Row(
                    children: [
                      Image.asset(
                        'assets/thanos_logo.png',
                        height: 40,
                        width: 40,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'BALANCE THE UNIVERSE',
                        style: TextStyle(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.0,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  centerTitle: false,
                  actions: [
                    IconButton(
                      icon: Icon(Icons.calendar_today_outlined, color: colorScheme.secondary),
                      onPressed: () {},
                    ),
                    const SizedBox(width: 16),
                  ],
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'REALITY STONES',
                          style: TextStyle(
                            color: colorScheme.onSurface.withOpacity(0.7),
                            fontSize: 12,
                            letterSpacing: 2,
                          ),
                        ),
                        const SizedBox(height: 8),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              _buildFilterChip(context, 'All'),
                              const SizedBox(width: 8),
                              _buildFilterChip(context, 'Work'),
                              const SizedBox(width: 8),
                              _buildFilterChip(context, 'Personal'),
                              const SizedBox(width: 8),
                              _buildFilterChip(context, 'Study'),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'DESTINY',
                          style: TextStyle(
                            color: colorScheme.onSurface.withOpacity(0.7),
                            fontSize: 12,
                            letterSpacing: 2,
                          ),
                        ),
                        const SizedBox(height: 8),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              _buildStatusChip(context, 'All'),
                              const SizedBox(width: 8),
                              _buildStatusChip(context, 'Pending'),
                              const SizedBox(width: 8),
                              _buildStatusChip(context, 'Completed'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Consumer<TodoProvider>(
                  builder: (context, provider, child) {
                    if (provider.tasks.isEmpty) {
                      return SliverFillRemaining(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.auto_awesome,
                                size: 64,
                                color: colorScheme.primary.withOpacity(0.5),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'THE UNIVERSE IS BALANCED',
                                style: TextStyle(
                                  color: colorScheme.onSurfaceVariant,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ],
                          ).animate().fadeIn().scale(),
                        ),
                      );
                    }
                    return SliverPadding(
                      padding: const EdgeInsets.all(16.0),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final task = provider.tasks[index];
                            return TaskCard(task: task)
                                .animate()
                                .fadeIn(delay: (50 * index).ms)
                                .slideX(begin: 0.2, end: 0);
                          },
                          childCount: provider.tasks.length,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          if (_showBlast)
            LightningBlast(
              onComplete: () {
                setState(() {
                  _showBlast = false;
                });
              },
            ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        backgroundColor: const Color(0xFF2D1B4E),
        indicatorColor: colorScheme.primary.withOpacity(0.2),
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.list_alt),
            label: 'The Gauntlet',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: colorScheme.primary,
        foregroundColor: Colors.black,
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: const Color(0xFF2D1B4E),
            builder: (context) => AddTaskSheet(onAdd: _triggerBlast),
          );
        },
        label: const Text('SNAP IT', style: TextStyle(fontWeight: FontWeight.bold)),
        icon: const Icon(Icons.auto_awesome),
      ).animate().scale(delay: 500.ms).shimmer(delay: 1000.ms, duration: 1000.ms),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildFilterChip(BuildContext context, String label) {
    return Consumer<TodoProvider>(
      builder: (context, provider, _) {
        final isSelected = provider.selectedCategory == label;
        final colorScheme = Theme.of(context).colorScheme;
        return FilterChip(
          label: Text(label),
          selected: isSelected,
          checkmarkColor: Colors.black,
          labelStyle: TextStyle(
            color: isSelected ? Colors.black : colorScheme.primary,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
          backgroundColor: Colors.transparent,
          selectedColor: colorScheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(
              color: colorScheme.primary.withOpacity(0.5),
            ),
          ),
          onSelected: (selected) {
            Provider.of<TodoProvider>(context, listen: false).filterByCategory(label);
          },
        );
      },
    );
  }

  Widget _buildStatusChip(BuildContext context, String label) {
    return Consumer<TodoProvider>(
      builder: (context, provider, _) {
        final isSelected = provider.selectedStatus == label;
        final colorScheme = Theme.of(context).colorScheme;
        return FilterChip(
          label: Text(label),
          selected: isSelected,
          checkmarkColor: Colors.black,
          labelStyle: TextStyle(
            color: isSelected ? Colors.black : colorScheme.secondary,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
          backgroundColor: Colors.transparent,
          selectedColor: colorScheme.secondary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(
              color: colorScheme.secondary.withOpacity(0.5),
            ),
          ),
          onSelected: (selected) {
            Provider.of<TodoProvider>(context, listen: false).filterByStatus(label);
          },
        );
      },
    );
  }
}
