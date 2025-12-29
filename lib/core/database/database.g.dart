// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $SleepInfoTableTable extends SleepInfoTable
    with TableInfo<$SleepInfoTableTable, SleepInfoTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SleepInfoTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _bedTimeMeta = const VerificationMeta(
    'bedTime',
  );
  @override
  late final GeneratedColumn<int> bedTime = GeneratedColumn<int>(
    'bed_time',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _riseTimeMeta = const VerificationMeta(
    'riseTime',
  );
  @override
  late final GeneratedColumn<int> riseTime = GeneratedColumn<int>(
    'rise_time',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sleepDurationMinutesMeta =
      const VerificationMeta('sleepDurationMinutes');
  @override
  late final GeneratedColumn<int> sleepDurationMinutes = GeneratedColumn<int>(
    'sleep_duration_minutes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sleepQualityMeta = const VerificationMeta(
    'sleepQuality',
  );
  @override
  late final GeneratedColumn<String> sleepQuality = GeneratedColumn<String>(
    'sleep_quality',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    bedTime,
    riseTime,
    sleepDurationMinutes,
    sleepQuality,
    notes,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sleep_info';
  @override
  VerificationContext validateIntegrity(
    Insertable<SleepInfoTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('bed_time')) {
      context.handle(
        _bedTimeMeta,
        bedTime.isAcceptableOrUnknown(data['bed_time']!, _bedTimeMeta),
      );
    }
    if (data.containsKey('rise_time')) {
      context.handle(
        _riseTimeMeta,
        riseTime.isAcceptableOrUnknown(data['rise_time']!, _riseTimeMeta),
      );
    }
    if (data.containsKey('sleep_duration_minutes')) {
      context.handle(
        _sleepDurationMinutesMeta,
        sleepDurationMinutes.isAcceptableOrUnknown(
          data['sleep_duration_minutes']!,
          _sleepDurationMinutesMeta,
        ),
      );
    }
    if (data.containsKey('sleep_quality')) {
      context.handle(
        _sleepQualityMeta,
        sleepQuality.isAcceptableOrUnknown(
          data['sleep_quality']!,
          _sleepQualityMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SleepInfoTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SleepInfoTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      bedTime: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}bed_time'],
      ),
      riseTime: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rise_time'],
      ),
      sleepDurationMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sleep_duration_minutes'],
      ),
      sleepQuality: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sleep_quality'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
    );
  }

  @override
  $SleepInfoTableTable createAlias(String alias) {
    return $SleepInfoTableTable(attachedDatabase, alias);
  }
}

class SleepInfoTableData extends DataClass
    implements Insertable<SleepInfoTableData> {
  final int id;
  final int? bedTime;
  final int? riseTime;
  final int? sleepDurationMinutes;
  final String? sleepQuality;
  final String? notes;
  const SleepInfoTableData({
    required this.id,
    this.bedTime,
    this.riseTime,
    this.sleepDurationMinutes,
    this.sleepQuality,
    this.notes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || bedTime != null) {
      map['bed_time'] = Variable<int>(bedTime);
    }
    if (!nullToAbsent || riseTime != null) {
      map['rise_time'] = Variable<int>(riseTime);
    }
    if (!nullToAbsent || sleepDurationMinutes != null) {
      map['sleep_duration_minutes'] = Variable<int>(sleepDurationMinutes);
    }
    if (!nullToAbsent || sleepQuality != null) {
      map['sleep_quality'] = Variable<String>(sleepQuality);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  SleepInfoTableCompanion toCompanion(bool nullToAbsent) {
    return SleepInfoTableCompanion(
      id: Value(id),
      bedTime: bedTime == null && nullToAbsent
          ? const Value.absent()
          : Value(bedTime),
      riseTime: riseTime == null && nullToAbsent
          ? const Value.absent()
          : Value(riseTime),
      sleepDurationMinutes: sleepDurationMinutes == null && nullToAbsent
          ? const Value.absent()
          : Value(sleepDurationMinutes),
      sleepQuality: sleepQuality == null && nullToAbsent
          ? const Value.absent()
          : Value(sleepQuality),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
    );
  }

  factory SleepInfoTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SleepInfoTableData(
      id: serializer.fromJson<int>(json['id']),
      bedTime: serializer.fromJson<int?>(json['bedTime']),
      riseTime: serializer.fromJson<int?>(json['riseTime']),
      sleepDurationMinutes: serializer.fromJson<int?>(
        json['sleepDurationMinutes'],
      ),
      sleepQuality: serializer.fromJson<String?>(json['sleepQuality']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'bedTime': serializer.toJson<int?>(bedTime),
      'riseTime': serializer.toJson<int?>(riseTime),
      'sleepDurationMinutes': serializer.toJson<int?>(sleepDurationMinutes),
      'sleepQuality': serializer.toJson<String?>(sleepQuality),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  SleepInfoTableData copyWith({
    int? id,
    Value<int?> bedTime = const Value.absent(),
    Value<int?> riseTime = const Value.absent(),
    Value<int?> sleepDurationMinutes = const Value.absent(),
    Value<String?> sleepQuality = const Value.absent(),
    Value<String?> notes = const Value.absent(),
  }) => SleepInfoTableData(
    id: id ?? this.id,
    bedTime: bedTime.present ? bedTime.value : this.bedTime,
    riseTime: riseTime.present ? riseTime.value : this.riseTime,
    sleepDurationMinutes: sleepDurationMinutes.present
        ? sleepDurationMinutes.value
        : this.sleepDurationMinutes,
    sleepQuality: sleepQuality.present ? sleepQuality.value : this.sleepQuality,
    notes: notes.present ? notes.value : this.notes,
  );
  SleepInfoTableData copyWithCompanion(SleepInfoTableCompanion data) {
    return SleepInfoTableData(
      id: data.id.present ? data.id.value : this.id,
      bedTime: data.bedTime.present ? data.bedTime.value : this.bedTime,
      riseTime: data.riseTime.present ? data.riseTime.value : this.riseTime,
      sleepDurationMinutes: data.sleepDurationMinutes.present
          ? data.sleepDurationMinutes.value
          : this.sleepDurationMinutes,
      sleepQuality: data.sleepQuality.present
          ? data.sleepQuality.value
          : this.sleepQuality,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SleepInfoTableData(')
          ..write('id: $id, ')
          ..write('bedTime: $bedTime, ')
          ..write('riseTime: $riseTime, ')
          ..write('sleepDurationMinutes: $sleepDurationMinutes, ')
          ..write('sleepQuality: $sleepQuality, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    bedTime,
    riseTime,
    sleepDurationMinutes,
    sleepQuality,
    notes,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SleepInfoTableData &&
          other.id == this.id &&
          other.bedTime == this.bedTime &&
          other.riseTime == this.riseTime &&
          other.sleepDurationMinutes == this.sleepDurationMinutes &&
          other.sleepQuality == this.sleepQuality &&
          other.notes == this.notes);
}

class SleepInfoTableCompanion extends UpdateCompanion<SleepInfoTableData> {
  final Value<int> id;
  final Value<int?> bedTime;
  final Value<int?> riseTime;
  final Value<int?> sleepDurationMinutes;
  final Value<String?> sleepQuality;
  final Value<String?> notes;
  const SleepInfoTableCompanion({
    this.id = const Value.absent(),
    this.bedTime = const Value.absent(),
    this.riseTime = const Value.absent(),
    this.sleepDurationMinutes = const Value.absent(),
    this.sleepQuality = const Value.absent(),
    this.notes = const Value.absent(),
  });
  SleepInfoTableCompanion.insert({
    this.id = const Value.absent(),
    this.bedTime = const Value.absent(),
    this.riseTime = const Value.absent(),
    this.sleepDurationMinutes = const Value.absent(),
    this.sleepQuality = const Value.absent(),
    this.notes = const Value.absent(),
  });
  static Insertable<SleepInfoTableData> custom({
    Expression<int>? id,
    Expression<int>? bedTime,
    Expression<int>? riseTime,
    Expression<int>? sleepDurationMinutes,
    Expression<String>? sleepQuality,
    Expression<String>? notes,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (bedTime != null) 'bed_time': bedTime,
      if (riseTime != null) 'rise_time': riseTime,
      if (sleepDurationMinutes != null)
        'sleep_duration_minutes': sleepDurationMinutes,
      if (sleepQuality != null) 'sleep_quality': sleepQuality,
      if (notes != null) 'notes': notes,
    });
  }

  SleepInfoTableCompanion copyWith({
    Value<int>? id,
    Value<int?>? bedTime,
    Value<int?>? riseTime,
    Value<int?>? sleepDurationMinutes,
    Value<String?>? sleepQuality,
    Value<String?>? notes,
  }) {
    return SleepInfoTableCompanion(
      id: id ?? this.id,
      bedTime: bedTime ?? this.bedTime,
      riseTime: riseTime ?? this.riseTime,
      sleepDurationMinutes: sleepDurationMinutes ?? this.sleepDurationMinutes,
      sleepQuality: sleepQuality ?? this.sleepQuality,
      notes: notes ?? this.notes,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (bedTime.present) {
      map['bed_time'] = Variable<int>(bedTime.value);
    }
    if (riseTime.present) {
      map['rise_time'] = Variable<int>(riseTime.value);
    }
    if (sleepDurationMinutes.present) {
      map['sleep_duration_minutes'] = Variable<int>(sleepDurationMinutes.value);
    }
    if (sleepQuality.present) {
      map['sleep_quality'] = Variable<String>(sleepQuality.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SleepInfoTableCompanion(')
          ..write('id: $id, ')
          ..write('bedTime: $bedTime, ')
          ..write('riseTime: $riseTime, ')
          ..write('sleepDurationMinutes: $sleepDurationMinutes, ')
          ..write('sleepQuality: $sleepQuality, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $SleepInfoTableTable sleepInfoTable = $SleepInfoTableTable(this);
  late final SleepDao sleepDao = SleepDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [sleepInfoTable];
}

typedef $$SleepInfoTableTableCreateCompanionBuilder =
    SleepInfoTableCompanion Function({
      Value<int> id,
      Value<int?> bedTime,
      Value<int?> riseTime,
      Value<int?> sleepDurationMinutes,
      Value<String?> sleepQuality,
      Value<String?> notes,
    });
typedef $$SleepInfoTableTableUpdateCompanionBuilder =
    SleepInfoTableCompanion Function({
      Value<int> id,
      Value<int?> bedTime,
      Value<int?> riseTime,
      Value<int?> sleepDurationMinutes,
      Value<String?> sleepQuality,
      Value<String?> notes,
    });

class $$SleepInfoTableTableFilterComposer
    extends Composer<_$AppDatabase, $SleepInfoTableTable> {
  $$SleepInfoTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get bedTime => $composableBuilder(
    column: $table.bedTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get riseTime => $composableBuilder(
    column: $table.riseTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sleepDurationMinutes => $composableBuilder(
    column: $table.sleepDurationMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sleepQuality => $composableBuilder(
    column: $table.sleepQuality,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SleepInfoTableTableOrderingComposer
    extends Composer<_$AppDatabase, $SleepInfoTableTable> {
  $$SleepInfoTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get bedTime => $composableBuilder(
    column: $table.bedTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get riseTime => $composableBuilder(
    column: $table.riseTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sleepDurationMinutes => $composableBuilder(
    column: $table.sleepDurationMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sleepQuality => $composableBuilder(
    column: $table.sleepQuality,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SleepInfoTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $SleepInfoTableTable> {
  $$SleepInfoTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get bedTime =>
      $composableBuilder(column: $table.bedTime, builder: (column) => column);

  GeneratedColumn<int> get riseTime =>
      $composableBuilder(column: $table.riseTime, builder: (column) => column);

  GeneratedColumn<int> get sleepDurationMinutes => $composableBuilder(
    column: $table.sleepDurationMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sleepQuality => $composableBuilder(
    column: $table.sleepQuality,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);
}

class $$SleepInfoTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SleepInfoTableTable,
          SleepInfoTableData,
          $$SleepInfoTableTableFilterComposer,
          $$SleepInfoTableTableOrderingComposer,
          $$SleepInfoTableTableAnnotationComposer,
          $$SleepInfoTableTableCreateCompanionBuilder,
          $$SleepInfoTableTableUpdateCompanionBuilder,
          (
            SleepInfoTableData,
            BaseReferences<
              _$AppDatabase,
              $SleepInfoTableTable,
              SleepInfoTableData
            >,
          ),
          SleepInfoTableData,
          PrefetchHooks Function()
        > {
  $$SleepInfoTableTableTableManager(
    _$AppDatabase db,
    $SleepInfoTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SleepInfoTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SleepInfoTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SleepInfoTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> bedTime = const Value.absent(),
                Value<int?> riseTime = const Value.absent(),
                Value<int?> sleepDurationMinutes = const Value.absent(),
                Value<String?> sleepQuality = const Value.absent(),
                Value<String?> notes = const Value.absent(),
              }) => SleepInfoTableCompanion(
                id: id,
                bedTime: bedTime,
                riseTime: riseTime,
                sleepDurationMinutes: sleepDurationMinutes,
                sleepQuality: sleepQuality,
                notes: notes,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> bedTime = const Value.absent(),
                Value<int?> riseTime = const Value.absent(),
                Value<int?> sleepDurationMinutes = const Value.absent(),
                Value<String?> sleepQuality = const Value.absent(),
                Value<String?> notes = const Value.absent(),
              }) => SleepInfoTableCompanion.insert(
                id: id,
                bedTime: bedTime,
                riseTime: riseTime,
                sleepDurationMinutes: sleepDurationMinutes,
                sleepQuality: sleepQuality,
                notes: notes,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SleepInfoTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SleepInfoTableTable,
      SleepInfoTableData,
      $$SleepInfoTableTableFilterComposer,
      $$SleepInfoTableTableOrderingComposer,
      $$SleepInfoTableTableAnnotationComposer,
      $$SleepInfoTableTableCreateCompanionBuilder,
      $$SleepInfoTableTableUpdateCompanionBuilder,
      (
        SleepInfoTableData,
        BaseReferences<_$AppDatabase, $SleepInfoTableTable, SleepInfoTableData>,
      ),
      SleepInfoTableData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$SleepInfoTableTableTableManager get sleepInfoTable =>
      $$SleepInfoTableTableTableManager(_db, _db.sleepInfoTable);
}
