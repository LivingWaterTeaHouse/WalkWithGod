import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../configurations/theme.dart';
import '../../providers/article/articles_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/user/profile_provider.dart';
import '../../screens/personal_management_screen/personal_management_screen.dart';
import '../../utils/my_logger.dart';
import '../../widgets/profile_picture.dart';
import 'article/article_list.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ScrollController _controller = new ScrollController();
  var prevIndex = -1;
  ValueNotifier<String> title;
  ValueNotifier<String> formattedDate;
  var formatter = new DateFormat('yyyy年M月d日');

  String diff(DateTime time) {
    var now = DateTime.now();
    var diffDays = now.difference(time).inDays;
    if (diffDays < 1) {
      return "今日";
    } else if (diffDays < 2) {
      return "昨日";
    } else if (diffDays < 3) {
      return "前日";
    }
    return "往日";
  }

  @override
  void didChangeDependencies() {
    var articleHeight = (MediaQuery.of(context).size.width - 40) / 7 * 8 + 25;
    title = ValueNotifier<String>("今日");
    formattedDate = ValueNotifier<String>(formatter.format(new DateTime.now()));
    _controller.addListener(() {
      var index = (_controller.offset.floor() / articleHeight).floor();
      var articles =
          Provider.of<ArticlesProvider>(context, listen: false).articles;
      if (index != prevIndex && index < articles.length && index >= 0) {
        title.value = diff(articles[index].createdDate);
        formattedDate.value = formatter.format(articles[index].createdDate);
        prevIndex = index;
      }
    });
    super.didChangeDependencies();
  }

  refreshHeader(articles) {
    if (articles.length < 1) {
      return;
    }
    title = ValueNotifier<String>(diff(articles[0].createdDate));
    formattedDate =
        ValueNotifier<String>(formatter.format(articles[0].createdDate));
  }

  Future<void> _refreshArticles(BuildContext ctx) async {
    await Provider.of<ArticlesProvider>(context, listen: false)
        .fetchArticlesByDate(new DateTime.utc(1989, 11, 9));
  }

  @override
  Widget build(BuildContext context) {
    MyLogger("Widget").i("HomeScreen-build");
    Provider.of<ProfileProvider>(context, listen: false).fetchAllUserData();
    return Scaffold(
        body: SafeArea(
            child: RefreshIndicator(
                onRefresh: () => _refreshArticles(context),
                child: NotificationListener<ScrollNotification>(onNotification:
                    (ScrollNotification scrollInfo) {
                  if (scrollInfo.metrics.pixels ==
                      scrollInfo.metrics.maxScrollExtent) {
                    Provider.of<ArticlesProvider>(context, listen: false)
                        .fetchMoreArticles(new DateTime.utc(1989, 11, 9));
                  }
                  return true;
                }, child:
                    Consumer<ArticlesProvider>(builder: (context, data, child) {
                  refreshHeader(data.articles);
                  return CustomScrollView(controller: _controller, slivers: <
                      Widget>[
                    SliverAppBar(
                      toolbarHeight: 48.0,
                      shadowColor: Theme.of(context).canvasColor,
                      backgroundColor: Theme.of(context).canvasColor,
                      pinned: true,
                      automaticallyImplyLeading: false,
                      flexibleSpace: Row(
                        children: <Widget>[
                          RawMaterialButton(
                            constraints: BoxConstraints(),
                            padding: EdgeInsets.only(left: 20),
                            onPressed: () {},
                            child: ValueListenableBuilder(
                              valueListenable: title,
                              builder: (context, String value, child) => Text(
                                value,
                                style:
                                    Theme.of(context).textTheme.captionMedium2,
                              ),
                            ),
                          ),
                          Container(
                              height: 10,
                              child: VerticalDivider(
                                  color: Color.fromARGB(255, 128, 128, 128))),
                          ValueListenableBuilder(
                            valueListenable: formattedDate,
                            builder: (context, String value, child) => Text(
                              value,
                              style: Theme.of(context)
                                  .textTheme
                                  .captionMainWideSpacing,
                            ),
                          ),
                        ],
                      ),
                      actions: [
                        FlatButton(
                          child: Consumer<ProfileProvider>(
                              builder: (ctx, profile, _) =>
                                  ProfilePicture(18.0, profile.imageUrl)),
                          onPressed: () {
                            Navigator.of(context).pushNamed(
                              PersonalManagementScreen.routeName,
                            );
                          },
                        )
                      ],
                    ),
                    ArticleList(),
                  ]);
                })))));
  }
}
