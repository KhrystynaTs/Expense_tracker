import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart'; //package gives DateFormat class
import 'package:expense_tracker/models/expense.dart';

final formatter = DateFormat
    .yMd(); // DateFormat class create utility object with constructor function yMd. It is creates formatter object which we can use to format dates

class NewExpense extends StatefulWidget {
  const NewExpense({super.key, required this.onAddExpense});

  final void Function(Expense expense) onAddExpense;

  @override
  State<NewExpense> createState() {
    return _NewExpenseState();
  }
}

class _NewExpenseState extends State<NewExpense> {
  final _titleController =
      TextEditingController(); //this class provided by Flutter, creates an object that is optimized for handling user input
  final _amountController = TextEditingController();
  DateTime? _selectedDate;
  Category _selectedCategory =
      Category.leisure; //leisure will be selected initially
  @override //Important: we should delete Controller when the widget is not needed anymore because otherwise Controller would live in memory even though the widget is not visible anymore
  void dispose() {
    _titleController
        .dispose(); //Only 'State" classes can implement this 'dispose" method.That is also why you must use a StatefulWidget (Stateless widget can't)
    _amountController.dispose();
    super.dispose();
  }

  void _presentDatePicker() async {
    //async await we can use whenewer you get such a future value
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final pickedDate = await showDatePicker(
        //await keyword tell's Flutter that this value that shoul be stored in pickedDate won't be available immediately but at leat at some point in the future and Flutter shoul basically wait for that value before it stores it in that variable.
        context: context,
        initialDate: now,
        firstDate: firstDate,
        lastDate: now);
    //.then((value) => null);
    setState(() {
      _selectedDate = pickedDate;
    });
  }

  void _showDialog() {
    if (Platform.isIOS) {
      showCupertinoDialog(
          context: context,
          builder: (ctx) => CupertinoAlertDialog(
                title: const Text('Invalid input'),
                content: const Text(
                    'Please make sure a valid title,amount, date and category was entered.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                    },
                    child: const Text('Okay'),
                  ),
                ],
              ));
    } else {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Invalid input'),
          content: const Text(
              'Please make sure a valid title,amount, date and category was entered.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: const Text('Okay'),
            ),
          ],
        ),
      );
    }
  }

  void _submitExpenseData() {
    final enteredAmount = double.tryParse(_amountController
        .text); //Try parse takes a string as an input and then returns a double if it is able to convert that string to a number otherwise it returns null
    //tryParse('Hello')=>null, tryParse('3.14')=3.14
    final amountIsInvalid = enteredAmount == null ||
        enteredAmount <=
            0; // we wanna check here is whether enteredAmount is maybe equal to null because I just mentioned tryParse will yield null if an invald number was entered. So some text that can not be converted to a number
    if (_titleController.text
            .trim()
            .isEmpty || //trim is a built-in method that removes excess white space at the beginning or end
        amountIsInvalid ||
        _selectedDate == null) {
      _showDialog();
      return;
    }
    widget.onAddExpense(
      Expense(
          title: _titleController.text,
          amount: enteredAmount,
          date: _selectedDate!,
          category: _selectedCategory),
    );
    Navigator.pop(context);
  }

  /*
  var _enteredTitle = '';
  void _saveTitleInput(String inputValue){
    _enteredTitle = inputValue;
  }
  */

  @override
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.of(context)
        .viewInsets
        .bottom; //I can get the amount of space taken up by the keyboard
    return LayoutBuilder(builder: (ctx, constrains) {
      final width = constrains.maxWidth;
      return SizedBox(
        height: double.infinity,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                16,
                48,
                16,
                keyboardSpace +
                    16), //allows us to set different spacings for different directions
            child: Column(
              children: [
                if (width >= 600)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: TextField(
                          // keyboardAppearance: Brightness.dark,
                          controller: _titleController,
                          //onChanged: _saveTitleInput,
                          maxLength: 50,
                          decoration:
                              const InputDecoration(label: Text('Title')),
                        ),
                      ),
                      const SizedBox(
                        width: 24,
                      ),
                      Expanded(
                        child: TextField(
                          keyboardAppearance: Brightness.dark, //
                          controller: _amountController,
                          //onChanged: _saveTitleInput,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                              prefixText: '\$ ', label: Text('Amount')),
                        ),
                      ),
                    ],
                  )
                else
                  TextField(
                    keyboardAppearance: Brightness.dark,
                    controller: _titleController,
                    //onChanged: _saveTitleInput,
                    maxLength: 50,
                    decoration: const InputDecoration(label: Text('Title')),
                  ),
                if (width >= 600)
                  Row(
                    children: [
                      DropdownButton(
                        value:
                            _selectedCategory, //with that, we ensure that the currently selected value will be shown on the screen
                        items: Category.values
                            .map(
                              (category) => DropdownMenuItem(
                                value: category,
                                child: Text(
                                  category.name
                                      .toUpperCase(), //transforms a String to be all upper case
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            //dropdown button does not support a controller but we can of course manage this manually.
                            if (value == null) {
                              //value should be updates whenever a new value is selected so with help of onChanged
                              return;
                            }
                            _selectedCategory = value;
                          });
                        },
                      ),
                      const SizedBox(
                        width: 24,
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(_selectedDate == null
                                ? 'No date selected'
                                : formatter.format(
                                    _selectedDate!)), //ternary expressions
                            IconButton(
                              onPressed: _presentDatePicker,
                              icon: const Icon(Icons.calendar_month),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                else
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          keyboardAppearance: Brightness.dark, //
                          controller: _amountController,
                          //onChanged: _saveTitleInput,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                              prefixText: '\$ ', label: Text('Amount')),
                        ),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(_selectedDate == null
                                ? 'No date selected'
                                : formatter.format(
                                    _selectedDate!)), //ternary expressions
                            IconButton(
                              onPressed: _presentDatePicker,
                              icon: const Icon(Icons.calendar_month),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                const SizedBox(
                  height: 16,
                ),
                if (width >= 600)
                  Row(
                    children: [
                      const Spacer(),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(
                              context); //the pop simply removes this overlay from the screen
                        },
                        child: const Text('Cancel'),
                      ),
                      ElevatedButton(
                        onPressed: _submitExpenseData,
                        child: const Text('Save Expense'),
                      ),
                    ],
                  )
                else
                  Row(children: [
                    DropdownButton(
                      value:
                          _selectedCategory, //with that, we ensure that the currently selected value will be shown on the screen
                      items: Category.values
                          .map(
                            (category) => DropdownMenuItem(
                              value: category,
                              child: Text(
                                category.name
                                    .toUpperCase(), //transforms a String to be all upper case
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          //dropdown button does not support a controller but we can of course manage this manually.
                          if (value == null) {
                            //value should be updates whenever a new value is selected so with help of onChanged
                            return;
                          }
                          _selectedCategory = value;
                        });
                      },
                    ),
                  ]),
              ],
            ),
          ),
        ),
      );
    });
  }
}
