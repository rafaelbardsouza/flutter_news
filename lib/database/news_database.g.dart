// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'news_database.dart';

// ignore_for_file: type=lint
class $TagsTable extends Tags with TableInfo<$TagsTable, Tag> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TagsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [id, name, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tags';
  @override
  VerificationContext validateIntegrity(Insertable<Tag> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Tag map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Tag(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $TagsTable createAlias(String alias) {
    return $TagsTable(attachedDatabase, alias);
  }
}

class Tag extends DataClass implements Insertable<Tag> {
  final int id;
  final String name;
  final DateTime createdAt;
  const Tag({required this.id, required this.name, required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  TagsCompanion toCompanion(bool nullToAbsent) {
    return TagsCompanion(
      id: Value(id),
      name: Value(name),
      createdAt: Value(createdAt),
    );
  }

  factory Tag.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Tag(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Tag copyWith({int? id, String? name, DateTime? createdAt}) => Tag(
        id: id ?? this.id,
        name: name ?? this.name,
        createdAt: createdAt ?? this.createdAt,
      );
  Tag copyWithCompanion(TagsCompanion data) {
    return Tag(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Tag(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Tag &&
          other.id == this.id &&
          other.name == this.name &&
          other.createdAt == this.createdAt);
}

class TagsCompanion extends UpdateCompanion<Tag> {
  final Value<int> id;
  final Value<String> name;
  final Value<DateTime> createdAt;
  const TagsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  TagsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.createdAt = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Tag> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  TagsCompanion copyWith(
      {Value<int>? id, Value<String>? name, Value<DateTime>? createdAt}) {
    return TagsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TagsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $NewsArticlesTable extends NewsArticles
    with TableInfo<$NewsArticlesTable, NewsArticle> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NewsArticlesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _urlMeta = const VerificationMeta('url');
  @override
  late final GeneratedColumn<String> url = GeneratedColumn<String>(
      'url', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
      'source', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _matchedTagMeta =
      const VerificationMeta('matchedTag');
  @override
  late final GeneratedColumn<String> matchedTag = GeneratedColumn<String>(
      'matched_tag', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _isReadMeta = const VerificationMeta('isRead');
  @override
  late final GeneratedColumn<bool> isRead = GeneratedColumn<bool>(
      'is_read', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_read" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _publishedAtMeta =
      const VerificationMeta('publishedAt');
  @override
  late final GeneratedColumn<DateTime> publishedAt = GeneratedColumn<DateTime>(
      'published_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, title, url, source, matchedTag, isRead, publishedAt, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'news_articles';
  @override
  VerificationContext validateIntegrity(Insertable<NewsArticle> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('url')) {
      context.handle(
          _urlMeta, url.isAcceptableOrUnknown(data['url']!, _urlMeta));
    } else if (isInserting) {
      context.missing(_urlMeta);
    }
    if (data.containsKey('source')) {
      context.handle(_sourceMeta,
          source.isAcceptableOrUnknown(data['source']!, _sourceMeta));
    } else if (isInserting) {
      context.missing(_sourceMeta);
    }
    if (data.containsKey('matched_tag')) {
      context.handle(
          _matchedTagMeta,
          matchedTag.isAcceptableOrUnknown(
              data['matched_tag']!, _matchedTagMeta));
    } else if (isInserting) {
      context.missing(_matchedTagMeta);
    }
    if (data.containsKey('is_read')) {
      context.handle(_isReadMeta,
          isRead.isAcceptableOrUnknown(data['is_read']!, _isReadMeta));
    }
    if (data.containsKey('published_at')) {
      context.handle(
          _publishedAtMeta,
          publishedAt.isAcceptableOrUnknown(
              data['published_at']!, _publishedAtMeta));
    } else if (isInserting) {
      context.missing(_publishedAtMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  NewsArticle map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NewsArticle(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      url: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}url'])!,
      source: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}source'])!,
      matchedTag: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}matched_tag'])!,
      isRead: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_read'])!,
      publishedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}published_at'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $NewsArticlesTable createAlias(String alias) {
    return $NewsArticlesTable(attachedDatabase, alias);
  }
}

class NewsArticle extends DataClass implements Insertable<NewsArticle> {
  final int id;
  final String title;
  final String url;
  final String source;
  final String matchedTag;
  final bool isRead;
  final DateTime publishedAt;
  final DateTime createdAt;
  const NewsArticle(
      {required this.id,
      required this.title,
      required this.url,
      required this.source,
      required this.matchedTag,
      required this.isRead,
      required this.publishedAt,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    map['url'] = Variable<String>(url);
    map['source'] = Variable<String>(source);
    map['matched_tag'] = Variable<String>(matchedTag);
    map['is_read'] = Variable<bool>(isRead);
    map['published_at'] = Variable<DateTime>(publishedAt);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  NewsArticlesCompanion toCompanion(bool nullToAbsent) {
    return NewsArticlesCompanion(
      id: Value(id),
      title: Value(title),
      url: Value(url),
      source: Value(source),
      matchedTag: Value(matchedTag),
      isRead: Value(isRead),
      publishedAt: Value(publishedAt),
      createdAt: Value(createdAt),
    );
  }

  factory NewsArticle.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NewsArticle(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      url: serializer.fromJson<String>(json['url']),
      source: serializer.fromJson<String>(json['source']),
      matchedTag: serializer.fromJson<String>(json['matchedTag']),
      isRead: serializer.fromJson<bool>(json['isRead']),
      publishedAt: serializer.fromJson<DateTime>(json['publishedAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'url': serializer.toJson<String>(url),
      'source': serializer.toJson<String>(source),
      'matchedTag': serializer.toJson<String>(matchedTag),
      'isRead': serializer.toJson<bool>(isRead),
      'publishedAt': serializer.toJson<DateTime>(publishedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  NewsArticle copyWith(
          {int? id,
          String? title,
          String? url,
          String? source,
          String? matchedTag,
          bool? isRead,
          DateTime? publishedAt,
          DateTime? createdAt}) =>
      NewsArticle(
        id: id ?? this.id,
        title: title ?? this.title,
        url: url ?? this.url,
        source: source ?? this.source,
        matchedTag: matchedTag ?? this.matchedTag,
        isRead: isRead ?? this.isRead,
        publishedAt: publishedAt ?? this.publishedAt,
        createdAt: createdAt ?? this.createdAt,
      );
  NewsArticle copyWithCompanion(NewsArticlesCompanion data) {
    return NewsArticle(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      url: data.url.present ? data.url.value : this.url,
      source: data.source.present ? data.source.value : this.source,
      matchedTag:
          data.matchedTag.present ? data.matchedTag.value : this.matchedTag,
      isRead: data.isRead.present ? data.isRead.value : this.isRead,
      publishedAt:
          data.publishedAt.present ? data.publishedAt.value : this.publishedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('NewsArticle(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('url: $url, ')
          ..write('source: $source, ')
          ..write('matchedTag: $matchedTag, ')
          ..write('isRead: $isRead, ')
          ..write('publishedAt: $publishedAt, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, title, url, source, matchedTag, isRead, publishedAt, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NewsArticle &&
          other.id == this.id &&
          other.title == this.title &&
          other.url == this.url &&
          other.source == this.source &&
          other.matchedTag == this.matchedTag &&
          other.isRead == this.isRead &&
          other.publishedAt == this.publishedAt &&
          other.createdAt == this.createdAt);
}

class NewsArticlesCompanion extends UpdateCompanion<NewsArticle> {
  final Value<int> id;
  final Value<String> title;
  final Value<String> url;
  final Value<String> source;
  final Value<String> matchedTag;
  final Value<bool> isRead;
  final Value<DateTime> publishedAt;
  final Value<DateTime> createdAt;
  const NewsArticlesCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.url = const Value.absent(),
    this.source = const Value.absent(),
    this.matchedTag = const Value.absent(),
    this.isRead = const Value.absent(),
    this.publishedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  NewsArticlesCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    required String url,
    required String source,
    required String matchedTag,
    this.isRead = const Value.absent(),
    required DateTime publishedAt,
    this.createdAt = const Value.absent(),
  })  : title = Value(title),
        url = Value(url),
        source = Value(source),
        matchedTag = Value(matchedTag),
        publishedAt = Value(publishedAt);
  static Insertable<NewsArticle> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<String>? url,
    Expression<String>? source,
    Expression<String>? matchedTag,
    Expression<bool>? isRead,
    Expression<DateTime>? publishedAt,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (url != null) 'url': url,
      if (source != null) 'source': source,
      if (matchedTag != null) 'matched_tag': matchedTag,
      if (isRead != null) 'is_read': isRead,
      if (publishedAt != null) 'published_at': publishedAt,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  NewsArticlesCompanion copyWith(
      {Value<int>? id,
      Value<String>? title,
      Value<String>? url,
      Value<String>? source,
      Value<String>? matchedTag,
      Value<bool>? isRead,
      Value<DateTime>? publishedAt,
      Value<DateTime>? createdAt}) {
    return NewsArticlesCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      url: url ?? this.url,
      source: source ?? this.source,
      matchedTag: matchedTag ?? this.matchedTag,
      isRead: isRead ?? this.isRead,
      publishedAt: publishedAt ?? this.publishedAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (url.present) {
      map['url'] = Variable<String>(url.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (matchedTag.present) {
      map['matched_tag'] = Variable<String>(matchedTag.value);
    }
    if (isRead.present) {
      map['is_read'] = Variable<bool>(isRead.value);
    }
    if (publishedAt.present) {
      map['published_at'] = Variable<DateTime>(publishedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NewsArticlesCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('url: $url, ')
          ..write('source: $source, ')
          ..write('matchedTag: $matchedTag, ')
          ..write('isRead: $isRead, ')
          ..write('publishedAt: $publishedAt, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$NewsDatabase extends GeneratedDatabase {
  _$NewsDatabase(QueryExecutor e) : super(e);
  $NewsDatabaseManager get managers => $NewsDatabaseManager(this);
  late final $TagsTable tags = $TagsTable(this);
  late final $NewsArticlesTable newsArticles = $NewsArticlesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [tags, newsArticles];
}

typedef $$TagsTableCreateCompanionBuilder = TagsCompanion Function({
  Value<int> id,
  required String name,
  Value<DateTime> createdAt,
});
typedef $$TagsTableUpdateCompanionBuilder = TagsCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<DateTime> createdAt,
});

class $$TagsTableFilterComposer extends Composer<_$NewsDatabase, $TagsTable> {
  $$TagsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$TagsTableOrderingComposer extends Composer<_$NewsDatabase, $TagsTable> {
  $$TagsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$TagsTableAnnotationComposer
    extends Composer<_$NewsDatabase, $TagsTable> {
  $$TagsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$TagsTableTableManager extends RootTableManager<
    _$NewsDatabase,
    $TagsTable,
    Tag,
    $$TagsTableFilterComposer,
    $$TagsTableOrderingComposer,
    $$TagsTableAnnotationComposer,
    $$TagsTableCreateCompanionBuilder,
    $$TagsTableUpdateCompanionBuilder,
    (Tag, BaseReferences<_$NewsDatabase, $TagsTable, Tag>),
    Tag,
    PrefetchHooks Function()> {
  $$TagsTableTableManager(_$NewsDatabase db, $TagsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TagsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TagsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TagsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              TagsCompanion(
            id: id,
            name: name,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              TagsCompanion.insert(
            id: id,
            name: name,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$TagsTableProcessedTableManager = ProcessedTableManager<
    _$NewsDatabase,
    $TagsTable,
    Tag,
    $$TagsTableFilterComposer,
    $$TagsTableOrderingComposer,
    $$TagsTableAnnotationComposer,
    $$TagsTableCreateCompanionBuilder,
    $$TagsTableUpdateCompanionBuilder,
    (Tag, BaseReferences<_$NewsDatabase, $TagsTable, Tag>),
    Tag,
    PrefetchHooks Function()>;
typedef $$NewsArticlesTableCreateCompanionBuilder = NewsArticlesCompanion
    Function({
  Value<int> id,
  required String title,
  required String url,
  required String source,
  required String matchedTag,
  Value<bool> isRead,
  required DateTime publishedAt,
  Value<DateTime> createdAt,
});
typedef $$NewsArticlesTableUpdateCompanionBuilder = NewsArticlesCompanion
    Function({
  Value<int> id,
  Value<String> title,
  Value<String> url,
  Value<String> source,
  Value<String> matchedTag,
  Value<bool> isRead,
  Value<DateTime> publishedAt,
  Value<DateTime> createdAt,
});

class $$NewsArticlesTableFilterComposer
    extends Composer<_$NewsDatabase, $NewsArticlesTable> {
  $$NewsArticlesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get url => $composableBuilder(
      column: $table.url, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get source => $composableBuilder(
      column: $table.source, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get matchedTag => $composableBuilder(
      column: $table.matchedTag, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isRead => $composableBuilder(
      column: $table.isRead, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get publishedAt => $composableBuilder(
      column: $table.publishedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$NewsArticlesTableOrderingComposer
    extends Composer<_$NewsDatabase, $NewsArticlesTable> {
  $$NewsArticlesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get url => $composableBuilder(
      column: $table.url, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get source => $composableBuilder(
      column: $table.source, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get matchedTag => $composableBuilder(
      column: $table.matchedTag, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isRead => $composableBuilder(
      column: $table.isRead, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get publishedAt => $composableBuilder(
      column: $table.publishedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$NewsArticlesTableAnnotationComposer
    extends Composer<_$NewsDatabase, $NewsArticlesTable> {
  $$NewsArticlesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get url =>
      $composableBuilder(column: $table.url, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<String> get matchedTag => $composableBuilder(
      column: $table.matchedTag, builder: (column) => column);

  GeneratedColumn<bool> get isRead =>
      $composableBuilder(column: $table.isRead, builder: (column) => column);

  GeneratedColumn<DateTime> get publishedAt => $composableBuilder(
      column: $table.publishedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$NewsArticlesTableTableManager extends RootTableManager<
    _$NewsDatabase,
    $NewsArticlesTable,
    NewsArticle,
    $$NewsArticlesTableFilterComposer,
    $$NewsArticlesTableOrderingComposer,
    $$NewsArticlesTableAnnotationComposer,
    $$NewsArticlesTableCreateCompanionBuilder,
    $$NewsArticlesTableUpdateCompanionBuilder,
    (
      NewsArticle,
      BaseReferences<_$NewsDatabase, $NewsArticlesTable, NewsArticle>
    ),
    NewsArticle,
    PrefetchHooks Function()> {
  $$NewsArticlesTableTableManager(_$NewsDatabase db, $NewsArticlesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NewsArticlesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$NewsArticlesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$NewsArticlesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String> url = const Value.absent(),
            Value<String> source = const Value.absent(),
            Value<String> matchedTag = const Value.absent(),
            Value<bool> isRead = const Value.absent(),
            Value<DateTime> publishedAt = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              NewsArticlesCompanion(
            id: id,
            title: title,
            url: url,
            source: source,
            matchedTag: matchedTag,
            isRead: isRead,
            publishedAt: publishedAt,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String title,
            required String url,
            required String source,
            required String matchedTag,
            Value<bool> isRead = const Value.absent(),
            required DateTime publishedAt,
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              NewsArticlesCompanion.insert(
            id: id,
            title: title,
            url: url,
            source: source,
            matchedTag: matchedTag,
            isRead: isRead,
            publishedAt: publishedAt,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$NewsArticlesTableProcessedTableManager = ProcessedTableManager<
    _$NewsDatabase,
    $NewsArticlesTable,
    NewsArticle,
    $$NewsArticlesTableFilterComposer,
    $$NewsArticlesTableOrderingComposer,
    $$NewsArticlesTableAnnotationComposer,
    $$NewsArticlesTableCreateCompanionBuilder,
    $$NewsArticlesTableUpdateCompanionBuilder,
    (
      NewsArticle,
      BaseReferences<_$NewsDatabase, $NewsArticlesTable, NewsArticle>
    ),
    NewsArticle,
    PrefetchHooks Function()>;

class $NewsDatabaseManager {
  final _$NewsDatabase _db;
  $NewsDatabaseManager(this._db);
  $$TagsTableTableManager get tags => $$TagsTableTableManager(_db, _db.tags);
  $$NewsArticlesTableTableManager get newsArticles =>
      $$NewsArticlesTableTableManager(_db, _db.newsArticles);
}
