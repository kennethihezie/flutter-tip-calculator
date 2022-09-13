import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tip_calculator/util/hexcolor.dart';

class TipCalculator extends StatefulWidget {
  const TipCalculator({Key? key}) : super(key: key);

  @override
  State<TipCalculator> createState() => _TipCalculatorState();
}

class _TipCalculatorState extends State<TipCalculator> {
  int _tipPercentage = 0;
  int _personCounter = 1;
  double _billAmount = 0.0;
  final Color _purple = HexColor("#6908D6");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        //use mediaquery to put dynamic heights and widths to fit all screen sizes
        margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.1),
        color: Colors.white,
        //use listview to wrap all your widgets. to avoid background pixel overflow
        child: ListView(
          scrollDirection: Axis.vertical,
          padding: const EdgeInsets.all(20.5),
          children: [
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                  color: _purple.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12.0)),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Total Per Person", style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16.0, color: _purple),),
                    const Padding(padding: EdgeInsets.all(8.0)),
                    Text("\$${_calculateTotalPerPerson(_billAmount, _personCounter, _tipPercentage)}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0, color: _purple)),
                  ],
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20.0),
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(
                      color: Colors.grey.shade100, style: BorderStyle.solid),
                  borderRadius: BorderRadius.circular(12.0)),
              child: Column(
                children: [
                  TextField(
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    style: TextStyle(color: _purple),
                    decoration: const InputDecoration(
                        prefixText: "Bill Amount ",
                        prefixIcon: Icon(Icons.attach_money)),
                    onChanged: (text) {
                      try {
                        _billAmount = double.parse(text);
                      } catch (e) {
                        _billAmount = 0.0;
                      }
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Split",
                        style: TextStyle(color: Colors.grey),
                      ),
                      Row(
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                if (_personCounter > 1) {
                                  _personCounter--;
                                }
                              });
                            },
                            child: Container(
                              width: 40,
                              height: 40,
                              margin: const EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(7.0),
                                  color: _purple.withOpacity(0.1)),
                              child: Center(
                                  child: Text(
                                "-",
                                style: TextStyle(
                                    color: _purple,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17.0),
                              )),
                            ),
                          ),
                          Text(
                            "$_personCounter",
                            style: TextStyle(color: _purple),
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                if (_personCounter < 1) {
                                  _personCounter++;
                                }
                              });
                            },
                            child: Container(
                              width: 40,
                              height: 40,
                              margin: const EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(7.0),
                                  color: _purple.withOpacity(0.1)),
                              child: Center(
                                  child: Text(
                                "+",
                                style: TextStyle(
                                    color: _purple,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17.0),
                              )),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Tip",
                        style: TextStyle(color: Colors.grey.shade700),
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "\$${(_calculateTotalTip(_billAmount, _personCounter, _tipPercentage)).toStringAsFixed(2)}",
                          style: TextStyle(
                              color: _purple,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0),
                        ),
                      )
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "$_tipPercentage%",
                        style: TextStyle(
                            color: _purple,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold),
                      ),
                      Slider(
                        value: _tipPercentage.toDouble(),
                        onChanged: (value) {
                          setState(() {
                            _tipPercentage = value.round();
                          });
                        },
                        min: 0,
                        max: 100,
                        activeColor: _purple,
                        inactiveColor: Colors.grey,
                        divisions: 10,
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  String _calculateTotalPerPerson(double billAmount, int splitBy, int tipPerPercentage){
    var totalPerPerson = (_calculateTotalTip(billAmount, splitBy,tipPerPercentage) + billAmount) / splitBy;
    return totalPerPerson.toStringAsFixed(2);
  }

  double _calculateTotalTip(double billAmount, int splitBy, int tipPercentage){
    double totalTip = 0.0;
    if(billAmount > 0 || billAmount.toString().isNotEmpty){
      totalTip = (billAmount) * tipPercentage / 100;
    }
    return totalTip;
  }
}
