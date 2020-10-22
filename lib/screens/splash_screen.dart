import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:walk_with_god/widgets/my_icon_button.dart';

import '../configurations/theme.dart';
import '../providers/article/articles_provider.dart';
import '../providers/splash_provider.dart';
import '../providers/user/profile_provider.dart';
import '../utils/my_logger.dart';
import '../utils/utils.dart';
import 'home_screen/home_screen.dart';

class SplashScreen extends StatefulWidget {
  static const routeHomeName = '/splash';
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  StatefulWidget nextScreen;
  Timer _timer;

  @override
  void initState() {
    super.initState();
    startTime();
    loadData();
  }

  loadData() {
    exceptionHandling(context, () async {
      await Provider.of<SplashProvider>(context, listen: false)
          .fetchSplashScreensData();
      await Provider.of<ArticlesProvider>(context, listen: false)
          .fetchArticlesByDate(new DateTime.utc(1989, 11, 9));
      await Provider.of<ProfileProvider>(context, listen: false)
          .fetchAllUserData();
    });
  }

  startTime() {
    _timer = Timer(Duration(seconds: 8), routeHome);
  }

  void routeHome() {
    Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    MyLogger("Widget").i("SplashScreen-build");
    return Scaffold(body: SafeArea(
        child: Consumer<SplashProvider>(builder: (context, splash, child) {
      if (splash.imageUrl == null)
        return Center(child: CircularProgressIndicator());
      return FlatButton(
          onPressed: () {
            _timer.cancel();
            routeHome();
          },
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 4.0),
                  child: Center(
                      child: Material(
                    child: CachedNetworkImage(
                      imageUrl: splash.imageUrl,
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  )),
                ),
              ),
              Container(
                width: 200,
                child: Column(children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2.0),
                    child: Text(
                      splash.content,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.captionSmall2,
                    ),
                  ),
                  Divider(
                    indent: 8.0,
                    endIndent: 8.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2.0),
                    child: Text(
                      splash.author + " 作品 ",
                      style: Theme.of(context).textTheme.captionSmall2,
                    ),
                  ),
                ]),
              ),
              Row(
                children: [
                  Container(
                    width: 100,
                    height: 50,
                    child: Image.asset("assets/images/app_logo.png"),
                  ),
                  Expanded(
                    child: SizedBox(),
                  ),
                  Container(
                      height: 10,
                      child: VerticalDivider(
                          color: Color.fromARGB(255, 128, 128, 128))),
                  FlatButton(
                      onPressed: () {
                        _timer.cancel();
                        routeHome();
                      },
                      child: Row(
                        children: [
                          Text(
                            "进入应用",
                            style: Theme.of(context).textTheme.captionSmall2,
                          ),
                          Icon(Icons.arrow_right)
                        ],
                      ))
                ],
              ),
            ],
          ));
    })));
  }
}
