import 'dart:async';
import 'package:myapp/models/comment_model.dart';
import 'package:myapp/models/group_message_model.dart';
import 'package:myapp/models/group_model.dart';
import 'package:myapp/models/notification_model.dart';
import 'package:myapp/models/post_model.dart';
import 'package:myapp/models/user_message.dart';
import 'package:myapp/models/user_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._instance();
  static Database? _db;

  DatabaseHelper._instance();

  Future<Database> get db async {
    _db ??= await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'social_app.db');

    final socialDb = await openDatabase(
      path,
      version: 1,
      onCreate: _createDb,
    );
    return socialDb;
  }

  void _createDb(Database db, int version) async {
    await db.execute(
      'CREATE TABLE post_table(id INTEGER PRIMARY KEY AUTOINCREMENT, userId INTEGER, user TEXT, content TEXT, likedBy TEXT, shares INTEGER, FOREIGN KEY(userId) REFERENCES user_table(id))',
    );

    await db.execute(
      'CREATE TABLE comment_table(id INTEGER PRIMARY KEY AUTOINCREMENT, postId INTEGER, user TEXT, content TEXT, FOREIGN KEY(postId) REFERENCES post_table(id))',
    );

    await db.execute(
      'CREATE TABLE user_table(id INTEGER PRIMARY KEY AUTOINCREMENT, firstName TEXT, lastName TEXT, email TEXT, password TEXT)',
    );

    await db.execute(
      'CREATE TABLE group_table(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, description TEXT)',
    );

    await db.execute(
      'CREATE TABLE group_message_table(id INTEGER PRIMARY KEY AUTOINCREMENT, groupId INTEGER, sender TEXT, message TEXT, timestamp TEXT, FOREIGN KEY(groupId) REFERENCES group_table(id))',
    );

    await db.execute(
      'CREATE TABLE user_message_table(id INTEGER PRIMARY KEY AUTOINCREMENT, senderId INTEGER, receiverId INTEGER, message TEXT, timestamp TEXT)',
    );

    await db.execute(
      'CREATE TABLE notification_table(id INTEGER PRIMARY KEY AUTOINCREMENT, message TEXT, time TEXT, avatarUrl TEXT)',
    );
  }

  // User CRUD operations
  Future<int> insertUser(User user) async {
    final db = await this.db;
    final int result = await db.insert('user_table', user.toJson());
    return result;
  }

  Future<User?> getUser(String email, String password) async {
    final db = await this.db;
    final List<Map<String, dynamic>> result = await db.query(
      'user_table',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );

    if (result.isNotEmpty) {
      return User.fromJson(result.first);
    }
    return null;
  }

  Future<User?> getUserById(int id) async {
    final db = await this.db;
    final List<Map<String, dynamic>> result = await db.query(
      'user_table',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (result.isNotEmpty) {
      return User.fromJson(result.first);
    }
    return null;
  }

  // Post CRUD operations
  Future<int> insertPost(Post post) async {
    final db = await this.db;
    final int result = await db.insert('post_table', post.toJson());
    return result;
  }

  Future<List<Post>> getPosts() async {
    final db = await this.db;
    final List<Map<String, dynamic>> result = await db.query('post_table');

    return result.isNotEmpty
        ? result.map((item) => Post.fromJson(item)).toList()
        : [];
  }

  Future<int> updatePost(Post post) async {
    final db = await this.db;
    final int result = await db.update(
      'post_table',
      post.toJson(),
      where: 'id = ?',
      whereArgs: [post.id],
    );
    return result;
  }

  Future<int> deletePost(int id) async {
    final db = await this.db;
    final int result = await db.delete(
      'post_table',
      where: 'id = ?',
      whereArgs: [id],
    );
    return result;
  }

  // Comment CRUD operations
  Future<int> insertComment(Comment comment) async {
    final db = await this.db;
    final int result = await db.insert('comment_table', comment.toJson());
    return result;
  }

  Future<List<Comment>> getComments(int postId) async {
    final db = await this.db;
    final List<Map<String, dynamic>> result = await db.query(
      'comment_table',
      where: 'postId = ?',
      whereArgs: [postId],
    );

    return result.isNotEmpty
        ? result.map((item) => Comment.fromJson(item)).toList()
        : [];
  }

  Future<int> deleteComment(int id) async {
    final db = await this.db;
    final int result = await db.delete(
      'comment_table',
      where: 'id = ?',
      whereArgs: [id],
    );
    return result;
  }

  // Group CRUD operations
  Future<int> insertGroup(Group group) async {
    final db = await this.db;
    final int result = await db.insert('group_table', group.toJson());
    return result;
  }

  Future<List<Group>> getGroups() async {
    final db = await this.db;
    final List<Map<String, dynamic>> result = await db.query('group_table');

    return result.isNotEmpty
        ? result.map((item) => Group.fromJson(item)).toList()
        : [];
  }

  Future<int> updateGroup(Group group) async {
    final db = await this.db;
    final int result = await db.update(
      'group_table',
      group.toJson(),
      where: 'id = ?',
      whereArgs: [group.id],
    );
    return result;
  }

  Future<int> deleteGroup(int id) async {
    final db = await this.db;
    final int result = await db.delete(
      'group_table',
      where: 'id = ?',
      whereArgs: [id],
    );
    return result;
  }

  Future<int> insertGroupMessage(GroupMessage message) async {
    final db = await this.db;
    final int result = await db.insert('group_message_table', message.toJson());
    return result;
  }

  Future<List<GroupMessage>> getGroupMessages(int groupId) async {
    final db = await this.db;
    final List<Map<String, dynamic>> result = await db.query(
      'group_message_table',
      where: 'groupId = ?',
      whereArgs: [groupId],
      orderBy: 'timestamp ASC',
    );

    return result.isNotEmpty
        ? result.map((item) => GroupMessage.fromJson(item)).toList()
        : [];
  }

  Future<int> deleteGroupMessage(int id) async {
    final db = await this.db;
    final int result = await db.delete(
      'group_message_table',
      where: 'id = ?',
      whereArgs: [id],
    );
    return result;
  }

  Future<List<Post>> getUserPosts(int userId) async {
    final db = await this.db;
    final List<Map<String, dynamic>> result = await db.query(
      'post_table',
      where: 'userId = ?',
      whereArgs: [userId],
    );

    return result.isNotEmpty
        ? result.map((item) => Post.fromJson(item)).toList()
        : [];
  }

  // UserMessage CRUD operations
  Future<int> insertUserMessage(UserMessage message) async {
    final db = await this.db;
    final int result = await db.insert('user_message_table', message.toJson());
    return result;
  }

  Future<List<UserMessage>> getUserMessages(int userId1, int userId2) async {
    final db = await this.db;
    final List<Map<String, dynamic>> result = await db.query(
      'user_message_table',
      where:
          '(senderId = ? AND receiverId = ?) OR (senderId = ? AND receiverId = ?)',
      whereArgs: [userId1, userId2, userId2, userId1],
      orderBy: 'timestamp ASC',
    );

    return result.isNotEmpty
        ? result.map((item) => UserMessage.fromJson(item)).toList()
        : [];
  }

  Future<List<User>> getChatUsers(int currentUserId) async {
    final db = await this.db;
    final List<Map<String, dynamic>> result = await db.rawQuery(
      '''
      SELECT DISTINCT user_table.* FROM user_table
      JOIN user_message_table ON user_table.id = user_message_table.senderId OR user_table.id = user_message_table.receiverId
      WHERE user_message_table.senderId = ? OR user_message_table.receiverId = ?
      ''',
      [currentUserId, currentUserId],
    );

    return result.isNotEmpty
        ? result.map((item) => User.fromJson(item)).toList()
        : [];
  }

  Future<int> updateUser(User user) async {
    final db = await this.db;
    final int result = await db.update(
      'user_table',
      user.toJson(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
    return result;
  }

  Future<int> insertNotification(NotificationModel notification) async {
    final db = await this.db;
    final int result =
        await db.insert('notification_table', notification.toJson());
    return result;
  }

  Future<List<NotificationModel>> getNotifications() async {
    final db = await this.db;
    final List<Map<String, dynamic>> result =
        await db.query('notification_table');

    return result.isNotEmpty
        ? result.map((item) => NotificationModel.fromJson(item)).toList()
        : [];
  }

  Future<int> deleteNotification(int id) async {
    final db = await this.db;
    final int result = await db.delete(
      'notification_table',
      where: 'id = ?',
      whereArgs: [id],
    );
    return result;
  }
}
