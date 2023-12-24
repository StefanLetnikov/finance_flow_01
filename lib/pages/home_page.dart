import 'package:finance_flow_01/components/expense_tile.dart';
import 'package:finance_flow_01/data/expense_data.dart';
import 'package:finance_flow_01/models/expense_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/expense_summary.dart';



class HomePage extends StatefulWidget{
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>{

  // text controllers
  final newExpenseNameController = TextEditingController();
  final newExpenseAmountController = TextEditingController();

  @override
  void initState(){
    super.initState();

    //prepare data on startup
    Provider.of<ExpenseData>(context, listen: false).prepareData();
  }


  //add new expense
  void addNewExpense(){
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Add new expense'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              //expense name
              TextField(
                controller: newExpenseNameController,
                decoration: const InputDecoration(
                  hintText: "Expense name",
                ),
              ),
              //expense amount
              TextField(
                controller: newExpenseAmountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: "Expense amount",
                ),
              ),
            ],

          ),
          actions: [
            //save button
            MaterialButton(
                onPressed: save,
              child: Text('Save'),
            ),
            //cancel button
            MaterialButton(
              onPressed: cancel,
              child: Text('Cancel'),
            )
          ],
        )
    );
  }

  //delete expense
  void deleteExpense(ExpenseItem expense){
    Provider.of<ExpenseData>(context, listen: false).deleteExpense(expense);
  }

  //save
  void save(){
    //only save expense if all fields are filled
    if(newExpenseNameController.text.isNotEmpty && newExpenseAmountController.text.isNotEmpty ){
      //create expense item
      ExpenseItem newExpense = ExpenseItem(
          name: newExpenseNameController.text,
          amount: newExpenseAmountController.text,
          dateTime: DateTime.now()
      );

      //add the new expense
      Provider.of<ExpenseData>(context, listen: false).addNewExpense(newExpense);
    }

    Navigator.pop(context);
    clear();
  }

  //cancel
  void cancel(){

    Navigator.pop(context);
    clear();
  }

  //clear controllers
  void clear(){
    newExpenseNameController.clear();
    newExpenseAmountController.clear();
  }



  @override
  Widget build(BuildContext context){
    return Consumer<ExpenseData>(
      builder: (context, value, child) => Scaffold(
        backgroundColor: Colors.grey[300],
        floatingActionButton: FloatingActionButton(
          onPressed: addNewExpense,
          child: Icon(Icons.add),
          backgroundColor: Colors.black,
        ),
        body: ListView(children: [
          //weekly summary
          ExpenseSummary(startOfWeek: value.startOfWeekDate(),),

          const SizedBox(height: 20,),

          //expense list
          ListView.builder(
            shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: value.getAllExpenseList().length,
              itemBuilder: (context, index) => ExpenseTile(
                  name: value.getAllExpenseList()[index].name,
                  amount: value.getAllExpenseList()[index].amount,
                  dateTime: value.getAllExpenseList()[index].dateTime,
                deleteTapped: (p0) => deleteExpense(value.getAllExpenseList()[index]),
              )
          ),
        ],)
      ),
    );
  }
}