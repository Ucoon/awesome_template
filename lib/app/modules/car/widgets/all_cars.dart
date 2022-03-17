import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../entity/car.dart';
import '../providers/car_provider.dart';
import 'car_list_widget.dart';

class AllCarsTab extends StatelessWidget {
  const AllCarsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector<CarsProvider, List<Car>>(
      selector: (context, provider) {
        return provider.carList;
      },
      builder: (context, data, child) {
        if (data.isEmpty) return child!;
        return CarListWidget(cars: data);
      },
      child: const Center(
        child: Text(
          'There are no cars',
          style: TextStyle(
            fontSize: 25.0,
          ),
        ),
      ),
    );
  }
}
