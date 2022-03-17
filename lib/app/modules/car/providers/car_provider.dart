import 'dart:collection';
import '../../../base/provider/base_provider.dart';
import '../db/database_helper.dart';
import '../entity/car.dart';

class CarsProvider extends BaseProvider {
  CarsProvider() {
    DatabaseHelper().createDb();
  }

  List<Car> _carList = <Car>[];

  UnmodifiableListView<Car> get carList => UnmodifiableListView(_carList);

  UnmodifiableListView<Car> get unStartedCarList =>
      UnmodifiableListView(_carList.where((car) => !car.start));

  UnmodifiableListView<Car> get startedCarList =>
      UnmodifiableListView(_carList.where((car) => car.start));

  void getCarList() async {
    List<Car> carList = await DatabaseHelper().getCarList();
    _carList = List.from(carList);
    notifyListeners();
  }

  int get count => _carList.length;

  Future<int> addCar(Car car) async {
    int result;
    if (car.id != null) {
      result = await DatabaseHelper().updateCar(car);
    } else {
      result = await DatabaseHelper().insertCar(car);
    }
    getCarList();
    return result;
  }

  Future<int> startCar(Car car) async {
    car.start = !car.start;
    int result = await DatabaseHelper().updateCar(car);
    getCarList();
    return result;
  }

  Future<void> deleteCar(
    Car car, {
    Function? callback,
  }) async {
    if (car.id == null) {
      callback?.call('No Car was deleted');
      return;
    }

    int result = await DatabaseHelper().deleteCar(car.id!);
    if (result != 0) {
      callback?.call('Car Deleted Successfully');
    } else {
      callback?.call('Error Occurred while deleting note');
    }
    getCarList();
    notifyListeners();
  }
}
