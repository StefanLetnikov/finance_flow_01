import 'individual_bar.dart';

class BarData{
  final double mondayAmount;
  final double tuesdayAmount;
  final double wednesdayAmount;
  final double thursdayAmount;
  final double fridayAmount;
  final double saturdayAmount;
  final double sundayAmount;

  List<IndividualBar> barData = [];

  BarData({
    required this.mondayAmount,
    required this.tuesdayAmount,
    required this.wednesdayAmount,
    required this.thursdayAmount,
    required this.fridayAmount,
    required this.saturdayAmount,
    required this.sundayAmount
  });

  //initialize bar data
void initializeBarData(){
  barData = [
    //monday
    IndividualBar(x: 0, y: mondayAmount),
    //tuesday
    IndividualBar(x: 1, y: tuesdayAmount),
    //wednesday
    IndividualBar(x: 2, y: wednesdayAmount),
    //thursday
    IndividualBar(x: 3, y: thursdayAmount),
    //friday
    IndividualBar(x: 4, y: fridayAmount),
    //saturday
    IndividualBar(x: 5, y: saturdayAmount),
    //sunday
    IndividualBar(x: 6, y: sundayAmount),
  ];
}

}