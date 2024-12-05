import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'news_database.g.dart';

class Tags extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().unique()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

class NewsArticles extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  TextColumn get url => text()();
  TextColumn get source => text()();
  TextColumn get matchedTag => text()();
  BoolColumn get isRead => boolean().withDefault(const Constant(false))();
  DateTimeColumn get publishedAt => dateTime()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

@DriftDatabase(tables: [Tags, NewsArticles])
class NewsDatabase extends _$NewsDatabase {
  NewsDatabase._() : super(_openConnection());

  static final NewsDatabase instance = NewsDatabase._();

  factory NewsDatabase() => instance;

  @override
  int get schemaVersion => 1;

  Future<int> addTag(String tagName) {
    return into(tags).insert(TagsCompanion.insert(name: tagName));
  }

  Future<List<Tag>> getAllTags() {
    return select(tags).get();
  }

  Future<bool> deleteTag(String tagName) {
    return (delete(tags)..where((t) => t.name.equals(tagName)))
        .go()
        .then((value) => value > 0);
  }

  Future<NewsArticle> getArticleById(int id) async {
    return (select(newsArticles)..where((tbl) => tbl.id.equals(id)))
        .getSingle();
  }

  Future<void> logDatabaseState() async {
    final allArticles = await select(newsArticles).get();
    print('\nCurrent Database State:');
    print('Total articles in database: ${allArticles.length}');

    for (var article in allArticles) {
      print('ID: ${article.id}');
      print('Title: ${article.title}');
      print('Published: ${article.publishedAt}');
      print('Tag: ${article.matchedTag}');
      print('Read: ${article.isRead}');
      print('URL: ${article.url}');
      print('---');
    }
  }

  Future<int> addNewsArticle(NewsArticlesCompanion entry) {
    return into(newsArticles).insert(entry);
  }

  Future<List<NewsArticle>> getUnreadArticles() {
    return (select(newsArticles)..where((tbl) => tbl.isRead.equals(false)))
        .get();
  }

  Future<bool> markAsRead(int id) {
    return update(newsArticles).replace(NewsArticlesCompanion(
      id: Value(id),
      isRead: const Value(true),
    ));
  }

  Future<List<NewsArticle>> getArticlesByTag(String tag) {
    return (select(newsArticles)..where((tbl) => tbl.matchedTag.equals(tag)))
        .get();
  }

  Future<int> deleteArticlesByTag(String tag) {
    return (delete(newsArticles)..where((tbl) => tbl.matchedTag.equals(tag)))
        .go();
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'news.sqlite'));
    return NativeDatabase(file);
  });
}
