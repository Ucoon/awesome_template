import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'home/four_page.dart';
import 'home/home_page.dart';
import 'home/second_page.dart';
import 'home/third_page.dart';
import '/common/utils/utils.dart';
import '/generated/l10n.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;
  final List<Widget> _pageList = [];
  late PageController _pageController;
  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
    _pageList.addAll(_buildPageList());
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('_MainPageState.build');
    return BackButtonListener(
      onBackButtonPressed: () {
        return ApplicationUtil.confirmExitApplication(2);
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: _buildPageView(),
        bottomNavigationBar: _buildBottomNavigationBar(),
      ),
    );
  }

  Widget _buildPageView() {
    return PageView.builder(
      physics: const NeverScrollableScrollPhysics(),
      controller: _pageController,
      itemCount: _pageList.length,
      itemBuilder: (context, index) {
        return _pageList[index];
      },
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      items: _createBottomNavigationBarItems(),
      currentIndex: _currentIndex,
      onTap: _onBottomBarItemTap,
      type: BottomNavigationBarType.fixed,
      selectedFontSize: 10.sp,
      unselectedFontSize: 10.sp,
      backgroundColor: Colors.white,
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
      iconSize: 32.w,
    );
  }

  void _onBottomBarItemTap(int index) {
    if (!mounted || _currentIndex == index) return;
    setState(() {
      _currentIndex = index;
    });
    _pageController.jumpToPage(index);
  }

  List<BottomNavigationBarItem> _createBottomNavigationBarItems() {
    return <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        label: S.current.home,
        icon: const Icon(Icons.home, color: Colors.grey),
        activeIcon: const Icon(Icons.home, color: Colors.blue),
      ),
      BottomNavigationBarItem(
        label: S.current.mine_order,
        icon: const Icon(Icons.bookmark_border_rounded, color: Colors.grey),
        activeIcon:
            const Icon(Icons.bookmark_border_rounded, color: Colors.blue),
      ),
      BottomNavigationBarItem(
        label: S.current.knowledge_popularization,
        icon: const Icon(Icons.book, color: Colors.grey),
        activeIcon: const Icon(Icons.book, color: Colors.blue),
      ),
      BottomNavigationBarItem(
        label: S.current.personal_center,
        icon: const Icon(Icons.person, color: Colors.grey),
        activeIcon: const Icon(Icons.person, color: Colors.blue),
      ),
    ];
  }

  List<Widget> _buildPageList() {
    return <Widget>[
      const HomePage(title: 'home'),
      const SecondPage(),
      const ThirdPage(),
      const FourPage(),
    ];
  }
}
