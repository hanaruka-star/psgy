// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'watched_lot_isar.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetWatchedLotIsarCollection on Isar {
  IsarCollection<WatchedLotIsar> get watchedLotIsars => this.collection();
}

const WatchedLotIsarSchema = CollectionSchema(
  name: r'WatchedLotIsar',
  id: 4427805245368840950,
  properties: {
    r'estimatedOpeningAt': PropertySchema(
      id: 0,
      name: r'estimatedOpeningAt',
      type: IsarType.dateTime,
    ),
    r'hasUnreadUpdate': PropertySchema(
      id: 1,
      name: r'hasUnreadUpdate',
      type: IsarType.bool,
    ),
    r'lotId': PropertySchema(
      id: 2,
      name: r'lotId',
      type: IsarType.string,
    ),
    r'lotName': PropertySchema(
      id: 3,
      name: r'lotName',
      type: IsarType.string,
    ),
    r'watchedAt': PropertySchema(
      id: 4,
      name: r'watchedAt',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _watchedLotIsarEstimateSize,
  serialize: _watchedLotIsarSerialize,
  deserialize: _watchedLotIsarDeserialize,
  deserializeProp: _watchedLotIsarDeserializeProp,
  idName: r'id',
  indexes: {
    r'lotId': IndexSchema(
      id: 7594258205857764483,
      name: r'lotId',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'lotId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _watchedLotIsarGetId,
  getLinks: _watchedLotIsarGetLinks,
  attach: _watchedLotIsarAttach,
  version: '3.1.0+1',
);

int _watchedLotIsarEstimateSize(
  WatchedLotIsar object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.lotId.length * 3;
  bytesCount += 3 + object.lotName.length * 3;
  return bytesCount;
}

void _watchedLotIsarSerialize(
  WatchedLotIsar object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.estimatedOpeningAt);
  writer.writeBool(offsets[1], object.hasUnreadUpdate);
  writer.writeString(offsets[2], object.lotId);
  writer.writeString(offsets[3], object.lotName);
  writer.writeDateTime(offsets[4], object.watchedAt);
}

WatchedLotIsar _watchedLotIsarDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = WatchedLotIsar();
  object.estimatedOpeningAt = reader.readDateTimeOrNull(offsets[0]);
  object.hasUnreadUpdate = reader.readBool(offsets[1]);
  object.id = id;
  object.lotId = reader.readString(offsets[2]);
  object.lotName = reader.readString(offsets[3]);
  object.watchedAt = reader.readDateTime(offsets[4]);
  return object;
}

P _watchedLotIsarDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 1:
      return (reader.readBool(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _watchedLotIsarGetId(WatchedLotIsar object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _watchedLotIsarGetLinks(WatchedLotIsar object) {
  return [];
}

void _watchedLotIsarAttach(
    IsarCollection<dynamic> col, Id id, WatchedLotIsar object) {
  object.id = id;
}

extension WatchedLotIsarByIndex on IsarCollection<WatchedLotIsar> {
  Future<WatchedLotIsar?> getByLotId(String lotId) {
    return getByIndex(r'lotId', [lotId]);
  }

  WatchedLotIsar? getByLotIdSync(String lotId) {
    return getByIndexSync(r'lotId', [lotId]);
  }

  Future<bool> deleteByLotId(String lotId) {
    return deleteByIndex(r'lotId', [lotId]);
  }

  bool deleteByLotIdSync(String lotId) {
    return deleteByIndexSync(r'lotId', [lotId]);
  }

  Future<List<WatchedLotIsar?>> getAllByLotId(List<String> lotIdValues) {
    final values = lotIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'lotId', values);
  }

  List<WatchedLotIsar?> getAllByLotIdSync(List<String> lotIdValues) {
    final values = lotIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'lotId', values);
  }

  Future<int> deleteAllByLotId(List<String> lotIdValues) {
    final values = lotIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'lotId', values);
  }

  int deleteAllByLotIdSync(List<String> lotIdValues) {
    final values = lotIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'lotId', values);
  }

  Future<Id> putByLotId(WatchedLotIsar object) {
    return putByIndex(r'lotId', object);
  }

  Id putByLotIdSync(WatchedLotIsar object, {bool saveLinks = true}) {
    return putByIndexSync(r'lotId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByLotId(List<WatchedLotIsar> objects) {
    return putAllByIndex(r'lotId', objects);
  }

  List<Id> putAllByLotIdSync(List<WatchedLotIsar> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'lotId', objects, saveLinks: saveLinks);
  }
}

extension WatchedLotIsarQueryWhereSort
    on QueryBuilder<WatchedLotIsar, WatchedLotIsar, QWhere> {
  QueryBuilder<WatchedLotIsar, WatchedLotIsar, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension WatchedLotIsarQueryWhere
    on QueryBuilder<WatchedLotIsar, WatchedLotIsar, QWhereClause> {
  QueryBuilder<WatchedLotIsar, WatchedLotIsar, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<WatchedLotIsar, WatchedLotIsar, QAfterWhereClause> idNotEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<WatchedLotIsar, WatchedLotIsar, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<WatchedLotIsar, WatchedLotIsar, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<WatchedLotIsar, WatchedLotIsar, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<WatchedLotIsar, WatchedLotIsar, QAfterWhereClause> lotIdEqualTo(
      String lotId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'lotId',
        value: [lotId],
      ));
    });
  }

  QueryBuilder<WatchedLotIsar, WatchedLotIsar, QAfterWhereClause>
      lotIdNotEqualTo(String lotId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'lotId',
              lower: [],
              upper: [lotId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'lotId',
              lower: [lotId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'lotId',
              lower: [lotId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'lotId',
              lower: [],
              upper: [lotId],
              includeUpper: false,
            ));
      }
    });
  }
}

extension WatchedLotIsarQueryFilter
    on QueryBuilder<WatchedLotIsar, WatchedLotIsar, QFilterCondition> {
  QueryBuilder<WatchedLotIsar, WatchedLotIsar, QAfterFilterCondition>
      estimatedOpeningAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'estimatedOpeningAt',
      ));
    });
  }

  QueryBuilder<WatchedLotIsar, WatchedLotIsar, QAfterFilterCondition>
      estimatedOpeningAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'estimatedOpeningAt',
      ));
    });
  }

  QueryBuilder<WatchedLotIsar, WatchedLotIsar, QAfterFilterCondition>
      estimatedOpeningAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'estimatedOpeningAt',
        value: value,
      ));
    });
  }

  QueryBuilder<WatchedLotIsar, WatchedLotIsar, QAfterFilterCondition>
      estimatedOpeningAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'estimatedOpeningAt',
        value: value,
      ));
    });
  }

  QueryBuilder<WatchedLotIsar, WatchedLotIsar, QAfterFilterCondition>
      estimatedOpeningAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'estimatedOpeningAt',
        value: value,
      ));
    });
  }

  QueryBuilder<WatchedLotIsar, WatchedLotIsar, QAfterFilterCondition>
      estimatedOpeningAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'estimatedOpeningAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<WatchedLotIsar, WatchedLotIsar, QAfterFilterCondition>
      hasUnreadUpdateEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hasUnreadUpdate',
        value: value,
      ));
    });
  }

  QueryBuilder<WatchedLotIsar, WatchedLotIsar, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<WatchedLotIsar, WatchedLotIsar, QAfterFilterCondition>
      idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<WatchedLotIsar, WatchedLotIsar, QAfterFilterCondition>
      idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<WatchedLotIsar, WatchedLotIsar, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<WatchedLotIsar, WatchedLotIsar, QAfterFilterCondition>
      lotIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lotId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WatchedLotIsar, WatchedLotIsar, QAfterFilterCondition>
      lotIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lotId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WatchedLotIsar, WatchedLotIsar, QAfterFilterCondition>
      lotIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lotId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WatchedLotIsar, WatchedLotIsar, QAfterFilterCondition>
      lotIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lotId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WatchedLotIsar, WatchedLotIsar, QAfterFilterCondition>
      lotIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'lotId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WatchedLotIsar, WatchedLotIsar, QAfterFilterCondition>
      lotIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'lotId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WatchedLotIsar, WatchedLotIsar, QAfterFilterCondition>
      lotIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'lotId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WatchedLotIsar, WatchedLotIsar, QAfterFilterCondition>
      lotIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'lotId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WatchedLotIsar, WatchedLotIsar, QAfterFilterCondition>
      lotIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lotId',
        value: '',
      ));
    });
  }

  QueryBuilder<WatchedLotIsar, WatchedLotIsar, QAfterFilterCondition>
      lotIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'lotId',
        value: '',
      ));
    });
  }

  QueryBuilder<WatchedLotIsar, WatchedLotIsar, QAfterFilterCondition>
      lotNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lotName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WatchedLotIsar, WatchedLotIsar, QAfterFilterCondition>
      lotNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lotName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WatchedLotIsar, WatchedLotIsar, QAfterFilterCondition>
      lotNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lotName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WatchedLotIsar, WatchedLotIsar, QAfterFilterCondition>
      lotNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lotName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WatchedLotIsar, WatchedLotIsar, QAfterFilterCondition>
      lotNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'lotName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WatchedLotIsar, WatchedLotIsar, QAfterFilterCondition>
      lotNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'lotName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WatchedLotIsar, WatchedLotIsar, QAfterFilterCondition>
      lotNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'lotName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WatchedLotIsar, WatchedLotIsar, QAfterFilterCondition>
      lotNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'lotName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WatchedLotIsar, WatchedLotIsar, QAfterFilterCondition>
      lotNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lotName',
        value: '',
      ));
    });
  }

  QueryBuilder<WatchedLotIsar, WatchedLotIsar, QAfterFilterCondition>
      lotNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'lotName',
        value: '',
      ));
    });
  }

  QueryBuilder<WatchedLotIsar, WatchedLotIsar, QAfterFilterCondition>
      watchedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'watchedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<WatchedLotIsar, WatchedLotIsar, QAfterFilterCondition>
      watchedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'watchedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<WatchedLotIsar, WatchedLotIsar, QAfterFilterCondition>
      watchedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'watchedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<WatchedLotIsar, WatchedLotIsar, QAfterFilterCondition>
      watchedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'watchedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension WatchedLotIsarQueryObject
    on QueryBuilder<WatchedLotIsar, WatchedLotIsar, QFilterCondition> {}

extension WatchedLotIsarQueryLinks
    on QueryBuilder<WatchedLotIsar, WatchedLotIsar, QFilterCondition> {}

extension WatchedLotIsarQuerySortBy
    on QueryBuilder<WatchedLotIsar, WatchedLotIsar, QSortBy> {
  QueryBuilder<WatchedLotIsar, WatchedLotIsar, QAfterSortBy>
      sortByEstimatedOpeningAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'estimatedOpeningAt', Sort.asc);
    });
  }

  QueryBuilder<WatchedLotIsar, WatchedLotIsar, QAfterSortBy>
      sortByEstimatedOpeningAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'estimatedOpeningAt', Sort.desc);
    });
  }

  QueryBuilder<WatchedLotIsar, WatchedLotIsar, QAfterSortBy>
      sortByHasUnreadUpdate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasUnreadUpdate', Sort.asc);
    });
  }

  QueryBuilder<WatchedLotIsar, WatchedLotIsar, QAfterSortBy>
      sortByHasUnreadUpdateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasUnreadUpdate', Sort.desc);
    });
  }

  QueryBuilder<WatchedLotIsar, WatchedLotIsar, QAfterSortBy> sortByLotId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lotId', Sort.asc);
    });
  }

  QueryBuilder<WatchedLotIsar, WatchedLotIsar, QAfterSortBy> sortByLotIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lotId', Sort.desc);
    });
  }

  QueryBuilder<WatchedLotIsar, WatchedLotIsar, QAfterSortBy> sortByLotName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lotName', Sort.asc);
    });
  }

  QueryBuilder<WatchedLotIsar, WatchedLotIsar, QAfterSortBy>
      sortByLotNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lotName', Sort.desc);
    });
  }

  QueryBuilder<WatchedLotIsar, WatchedLotIsar, QAfterSortBy> sortByWatchedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'watchedAt', Sort.asc);
    });
  }

  QueryBuilder<WatchedLotIsar, WatchedLotIsar, QAfterSortBy>
      sortByWatchedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'watchedAt', Sort.desc);
    });
  }
}

extension WatchedLotIsarQuerySortThenBy
    on QueryBuilder<WatchedLotIsar, WatchedLotIsar, QSortThenBy> {
  QueryBuilder<WatchedLotIsar, WatchedLotIsar, QAfterSortBy>
      thenByEstimatedOpeningAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'estimatedOpeningAt', Sort.asc);
    });
  }

  QueryBuilder<WatchedLotIsar, WatchedLotIsar, QAfterSortBy>
      thenByEstimatedOpeningAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'estimatedOpeningAt', Sort.desc);
    });
  }

  QueryBuilder<WatchedLotIsar, WatchedLotIsar, QAfterSortBy>
      thenByHasUnreadUpdate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasUnreadUpdate', Sort.asc);
    });
  }

  QueryBuilder<WatchedLotIsar, WatchedLotIsar, QAfterSortBy>
      thenByHasUnreadUpdateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasUnreadUpdate', Sort.desc);
    });
  }

  QueryBuilder<WatchedLotIsar, WatchedLotIsar, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<WatchedLotIsar, WatchedLotIsar, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<WatchedLotIsar, WatchedLotIsar, QAfterSortBy> thenByLotId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lotId', Sort.asc);
    });
  }

  QueryBuilder<WatchedLotIsar, WatchedLotIsar, QAfterSortBy> thenByLotIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lotId', Sort.desc);
    });
  }

  QueryBuilder<WatchedLotIsar, WatchedLotIsar, QAfterSortBy> thenByLotName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lotName', Sort.asc);
    });
  }

  QueryBuilder<WatchedLotIsar, WatchedLotIsar, QAfterSortBy>
      thenByLotNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lotName', Sort.desc);
    });
  }

  QueryBuilder<WatchedLotIsar, WatchedLotIsar, QAfterSortBy> thenByWatchedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'watchedAt', Sort.asc);
    });
  }

  QueryBuilder<WatchedLotIsar, WatchedLotIsar, QAfterSortBy>
      thenByWatchedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'watchedAt', Sort.desc);
    });
  }
}

extension WatchedLotIsarQueryWhereDistinct
    on QueryBuilder<WatchedLotIsar, WatchedLotIsar, QDistinct> {
  QueryBuilder<WatchedLotIsar, WatchedLotIsar, QDistinct>
      distinctByEstimatedOpeningAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'estimatedOpeningAt');
    });
  }

  QueryBuilder<WatchedLotIsar, WatchedLotIsar, QDistinct>
      distinctByHasUnreadUpdate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hasUnreadUpdate');
    });
  }

  QueryBuilder<WatchedLotIsar, WatchedLotIsar, QDistinct> distinctByLotId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lotId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WatchedLotIsar, WatchedLotIsar, QDistinct> distinctByLotName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lotName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WatchedLotIsar, WatchedLotIsar, QDistinct>
      distinctByWatchedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'watchedAt');
    });
  }
}

extension WatchedLotIsarQueryProperty
    on QueryBuilder<WatchedLotIsar, WatchedLotIsar, QQueryProperty> {
  QueryBuilder<WatchedLotIsar, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<WatchedLotIsar, DateTime?, QQueryOperations>
      estimatedOpeningAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'estimatedOpeningAt');
    });
  }

  QueryBuilder<WatchedLotIsar, bool, QQueryOperations>
      hasUnreadUpdateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hasUnreadUpdate');
    });
  }

  QueryBuilder<WatchedLotIsar, String, QQueryOperations> lotIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lotId');
    });
  }

  QueryBuilder<WatchedLotIsar, String, QQueryOperations> lotNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lotName');
    });
  }

  QueryBuilder<WatchedLotIsar, DateTime, QQueryOperations> watchedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'watchedAt');
    });
  }
}
