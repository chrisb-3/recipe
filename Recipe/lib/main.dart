import 'package:flutter/material.dart';
import 'pages/instruction_page.dart';
import 'pages/shoppingList.dart';
//import 'package:provider/provider.dart';

/** start rendering UI and make MyApp the base widgit */
void main() {
  runApp(const MyApp());
}

/** Basic info of app like color theme and title*/
class MyApp extends StatelessWidget {
  const MyApp({super.key}); // constructor

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Weekly overview'), //widget that displays when app starts
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({ //constructor
    super.key,
    required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState(); // return a new instance of _MyHomePageState
}

/** Manages the sate of MyHomePage
 *  defines the build method
 */
class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Use SizedBox to set a fixed height for the ListView
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.8, // Adjust the height as needed
                child: ListView(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  children: List.generate(7, (index) { //call the button generating function 7 times
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: buildButton(index),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month_sharp),
            label: 'Weekly Overview',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.checklist_rtl),
            label: 'Shopping List',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (_selectedIndex == 0) {
      // Navigate to WeeklyOverviewPage when the Weekly Overview button is tapped
    } else if (_selectedIndex == 1) {
      bool shoppingListPageFound = false;
      Navigator.of(context).popUntil((route) {
        if (route.settings.name == ShoppingList().toString()) {
          shoppingListPageFound = true;
          return true;
        }
        return false;
      });

      if (!shoppingListPageFound) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ShoppingList()),
        );
      }
    }
  }

  //Generate buttons
  Widget buildButton(int buttonIndex) {
    final List<String> weekdays = [
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday",
      "Saturday",
      "Sunday"
    ];
    if (buttonIndex < 0 || buttonIndex >= weekdays.length) {
      return SizedBox();
    }
else {
    Color buttonColor = Colors.primaries[buttonIndex % Colors.primaries.length + 10];
    bool isSaturday = weekdays[buttonIndex] == "Saturday";
    return ElevatedButton(
      onPressed: () {
        Navigator.push( // go to the instruction page when a day is clicked
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                InstructionPage(), //add the day index
            transitionsBuilder: (context, animation, secondaryAnimation,
                child) {
              const beginOffset = Offset(1.0, 0.0);
              const endOffset = Offset.zero;
              final tween = Tween(begin: beginOffset, end: endOffset)
                  .chain(CurveTween(curve: Curves.easeInOut));
              final offsetAnimation = animation.drive(tween);

              return SlideTransition(
                position: offsetAnimation,
                child: child,
              );
            },
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(weekdays[buttonIndex].toString(),
          style: TextStyle(
            color: Colors.white,
            fontSize: 30, // Decrease font size for better fit
          ),
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonColor,
        // Change background color to the inputed color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
              50), // Increase border radius for a rounder button
          side: isSaturday
              ? BorderSide(color: Colors.red.shade900, width: 15)
              : BorderSide.none,
        ),
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        // Increase padding for better touch target
        elevation: 10,
        // Increase elevation for a more pronounced shadow
        shadowColor: buttonColor,
        // Change shadow color to a darker shade of the inputed color
        tapTargetSize: MaterialTapTargetSize.padded,
        // Add padding to the tap target for better touch feedback
        animationDuration: Duration(milliseconds: 300),
        // Decrease animation duration for quicker feedback
        splashFactory: InkRipple
            .splashFactory, // Use InkRipple splash effect for the ripple animation
      ),
    );
  }
  }
}