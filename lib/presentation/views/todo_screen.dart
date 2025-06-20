import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/todo_provider.dart';
import '../theme.dart';

class TodoScreen extends ConsumerStatefulWidget {
  const TodoScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends ConsumerState<TodoScreen> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final todoState = ref.watch(todoProvider);
    final todoViewModel = ref.read(todoProvider.notifier);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Modern App Bar
            SliverAppBar(
              expandedHeight: 80,
              floating: false,
              pinned: true,
              backgroundColor: theme.colorScheme.background,
              elevation: 0,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios_new,
                  color: theme.colorScheme.onBackground,
                ),
                onPressed: () => Navigator.pop(context),
              ),
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  'Yapılacaklar',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: theme.colorScheme.onBackground,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                centerTitle: true,
                titlePadding: const EdgeInsets.only(bottom: 16),
              ),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(1),
                child: Container(height: 1, color: const Color(0xFFE2E8F0)),
              ),
            ),

            // Add Todo Section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: AppTheme.modernCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.add_task,
                            color: AppTheme.primaryColor,
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Yeni Görev Ekle',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _controller,
                              focusNode: _focusNode,
                              decoration: InputDecoration(
                                hintText: 'Görev açıklaması...',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                filled: true,
                                fillColor: const Color(0xFFF1F5F9),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 16,
                                ),
                                hintStyle: const TextStyle(
                                  color: Color(0xFF94A3B8),
                                  fontSize: 16,
                                ),
                              ),
                              onSubmitted: (value) {
                                if (value.trim().isNotEmpty) {
                                  todoViewModel.addTodo(value.trim());
                                  _controller.clear();
                                  _focusNode.unfocus();
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: AppTheme.primaryGradient,
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: AppTheme.primaryColor.withOpacity(0.3),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(12),
                                onTap: () {
                                  if (_controller.text.trim().isNotEmpty) {
                                    todoViewModel.addTodo(
                                      _controller.text.trim(),
                                    );
                                    _controller.clear();
                                    _focusNode.unfocus();
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  child: const Icon(
                                    Icons.add,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Todo List
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final todo = todoState.todos[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: AppTheme.modernCard(
                      child: Row(
                        children: [
                          // Checkbox
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: todo.isDone
                                  ? AppTheme.successColor
                                  : Colors.transparent,
                              border: Border.all(
                                color: todo.isDone
                                    ? AppTheme.successColor
                                    : const Color(0xFFCBD5E1),
                                width: 2,
                              ),
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(20),
                                onTap: () => todoViewModel.toggleTodo(todo.id),
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  child: todo.isDone
                                      ? const Icon(
                                          Icons.check,
                                          color: Colors.white,
                                          size: 20,
                                        )
                                      : null,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(width: 16),

                          // Todo Text
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  todo.title,
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    decoration: todo.isDone
                                        ? TextDecoration.lineThrough
                                        : null,
                                    color: todo.isDone
                                        ? const Color(0xFF94A3B8)
                                        : theme.colorScheme.onSurface,
                                    fontWeight: todo.isDone
                                        ? FontWeight.w400
                                        : FontWeight.w500,
                                  ),
                                ),
                                if (todo.isDone) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    'Tamamlandı',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: AppTheme.successColor,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),

                          // Delete Button
                          Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFFFEF2F2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(8),
                                onTap: () => todoViewModel.removeTodo(todo.id),
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  child: Icon(
                                    Icons.delete_outline,
                                    color: AppTheme.errorColor,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }, childCount: todoState.todos.length),
              ),
            ),

            // Empty State
            if (todoState.todos.isEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(48),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Icon(
                          Icons.task_alt_outlined,
                          size: 64,
                          color: const Color(0xFFCBD5E1),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Henüz görev yok',
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: const Color(0xFF64748B),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Yukarıdan yeni görev ekleyerek başlayın',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: const Color(0xFF94A3B8),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),

            // Bottom spacing
            const SliverToBoxAdapter(child: SizedBox(height: 32)),
          ],
        ),
      ),
    );
  }
}
