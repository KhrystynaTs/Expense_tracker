import 'package:expense_tracker/widgets/chart/chart.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/widgets/expenses_list/expenses_list.dart';
import 'package:expense_tracker/widgets/new_expense.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});
  @override
  State<StatefulWidget> createState() {
    return _ExpensesState();
  }
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _registeredExpenses = [
    //whenever you creae a class, you automatically also get a type of the same name
    Expense(
        title: 'Flutter Course',
        amount: 19.99,
        date: DateTime.now(),
        category: Category.work),
    Expense(
      title: 'Cinema',
      amount: 15.69,
      date: DateTime.now(),
      category: Category.leisure,
    ),
    Expense(
        title: 'Food',
        amount: 190.99,
        date: DateTime.now(),
        category: Category.food),
    Expense(
        title: 'Notebook',
        amount: 2019.99,
        date: DateTime.now(),
        category: Category.work),
  ];
  void _openAddExpenseOverlay() {
    showModalBottomSheet(
      useSafeArea:
          true, //we makes sure that we stay away from the device features like the camera that might be affecting our UI. Some widgets  automatically use this safe area, for example Scaffold.
      isScrollControlled: true,
      context:
          context, //globally available context property, that's made available by Flutter automaticaly. Since we are in a class that extends state, Flutter automatically adds a context property to you class .
      builder: (ctx) => NewExpense(
          onAddExpense:
              _addExpense), //the context value as some kind of metadata collection. Every widget has its own context object that contains metadata information related to the widget and widget's position in the overal UI, in the overal widget tree
    ); //so this context value which we get here holds information about class - Expenses widget and it's position in the widget tree
  } //ctx it is a context of a showModalBottomSheet

  void _addExpense(Expense expense) {
    //I expect to get an expense value hat shoul be of type expense. So using our custom class here as a type.
    setState(() {
      _registeredExpenses.add(expense);
    });
  }

//that is how we can display such an into message with such an undo button
  void _removeExpense(Expense expense) {
    final expenseIndex = _registeredExpenses.indexOf(
        expense); //as a result we get a index of that value in that list
    setState(() {
      _registeredExpenses.remove(expense);
    });
    ScaffoldMessenger.of(context)
        .clearSnackBars(); //removes any SnackBars and any info messages we might still have on the screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 25),
        content: const Text('Expense deleted.'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _registeredExpenses.insert(expenseIndex,
                  expense); //insert method adds an item to a list at a specific position because I of course wanna bring back that expense that we removed in exactly the same place where it was before
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    Widget mainContent = const Center(
      child: Text('No expenses found. Start adding some!'),
    );

    if (_registeredExpenses.isNotEmpty) {
      mainContent = ExpensesList(
          expenses: _registeredExpenses, onRemoveExpense: _removeExpense);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter ExpenseTracker'),
        actions: [
          IconButton(
            onPressed: _openAddExpenseOverlay,
            icon: const Icon(Icons.add),
            //color: Theme.of(context).primaryColor,
            iconSize: 40,
          ),
        ],
      ),
      body: width < 600
          ? Column(
              children: [
                Chart(expenses: _registeredExpenses),
                Expanded(
                  child: mainContent,
                ),
              ],
            )
          : Row(children: [
              Expanded(
                child: Chart(expenses: _registeredExpenses),
              ),
              Expanded(
                child: mainContent,
              ),
            ]),
    );
  }
}
