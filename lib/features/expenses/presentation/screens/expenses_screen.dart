import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rota_plus/app/providers.dart';
import 'package:rota_plus/app/theme/breakpoints.dart';
import 'package:rota_plus/core/formatters/formatters.dart';
import 'package:rota_plus/features/expenses/domain/entities/expense.dart';
import 'package:rota_plus/features/expenses/presentation/widgets/expense_form.dart';

/// T11 — Registro de despesas do expediente.
class ExpensesScreen extends ConsumerWidget {
  /// Cria a tela.
  const ExpensesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expenses = ref.watch(todayExpensesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Despesas de hoje')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openForm(context, ref),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Nova despesa'),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: Breakpoints.readableWidth,
            ),
            child: switch (expenses) {
              AsyncValue(hasError: true) => const _Message(
                icon: Icons.error_outline_rounded,
                text: 'Não foi possível ler as despesas.',
              ),
              AsyncValue(:final value?) when value.isEmpty => const _Message(
                icon: Icons.receipt_long_outlined,
                text: 'Nenhuma despesa registrada hoje.',
              ),
              AsyncValue(:final value?) => _ExpenseList(expenses: value),
              _ => const Center(child: CircularProgressIndicator()),
            },
          ),
        ),
      ),
    );
  }

  Future<void> _openForm(
    BuildContext context,
    WidgetRef ref, {
    Expense? initial,
  }) async {
    final repo = ref.read(expenseRepositoryProvider);

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (sheetContext) => ExpenseForm(
        initial: initial,
        onSubmit: (draft) async {
          Navigator.of(sheetContext).pop();
          if (initial == null) {
            await repo.add(
              category: draft.category,
              amount: draft.amount,
              occurredAt: draft.occurredAt,
              liters: draft.liters,
              odometerKm: draft.odometerKm,
              description: draft.description,
            );
          } else {
            await repo.update(
              initial.copyWith(
                category: draft.category,
                amount: draft.amount,
                occurredAt: draft.occurredAt,
                liters: draft.liters,
                odometerKm: draft.odometerKm,
                description: draft.description,
              ),
            );
          }
        },
      ),
    );
  }
}

class _ExpenseList extends ConsumerWidget {
  const _ExpenseList({required this.expenses});

  final List<Expense> expenses;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final total = expenses.fold(
      Decimal.zero,
      (sum, expense) => sum + expense.amount,
    );

    return ListView.builder(
      // Espaço para o FAB não cobrir o último item.
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 96, top: 8),
      itemCount: expenses.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) return _TotalCard(total: total, count: expenses.length);
        final expense = expenses[index - 1];
        return _ExpenseTile(
          expense: expense,
          onDelete: () => _confirmDelete(context, ref, expense),
        );
      },
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    Expense expense,
  ) async {
    final repo = ref.read(expenseRepositoryProvider);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Excluir despesa?'),
        content: Text(
          '${expense.category.label} de ${Fmt.money(expense.amount)}.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );

    if (confirmed ?? false) await repo.remove(expense.clientId);
  }
}

class _TotalCard extends StatelessWidget {
  const _TotalCard({required this.total, required this.count});

  final Decimal total;
  final int count;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Total do dia', style: theme.textTheme.bodySmall),
                  const SizedBox(height: 2),
                  Text(Fmt.money(total), style: theme.textTheme.headlineMedium),
                ],
              ),
            ),
            Text(
              count == 1 ? '1 lançamento' : '$count lançamentos',
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

class _ExpenseTile extends StatelessWidget {
  const _ExpenseTile({required this.expense, required this.onDelete});

  final Expense expense;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final pricePerLiter = expense.pricePerLiter;

    final subtitle = <String>[
      _formatTime(expense.occurredAt),
      if (expense.liters case final liters?) '${Fmt.number(liters)} l',
      if (pricePerLiter case final price?) '${Fmt.money(price)}/l',
      ?expense.description,
    ].join(' · ');

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Card(
        child: ListTile(
          leading: Icon(_iconFor(expense.category)),
          title: Text(expense.category.label),
          subtitle: Text(
            subtitle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                Fmt.money(expense.amount),
                style: theme.textTheme.titleMedium,
              ),
              IconButton(
                onPressed: onDelete,
                icon: const Icon(Icons.delete_outline_rounded),
                tooltip: 'Excluir',
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime value) {
    final local = value.toLocal();
    return '${local.hour.toString().padLeft(2, '0')}:'
        '${local.minute.toString().padLeft(2, '0')}';
  }

  IconData _iconFor(ExpenseCategory category) => switch (category) {
    ExpenseCategory.fuel => Icons.local_gas_station_rounded,
    ExpenseCategory.food => Icons.restaurant_rounded,
    ExpenseCategory.carWash => Icons.local_car_wash_rounded,
    ExpenseCategory.parking => Icons.local_parking_rounded,
    ExpenseCategory.maintenance => Icons.build_rounded,
    ExpenseCategory.toll => Icons.toll_rounded,
    ExpenseCategory.fine => Icons.gavel_rounded,
    ExpenseCategory.rent => Icons.key_rounded,
    ExpenseCategory.other => Icons.more_horiz_rounded,
  };
}

class _Message extends StatelessWidget {
  const _Message({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 40, color: theme.colorScheme.onSurfaceVariant),
            const SizedBox(height: 12),
            Text(
              text,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
