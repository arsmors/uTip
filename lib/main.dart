import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:utip/providers/ThemeProvider.dart';
import 'package:utip/providers/TipCalculatorModel.dart';
import 'package:utip/widgets/bill_amount_field.dart';
import 'package:utip/widgets/person_counter.dart';
import 'package:utip/widgets/tip_row.dart';
import 'package:utip/widgets/tip_slider.dart';
import 'package:utip/widgets/toggle_theme_button.dart';
import 'package:utip/widgets/total_per_person.dart';

void main() {
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (context) => TipCalculatorModel()),
      ChangeNotifierProvider(create: (context) => ThemeProvider())
    ], child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      title: 'Utip App',
      theme: themeProvider.currentTheme,
      // theme: ThemeData(
      //   colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      //   useMaterial3: true,
      // ),
      home: const UTip(),
    );
  }
}

class UTip extends StatefulWidget {
  const UTip({super.key});

  @override
  State<UTip> createState() => _UTipState();
}

class _UTipState extends State<UTip> {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    final style = theme.textTheme.titleMedium!.copyWith(
        color: theme.colorScheme.onPrimary, fontWeight: FontWeight.bold);
    final model = Provider.of<TipCalculatorModel>(context);
    Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('UTip'),
        actions: const [ToggleThemeButton()],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TotalPerPerson(
              theme: theme, style: style, total: model.totalPerPerson),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border:
                      Border.all(color: theme.colorScheme.primary, width: 2)),
              child: Column(
                children: [
                  BillAmountField(
                    billAmount: model.billTotal.toString(),
                    onChanged: (value) {
                      model.updateBillTotal(double.parse(value));
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Split',
                        style: theme.textTheme.titleMedium,
                      ),
                      PersonCounter(
                        theme: theme,
                        personCount: model.personCount,
                        onDecrement: () {
                          if (model.personCount > 1) {
                            model.updatePersonCount(model.personCount - 1);
                          }
                        },
                        onIncrement: () {
                          model.updatePersonCount(model.personCount + 1);
                        },
                      ),
                    ],
                  ),
                  TipRow(
                      theme: theme,
                      billTotal: model.billTotal,
                      percentage: model.tipPercentage),
                  Text('${(model.tipPercentage * 100).round()}%'),
                  TipSlider(
                    tipPercentage: model.tipPercentage,
                    onChanged: (double value) {
                      model.updateTipPercentage(value);
                    },
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
