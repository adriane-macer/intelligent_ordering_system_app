import 'package:intelligent_ordering_system/ui/views/home/checkout.dart';
import 'package:intelligent_ordering_system/ui/views/home/end.dart';
import 'package:intelligent_ordering_system/ui/views/home/home.dart';
import 'package:intelligent_ordering_system/ui/views/home/image_capture_page.dart';
import 'package:intelligent_ordering_system/ui/views/home/play.dart';
import 'package:intelligent_ordering_system/ui/views/home/start.dart';
import 'package:intelligent_ordering_system/ui/views/home/facial.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:navigate/navigate.dart';
import 'core/config/route.dart';
import 'core/config/routes.dart';
import 'core/config/app.dart';

import 'core/viewmodel/category_viewmodel.dart';
import 'core/viewmodel/item_viewmodel.dart';
import 'core/viewmodel/theme_provider.dart';
import 'layout.dart';
import 'locator.dart';

void main() {
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp() {
    Navigate.registerRoutes(
        routes: route, defualtTransactionType: TransactionType.fadeIn);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(builder: (_) => ThemeProvider()),
        ChangeNotifierProvider(builder: (_) => CategoryViewModel()),
        ChangeNotifierProvider(builder: (_) => ItemViewModel()),
      ],
      child: new MaterialAppTheme(),
    );
  }
}

class MaterialAppTheme extends StatefulWidget {
  @override
  _MaterialAppThemeState createState() => _MaterialAppThemeState();
}

class _MaterialAppThemeState extends State<MaterialAppTheme> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      showPerformanceOverlay: false,
      debugShowCheckedModeBanner: false,
      title: App.name,
      home: Layout(),
      routes: <String, WidgetBuilder>{
        Routes.layout: (context) => Layout(),
        Routes.home: (context) => Home(),
        Routes.checkout: (context) => CheckOut(),
        Routes.play: (context) => Play(),
        Routes.start: (context) => Start(),
        Routes.facial: (context) => ImageCapturePage(),
        Routes.end: (context) => End(),
      },
    );
  }
}
