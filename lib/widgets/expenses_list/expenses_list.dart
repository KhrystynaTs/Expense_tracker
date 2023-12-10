import 'package:expense_tracker/models/expense.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/widgets/expenses_list/expense_item.dart';

class ExpensesList extends StatelessWidget {
  const ExpensesList(
      {super.key, required this.expenses, required this.onRemoveExpense});

  final List<Expense> expenses;
  final void Function(Expense expense) onRemoveExpense;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      //if we have a list with a lot of items, you should not use Column. Use ListView widget -  this is scrollable list
      itemCount: expenses.length,
      itemBuilder: (ctx, index) => Dismissible(
        //swiping effect
        key: ValueKey(expenses[index]),
        background: Container(
          color: Theme.of(context).colorScheme.error.withOpacity(0.3),
          margin: EdgeInsets.symmetric(
              horizontal: Theme.of(context).cardTheme.margin!.horizontal),
        ),
        //key mechanism exists to make widgets uniquely identifiable. In this situation a key in needed to allow Flutter to uniquely identify a widget and the data that is associated with it
        onDismissed: (direction) {
          onRemoveExpense(expenses[index]);
        },
        child: ExpenseItem(expenses[
            index]), //child should be the list item that can be swiped away
      ),
    ); //builder constructor function to make sure that all the items are only created when they are needed
  }
}
