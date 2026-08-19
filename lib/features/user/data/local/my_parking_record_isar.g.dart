// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_parking_record_isar.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetMyParkingRecordIsarCollection on Isar {
  IsarCollection<MyParkingRecordIsar> get myParkingRecordIsars =>
      this.collection();
}

const MyParkingRecordIsarSchema = CollectionSchema(
  name: r'MyParkingRecordIsar',
  id: 5249257107761248575,
  properties: {
    r'latitude': PropertySchema(
      id: 0,
      name: r'latitude',
      type: IsarType.double,
    ),
    r'longitude': PropertySchema(
      id: 1,
      name: r'longitude',
      type: IsarType.double,
    ),
    r'lotId': PropertySchema(
      id: 2,
      name: r'lotId',
      type: IsarType.string,
    ),
    r'lotLatitude': PropertySchema(
      id: 3,
      name: r'lotLatitude',
      type: IsarType.double,
    ),
    r'lotLongitude': PropertySchema(
      id: 4,
      name: r'lotLongitude',
      type: IsarType.double,
    ),
    r'lotName': PropertySchema(
      id: 5,
      name: r'lotName',
      type: IsarType.string,
    ),
    r'parkedAt': PropertySchema(
      id: 6,
      name: r'parkedAt',
      type: IsarType.dateTime,
    ),
    r'photoPath': PropertySchema(
      id: 7,
      name: r'photoPath',
      type: IsarType.string,
    ),
    r'recordId': PropertySchema(
      id: 8,
      name: r'recordId',
      type: IsarType.string,
    ),
    r'sessionId': PropertySchema(
      id: 9,
      name: r'sessionId',
      type: IsarType.string,
    ),
    r'type': PropertySchema(
      id: 10,
      name: r'type',
      type: IsarType.string,
    )
  },
  estimateSize: _myParkingRecordIsarEstimateSize,
  serialize: _myParkingRecordIsarSerialize,
  deserialize: _myParkingRecordIsarDeserialize,
  deserializeProp: _myParkingRecordIsarDeserializeProp,
  idName: r'id',
  indexes: {
    r'recordId': IndexSchema(
      id: 907839981883940929,
      name: r'recordId',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'recordId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'parkedAt': IndexSchema(
      id: -8508552685600289615,
      name: r'parkedAt',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'parkedAt',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _myParkingRecordIsarGetId,
  getLinks: _myParkingRecordIsarGetLinks,
  attach: _myParkingRecordIsarAttach,
  version: '3.1.0+1',
);

int _myParkingRecordIsarEstimateSize(
  MyParkingRecordIsar object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.lotId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.lotName;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.photoPath;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.recordId.length * 3;
  {
    final value = object.sessionId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.type.length * 3;
  return bytesCount;
}

void _myParkingRecordIsarSerialize(
  MyParkingRecordIsar object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDouble(offsets[0], object.latitude);
  writer.writeDouble(offsets[1], object.longitude);
  writer.writeString(offsets[2], object.lotId);
  writer.writeDouble(offsets[3], object.lotLatitude);
  writer.writeDouble(offsets[4], object.lotLongitude);
  writer.writeString(offsets[5], object.lotName);
  writer.writeDateTime(offsets[6], object.parkedAt);
  writer.writeString(offsets[7], object.photoPath);
  writer.writeString(offsets[8], object.recordId);
  writer.writeString(offsets[9], object.sessionId);
  writer.writeString(offsets[10], object.type);
}

MyParkingRecordIsar _myParkingRecordIsarDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = MyParkingRecordIsar();
  object.id = id;
  object.latitude = reader.readDouble(offsets[0]);
  object.longitude = reader.readDouble(offsets[1]);
  object.lotId = reader.readStringOrNull(offsets[2]);
  object.lotLatitude = reader.readDoubleOrNull(offsets[3]);
  object.lotLongitude = reader.readDoubleOrNull(offsets[4]);
  object.lotName = reader.readStringOrNull(offsets[5]);
  object.parkedAt = reader.readDateTime(offsets[6]);
  object.photoPath = reader.readStringOrNull(offsets[7]);
  object.recordId = reader.readString(offsets[8]);
  object.sessionId = reader.readStringOrNull(offsets[9]);
  object.type = reader.readString(offsets[10]);
  return object;
}

P _myParkingRecordIsarDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDouble(offset)) as P;
    case 1:
      return (reader.readDouble(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readDoubleOrNull(offset)) as P;
    case 4:
      return (reader.readDoubleOrNull(offset)) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    case 6:
      return (reader.readDateTime(offset)) as P;
    case 7:
      return (reader.readStringOrNull(offset)) as P;
    case 8:
      return (reader.readString(offset)) as P;
    case 9:
      return (reader.readStringOrNull(offset)) as P;
    case 10:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _myParkingRecordIsarGetId(MyParkingRecordIsar object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _myParkingRecordIsarGetLinks(
    MyParkingRecordIsar object) {
  return [];
}

void _myParkingRecordIsarAttach(
    IsarCollection<dynamic> col, Id id, MyParkingRecordIsar object) {
  object.id = id;
}

extension MyParkingRecordIsarByIndex on IsarCollection<MyParkingRecordIsar> {
  Future<MyParkingRecordIsar?> getByRecordId(String recordId) {
    return getByIndex(r'recordId', [recordId]);
  }

  MyParkingRecordIsar? getByRecordIdSync(String recordId) {
    return getByIndexSync(r'recordId', [recordId]);
  }

  Future<bool> deleteByRecordId(String recordId) {
    return deleteByIndex(r'recordId', [recordId]);
  }

  bool deleteByRecordIdSync(String recordId) {
    return deleteByIndexSync(r'recordId', [recordId]);
  }

  Future<List<MyParkingRecordIsar?>> getAllByRecordId(
      List<String> recordIdValues) {
    final values = recordIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'recordId', values);
  }

  List<MyParkingRecordIsar?> getAllByRecordIdSync(List<String> recordIdValues) {
    final values = recordIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'recordId', values);
  }

  Future<int> deleteAllByRecordId(List<String> recordIdValues) {
    final values = recordIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'recordId', values);
  }

  int deleteAllByRecordIdSync(List<String> recordIdValues) {
    final values = recordIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'recordId', values);
  }

  Future<Id> putByRecordId(MyParkingRecordIsar object) {
    return putByIndex(r'recordId', object);
  }

  Id putByRecordIdSync(MyParkingRecordIsar object, {bool saveLinks = true}) {
    return putByIndexSync(r'recordId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByRecordId(List<MyParkingRecordIsar> objects) {
    return putAllByIndex(r'recordId', objects);
  }

  List<Id> putAllByRecordIdSync(List<MyParkingRecordIsar> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'recordId', objects, saveLinks: saveLinks);
  }
}

extension MyParkingRecordIsarQueryWhereSort
    on QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QWhere> {
  QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QAfterWhere>
      anyParkedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'parkedAt'),
      );
    });
  }
}

extension MyParkingRecordIsarQueryWhere
    on QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QWhereClause> {
  QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QAfterWhereClause>
      idNotEqualTo(Id id) {
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

  QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QAfterWhereClause>
      idBetween(
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

  QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QAfterWhereClause>
      recordIdEqualTo(String recordId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'recordId',
        value: [recordId],
      ));
    });
  }

  QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QAfterWhereClause>
      recordIdNotEqualTo(String recordId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'recordId',
              lower: [],
              upper: [recordId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'recordId',
              lower: [recordId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'recordId',
              lower: [recordId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'recordId',
              lower: [],
              upper: [recordId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QAfterWhereClause>
      parkedAtEqualTo(DateTime parkedAt) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'parkedAt',
        value: [parkedAt],
      ));
    });
  }

  QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QAfterWhereClause>
      parkedAtNotEqualTo(DateTime parkedAt) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'parkedAt',
              lower: [],
              upper: [parkedAt],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'parkedAt',
              lower: [parkedAt],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'parkedAt',
              lower: [parkedAt],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'parkedAt',
              lower: [],
              upper: [parkedAt],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QAfterWhereClause>
      parkedAtGreaterThan(
    DateTime parkedAt, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'parkedAt',
        lower: [parkedAt],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QAfterWhereClause>
      parkedAtLessThan(
    DateTime parkedAt, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'parkedAt',
        lower: [],
        upper: [parkedAt],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QAfterWhereClause>
      parkedAtBetween(
    DateTime lowerParkedAt,
    DateTime upperParkedAt, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'parkedAt',
        lower: [lowerParkedAt],
        includeLower: includeLower,
        upper: [upperParkedAt],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension MyParkingRecordIsarQueryFilter on QueryBuilder<MyParkingRecordIsar,
    MyParkingRecordIsar, QFilterCondition> {
  QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QAfterFilterCondition>
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

  QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QAfterFilterCondition>
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

  QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QAfterFilterCondition>
      idBetween(
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

  QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QAfterFilterCondition>
      latitudeEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'latitude',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QAfterFilterCondition>
      latitudeGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'latitude',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QAfterFilterCondition>
      latitudeLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'latitude',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QAfterFilterCondition>
      latitudeBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'latitude',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QAfterFilterCondition>
      longitudeEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'longitude',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QAfterFilterCondition>
      longitudeGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'longitude',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QAfterFilterCondition>
      longitudeLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'longitude',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QAfterFilterCondition>
      longitudeBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'longitude',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QAfterFilterCondition>
      lotIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lotId',
      ));
    });
  }

  QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QAfterFilterCondition>
      lotIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lotId',
      ));
    });
  }

  QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QAfterFilterCondition>
      lotIdEqualTo(
    String? value, {
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

  QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QAfterFilterCondition>
      lotIdGreaterThan(
    String? value, {
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

  QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QAfterFilterCondition>
      lotIdLessThan(
    String? value, {
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

  QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QAfterFilterCondition>
      lotIdBetween(
    String? lower,
    String? upper, {
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

  QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QAfterFilterCondition>
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

  QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QAfterFilterCondition>
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

  QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QAfterFilterCondition>
      lotIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'lotId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QAfterFilterCondition>
      lotIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'lotId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QAfterFilterCondition>
      lotIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lotId',
        value: '',
      ));
    });
  }

  QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QAfterFilterCondition>
      lotIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'lotId',
        value: '',
      ));
    });
  }

  QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QAfterFilterCondition>
      lotLatitudeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lotLatitude',
      ));
    });
  }

  QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QAfterFilterCondition>
      lotLatitudeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lotLatitude',
      ));
    });
  }

  QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QAfterFilterCondition>
      lotLatitudeEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lotLatitude',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QAfterFilterCondition>
      lotLatitudeGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lotLatitude',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QAfterFilterCondition>
      lotLatitudeLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lotLatitude',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QAfterFilterCondition>
      lotLatitudeBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lotLatitude',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QAfterFilterCondition>
      lotLongitudeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lotLongitude',
      ));
    });
  }

  QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QAfterFilterCondition>
      lotLongitudeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lotLongitude',
      ));
    });
  }

  QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QAfterFilterCondition>
      lotLongitudeEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lotLongitude',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QAfterFilterCondition>
      lotLongitudeGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lotLongitude',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QAfterFilterCondition>
      lotLongitudeLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lotLongitude',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QAfterFilterCondition>
      lotLongitudeBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lotLongitude',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QAfterFilterCondition>
      lotNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lotName',
      ));
    });
  }

  QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QAfterFilterCondition>
      lotNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lotName',
      ));
    });
  }

  QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QAfterFilterCondition>
      lotNameEqualTo(
    String? value, {
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

  QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QAfterFilterCondition>
      lotNameGreaterThan(
    String? value, {
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

  QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QAfterFilterCondition>
      lotNameLessThan(
    String? value, {
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

  QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QAfterFilterCondition>
      lotNameBetween(
    String? lower,
    String? upper, {
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

  QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QAfterFilterCondition>
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

  QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QAfterFilterCondition>
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

  QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QAfterFilterCondition>
      lotNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'lotName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QAfterFilterCondition>
      lotNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'lotName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QAfterFilterCondition>
      lotNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lotName',
        value: '',
      ));
    });
  }

  QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QAfterFilterCondition>
      lotNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'lotName',
        value: '',
      ));
    });
  }

  QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QAfterFilterCondition>
      parkedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'parkedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QAfterFilterCondition>
      parkedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'parkedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QAfterFilterCondition>
      parkedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'parkedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QAfterFilterCondition>
      parkedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'parkedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QAfterFilterCondition>
      photoPathIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'photoPath',
      ));
    });
  }

  QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QAfterFilterCondition>
      photoPathIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'photoPath',
      ));
    });
  }

  QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QAfterFilterCondition>
      photoPathEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'photoPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QAfterFilterCondition>
      photoPathGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'photoPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QAfterFilterCondition>
      photoPathLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'photoPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QAfterFilterCondition>
      photoPathBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'photoPath',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QAfterFilterCondition>
      photoPathStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'photoPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QAfterFilterCondition>
      photoPathEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'photoPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QAfterFilterCondition>
      photoPathContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'photoPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QAfterFilterCondition>
      photoPathMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'photoPath',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QAfterFilterCondition>
      photoPathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'photoPath',
        value: '',
      ));
    });
  }

  QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QAfterFilterCondition>
      photoPathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'photoPath',
        value: '',
      ));
    });
  }

  QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QAfterFilterCondition>
      recordIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'recordId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QAfterFilterCondition>
      recordIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'recordId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QAfterFilterCondition>
      recordIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'recordId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QAfterFilterCondition>
      recordIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'recordId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QAfterFilterCondition>
      recordIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'recordId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QAfterFilterCondition>
      recordIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'recordId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QAfterFilterCondition>
      recordIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'recordId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QAfterFilterCondition>
      recordIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'recordId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QAfterFilterCondition>
      recordIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'recordId',
        value: '',
      ));
    });
  }

  QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QAfterFilterCondition>
      recordIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'recordId',
        value: '',
      ));
    });
  }

  QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QAfterFilterCondition>
      sessionIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'sessionId',
      ));
    });
  }

  QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QAfterFilterCondition>
      sessionIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'sessionId',
      ));
    });
  }

  QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QAfterFilterCondition>
      sessionIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sessionId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QAfterFilterCondition>
      sessionIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'sessionId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QAfterFilterCondition>
      sessionIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'sessionId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QAfterFilterCondition>
      sessionIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'sessionId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QAfterFilterCondition>
      sessionIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'sessionId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QAfterFilterCondition>
      sessionIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'sessionId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QAfterFilterCondition>
      sessionIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'sessionId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QAfterFilterCondition>
      sessionIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'sessionId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QAfterFilterCondition>
      sessionIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sessionId',
        value: '',
      ));
    });
  }

  QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QAfterFilterCondition>
      sessionIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'sessionId',
        value: '',
      ));
    });
  }

  QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QAfterFilterCondition>
      typeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QAfterFilterCondition>
      typeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QAfterFilterCondition>
      typeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QAfterFilterCondition>
      typeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'type',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QAfterFilterCondition>
      typeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QAfterFilterCondition>
      typeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QAfterFilterCondition>
      typeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QAfterFilterCondition>
      typeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'type',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QAfterFilterCondition>
      typeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'type',
        value: '',
      ));
    });
  }

  QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QAfterFilterCondition>
      typeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'type',
        value: '',
      ));
    });
  }
}

extension MyParkingRecordIsarQueryObject on QueryBuilder<MyParkingRecordIsar,
    MyParkingRecordIsar, QFilterCondition> {}

extension MyParkingRecordIsarQueryLinks on QueryBuilder<MyParkingRecordIsar,
    MyParkingRecordIsar, QFilterCondition> {}

extension MyParkingRecordIsarQuerySortBy
    on QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QSortBy> {
  QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QAfterSortBy>
      sortByLatitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'latitude', Sort.asc);
    });
  }

  QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QAfterSortBy>
      sortByLatitudeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'latitude', Sort.desc);
    });
  }

  QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QAfterSortBy>
      sortByLongitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'longitude', Sort.asc);
    });
  }

  QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QAfterSortBy>
      sortByLongitudeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'longitude', Sort.desc);
    });
  }

  QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QAfterSortBy>
      sortByLotId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lotId', Sort.asc);
    });
  }

  QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QAfterSortBy>
      sortByLotIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lotId', Sort.desc);
    });
  }

  QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QAfterSortBy>
      sortByLotLatitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lotLatitude', Sort.asc);
    });
  }

  QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QAfterSortBy>
      sortByLotLatitudeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lotLatitude', Sort.desc);
    });
  }

  QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QAfterSortBy>
      sortByLotLongitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lotLongitude', Sort.asc);
    });
  }

  QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QAfterSortBy>
      sortByLotLongitudeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lotLongitude', Sort.desc);
    });
  }

  QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QAfterSortBy>
      sortByLotName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lotName', Sort.asc);
    });
  }

  QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QAfterSortBy>
      sortByLotNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lotName', Sort.desc);
    });
  }

  QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QAfterSortBy>
      sortByParkedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'parkedAt', Sort.asc);
    });
  }

  QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QAfterSortBy>
      sortByParkedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'parkedAt', Sort.desc);
    });
  }

  QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QAfterSortBy>
      sortByPhotoPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'photoPath', Sort.asc);
    });
  }

  QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QAfterSortBy>
      sortByPhotoPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'photoPath', Sort.desc);
    });
  }

  QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QAfterSortBy>
      sortByRecordId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recordId', Sort.asc);
    });
  }

  QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QAfterSortBy>
      sortByRecordIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recordId', Sort.desc);
    });
  }

  QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QAfterSortBy>
      sortBySessionId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sessionId', Sort.asc);
    });
  }

  QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QAfterSortBy>
      sortBySessionIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sessionId', Sort.desc);
    });
  }

  QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QAfterSortBy>
      sortByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QAfterSortBy>
      sortByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }
}

extension MyParkingRecordIsarQuerySortThenBy
    on QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QSortThenBy> {
  QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QAfterSortBy>
      thenByLatitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'latitude', Sort.asc);
    });
  }

  QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QAfterSortBy>
      thenByLatitudeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'latitude', Sort.desc);
    });
  }

  QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QAfterSortBy>
      thenByLongitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'longitude', Sort.asc);
    });
  }

  QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QAfterSortBy>
      thenByLongitudeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'longitude', Sort.desc);
    });
  }

  QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QAfterSortBy>
      thenByLotId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lotId', Sort.asc);
    });
  }

  QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QAfterSortBy>
      thenByLotIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lotId', Sort.desc);
    });
  }

  QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QAfterSortBy>
      thenByLotLatitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lotLatitude', Sort.asc);
    });
  }

  QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QAfterSortBy>
      thenByLotLatitudeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lotLatitude', Sort.desc);
    });
  }

  QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QAfterSortBy>
      thenByLotLongitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lotLongitude', Sort.asc);
    });
  }

  QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QAfterSortBy>
      thenByLotLongitudeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lotLongitude', Sort.desc);
    });
  }

  QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QAfterSortBy>
      thenByLotName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lotName', Sort.asc);
    });
  }

  QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QAfterSortBy>
      thenByLotNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lotName', Sort.desc);
    });
  }

  QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QAfterSortBy>
      thenByParkedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'parkedAt', Sort.asc);
    });
  }

  QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QAfterSortBy>
      thenByParkedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'parkedAt', Sort.desc);
    });
  }

  QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QAfterSortBy>
      thenByPhotoPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'photoPath', Sort.asc);
    });
  }

  QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QAfterSortBy>
      thenByPhotoPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'photoPath', Sort.desc);
    });
  }

  QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QAfterSortBy>
      thenByRecordId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recordId', Sort.asc);
    });
  }

  QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QAfterSortBy>
      thenByRecordIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recordId', Sort.desc);
    });
  }

  QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QAfterSortBy>
      thenBySessionId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sessionId', Sort.asc);
    });
  }

  QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QAfterSortBy>
      thenBySessionIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sessionId', Sort.desc);
    });
  }

  QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QAfterSortBy>
      thenByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QAfterSortBy>
      thenByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }
}

extension MyParkingRecordIsarQueryWhereDistinct
    on QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QDistinct> {
  QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QDistinct>
      distinctByLatitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'latitude');
    });
  }

  QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QDistinct>
      distinctByLongitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'longitude');
    });
  }

  QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QDistinct>
      distinctByLotId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lotId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QDistinct>
      distinctByLotLatitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lotLatitude');
    });
  }

  QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QDistinct>
      distinctByLotLongitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lotLongitude');
    });
  }

  QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QDistinct>
      distinctByLotName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lotName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QDistinct>
      distinctByParkedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'parkedAt');
    });
  }

  QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QDistinct>
      distinctByPhotoPath({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'photoPath', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QDistinct>
      distinctByRecordId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'recordId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QDistinct>
      distinctBySessionId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sessionId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QDistinct>
      distinctByType({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'type', caseSensitive: caseSensitive);
    });
  }
}

extension MyParkingRecordIsarQueryProperty
    on QueryBuilder<MyParkingRecordIsar, MyParkingRecordIsar, QQueryProperty> {
  QueryBuilder<MyParkingRecordIsar, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<MyParkingRecordIsar, double, QQueryOperations>
      latitudeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'latitude');
    });
  }

  QueryBuilder<MyParkingRecordIsar, double, QQueryOperations>
      longitudeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'longitude');
    });
  }

  QueryBuilder<MyParkingRecordIsar, String?, QQueryOperations> lotIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lotId');
    });
  }

  QueryBuilder<MyParkingRecordIsar, double?, QQueryOperations>
      lotLatitudeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lotLatitude');
    });
  }

  QueryBuilder<MyParkingRecordIsar, double?, QQueryOperations>
      lotLongitudeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lotLongitude');
    });
  }

  QueryBuilder<MyParkingRecordIsar, String?, QQueryOperations>
      lotNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lotName');
    });
  }

  QueryBuilder<MyParkingRecordIsar, DateTime, QQueryOperations>
      parkedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'parkedAt');
    });
  }

  QueryBuilder<MyParkingRecordIsar, String?, QQueryOperations>
      photoPathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'photoPath');
    });
  }

  QueryBuilder<MyParkingRecordIsar, String, QQueryOperations>
      recordIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'recordId');
    });
  }

  QueryBuilder<MyParkingRecordIsar, String?, QQueryOperations>
      sessionIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sessionId');
    });
  }

  QueryBuilder<MyParkingRecordIsar, String, QQueryOperations> typeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'type');
    });
  }
}
