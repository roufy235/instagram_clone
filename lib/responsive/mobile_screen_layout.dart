import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:instagram_clone_app/models/user.dart';
import 'package:instagram_clone_app/providers/user_provider.dart';
import 'package:instagram_clone_app/screens/add_post/add_post_screen.dart';
import 'package:instagram_clone_app/screens/home/home_screen.dart';
import 'package:instagram_clone_app/screens/search/search_screen.dart';
import 'package:instagram_clone_app/utils/colors.dart';
import 'package:instagram_clone_app/utils/dimensions.dart';
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

    UserModel user = Provider.of<UserProvider>(context).getUser;

    return Scaffold(
      body: PageView(
        controller: pageController,
        onPageChanged: onPageChanged,
        physics: const NeverScrollableScrollPhysics(),
        children: const [
          HomeScreen(),
          SearchScreen(),
          AddPostScreen(),
          Center(child: Text("fav"),),
          Center(child: Text("profile"),)
        ],
      ),
      bottomNavigationBar: CupertinoTabBar(
        currentIndex: _page,
        onTap: navigationTapped,
        backgroundColor: mobileBackgroundColor,
        items: [
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.house, color: _page == 0 ? primaryColor : secondaryColor, size: bottomNavBarIconSize,),
            label: "",
            backgroundColor: primaryColor,
          ),
          BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.magnifyingGlass, color: _page == 1 ? primaryColor : secondaryColor, size: bottomNavBarIconSize,),
              label: "",
              backgroundColor: primaryColor
          ),
          BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.circlePlus, color: _page == 2 ? primaryColor : secondaryColor, size: bottomNavBarIconSize,),
              label: "",
              backgroundColor: primaryColor
          ),
          BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.heart, color: _page == 3 ? primaryColor : secondaryColor, size: bottomNavBarIconSize,),
              label: "",
              backgroundColor: primaryColor
          ),
          BottomNavigationBarItem(
            icon: CircleAvatar(
              backgroundImage: NetworkImage(user.photoUrl),
              radius: 16,
            ),
              //icon: Icon(Icons.person, color: _page == 4 ? primaryColor : secondaryColor),
              label: "",
              backgroundColor: primaryColor
          )
        ],
      ),
    );
  }
}
