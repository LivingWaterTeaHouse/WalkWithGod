import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

import '../../configurations/constants.dart';
import '../../utils/my_logger.dart';
import 'message_provider.dart';

class MessagesProvider with ChangeNotifier {
  var fdb;
  MyLogger _logger = MyLogger("Provider");
  String _userId;
  int messagesCount = 0;
  int unreadMessagesCount = 0;
  List<MessageProvider> _items = [];
  DocumentSnapshot _lastVisible;
  bool _noMore = false;
  bool _isFetching = false; // To avoid frequently request

  // getters and setters

  void setProvider(dynamic fdb, String userId) {
    this.fdb = fdb;
    _userId = userId;
  }

  List<MessageProvider> get items {
    return [..._items];
  }

  bool get noMore {
    return _noMore;
  }

  // methods

  Future<void> fetchMessageList([int limit = loadLimit]) async {
    _logger.i("MessagesProvider-fetchMessageList");
    QuerySnapshot query = await fdb
        .collection(cUsers)
        .doc(_userId)
        .collection(cUserMessages)
        .orderBy(fCreatedDate, descending: true)
        .limit(limit)
        .get();
    _items = [];
    _appendMessageList(query, limit);
  }

  Future<void> fetchMoreMessages([int limit = loadLimit]) async {
    if (_userId == null || _isFetching) return;
    _logger.i("MessagesProvider-fetchMoreMessages");
    _isFetching = true;
    QuerySnapshot query = await fdb
        .collection(cUsers)
        .doc(_userId)
        .collection(cUserMessages)
        .orderBy(fCreatedDate, descending: true)
        .startAfterDocument(_lastVisible)
        .limit(limit)
        .get();
    _isFetching = false;
    _appendMessageList(query, limit);
  }

  static Future<void> markMessageAsRead(
      String receiverUid, String messageId) async {
    MessageProvider message = MessageProvider(
        id: messageId,
        articleId: null,
        commentId: null,
        senderUid: null,
        senderName: null,
        senderImage: null,
        receiverUid: receiverUid,
        type: null,
        createdDate: null,
        isRead: null);
    message.markMessageAsRead(true);
  }

  MessageProvider findMessageInItem(String messageId) {
    return _items.firstWhere((a) => a.id == messageId, orElse: () {
      return null;
    });
  }

  // Used by other classes
  static Future<void> sendMessage(
      String type,
      String senderUid,
      String senderName,
      String senderImage,
      String receiverUid,
      String articleId,
      String commentId,
      String content) async {
    MyLogger("Provider").i("MessagesProvider-sendMessage");
    Map<String, dynamic> data = {};
    data[fMessageType] = type;
    data[fMessageSenderUid] = senderUid;
    data[fMessageSenderName] = senderName;
    if (senderImage != null) data[fMessageSenderImage] = senderImage;
    data[fMessageReceiverUid] = receiverUid;
    data[fMessageArticleId] = articleId;
    data[fMessageCommentId] = commentId;
    data[fCreatedDate] = Timestamp.now();
    data[fMessageIsRead] = false;
    data[fMessageContent] = content;

    FirebaseFirestore.instance
        .collection(cUsers)
        .doc(receiverUid)
        .collection(cUserMessages)
        .doc()
        .set(data, SetOptions(merge: true));
  }

  void _appendMessageList(QuerySnapshot query, int limit) {
    List<DocumentSnapshot> docs = query.docs;
    docs.forEach((data) {
      _items.add(_buildMessageByMap(data.id, data.data()));
    });
    if (docs.length < limit) _noMore = true;
    if (docs.length > 0) _lastVisible = docs[docs.length - 1];
    notifyListeners();
  }

  MessageProvider _buildMessageByMap(String id, Map<String, dynamic> data) {
    return MessageProvider(
        id: id,
        articleId: data[fMessageArticleId],
        commentId: data[fMessageCommentId],
        senderUid: data[fMessageSenderUid],
        senderName: data[fMessageSenderName],
        senderImage: data[fMessageSenderImage],
        receiverUid: data[fMessageReceiverUid],
        type: data[fMessageType],
        createdDate: (data[fCreatedDate] as Timestamp).toDate(),
        isRead: data[fMessageIsRead]);
  }
}
