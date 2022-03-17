import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'app/modules/car/providers/car_provider.dart';

///provider mvvm封装 参考：https://www.examplecode.cn/2020/05/09/flutter-provider-mvvm/
List<SingleChildWidget> providers = [
  ...independentServices,
  ...dependentServices,
];

/// 独立的model
List<SingleChildWidget> independentServices = [
  ChangeNotifierProvider(
    create: (context) => CarsProvider(),
  ),
];

/// 需要依赖的model
/// UserModel依赖globalFavouriteStateModel
List<SingleChildWidget> dependentServices = [];
