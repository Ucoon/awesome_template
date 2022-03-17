import 'package:awesome_template/app/routes/app_routes.dart';
import 'package:awesome_template/r_router/r_router.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/car_provider.dart';
import '../widgets/all_cars.dart';
import '../widgets/ready_cars.dart';
import '../widgets/unready_cars.dart';

class CarPage extends StatefulWidget {
  const CarPage({Key? key}) : super(key: key);

  @override
  _CarPageState createState() => _CarPageState();
}

class _CarPageState extends State<CarPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      Provider.of<CarsProvider>(context, listen: false).getCarList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cars'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              RRouter.navigateTo(AppRoutes.addCarPage);
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const <Widget>[
            Tab(text: 'All'),
            Tab(text: 'UnReady'),
            Tab(text: 'Ready'),
          ],
        ),
      ),
      body: Selector<CarsProvider, int>(
        selector: (context, provider) {
          return provider.count;
        },
        builder: (context, data, child) {
          if (data <= 0) return child!;
          return TabBarView(
            controller: _tabController,
            children: const <Widget>[
              AllCarsTab(),
              UnReadyCarsTab(),
              ReadyCarsTab()
            ],
          );
        },
        child: const Center(
          child: Text(
            'nothing in here',
            style: TextStyle(fontSize: 20.0),
          ),
        ),
      ),
    );
  }
}
