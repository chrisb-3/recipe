import 'package:flutter/material.dart';
import 'pages/instruction_page.dart'; // Assuming instruction_page.dart is the file containing InstructionPage

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Weekly overview'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
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
                    children: List.generate(7, (index) {
                      Color buttonColor = Colors.primaries[index % Colors.primaries.length + 10];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: buildButton(index, buttonColor),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  //Generate buttons
  Widget buildButton(int buttonIndex, Color buttonColor) {
    final List<String> weekdays = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"];
    if(buttonIndex < 0 || buttonIndex > weekdays.length) {
      return ElevatedButton(
        onPressed: () {
          //handle action}
        },
        child: Text("error"),
      );
    }
    bool isSaturday = weekdays[buttonIndex] == "Saturday";
    return ElevatedButton(
                onPressed: () {
                  //handle click
                  //Navigator.push(context, MaterialPageRoute(builder: (context) => InstructionPage(),),);
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) => InstructionPage(),
                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
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

                  //  Navigator.push(
                 //    context,
                 //    MaterialPageRoute(builder: (context) => InstructionPage()),
                 //  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text( weekdays[buttonIndex].toString(),
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
                    side: isSaturday ? BorderSide(color: Colors.red.shade900, width: 15) : BorderSide.none,
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