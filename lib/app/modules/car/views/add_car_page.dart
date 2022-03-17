import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../entity/car.dart';
import '../providers/car_provider.dart';

class AddCarPage extends StatefulWidget {
  const AddCarPage({Key? key}) : super(key: key);

  @override
  _AddCarPageState createState() => _AddCarPageState();
}

class _AddCarPageState extends State<AddCarPage> {
  final carBrandController = TextEditingController();
  final carTypeController = TextEditingController();
  bool started = false;

  @override
  void dispose() {
    carBrandController.dispose();
    super.dispose();
  }

  void onAdd() {
    if (carBrandController.text.isNotEmpty &&
        carTypeController.text.isNotEmpty) {
      final Car car = Car(
          brand: carBrandController.text,
          type: carTypeController.text,
          start: started);
      Provider.of<CarsProvider>(context, listen: false).addCar(car);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Cars'),
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                TextField(
                  controller: carBrandController,
                ),
                TextField(
                  controller: carTypeController,
                ),
                CheckboxListTile(
                  value: started,
                  onChanged: (checked) {
                    setState(() {
                      started = checked!;
                    });
                  },
                  title: const Text('Start ?'),
                ),
                ElevatedButton(
                  child: const Text('Add'),
                  onPressed: onAdd,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
