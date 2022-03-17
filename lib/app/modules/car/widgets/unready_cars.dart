import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';
import '../entity/car.dart';
import '../providers/car_provider.dart';
import 'car_list_widget.dart';

class UnReadyCarsTab extends StatelessWidget {
  const UnReadyCarsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector<CarsProvider, Tuple2<List<Car>, int>>(
      selector: (context, provider) {
        return Tuple2(
            provider.unStartedCarList, provider.unStartedCarList.length);
      },
      builder: (context, data, child) {
        if (data.item2 == 0) return child!;
        return CarListWidget(cars: data.item1);
      },
      child: const Center(
        child: Text(
          'There are no incomplete tasks',
          style: TextStyle(
            fontSize: 25.0,
          ),
        ),
      ),
    );
  }
}
