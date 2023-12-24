import 'package:finance_flow_01/data/hive_database.dart';
import 'package:finance_flow_01/datetime/date_time_helper.dart';
import 'package:flutter/foundation.dart';

import '../models/expense_item.dart';

class ExpenseData extends ChangeNotifier{
  final db = HiveDataBase();
  //prepare date to display
  void prepareData(){
    //if there exists data, fetch it
    if(db.readData().isNotEmpty){
      overallExpenseList = db.readData();
    }
  }

  //list of all expenses
  List<ExpenseItem> overallExpenseList = [];

  //get expense list
  List<ExpenseItem> getAllExpenseList() {
    return overallExpenseList;
  }

  //add new expense
  void addNewExpense(ExpenseItem newExpense){
    overallExpenseList.add(newExpense);

    notifyListeners();
    db.saveData(overallExpenseList);
  }

  //delete expense
  void deleteExpense(ExpenseItem expense){
    overallExpenseList.remove(expense);

    notifyListeners();
    db.saveData(overallExpenseList);
  }

  //get weekday from a dateTime object
  String getDayName(DateTime dateTime){
    switch(dateTime.weekday){
      case 1:
        return 'Monday';
      case 2:
        return 'Tuesday';
      case 3:
        return 'Wednesday';
      case 4:
        return 'Thursday';
      case 5:
        return 'Friday';
      case 6:
        return 'Saturday';
      case 7:
        return 'Sunday';
      default:
        return '';
    }
  }

  //get the date for the start of the week
  DateTime startOfWeekDate(){
    DateTime? startOfWeek;

    //get todays date
    DateTime today = DateTime.now();

    //go bakwards from today to find monday
    for(int i = 0; i<7; i++){
      if(getDayName(today.subtract(Duration(days:i))) == 'Monday'){
        startOfWeek = today.subtract(Duration(days:i));
      }
    }

    return startOfWeek!;
  }

  /*
  convert overall list of expenses into a daily expense summary
  e.g.

  overallExpenseList =
  [

  [food, 2023/01/30, 10$]
  [clothes, 2023/01/30, 20$]
  [drinks, 2023/01/30, 5$]
  [bills, 2023/01/30, 100$]
  [fuel, 2023/01/30, 50$]

  ]

  ->

  DailyExpenseSummary =
  [
  [ 30012023: 25$ ],
  [ 31012023: 25$ ],
  [ 01022023: 30$ ],
  [ 02022023: 40$ ],

  ]
   */
  Map<String,double> calculateDailyExpenseSummary(){
    Map<String,double> dailyExpenseSummary = {
      //date {ddmmyyyy} : amountTotalForDay
    };

    for(var expense in overallExpenseList){
      String date = convertDateTimeToString(expense.dateTime);
      double amount = double.parse(expense.amount);
      
      if(dailyExpenseSummary.containsKey(date)){
        double currentAmount = dailyExpenseSummary[date]!;
        currentAmount += amount;
        dailyExpenseSummary[date] = currentAmount;
      }
      else{
        dailyExpenseSummary.addAll({date:amount});
      }
    }
    return dailyExpenseSummary;
  }

}