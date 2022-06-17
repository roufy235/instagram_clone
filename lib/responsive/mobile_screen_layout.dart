import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone_app/models/user.dart';
import 'package:instagram_clone_app/providers/user_provider.dart';
import 'package:instagram_clone_app/utils/colors.dart';
import 'package:provider/provider.dart';

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({Key? key}) : super(key: key);

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {

  int _page = 0;
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  void navigationTapped(int tabPosition) {
    pageController.jumpToPage(tabPosition);
  }

  void onPageChanged(int index) {
    setState(() {
      _page = index;
    });
  }

  @override
  Widget build(BuildContext context) {

    //UserModel userModel = Provider.of<UserProvider>(context).getUser;

    return Scaffold(
      body: PageView(
        controller: pageController,
        onPageChanged: onPageChanged,
        children: [
          Center(
            child: Text("home"),
          ),
          Center(
            child: Text("search"),
          ),
          Center(
            child: Text("add"),
          ),
          Center(
            child: Text("fav"),
          ),
          Center(
            child: Text("profile"),
          )
        ],
      ),
      bottomNavigationBar: CupertinoTabBar(
        currentIndex: _page,
        onTap: navigationTapped,
        backgroundColor: mobileBackgroundColor,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: _page == 0 ? primaryColor : secondaryColor),
            label: "",
            backgroundColor: primaryColor,
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.search, color: _page == 1 ? primaryColor : secondaryColor),
              label: "",
              backgroundColor: primaryColor
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.add_circle, color: _page == 2 ? primaryColor : secondaryColor),
              label: "",
              backgroundColor: primaryColor
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite, color: _page == 3 ? primaryColor : secondaryColor),
              label: "",
              backgroundColor: primaryColor
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.person, color: _page == 4 ? primaryColor : secondaryColor),
              label: "",
              backgroundColor: primaryColor
          )
        ],
      ),
    );
  }
}
