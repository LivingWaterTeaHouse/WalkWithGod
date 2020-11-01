import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

import '../../configurations/constants.dart';
import '../../utils/my_logger.dart';
import 'article_provider.dart';

class ArticlesProvider with ChangeNotifier {
  var _fdb = FirebaseFirestore.instance;
  MyLogger _logger = MyLogger("Provider");
  DocumentSnapshot _lastVisibleChild;
  bool _noMoreChild = false;
  bool _isFetching = false;

  List<ArticleProvider> _articles = [];

  List<ArticleProvider> get articles {
    return [..._articles];
  }

  static Future<List<ArticleProvider>> fetchList(List<String> aids) async {
    MyLogger("Provider").i("ArticlesProvider-fetchList");
    QuerySnapshot query = await FirebaseFirestore.instance
        .collection(cArticles)
        .where(FieldPath.documentId, whereIn: aids)
        .get();
    List<ArticleProvider> result = [];
    query.docs.forEach((data) {
      result.add(buildArticleByMap(data.id, data.data()));
    });
    return result;
  }

  Future<void> fetchArticlesByDate(
      [DateTime dateTime,
      int n = loadLimit,
      bool isContentNeeded = false]) async {
    _logger.i("ArticlesProvider-fetchArticlesByDate");
    if (dateTime == null) dateTime = DateTime.now();

    QuerySnapshot query = await _fdb
        .collection(cArticles)
        .where(fCreatedDate, isGreaterThanOrEqualTo: dateTime)
        .orderBy(fCreatedDate, descending: true)
        .limit(n)
        .get();
    _articles = [];
    setArticles(query, isContentNeeded, n);
  }

  Future<void> fetchMoreArticles(
      [DateTime dateTime,
      int n = loadLimit,
      bool isContentNeeded = false]) async {
    if (_noMoreChild || _isFetching) return;
    _logger.i("ArticlesProvider-fetchMoreArticles");
    _isFetching = true;
    if (dateTime == null) dateTime = DateTime.now();

    QuerySnapshot query = await _fdb
        .collection(cArticles)
        .where(fCreatedDate, isGreaterThanOrEqualTo: dateTime)
        .orderBy(fCreatedDate, descending: true)
        .startAfterDocument(_lastVisibleChild)
        .limit(n)
        .get();
    _isFetching = false;
    setArticles(query, isContentNeeded, n);
  }

  ArticleProvider findArticleInListById(String aid) {
    return _articles.firstWhere((a) => a.id == aid, orElse: () {
      return ArticleProvider();
    });
  }

  Future<ArticleProvider> fetchArticlePreviewById(String aid) async {
    ArticleProvider article = findArticleInListById(aid);
    if (article.id != null) return article;
    MyLogger("Provider").i("ArticlesProvider-fetchArticlePreviewById");
    DocumentSnapshot data =
        await FirebaseFirestore.instance.collection(cArticles).doc(aid).get();
    return buildArticleByMap(data.id, data.data());
  }

  void setArticles(QuerySnapshot query,
      [bool isContentNeeded = false, int limit = 10]) {
    query.docs.forEach((data) {
      _articles.add(buildArticleByMap(data.id, data.data()));
    });
    if (query.docs.length < limit) _noMoreChild = true;
    if (query.docs.length > 0)
      _lastVisibleChild = query.docs[query.docs.length - 1];
    notifyListeners();
  }

  static ArticleProvider buildArticleByMap(
      String id, Map<String, dynamic> data) {
    return ArticleProvider(
        id: id,
        title: data[fArticleTitle],
        description: data[fArticleDescription],
        imageUrl: data[fArticleImageUrl],
        authorName: data[fArticleAuthorName],
        authorUid: data[fArticleAuthorUid],
        createdDate: (data[fCreatedDate] as Timestamp).toDate(),
        icon: data[fArticleIcon],
        publisher: data[fArticlePublisher]);
  }
}
