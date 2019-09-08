import '../screens/results_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../components/description_card.dart';
import '../components/reusable_card.dart';
import '../constants.dart';
import '../components/bottom_button.dart';
import '../components/round_icon_button.dart';
import '../calculator_brain.dart';

enum GenderType { male, female }

class InputPage extends StatefulWidget {
  @override
  _InputPageState createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  GenderType _selectedGender;
  int _height = 160;
  int _weight = 60;
  int _age = 30;

  bool _loopActive = false;
  bool _buttonDecreaseWeightPressed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(child: Text('BMI CALCULATOR')),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedGender = GenderType.male;
                        });
                      },
                      child: new ReusableCard(
                        colour: _selectedGender == GenderType.male
                            ? kActiveCardColour
                            : kInactiveCardColour,
                        cardChild: new DescriptionCard(
                          icon: FontAwesomeIcons.mars,
                          textPrimary: 'MALE',
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedGender = GenderType.female;
                        });
                      },
                      child: new ReusableCard(
                        colour: _selectedGender == GenderType.female
                            ? kActiveCardColour
                            : kInactiveCardColour,
                        cardChild: new DescriptionCard(
                          icon: FontAwesomeIcons.venus,
                          textPrimary: 'FEMALE',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: new ReusableCard(
                colour: kActiveCardColour,
                cardChild: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'HEIGHT',
                      style: kLabelTextStyle,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: <Widget>[
                        Text(
                          '${_height.toInt()}',
                          style: kNumberTextStyle,
                        ),
                        Text(
                          'cm',
                          style: kLabelTextStyle,
                        ),
                      ],
                    ),
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: Colors.white,
                        inactiveTrackColor: Color(0xFFEB1555),
                        thumbColor: Color(0xFFEB1555),
                        thumbShape:
                            RoundSliderThumbShape(enabledThumbRadius: 15.0),
                        overlayShape:
                            RoundSliderOverlayShape(overlayRadius: 30.0),
                      ),
                      child: Slider(
                        min: 120.0,
                        max: 220.0,
                        onChanged: (newRating) {
                          setState(() => _height = newRating.toInt());
                        },
                        value: _height.toDouble(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: new ReusableCard(
                      colour: kActiveCardColour,
                      cardChild: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'WEIGHT',
                            style: kLabelTextStyle,
                          ),
                          Text(_weight.toString(), style: kNumberTextStyle),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Listener(
                                  onPointerDown: (details) {
                                    _buttonDecreaseWeightPressed = true;
                                    _adjustValueWhilePressed();
                                  },
                                  onPointerUp: (details) {
                                    _buttonDecreaseWeightPressed = false;
                                  },
                                  child: RoundIconButton(
                                    icon: FontAwesomeIcons.minus,
//                                    onPressed: () {
//                                      setState(() {
//                                        weight--;
//                                      });
//                                    },
                                  ),
                                ),
                                RoundIconButton(
                                  icon: FontAwesomeIcons.plus,
                                  onPressed: () {
                                    setState(() {
                                      _weight++;
                                    });
                                  },
                                ),
                              ]),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: new ReusableCard(
                      colour: kActiveCardColour,
                      cardChild: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'AGE',
                            style: kLabelTextStyle,
                          ),
                          Text(_age.toString(), style: kNumberTextStyle),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                //TODO longPress to change weight and height value
                                RoundIconButton(
                                  icon: FontAwesomeIcons.minus,
                                  onPressed: () {
                                    setState(() {
                                      _age--;
                                    });
                                  },
                                ),
                                RoundIconButton(
                                  icon: FontAwesomeIcons.plus,
                                  onPressed: () {
                                    setState(() {
                                      _age++;
                                    });
                                  },
                                ),
                              ]),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            BottomButton(
              titleButton: 'CALCULATE',
              onTap: () {
                CalculatorBrain calc =
                    CalculatorBrain(height: _height, weight: _weight);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ResultsPage(
                              bmiResult: calc.calculateBMI(),
                              resultText: calc.getResult(),
                              interpretation: calc.getInterpretation(),
                            )));
              },
            ),
          ],
        ));
  }

  void _adjustValueWhilePressed() async {
    // make sure that only one loop is active
    if (_loopActive) return;

    _loopActive = true;

    while (_buttonDecreaseWeightPressed) {
      // do your thing
      setState(() {
        _weight--;
      });

      // wait a bit
      await Future.delayed(Duration(milliseconds: 200));
    }

    _loopActive = false;
  }
}
