import 'package:hive/hive.dart';

import '../models/expense_item.dart';

class HiveDataBase{
  //reference our box
  final _myBox = Hive.box("expense_database");

  //write data
  void saveData(List<ExpenseItem> allExpenses){

    /*
    Hive can only store strings and dateTime, and not custom objects like ExpenseItem
    So ill convert ExpenseItem objects into types that can be stored in our db

    allExpenses =
    [
      ExpenseItem (name / amount / dateTime)
      ...
    ]

    ->

    [
      [ name, amount, dateTime ],
      ...
    ]

     */

    List<List<dynamic>> allExpensesFormatted = [];

    for(var expense in allExpenses){
      //convert each expenseItem into a list of storable types (string, dateTime)
      List<dynamic> expenseFormatted = [
        expense.name,
        expense.amount,
        expense.dateTime,
      ];
      allExpensesFormatted.add(expenseFormatted);
    }

    //store into our db
    _myBox.put("ALL_EXPENSES",allExpensesFormatted);


  }

  //read data

  List<ExpenseItem> readData(){

    /*
    Data is sitred in hive as a list of strings and dateTime
    Ill convert the saved data into ExpenseItem objects

    savedData =
    [
      [ name , amount, dateTime ],
      ...
    ]

    ->
    [
      ExpenseItem (name ,amount, dateTime),
      ...
    ]

     */

    List savedExpenses = _myBox.get("ALL_EXPENSES") ?? [];
    List<ExpenseItem> allExpenses = [];

    for(int i=0; i<savedExpenses.length; i++){
      //collect individual expense data
      String name = savedExpenses[i][0];
      String amount = savedExpenses[i][1];
      DateTime dateTime = savedExpenses[i][2];

      //create expense item obj
      ExpenseItem expense = ExpenseItem(
          name: name,
          amount: amount,
          dateTime: dateTime
      );

      //add expense to list of overall expenses
      allExpenses.add(expense);
    }
    return allExpenses;
  }
}
