import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartpart/Page/SecondPage/State/second_page.dart';

class AgeSlider extends StatefulWidget {
  const AgeSlider({super.key});

  @override
  State<AgeSlider> createState() => _AgeSliderState();
}

class _AgeSliderState extends State<AgeSlider> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Selector<SecondPageModel, double>(
          builder: (_, age, __) {
            return Text(
              "Age: ${age.round()}",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 114, 114, 114),
              ),
            );
          },
          selector: (_, model) => model.age,
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: Colors.blue,
            inactiveTrackColor: const Color.fromARGB(255, 149, 149, 149),
            trackHeight: 5,
            thumbColor: Colors.blue,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
            overlayColor: Colors.blue.withOpacity(0.2),
          ),
          child: Selector<SecondPageModel, double>(
            builder: (_, age, __) {
              return Slider(
                value: age,
                min: 18,
                max: 75,
                divisions: 57,
                label: age.round().toString(),
                onChanged: (value) {
                  context.read<SecondPageModel>().storeAge(value);
                },
              );
            },
            selector: (_, model) => model.age,
          ),
        ),
      ],
    );
  }
}
