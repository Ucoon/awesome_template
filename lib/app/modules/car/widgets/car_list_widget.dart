import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../entity/car.dart';
import '../providers/car_provider.dart';

class CarListWidget extends StatelessWidget {
  final List<Car> cars;
  const CarListWidget({
    Key? key,
    required this.cars,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: cars.map((car) => _buildItemCarWidget(context, car)).toList(),
    );
  }

  Widget _buildItemCarWidget(BuildContext context, Car car) {
    return ListTile(
      leading: Checkbox(
        value: car.start,
        onChanged: (bool? checked) async {
          int result = await Provider.of<CarsProvider>(context, listen: false)
              .startCar(car);
          if (result != 0 && car.start) {
            _showSnackBar(context, '${car.brand}  ${car.type} Start');
          }
        },
      ),
      title: Text(car.brand + "  " + car.type),
      trailing: IconButton(
        onPressed: () {
          Provider.of<CarsProvider>(context, listen: false).deleteCar(car,
              callback: (result) {
            _showSnackBar(context, result);
          });
        },
        icon: Icon(
          Icons.delete,
          color: const ColorScheme.light().secondary,
        ),
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(
      duration: const Duration(milliseconds: 500),
      content: Text(
        message,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: Theme.of(context).primaryColor,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
