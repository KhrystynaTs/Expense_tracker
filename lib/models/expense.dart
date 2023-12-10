import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; //package gives DateFormat class

final formatter = DateFormat
    .yMd(); // DateFormat class create utility object with constructor function yMd. It is creates formatter object which we can use to format dates

const uuid = Uuid();

enum Category { food, travel, leisure, work }

const categoryIcons = {
  Category.food: Icons.lunch_dining,
  Category.travel: Icons.flight_takeoff,
  Category.leisure: Icons.movie,
  Category.work: Icons.work,
};

class Expense {
  Expense({
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
  }) : id = uuid
            .v4(); //generates a unique ID and assigns itas an initial value to the ID property

  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final Category category;

  String get formattedDate {
    return formatter.format(date);
  }
}

class ExpenseBucket {
  const ExpenseBucket({
    required this.category,
    required this.expenses,
  });

  ExpenseBucket.forCategory(List<Expense> allExpenses,
      this.category) //this is how you can add additional constructor functions to ypur classes:repeating the name of the class and then dot right after it inside here of the class definition and then adding the name of the extra constructions function you wanna add

      : expenses = allExpenses
            .where((expense) => expense.category == category)
            .toList();

  final Category category;
  final List<Expense> expenses;

  double get totalExpenses {
    double sum = 0;
    //using another kind of Loop for-in
    for (final expense in expenses) {
      //we simply tell dart that we want to go through all the items in expenses list and every iteration a new item will be picked and stored in a newly created final variable called expense
      sum = sum + expense.amount;
    }
    return sum;
  }
}
