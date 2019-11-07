import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intelligent_ordering_system/core/config/app.dart';
import 'package:intelligent_ordering_system/core/config/route.dart';
import 'package:intelligent_ordering_system/core/config/routes.dart';
import 'package:intelligent_ordering_system/core/viewmodel/category_viewmodel.dart';
import 'package:intelligent_ordering_system/core/viewmodel/item_viewmodel.dart';
import 'package:intelligent_ordering_system/core/viewmodel/theme_provider.dart';
import 'package:intelligent_ordering_system/layout.dart';
import 'package:intelligent_ordering_system/locator.dart';
import 'package:intelligent_ordering_system/ui/views/home/checkout.dart';
import 'package:navigate/navigate.dart';
import 'package:provider/provider.dart';


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
        Routes.checkout: (context) => CheckOut(),
      },
    );
  }
}
