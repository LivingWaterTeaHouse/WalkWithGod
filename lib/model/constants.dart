///******** keys in Firestore ********///

const int loadLimit = 10;

// Global field names

const String fCreatedDate = "created_date";
const String fUpdatedDate = "updated_date";

// First Level collection names

const String cArticles = "articles";
const String cUsers = "users";

// Second level collection names

const String cArticleComments = "comments";

const String cUserProfile = "profile";
const String cUserfollowers = "followers";
const String cUserfollowings = "followings";
const String cUserMessages = "messages";
const String cUserSavedarticles = "saved_articles";

// Third level collection names

const String cArticleCommentReplies = "replies";
const String cArticleCommentLikes = "likes";

// Third level field names

const String fUserProfileName = "name";
const String fUserProfileImageUrl = "image_url";

const String fMessageType = "type";
const String eMessageTypeLike = "like";
const String eMessageTypeReply = "reply";
const String fMessageSenderUid = "sender_uid";
const String fMessageSenderName = "sender_name";
const String fMessageSenderImage = "sender_image";
const String fMessageReceiverUid = "receiver_uid";
const String fMessageArticleId = "article_id";
const String fMessageContent = "content";
const String fMessageIsRead = "is_read";

const String fArticleTitle = 'title';
const String fArticleDescription = 'description';
const String fArticleImageUrl = 'image_url';
const String fArticleAuthor = 'author';
const String fArticleContent = 'content';
const String fArticleIcon = 'icon';

const String fCommentArticleId = 'aid';
const String fCommentContent = 'content';
const String fCommentCreatorUid = 'creator_uid';
const String fCommentCreatorName = 'creator_name';
const String fCommentCreatorImage = 'creator_image';
const String fCommentParent = 'parent';
const String fCommentReplyTo = 'reply_to';
const String fCommentChildrenCount = 'children_count';
const String fCommentLikesCount = 'likes_count';
const String fCommentReplyLikes = 'likes';
