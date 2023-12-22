import 'package:flutter/material.dart';
import 'package:goodspace_assignment/home_widget/message_page.dart';
import 'package:goodspace_assignment/home_widget/profile_page.dart';
import 'package:goodspace_assignment/home_widget/recruit_page.dart';
import 'package:goodspace_assignment/home_widget/social_page.dart';
import 'package:goodspace_assignment/screens/home_page.dart';






class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  late List<Widget> tabs; 
 

  @override
  void initState() {
    super.initState();
   
    tabs = [
      HomePage(),
      WorkPage(),
      SocialPage(), 
      MessagePage(), 
      ProfilePage(),

    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
      body: tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.work),
            label: "Work",
            backgroundColor: Colors.white
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.work_outline),
            label: "Recruit",
            backgroundColor: Colors.white
          ),
          BottomNavigationBarItem(
            icon:Icon(Icons.account_tree),
            label: "Social",
            backgroundColor: Colors.white
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: "Message",
            backgroundColor: Colors.white
          ),
                 BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
            backgroundColor: Colors.white
          ),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
