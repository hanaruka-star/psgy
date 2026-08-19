// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'parking_session_isar.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetParkingSessionIsarCollection on Isar {
  IsarCollection<ParkingSessionIsar> get parkingSessionIsars =>
      this.collection();
}

const ParkingSessionIsarSchema = CollectionSchema(
  name: r'ParkingSessionIsar',
  id: -2071158326537395214,
  properties: {
    r'cachedAt': PropertySchema(
      id: 0,
      name: r'cachedAt',
      type: IsarType.dateTime,
    ),
    r'checkInMethod': PropertySchema(
      id: 1,
      name: r'checkInMethod',
      type: IsarType.string,
    ),
    r'checkOutMethod': PropertySchema(
      id: 2,
      name: r'checkOutMethod',
      type: IsarType.string,
    ),
    r'checkOutStaffId': PropertySchema(
      id: 3,
      name: r'checkOutStaffId',
      type: IsarType.string,
    ),
    r'checkOutTokenId': PropertySchema(
      id: 4,
      name: r'checkOutTokenId',
      type: IsarType.string,
    ),
    r'checkedInAt': PropertySchema(
      id: 5,
      name: r'checkedInAt',
      type: IsarType.dateTime,
    ),
    r'checkedOutAt': PropertySchema(
      id: 6,
      name: r'checkedOutAt',
      type: IsarType.dateTime,
    ),
    r'lotId': PropertySchema(
      id: 7,
      name: r'lotId',
      type: IsarType.string,
    ),
    r'metadataJson': PropertySchema(
      id: 8,
      name: r'metadataJson',
      type: IsarType.string,
    ),
    r'sessionId': PropertySchema(
      id: 9,
      name: r'sessionId',
      type: IsarType.string,
    ),
    r'staffId': PropertySchema(
      id: 10,
      name: r'staffId',
      type: IsarType.string,
    ),
    r'status': PropertySchema(
      id: 11,
      name: r'status',
      type: IsarType.string,
    ),
    r'userId': PropertySchema(
      id: 12,
      name: r'userId',
      type: IsarType.string,
    ),
    r'vehicleId': PropertySchema(
      id: 13,
      name: r'vehicleId',
      type: IsarType.string,
    ),
    r'vehiclePhotoUrl': PropertySchema(
      id: 14,
      name: r'vehiclePhotoUrl',
      type: IsarType.string,
    ),
    r'vehiclePlate': PropertySchema(
      id: 15,
      name: r'vehiclePlate',
      type: IsarType.string,
    ),
    r'vehicleType': PropertySchema(
      id: 16,
      name: r'vehicleType',
      type: IsarType.string,
    )
  },
  estimateSize: _parkingSessionIsarEstimateSize,
  serialize: _parkingSessionIsarSerialize,
  deserialize: _parkingSessionIsarDeserialize,
  deserializeProp: _parkingSessionIsarDeserializeProp,
  idName: r'id',
  indexes: {
    r'sessionId': IndexSchema(
      id: 6949518585047923839,
      name: r'sessionId',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'sessionId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'lotId': IndexSchema(
      id: 7594258205857764483,
      name: r'lotId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'lotId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'vehicleType': IndexSchema(
      id: -3096741324283704007,
      name: r'vehicleType',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'vehicleType',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'status': IndexSchema(
      id: -107785170620420283,
      name: r'status',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'status',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _parkingSessionIsarGetId,
  getLinks: _parkingSessionIsarGetLinks,
  attach: _parkingSessionIsarAttach,
  version: '3.1.0+1',
);

int _parkingSessionIsarEstimateSize(
  ParkingSessionIsar object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.checkInMethod;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.checkOutMethod;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.checkOutStaffId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.checkOutTokenId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.lotId.length * 3;
  {
    final value = object.metadataJson;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.sessionId.length * 3;
  {
    final value = object.staffId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.status.length * 3;
  {
    final value = object.userId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.vehicleId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.vehiclePhotoUrl;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.vehiclePlate.length * 3;
  bytesCount += 3 + object.vehicleType.length * 3;
  return bytesCount;
}

void _parkingSessionIsarSerialize(
  ParkingSessionIsar object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.cachedAt);
  writer.writeString(offsets[1], object.checkInMethod);
  writer.writeString(offsets[2], object.checkOutMethod);
  writer.writeString(offsets[3], object.checkOutStaffId);
  writer.writeString(offsets[4], object.checkOutTokenId);
  writer.writeDateTime(offsets[5], object.checkedInAt);
  writer.writeDateTime(offsets[6], object.checkedOutAt);
  writer.writeString(offsets[7], object.lotId);
  writer.writeString(offsets[8], object.metadataJson);
  writer.writeString(offsets[9], object.sessionId);
  writer.writeString(offsets[10], object.staffId);
  writer.writeString(offsets[11], object.status);
  writer.writeString(offsets[12], object.userId);
  writer.writeString(offsets[13], object.vehicleId);
  writer.writeString(offsets[14], object.vehiclePhotoUrl);
  writer.writeString(offsets[15], object.vehiclePlate);
  writer.writeString(offsets[16], object.vehicleType);
}

ParkingSessionIsar _parkingSessionIsarDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ParkingSessionIsar();
  object.cachedAt = reader.readDateTime(offsets[0]);
  object.checkInMethod = reader.readStringOrNull(offsets[1]);
  object.checkOutMethod = reader.readStringOrNull(offsets[2]);
  object.checkOutStaffId = reader.readStringOrNull(offsets[3]);
  object.checkOutTokenId = reader.readStringOrNull(offsets[4]);
  object.checkedInAt = reader.readDateTime(offsets[5]);
  object.checkedOutAt = reader.readDateTimeOrNull(offsets[6]);
  object.id = id;
  object.lotId = reader.readString(offsets[7]);
  object.metadataJson = reader.readStringOrNull(offsets[8]);
  object.sessionId = reader.readString(offsets[9]);
  object.staffId = reader.readStringOrNull(offsets[10]);
  object.status = reader.readString(offsets[11]);
  object.userId = reader.readStringOrNull(offsets[12]);
  object.vehicleId = reader.readStringOrNull(offsets[13]);
  object.vehiclePhotoUrl = reader.readStringOrNull(offsets[14]);
  object.vehiclePlate = reader.readString(offsets[15]);
  object.vehicleType = reader.readString(offsets[16]);
  return object;
}

P _parkingSessionIsarDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readDateTime(offset)) as P;
    case 6:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    case 8:
      return (reader.readStringOrNull(offset)) as P;
    case 9:
      return (reader.readString(offset)) as P;
    case 10:
      return (reader.readStringOrNull(offset)) as P;
    case 11:
      return (reader.readString(offset)) as P;
    case 12:
      return (reader.readStringOrNull(offset)) as P;
    case 13:
      return (reader.readStringOrNull(offset)) as P;
    case 14:
      return (reader.readStringOrNull(offset)) as P;
    case 15:
      return (reader.readString(offset)) as P;
    case 16:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _parkingSessionIsarGetId(ParkingSessionIsar object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _parkingSessionIsarGetLinks(
    ParkingSessionIsar object) {
  return [];
}

void _parkingSessionIsarAttach(
    IsarCollection<dynamic> col, Id id, ParkingSessionIsar object) {
  object.id = id;
}

extension ParkingSessionIsarByIndex on IsarCollection<ParkingSessionIsar> {
  Future<ParkingSessionIsar?> getBySessionId(String sessionId) {
    return getByIndex(r'sessionId', [sessionId]);
  }

  ParkingSessionIsar? getBySessionIdSync(String sessionId) {
    return getByIndexSync(r'sessionId', [sessionId]);
  }

  Future<bool> deleteBySessionId(String sessionId) {
    return deleteByIndex(r'sessionId', [sessionId]);
  }

  bool deleteBySessionIdSync(String sessionId) {
    return deleteByIndexSync(r'sessionId', [sessionId]);
  }

  Future<List<ParkingSessionIsar?>> getAllBySessionId(
      List<String> sessionIdValues) {
    final values = sessionIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'sessionId', values);
  }

  List<ParkingSessionIsar?> getAllBySessionIdSync(
      List<String> sessionIdValues) {
    final values = sessionIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'sessionId', values);
  }

  Future<int> deleteAllBySessionId(List<String> sessionIdValues) {
    final values = sessionIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'sessionId', values);
  }

  int deleteAllBySessionIdSync(List<String> sessionIdValues) {
    final values = sessionIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'sessionId', values);
  }

  Future<Id> putBySessionId(ParkingSessionIsar object) {
    return putByIndex(r'sessionId', object);
  }

  Id putBySessionIdSync(ParkingSessionIsar object, {bool saveLinks = true}) {
    return putByIndexSync(r'sessionId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllBySessionId(List<ParkingSessionIsar> objects) {
    return putAllByIndex(r'sessionId', objects);
  }

  List<Id> putAllBySessionIdSync(List<ParkingSessionIsar> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'sessionId', objects, saveLinks: saveLinks);
  }
}

extension ParkingSessionIsarQueryWhereSort
    on QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QWhere> {
  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension ParkingSessionIsarQueryWhere
    on QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QWhereClause> {
  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterWhereClause>
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

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterWhereClause>
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

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterWhereClause>
      sessionIdEqualTo(String sessionId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'sessionId',
        value: [sessionId],
      ));
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterWhereClause>
      sessionIdNotEqualTo(String sessionId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'sessionId',
              lower: [],
              upper: [sessionId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'sessionId',
              lower: [sessionId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'sessionId',
              lower: [sessionId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'sessionId',
              lower: [],
              upper: [sessionId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterWhereClause>
      lotIdEqualTo(String lotId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'lotId',
        value: [lotId],
      ));
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterWhereClause>
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

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterWhereClause>
      vehicleTypeEqualTo(String vehicleType) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'vehicleType',
        value: [vehicleType],
      ));
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterWhereClause>
      vehicleTypeNotEqualTo(String vehicleType) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'vehicleType',
              lower: [],
              upper: [vehicleType],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'vehicleType',
              lower: [vehicleType],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'vehicleType',
              lower: [vehicleType],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'vehicleType',
              lower: [],
              upper: [vehicleType],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterWhereClause>
      statusEqualTo(String status) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'status',
        value: [status],
      ));
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterWhereClause>
      statusNotEqualTo(String status) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'status',
              lower: [],
              upper: [status],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'status',
              lower: [status],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'status',
              lower: [status],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'status',
              lower: [],
              upper: [status],
              includeUpper: false,
            ));
      }
    });
  }
}

extension ParkingSessionIsarQueryFilter
    on QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QFilterCondition> {
  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
      cachedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cachedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
      cachedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'cachedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
      cachedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'cachedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
      cachedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'cachedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
      checkInMethodIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'checkInMethod',
      ));
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
      checkInMethodIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'checkInMethod',
      ));
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
      checkInMethodEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'checkInMethod',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
      checkInMethodGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'checkInMethod',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
      checkInMethodLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'checkInMethod',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
      checkInMethodBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'checkInMethod',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
      checkInMethodStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'checkInMethod',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
      checkInMethodEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'checkInMethod',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
      checkInMethodContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'checkInMethod',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
      checkInMethodMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'checkInMethod',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
      checkInMethodIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'checkInMethod',
        value: '',
      ));
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
      checkInMethodIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'checkInMethod',
        value: '',
      ));
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
      checkOutMethodIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'checkOutMethod',
      ));
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
      checkOutMethodIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'checkOutMethod',
      ));
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
      checkOutMethodEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'checkOutMethod',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
      checkOutMethodGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'checkOutMethod',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
      checkOutMethodLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'checkOutMethod',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
      checkOutMethodBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'checkOutMethod',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
      checkOutMethodStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'checkOutMethod',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
      checkOutMethodEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'checkOutMethod',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
      checkOutMethodContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'checkOutMethod',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
      checkOutMethodMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'checkOutMethod',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
      checkOutMethodIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'checkOutMethod',
        value: '',
      ));
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
      checkOutMethodIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'checkOutMethod',
        value: '',
      ));
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
      checkOutStaffIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'checkOutStaffId',
      ));
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
      checkOutStaffIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'checkOutStaffId',
      ));
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
      checkOutStaffIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'checkOutStaffId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
      checkOutStaffIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'checkOutStaffId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
      checkOutStaffIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'checkOutStaffId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
      checkOutStaffIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'checkOutStaffId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
      checkOutStaffIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'checkOutStaffId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
      checkOutStaffIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'checkOutStaffId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
      checkOutStaffIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'checkOutStaffId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
      checkOutStaffIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'checkOutStaffId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
      checkOutStaffIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'checkOutStaffId',
        value: '',
      ));
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
      checkOutStaffIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'checkOutStaffId',
        value: '',
      ));
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
      checkOutTokenIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'checkOutTokenId',
      ));
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
      checkOutTokenIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'checkOutTokenId',
      ));
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
      checkOutTokenIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'checkOutTokenId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
      checkOutTokenIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'checkOutTokenId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
      checkOutTokenIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'checkOutTokenId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
      checkOutTokenIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'checkOutTokenId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
      checkOutTokenIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'checkOutTokenId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
      checkOutTokenIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'checkOutTokenId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
      checkOutTokenIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'checkOutTokenId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
      checkOutTokenIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'checkOutTokenId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
      checkOutTokenIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'checkOutTokenId',
        value: '',
      ));
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
      checkOutTokenIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'checkOutTokenId',
        value: '',
      ));
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
      checkedInAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'checkedInAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
      checkedInAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'checkedInAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
      checkedInAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'checkedInAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
      checkedInAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'checkedInAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
      checkedOutAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'checkedOutAt',
      ));
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
      checkedOutAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'checkedOutAt',
      ));
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
      checkedOutAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'checkedOutAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
      checkedOutAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'checkedOutAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
      checkedOutAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'checkedOutAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
      checkedOutAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'checkedOutAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
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

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
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

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
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

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
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

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
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

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
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

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
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

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
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

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
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

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
      lotIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'lotId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
      lotIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'lotId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
      lotIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lotId',
        value: '',
      ));
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
      lotIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'lotId',
        value: '',
      ));
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
      metadataJsonIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'metadataJson',
      ));
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
      metadataJsonIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'metadataJson',
      ));
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
      metadataJsonEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'metadataJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
      metadataJsonGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'metadataJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
      metadataJsonLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'metadataJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
      metadataJsonBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'metadataJson',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
      metadataJsonStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'metadataJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
      metadataJsonEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'metadataJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
      metadataJsonContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'metadataJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
      metadataJsonMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'metadataJson',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
      metadataJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'metadataJson',
        value: '',
      ));
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
      metadataJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'metadataJson',
        value: '',
      ));
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
      sessionIdEqualTo(
    String value, {
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

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
      sessionIdGreaterThan(
    String value, {
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

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
      sessionIdLessThan(
    String value, {
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

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
      sessionIdBetween(
    String lower,
    String upper, {
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

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
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

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
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

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
      sessionIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'sessionId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
      sessionIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'sessionId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
      sessionIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sessionId',
        value: '',
      ));
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
      sessionIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'sessionId',
        value: '',
      ));
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
      staffIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'staffId',
      ));
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
      staffIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'staffId',
      ));
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
      staffIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'staffId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
      staffIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'staffId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
      staffIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'staffId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
      staffIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'staffId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
      staffIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'staffId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
      staffIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'staffId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
      staffIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'staffId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
      staffIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'staffId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
      staffIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'staffId',
        value: '',
      ));
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
      staffIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'staffId',
        value: '',
      ));
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
      statusEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
      statusGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
      statusLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
      statusBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'status',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
      statusStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
      statusEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
      statusContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
      statusMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'status',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
      statusIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'status',
        value: '',
      ));
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
      statusIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'status',
        value: '',
      ));
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
      userIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'userId',
      ));
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
      userIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'userId',
      ));
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
      userIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
      userIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
      userIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
      userIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'userId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
      userIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
      userIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
      userIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
      userIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'userId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
      userIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'userId',
        value: '',
      ));
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
      userIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'userId',
        value: '',
      ));
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
      vehicleIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'vehicleId',
      ));
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
      vehicleIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'vehicleId',
      ));
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
      vehicleIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'vehicleId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
      vehicleIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'vehicleId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
      vehicleIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'vehicleId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
      vehicleIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'vehicleId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
      vehicleIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'vehicleId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
      vehicleIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'vehicleId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
      vehicleIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'vehicleId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
      vehicleIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'vehicleId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
      vehicleIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'vehicleId',
        value: '',
      ));
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
      vehicleIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'vehicleId',
        value: '',
      ));
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
      vehiclePhotoUrlIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'vehiclePhotoUrl',
      ));
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
      vehiclePhotoUrlIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'vehiclePhotoUrl',
      ));
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
      vehiclePhotoUrlEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'vehiclePhotoUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
      vehiclePhotoUrlGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'vehiclePhotoUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
      vehiclePhotoUrlLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'vehiclePhotoUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
      vehiclePhotoUrlBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'vehiclePhotoUrl',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
      vehiclePhotoUrlStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'vehiclePhotoUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
      vehiclePhotoUrlEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'vehiclePhotoUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
      vehiclePhotoUrlContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'vehiclePhotoUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
      vehiclePhotoUrlMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'vehiclePhotoUrl',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
      vehiclePhotoUrlIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'vehiclePhotoUrl',
        value: '',
      ));
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
      vehiclePhotoUrlIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'vehiclePhotoUrl',
        value: '',
      ));
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
      vehiclePlateEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'vehiclePlate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
      vehiclePlateGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'vehiclePlate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
      vehiclePlateLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'vehiclePlate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
      vehiclePlateBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'vehiclePlate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
      vehiclePlateStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'vehiclePlate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
      vehiclePlateEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'vehiclePlate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
      vehiclePlateContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'vehiclePlate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
      vehiclePlateMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'vehiclePlate',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
      vehiclePlateIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'vehiclePlate',
        value: '',
      ));
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
      vehiclePlateIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'vehiclePlate',
        value: '',
      ));
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
      vehicleTypeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'vehicleType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
      vehicleTypeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'vehicleType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
      vehicleTypeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'vehicleType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
      vehicleTypeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'vehicleType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
      vehicleTypeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'vehicleType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
      vehicleTypeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'vehicleType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
      vehicleTypeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'vehicleType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
      vehicleTypeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'vehicleType',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
      vehicleTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'vehicleType',
        value: '',
      ));
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterFilterCondition>
      vehicleTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'vehicleType',
        value: '',
      ));
    });
  }
}

extension ParkingSessionIsarQueryObject
    on QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QFilterCondition> {}

extension ParkingSessionIsarQueryLinks
    on QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QFilterCondition> {}

extension ParkingSessionIsarQuerySortBy
    on QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QSortBy> {
  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterSortBy>
      sortByCachedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cachedAt', Sort.asc);
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterSortBy>
      sortByCachedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cachedAt', Sort.desc);
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterSortBy>
      sortByCheckInMethod() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'checkInMethod', Sort.asc);
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterSortBy>
      sortByCheckInMethodDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'checkInMethod', Sort.desc);
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterSortBy>
      sortByCheckOutMethod() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'checkOutMethod', Sort.asc);
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterSortBy>
      sortByCheckOutMethodDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'checkOutMethod', Sort.desc);
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterSortBy>
      sortByCheckOutStaffId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'checkOutStaffId', Sort.asc);
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterSortBy>
      sortByCheckOutStaffIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'checkOutStaffId', Sort.desc);
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterSortBy>
      sortByCheckOutTokenId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'checkOutTokenId', Sort.asc);
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterSortBy>
      sortByCheckOutTokenIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'checkOutTokenId', Sort.desc);
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterSortBy>
      sortByCheckedInAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'checkedInAt', Sort.asc);
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterSortBy>
      sortByCheckedInAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'checkedInAt', Sort.desc);
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterSortBy>
      sortByCheckedOutAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'checkedOutAt', Sort.asc);
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterSortBy>
      sortByCheckedOutAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'checkedOutAt', Sort.desc);
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterSortBy>
      sortByLotId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lotId', Sort.asc);
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterSortBy>
      sortByLotIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lotId', Sort.desc);
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterSortBy>
      sortByMetadataJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'metadataJson', Sort.asc);
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterSortBy>
      sortByMetadataJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'metadataJson', Sort.desc);
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterSortBy>
      sortBySessionId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sessionId', Sort.asc);
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterSortBy>
      sortBySessionIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sessionId', Sort.desc);
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterSortBy>
      sortByStaffId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'staffId', Sort.asc);
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterSortBy>
      sortByStaffIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'staffId', Sort.desc);
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterSortBy>
      sortByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterSortBy>
      sortByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterSortBy>
      sortByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.asc);
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterSortBy>
      sortByUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.desc);
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterSortBy>
      sortByVehicleId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vehicleId', Sort.asc);
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterSortBy>
      sortByVehicleIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vehicleId', Sort.desc);
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterSortBy>
      sortByVehiclePhotoUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vehiclePhotoUrl', Sort.asc);
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterSortBy>
      sortByVehiclePhotoUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vehiclePhotoUrl', Sort.desc);
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterSortBy>
      sortByVehiclePlate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vehiclePlate', Sort.asc);
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterSortBy>
      sortByVehiclePlateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vehiclePlate', Sort.desc);
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterSortBy>
      sortByVehicleType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vehicleType', Sort.asc);
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterSortBy>
      sortByVehicleTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vehicleType', Sort.desc);
    });
  }
}

extension ParkingSessionIsarQuerySortThenBy
    on QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QSortThenBy> {
  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterSortBy>
      thenByCachedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cachedAt', Sort.asc);
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterSortBy>
      thenByCachedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cachedAt', Sort.desc);
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterSortBy>
      thenByCheckInMethod() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'checkInMethod', Sort.asc);
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterSortBy>
      thenByCheckInMethodDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'checkInMethod', Sort.desc);
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterSortBy>
      thenByCheckOutMethod() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'checkOutMethod', Sort.asc);
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterSortBy>
      thenByCheckOutMethodDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'checkOutMethod', Sort.desc);
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterSortBy>
      thenByCheckOutStaffId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'checkOutStaffId', Sort.asc);
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterSortBy>
      thenByCheckOutStaffIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'checkOutStaffId', Sort.desc);
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterSortBy>
      thenByCheckOutTokenId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'checkOutTokenId', Sort.asc);
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterSortBy>
      thenByCheckOutTokenIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'checkOutTokenId', Sort.desc);
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterSortBy>
      thenByCheckedInAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'checkedInAt', Sort.asc);
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterSortBy>
      thenByCheckedInAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'checkedInAt', Sort.desc);
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterSortBy>
      thenByCheckedOutAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'checkedOutAt', Sort.asc);
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterSortBy>
      thenByCheckedOutAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'checkedOutAt', Sort.desc);
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterSortBy>
      thenByLotId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lotId', Sort.asc);
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterSortBy>
      thenByLotIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lotId', Sort.desc);
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterSortBy>
      thenByMetadataJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'metadataJson', Sort.asc);
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterSortBy>
      thenByMetadataJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'metadataJson', Sort.desc);
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterSortBy>
      thenBySessionId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sessionId', Sort.asc);
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterSortBy>
      thenBySessionIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sessionId', Sort.desc);
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterSortBy>
      thenByStaffId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'staffId', Sort.asc);
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterSortBy>
      thenByStaffIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'staffId', Sort.desc);
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterSortBy>
      thenByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterSortBy>
      thenByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterSortBy>
      thenByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.asc);
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterSortBy>
      thenByUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.desc);
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterSortBy>
      thenByVehicleId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vehicleId', Sort.asc);
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterSortBy>
      thenByVehicleIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vehicleId', Sort.desc);
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterSortBy>
      thenByVehiclePhotoUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vehiclePhotoUrl', Sort.asc);
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterSortBy>
      thenByVehiclePhotoUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vehiclePhotoUrl', Sort.desc);
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterSortBy>
      thenByVehiclePlate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vehiclePlate', Sort.asc);
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterSortBy>
      thenByVehiclePlateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vehiclePlate', Sort.desc);
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterSortBy>
      thenByVehicleType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vehicleType', Sort.asc);
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QAfterSortBy>
      thenByVehicleTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vehicleType', Sort.desc);
    });
  }
}

extension ParkingSessionIsarQueryWhereDistinct
    on QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QDistinct> {
  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QDistinct>
      distinctByCachedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'cachedAt');
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QDistinct>
      distinctByCheckInMethod({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'checkInMethod',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QDistinct>
      distinctByCheckOutMethod({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'checkOutMethod',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QDistinct>
      distinctByCheckOutStaffId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'checkOutStaffId',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QDistinct>
      distinctByCheckOutTokenId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'checkOutTokenId',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QDistinct>
      distinctByCheckedInAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'checkedInAt');
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QDistinct>
      distinctByCheckedOutAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'checkedOutAt');
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QDistinct>
      distinctByLotId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lotId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QDistinct>
      distinctByMetadataJson({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'metadataJson', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QDistinct>
      distinctBySessionId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sessionId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QDistinct>
      distinctByStaffId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'staffId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QDistinct>
      distinctByStatus({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'status', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QDistinct>
      distinctByUserId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'userId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QDistinct>
      distinctByVehicleId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'vehicleId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QDistinct>
      distinctByVehiclePhotoUrl({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'vehiclePhotoUrl',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QDistinct>
      distinctByVehiclePlate({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'vehiclePlate', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QDistinct>
      distinctByVehicleType({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'vehicleType', caseSensitive: caseSensitive);
    });
  }
}

extension ParkingSessionIsarQueryProperty
    on QueryBuilder<ParkingSessionIsar, ParkingSessionIsar, QQueryProperty> {
  QueryBuilder<ParkingSessionIsar, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<ParkingSessionIsar, DateTime, QQueryOperations>
      cachedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'cachedAt');
    });
  }

  QueryBuilder<ParkingSessionIsar, String?, QQueryOperations>
      checkInMethodProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'checkInMethod');
    });
  }

  QueryBuilder<ParkingSessionIsar, String?, QQueryOperations>
      checkOutMethodProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'checkOutMethod');
    });
  }

  QueryBuilder<ParkingSessionIsar, String?, QQueryOperations>
      checkOutStaffIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'checkOutStaffId');
    });
  }

  QueryBuilder<ParkingSessionIsar, String?, QQueryOperations>
      checkOutTokenIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'checkOutTokenId');
    });
  }

  QueryBuilder<ParkingSessionIsar, DateTime, QQueryOperations>
      checkedInAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'checkedInAt');
    });
  }

  QueryBuilder<ParkingSessionIsar, DateTime?, QQueryOperations>
      checkedOutAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'checkedOutAt');
    });
  }

  QueryBuilder<ParkingSessionIsar, String, QQueryOperations> lotIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lotId');
    });
  }

  QueryBuilder<ParkingSessionIsar, String?, QQueryOperations>
      metadataJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'metadataJson');
    });
  }

  QueryBuilder<ParkingSessionIsar, String, QQueryOperations>
      sessionIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sessionId');
    });
  }

  QueryBuilder<ParkingSessionIsar, String?, QQueryOperations>
      staffIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'staffId');
    });
  }

  QueryBuilder<ParkingSessionIsar, String, QQueryOperations> statusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'status');
    });
  }

  QueryBuilder<ParkingSessionIsar, String?, QQueryOperations> userIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'userId');
    });
  }

  QueryBuilder<ParkingSessionIsar, String?, QQueryOperations>
      vehicleIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'vehicleId');
    });
  }

  QueryBuilder<ParkingSessionIsar, String?, QQueryOperations>
      vehiclePhotoUrlProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'vehiclePhotoUrl');
    });
  }

  QueryBuilder<ParkingSessionIsar, String, QQueryOperations>
      vehiclePlateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'vehiclePlate');
    });
  }

  QueryBuilder<ParkingSessionIsar, String, QQueryOperations>
      vehicleTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'vehicleType');
    });
  }
}
