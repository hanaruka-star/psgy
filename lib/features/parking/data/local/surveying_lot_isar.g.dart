// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'surveying_lot_isar.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetSurveyingLotIsarCollection on Isar {
  IsarCollection<SurveyingLotIsar> get surveyingLotIsars => this.collection();
}

const SurveyingLotIsarSchema = CollectionSchema(
  name: r'SurveyingLotIsar',
  id: 809120861098448851,
  properties: {
    r'address': PropertySchema(
      id: 0,
      name: r'address',
      type: IsarType.string,
    ),
    r'cachedAt': PropertySchema(
      id: 1,
      name: r'cachedAt',
      type: IsarType.dateTime,
    ),
    r'carPrice': PropertySchema(
      id: 2,
      name: r'carPrice',
      type: IsarType.long,
    ),
    r'category': PropertySchema(
      id: 3,
      name: r'category',
      type: IsarType.string,
    ),
    r'estimatedCarSlots': PropertySchema(
      id: 4,
      name: r'estimatedCarSlots',
      type: IsarType.long,
    ),
    r'estimatedMotoSlots': PropertySchema(
      id: 5,
      name: r'estimatedMotoSlots',
      type: IsarType.long,
    ),
    r'estimatedOpeningAt': PropertySchema(
      id: 6,
      name: r'estimatedOpeningAt',
      type: IsarType.dateTime,
    ),
    r'estimatedSlots': PropertySchema(
      id: 7,
      name: r'estimatedSlots',
      type: IsarType.long,
    ),
    r'geohash': PropertySchema(
      id: 8,
      name: r'geohash',
      type: IsarType.string,
    ),
    r'imageUrl': PropertySchema(
      id: 9,
      name: r'imageUrl',
      type: IsarType.string,
    ),
    r'lat': PropertySchema(
      id: 10,
      name: r'lat',
      type: IsarType.double,
    ),
    r'lng': PropertySchema(
      id: 11,
      name: r'lng',
      type: IsarType.double,
    ),
    r'lotId': PropertySchema(
      id: 12,
      name: r'lotId',
      type: IsarType.string,
    ),
    r'motoPrice': PropertySchema(
      id: 13,
      name: r'motoPrice',
      type: IsarType.long,
    ),
    r'name': PropertySchema(
      id: 14,
      name: r'name',
      type: IsarType.string,
    ),
    r'notes': PropertySchema(
      id: 15,
      name: r'notes',
      type: IsarType.string,
    ),
    r'photoUrl': PropertySchema(
      id: 16,
      name: r'photoUrl',
      type: IsarType.string,
    ),
    r'source': PropertySchema(
      id: 17,
      name: r'source',
      type: IsarType.string,
    ),
    r'status': PropertySchema(
      id: 18,
      name: r'status',
      type: IsarType.string,
    ),
    r'surveyedAt': PropertySchema(
      id: 19,
      name: r'surveyedAt',
      type: IsarType.dateTime,
    ),
    r'surveyor': PropertySchema(
      id: 20,
      name: r'surveyor',
      type: IsarType.string,
    ),
    r'totalSlots': PropertySchema(
      id: 21,
      name: r'totalSlots',
      type: IsarType.long,
    ),
    r'vehicleTypes': PropertySchema(
      id: 22,
      name: r'vehicleTypes',
      type: IsarType.string,
    )
  },
  estimateSize: _surveyingLotIsarEstimateSize,
  serialize: _surveyingLotIsarSerialize,
  deserialize: _surveyingLotIsarDeserialize,
  deserializeProp: _surveyingLotIsarDeserializeProp,
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
    ),
    r'lat': IndexSchema(
      id: 3038781890822997334,
      name: r'lat',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'lat',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'lng': IndexSchema(
      id: 428885709538637475,
      name: r'lng',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'lng',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'geohash': IndexSchema(
      id: -1996952489477322815,
      name: r'geohash',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'geohash',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _surveyingLotIsarGetId,
  getLinks: _surveyingLotIsarGetLinks,
  attach: _surveyingLotIsarAttach,
  version: '3.1.0+1',
);

int _surveyingLotIsarEstimateSize(
  SurveyingLotIsar object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.address.length * 3;
  bytesCount += 3 + object.category.length * 3;
  bytesCount += 3 + object.geohash.length * 3;
  {
    final value = object.imageUrl;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.lotId.length * 3;
  bytesCount += 3 + object.name.length * 3;
  {
    final value = object.notes;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.photoUrl;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.source.length * 3;
  bytesCount += 3 + object.status.length * 3;
  bytesCount += 3 + object.surveyor.length * 3;
  bytesCount += 3 + object.vehicleTypes.length * 3;
  return bytesCount;
}

void _surveyingLotIsarSerialize(
  SurveyingLotIsar object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.address);
  writer.writeDateTime(offsets[1], object.cachedAt);
  writer.writeLong(offsets[2], object.carPrice);
  writer.writeString(offsets[3], object.category);
  writer.writeLong(offsets[4], object.estimatedCarSlots);
  writer.writeLong(offsets[5], object.estimatedMotoSlots);
  writer.writeDateTime(offsets[6], object.estimatedOpeningAt);
  writer.writeLong(offsets[7], object.estimatedSlots);
  writer.writeString(offsets[8], object.geohash);
  writer.writeString(offsets[9], object.imageUrl);
  writer.writeDouble(offsets[10], object.lat);
  writer.writeDouble(offsets[11], object.lng);
  writer.writeString(offsets[12], object.lotId);
  writer.writeLong(offsets[13], object.motoPrice);
  writer.writeString(offsets[14], object.name);
  writer.writeString(offsets[15], object.notes);
  writer.writeString(offsets[16], object.photoUrl);
  writer.writeString(offsets[17], object.source);
  writer.writeString(offsets[18], object.status);
  writer.writeDateTime(offsets[19], object.surveyedAt);
  writer.writeString(offsets[20], object.surveyor);
  writer.writeLong(offsets[21], object.totalSlots);
  writer.writeString(offsets[22], object.vehicleTypes);
}

SurveyingLotIsar _surveyingLotIsarDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = SurveyingLotIsar();
  object.address = reader.readString(offsets[0]);
  object.cachedAt = reader.readDateTime(offsets[1]);
  object.carPrice = reader.readLong(offsets[2]);
  object.category = reader.readString(offsets[3]);
  object.estimatedCarSlots = reader.readLongOrNull(offsets[4]);
  object.estimatedMotoSlots = reader.readLongOrNull(offsets[5]);
  object.estimatedOpeningAt = reader.readDateTimeOrNull(offsets[6]);
  object.estimatedSlots = reader.readLongOrNull(offsets[7]);
  object.geohash = reader.readString(offsets[8]);
  object.id = id;
  object.imageUrl = reader.readStringOrNull(offsets[9]);
  object.lat = reader.readDouble(offsets[10]);
  object.lng = reader.readDouble(offsets[11]);
  object.lotId = reader.readString(offsets[12]);
  object.motoPrice = reader.readLong(offsets[13]);
  object.name = reader.readString(offsets[14]);
  object.notes = reader.readStringOrNull(offsets[15]);
  object.photoUrl = reader.readStringOrNull(offsets[16]);
  object.source = reader.readString(offsets[17]);
  object.status = reader.readString(offsets[18]);
  object.surveyedAt = reader.readDateTimeOrNull(offsets[19]);
  object.surveyor = reader.readString(offsets[20]);
  object.totalSlots = reader.readLong(offsets[21]);
  object.vehicleTypes = reader.readString(offsets[22]);
  return object;
}

P _surveyingLotIsarDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readLongOrNull(offset)) as P;
    case 5:
      return (reader.readLongOrNull(offset)) as P;
    case 6:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 7:
      return (reader.readLongOrNull(offset)) as P;
    case 8:
      return (reader.readString(offset)) as P;
    case 9:
      return (reader.readStringOrNull(offset)) as P;
    case 10:
      return (reader.readDouble(offset)) as P;
    case 11:
      return (reader.readDouble(offset)) as P;
    case 12:
      return (reader.readString(offset)) as P;
    case 13:
      return (reader.readLong(offset)) as P;
    case 14:
      return (reader.readString(offset)) as P;
    case 15:
      return (reader.readStringOrNull(offset)) as P;
    case 16:
      return (reader.readStringOrNull(offset)) as P;
    case 17:
      return (reader.readString(offset)) as P;
    case 18:
      return (reader.readString(offset)) as P;
    case 19:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 20:
      return (reader.readString(offset)) as P;
    case 21:
      return (reader.readLong(offset)) as P;
    case 22:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _surveyingLotIsarGetId(SurveyingLotIsar object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _surveyingLotIsarGetLinks(SurveyingLotIsar object) {
  return [];
}

void _surveyingLotIsarAttach(
    IsarCollection<dynamic> col, Id id, SurveyingLotIsar object) {
  object.id = id;
}

extension SurveyingLotIsarByIndex on IsarCollection<SurveyingLotIsar> {
  Future<SurveyingLotIsar?> getByLotId(String lotId) {
    return getByIndex(r'lotId', [lotId]);
  }

  SurveyingLotIsar? getByLotIdSync(String lotId) {
    return getByIndexSync(r'lotId', [lotId]);
  }

  Future<bool> deleteByLotId(String lotId) {
    return deleteByIndex(r'lotId', [lotId]);
  }

  bool deleteByLotIdSync(String lotId) {
    return deleteByIndexSync(r'lotId', [lotId]);
  }

  Future<List<SurveyingLotIsar?>> getAllByLotId(List<String> lotIdValues) {
    final values = lotIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'lotId', values);
  }

  List<SurveyingLotIsar?> getAllByLotIdSync(List<String> lotIdValues) {
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

  Future<Id> putByLotId(SurveyingLotIsar object) {
    return putByIndex(r'lotId', object);
  }

  Id putByLotIdSync(SurveyingLotIsar object, {bool saveLinks = true}) {
    return putByIndexSync(r'lotId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByLotId(List<SurveyingLotIsar> objects) {
    return putAllByIndex(r'lotId', objects);
  }

  List<Id> putAllByLotIdSync(List<SurveyingLotIsar> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'lotId', objects, saveLinks: saveLinks);
  }
}

extension SurveyingLotIsarQueryWhereSort
    on QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QWhere> {
  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterWhere> anyLat() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'lat'),
      );
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterWhere> anyLng() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'lng'),
      );
    });
  }
}

extension SurveyingLotIsarQueryWhere
    on QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QWhereClause> {
  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterWhereClause>
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

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterWhereClause> idBetween(
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

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterWhereClause>
      lotIdEqualTo(String lotId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'lotId',
        value: [lotId],
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterWhereClause>
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

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterWhereClause>
      latEqualTo(double lat) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'lat',
        value: [lat],
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterWhereClause>
      latNotEqualTo(double lat) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'lat',
              lower: [],
              upper: [lat],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'lat',
              lower: [lat],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'lat',
              lower: [lat],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'lat',
              lower: [],
              upper: [lat],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterWhereClause>
      latGreaterThan(
    double lat, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'lat',
        lower: [lat],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterWhereClause>
      latLessThan(
    double lat, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'lat',
        lower: [],
        upper: [lat],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterWhereClause>
      latBetween(
    double lowerLat,
    double upperLat, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'lat',
        lower: [lowerLat],
        includeLower: includeLower,
        upper: [upperLat],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterWhereClause>
      lngEqualTo(double lng) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'lng',
        value: [lng],
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterWhereClause>
      lngNotEqualTo(double lng) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'lng',
              lower: [],
              upper: [lng],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'lng',
              lower: [lng],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'lng',
              lower: [lng],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'lng',
              lower: [],
              upper: [lng],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterWhereClause>
      lngGreaterThan(
    double lng, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'lng',
        lower: [lng],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterWhereClause>
      lngLessThan(
    double lng, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'lng',
        lower: [],
        upper: [lng],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterWhereClause>
      lngBetween(
    double lowerLng,
    double upperLng, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'lng',
        lower: [lowerLng],
        includeLower: includeLower,
        upper: [upperLng],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterWhereClause>
      geohashEqualTo(String geohash) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'geohash',
        value: [geohash],
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterWhereClause>
      geohashNotEqualTo(String geohash) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'geohash',
              lower: [],
              upper: [geohash],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'geohash',
              lower: [geohash],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'geohash',
              lower: [geohash],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'geohash',
              lower: [],
              upper: [geohash],
              includeUpper: false,
            ));
      }
    });
  }
}

extension SurveyingLotIsarQueryFilter
    on QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QFilterCondition> {
  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
      addressEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'address',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
      addressGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'address',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
      addressLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'address',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
      addressBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'address',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
      addressStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'address',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
      addressEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'address',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
      addressContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'address',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
      addressMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'address',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
      addressIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'address',
        value: '',
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
      addressIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'address',
        value: '',
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
      cachedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cachedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
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

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
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

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
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

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
      carPriceEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'carPrice',
        value: value,
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
      carPriceGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'carPrice',
        value: value,
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
      carPriceLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'carPrice',
        value: value,
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
      carPriceBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'carPrice',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
      categoryEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
      categoryGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
      categoryLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
      categoryBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'category',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
      categoryStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
      categoryEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
      categoryContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
      categoryMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'category',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
      categoryIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'category',
        value: '',
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
      categoryIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'category',
        value: '',
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
      estimatedCarSlotsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'estimatedCarSlots',
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
      estimatedCarSlotsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'estimatedCarSlots',
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
      estimatedCarSlotsEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'estimatedCarSlots',
        value: value,
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
      estimatedCarSlotsGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'estimatedCarSlots',
        value: value,
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
      estimatedCarSlotsLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'estimatedCarSlots',
        value: value,
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
      estimatedCarSlotsBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'estimatedCarSlots',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
      estimatedMotoSlotsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'estimatedMotoSlots',
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
      estimatedMotoSlotsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'estimatedMotoSlots',
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
      estimatedMotoSlotsEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'estimatedMotoSlots',
        value: value,
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
      estimatedMotoSlotsGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'estimatedMotoSlots',
        value: value,
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
      estimatedMotoSlotsLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'estimatedMotoSlots',
        value: value,
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
      estimatedMotoSlotsBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'estimatedMotoSlots',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
      estimatedOpeningAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'estimatedOpeningAt',
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
      estimatedOpeningAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'estimatedOpeningAt',
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
      estimatedOpeningAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'estimatedOpeningAt',
        value: value,
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
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

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
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

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
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

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
      estimatedSlotsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'estimatedSlots',
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
      estimatedSlotsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'estimatedSlots',
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
      estimatedSlotsEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'estimatedSlots',
        value: value,
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
      estimatedSlotsGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'estimatedSlots',
        value: value,
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
      estimatedSlotsLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'estimatedSlots',
        value: value,
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
      estimatedSlotsBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'estimatedSlots',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
      geohashEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'geohash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
      geohashGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'geohash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
      geohashLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'geohash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
      geohashBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'geohash',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
      geohashStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'geohash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
      geohashEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'geohash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
      geohashContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'geohash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
      geohashMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'geohash',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
      geohashIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'geohash',
        value: '',
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
      geohashIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'geohash',
        value: '',
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
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

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
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

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
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

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
      imageUrlIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'imageUrl',
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
      imageUrlIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'imageUrl',
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
      imageUrlEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'imageUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
      imageUrlGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'imageUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
      imageUrlLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'imageUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
      imageUrlBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'imageUrl',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
      imageUrlStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'imageUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
      imageUrlEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'imageUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
      imageUrlContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'imageUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
      imageUrlMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'imageUrl',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
      imageUrlIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'imageUrl',
        value: '',
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
      imageUrlIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'imageUrl',
        value: '',
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
      latEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lat',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
      latGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lat',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
      latLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lat',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
      latBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lat',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
      lngEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lng',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
      lngGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lng',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
      lngLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lng',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
      lngBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lng',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
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

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
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

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
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

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
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

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
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

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
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

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
      lotIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'lotId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
      lotIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'lotId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
      lotIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lotId',
        value: '',
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
      lotIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'lotId',
        value: '',
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
      motoPriceEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'motoPrice',
        value: value,
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
      motoPriceGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'motoPrice',
        value: value,
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
      motoPriceLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'motoPrice',
        value: value,
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
      motoPriceBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'motoPrice',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
      nameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
      nameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
      nameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
      nameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'name',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
      nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
      nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
      nameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
      nameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'name',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
      nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
      nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
      notesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'notes',
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
      notesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'notes',
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
      notesEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
      notesGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
      notesLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
      notesBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'notes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
      notesStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
      notesEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
      notesContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
      notesMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'notes',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
      notesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'notes',
        value: '',
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
      notesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'notes',
        value: '',
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
      photoUrlIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'photoUrl',
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
      photoUrlIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'photoUrl',
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
      photoUrlEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'photoUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
      photoUrlGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'photoUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
      photoUrlLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'photoUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
      photoUrlBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'photoUrl',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
      photoUrlStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'photoUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
      photoUrlEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'photoUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
      photoUrlContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'photoUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
      photoUrlMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'photoUrl',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
      photoUrlIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'photoUrl',
        value: '',
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
      photoUrlIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'photoUrl',
        value: '',
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
      sourceEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'source',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
      sourceGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'source',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
      sourceLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'source',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
      sourceBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'source',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
      sourceStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'source',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
      sourceEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'source',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
      sourceContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'source',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
      sourceMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'source',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
      sourceIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'source',
        value: '',
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
      sourceIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'source',
        value: '',
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
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

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
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

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
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

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
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

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
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

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
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

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
      statusContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
      statusMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'status',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
      statusIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'status',
        value: '',
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
      statusIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'status',
        value: '',
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
      surveyedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'surveyedAt',
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
      surveyedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'surveyedAt',
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
      surveyedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'surveyedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
      surveyedAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'surveyedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
      surveyedAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'surveyedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
      surveyedAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'surveyedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
      surveyorEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'surveyor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
      surveyorGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'surveyor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
      surveyorLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'surveyor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
      surveyorBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'surveyor',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
      surveyorStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'surveyor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
      surveyorEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'surveyor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
      surveyorContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'surveyor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
      surveyorMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'surveyor',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
      surveyorIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'surveyor',
        value: '',
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
      surveyorIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'surveyor',
        value: '',
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
      totalSlotsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalSlots',
        value: value,
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
      totalSlotsGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalSlots',
        value: value,
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
      totalSlotsLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalSlots',
        value: value,
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
      totalSlotsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalSlots',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
      vehicleTypesEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'vehicleTypes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
      vehicleTypesGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'vehicleTypes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
      vehicleTypesLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'vehicleTypes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
      vehicleTypesBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'vehicleTypes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
      vehicleTypesStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'vehicleTypes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
      vehicleTypesEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'vehicleTypes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
      vehicleTypesContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'vehicleTypes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
      vehicleTypesMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'vehicleTypes',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
      vehicleTypesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'vehicleTypes',
        value: '',
      ));
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterFilterCondition>
      vehicleTypesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'vehicleTypes',
        value: '',
      ));
    });
  }
}

extension SurveyingLotIsarQueryObject
    on QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QFilterCondition> {}

extension SurveyingLotIsarQueryLinks
    on QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QFilterCondition> {}

extension SurveyingLotIsarQuerySortBy
    on QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QSortBy> {
  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterSortBy>
      sortByAddress() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'address', Sort.asc);
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterSortBy>
      sortByAddressDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'address', Sort.desc);
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterSortBy>
      sortByCachedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cachedAt', Sort.asc);
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterSortBy>
      sortByCachedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cachedAt', Sort.desc);
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterSortBy>
      sortByCarPrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'carPrice', Sort.asc);
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterSortBy>
      sortByCarPriceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'carPrice', Sort.desc);
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterSortBy>
      sortByCategory() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.asc);
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterSortBy>
      sortByCategoryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.desc);
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterSortBy>
      sortByEstimatedCarSlots() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'estimatedCarSlots', Sort.asc);
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterSortBy>
      sortByEstimatedCarSlotsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'estimatedCarSlots', Sort.desc);
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterSortBy>
      sortByEstimatedMotoSlots() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'estimatedMotoSlots', Sort.asc);
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterSortBy>
      sortByEstimatedMotoSlotsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'estimatedMotoSlots', Sort.desc);
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterSortBy>
      sortByEstimatedOpeningAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'estimatedOpeningAt', Sort.asc);
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterSortBy>
      sortByEstimatedOpeningAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'estimatedOpeningAt', Sort.desc);
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterSortBy>
      sortByEstimatedSlots() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'estimatedSlots', Sort.asc);
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterSortBy>
      sortByEstimatedSlotsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'estimatedSlots', Sort.desc);
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterSortBy>
      sortByGeohash() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'geohash', Sort.asc);
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterSortBy>
      sortByGeohashDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'geohash', Sort.desc);
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterSortBy>
      sortByImageUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imageUrl', Sort.asc);
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterSortBy>
      sortByImageUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imageUrl', Sort.desc);
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterSortBy> sortByLat() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lat', Sort.asc);
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterSortBy>
      sortByLatDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lat', Sort.desc);
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterSortBy> sortByLng() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lng', Sort.asc);
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterSortBy>
      sortByLngDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lng', Sort.desc);
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterSortBy> sortByLotId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lotId', Sort.asc);
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterSortBy>
      sortByLotIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lotId', Sort.desc);
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterSortBy>
      sortByMotoPrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'motoPrice', Sort.asc);
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterSortBy>
      sortByMotoPriceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'motoPrice', Sort.desc);
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterSortBy>
      sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterSortBy> sortByNotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.asc);
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterSortBy>
      sortByNotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.desc);
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterSortBy>
      sortByPhotoUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'photoUrl', Sort.asc);
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterSortBy>
      sortByPhotoUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'photoUrl', Sort.desc);
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterSortBy>
      sortBySource() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'source', Sort.asc);
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterSortBy>
      sortBySourceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'source', Sort.desc);
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterSortBy>
      sortByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterSortBy>
      sortByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterSortBy>
      sortBySurveyedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'surveyedAt', Sort.asc);
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterSortBy>
      sortBySurveyedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'surveyedAt', Sort.desc);
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterSortBy>
      sortBySurveyor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'surveyor', Sort.asc);
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterSortBy>
      sortBySurveyorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'surveyor', Sort.desc);
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterSortBy>
      sortByTotalSlots() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalSlots', Sort.asc);
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterSortBy>
      sortByTotalSlotsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalSlots', Sort.desc);
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterSortBy>
      sortByVehicleTypes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vehicleTypes', Sort.asc);
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterSortBy>
      sortByVehicleTypesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vehicleTypes', Sort.desc);
    });
  }
}

extension SurveyingLotIsarQuerySortThenBy
    on QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QSortThenBy> {
  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterSortBy>
      thenByAddress() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'address', Sort.asc);
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterSortBy>
      thenByAddressDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'address', Sort.desc);
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterSortBy>
      thenByCachedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cachedAt', Sort.asc);
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterSortBy>
      thenByCachedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cachedAt', Sort.desc);
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterSortBy>
      thenByCarPrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'carPrice', Sort.asc);
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterSortBy>
      thenByCarPriceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'carPrice', Sort.desc);
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterSortBy>
      thenByCategory() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.asc);
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterSortBy>
      thenByCategoryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.desc);
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterSortBy>
      thenByEstimatedCarSlots() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'estimatedCarSlots', Sort.asc);
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterSortBy>
      thenByEstimatedCarSlotsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'estimatedCarSlots', Sort.desc);
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterSortBy>
      thenByEstimatedMotoSlots() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'estimatedMotoSlots', Sort.asc);
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterSortBy>
      thenByEstimatedMotoSlotsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'estimatedMotoSlots', Sort.desc);
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterSortBy>
      thenByEstimatedOpeningAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'estimatedOpeningAt', Sort.asc);
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterSortBy>
      thenByEstimatedOpeningAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'estimatedOpeningAt', Sort.desc);
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterSortBy>
      thenByEstimatedSlots() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'estimatedSlots', Sort.asc);
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterSortBy>
      thenByEstimatedSlotsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'estimatedSlots', Sort.desc);
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterSortBy>
      thenByGeohash() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'geohash', Sort.asc);
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterSortBy>
      thenByGeohashDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'geohash', Sort.desc);
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterSortBy>
      thenByImageUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imageUrl', Sort.asc);
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterSortBy>
      thenByImageUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imageUrl', Sort.desc);
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterSortBy> thenByLat() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lat', Sort.asc);
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterSortBy>
      thenByLatDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lat', Sort.desc);
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterSortBy> thenByLng() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lng', Sort.asc);
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterSortBy>
      thenByLngDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lng', Sort.desc);
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterSortBy> thenByLotId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lotId', Sort.asc);
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterSortBy>
      thenByLotIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lotId', Sort.desc);
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterSortBy>
      thenByMotoPrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'motoPrice', Sort.asc);
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterSortBy>
      thenByMotoPriceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'motoPrice', Sort.desc);
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterSortBy>
      thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterSortBy> thenByNotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.asc);
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterSortBy>
      thenByNotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.desc);
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterSortBy>
      thenByPhotoUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'photoUrl', Sort.asc);
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterSortBy>
      thenByPhotoUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'photoUrl', Sort.desc);
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterSortBy>
      thenBySource() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'source', Sort.asc);
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterSortBy>
      thenBySourceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'source', Sort.desc);
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterSortBy>
      thenByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterSortBy>
      thenByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterSortBy>
      thenBySurveyedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'surveyedAt', Sort.asc);
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterSortBy>
      thenBySurveyedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'surveyedAt', Sort.desc);
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterSortBy>
      thenBySurveyor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'surveyor', Sort.asc);
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterSortBy>
      thenBySurveyorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'surveyor', Sort.desc);
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterSortBy>
      thenByTotalSlots() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalSlots', Sort.asc);
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterSortBy>
      thenByTotalSlotsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalSlots', Sort.desc);
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterSortBy>
      thenByVehicleTypes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vehicleTypes', Sort.asc);
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QAfterSortBy>
      thenByVehicleTypesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vehicleTypes', Sort.desc);
    });
  }
}

extension SurveyingLotIsarQueryWhereDistinct
    on QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QDistinct> {
  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QDistinct> distinctByAddress(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'address', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QDistinct>
      distinctByCachedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'cachedAt');
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QDistinct>
      distinctByCarPrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'carPrice');
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QDistinct>
      distinctByCategory({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'category', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QDistinct>
      distinctByEstimatedCarSlots() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'estimatedCarSlots');
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QDistinct>
      distinctByEstimatedMotoSlots() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'estimatedMotoSlots');
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QDistinct>
      distinctByEstimatedOpeningAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'estimatedOpeningAt');
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QDistinct>
      distinctByEstimatedSlots() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'estimatedSlots');
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QDistinct> distinctByGeohash(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'geohash', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QDistinct>
      distinctByImageUrl({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'imageUrl', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QDistinct> distinctByLat() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lat');
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QDistinct> distinctByLng() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lng');
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QDistinct> distinctByLotId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lotId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QDistinct>
      distinctByMotoPrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'motoPrice');
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QDistinct> distinctByNotes(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'notes', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QDistinct>
      distinctByPhotoUrl({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'photoUrl', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QDistinct> distinctBySource(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'source', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QDistinct> distinctByStatus(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'status', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QDistinct>
      distinctBySurveyedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'surveyedAt');
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QDistinct>
      distinctBySurveyor({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'surveyor', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QDistinct>
      distinctByTotalSlots() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalSlots');
    });
  }

  QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QDistinct>
      distinctByVehicleTypes({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'vehicleTypes', caseSensitive: caseSensitive);
    });
  }
}

extension SurveyingLotIsarQueryProperty
    on QueryBuilder<SurveyingLotIsar, SurveyingLotIsar, QQueryProperty> {
  QueryBuilder<SurveyingLotIsar, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<SurveyingLotIsar, String, QQueryOperations> addressProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'address');
    });
  }

  QueryBuilder<SurveyingLotIsar, DateTime, QQueryOperations>
      cachedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'cachedAt');
    });
  }

  QueryBuilder<SurveyingLotIsar, int, QQueryOperations> carPriceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'carPrice');
    });
  }

  QueryBuilder<SurveyingLotIsar, String, QQueryOperations> categoryProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'category');
    });
  }

  QueryBuilder<SurveyingLotIsar, int?, QQueryOperations>
      estimatedCarSlotsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'estimatedCarSlots');
    });
  }

  QueryBuilder<SurveyingLotIsar, int?, QQueryOperations>
      estimatedMotoSlotsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'estimatedMotoSlots');
    });
  }

  QueryBuilder<SurveyingLotIsar, DateTime?, QQueryOperations>
      estimatedOpeningAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'estimatedOpeningAt');
    });
  }

  QueryBuilder<SurveyingLotIsar, int?, QQueryOperations>
      estimatedSlotsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'estimatedSlots');
    });
  }

  QueryBuilder<SurveyingLotIsar, String, QQueryOperations> geohashProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'geohash');
    });
  }

  QueryBuilder<SurveyingLotIsar, String?, QQueryOperations> imageUrlProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'imageUrl');
    });
  }

  QueryBuilder<SurveyingLotIsar, double, QQueryOperations> latProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lat');
    });
  }

  QueryBuilder<SurveyingLotIsar, double, QQueryOperations> lngProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lng');
    });
  }

  QueryBuilder<SurveyingLotIsar, String, QQueryOperations> lotIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lotId');
    });
  }

  QueryBuilder<SurveyingLotIsar, int, QQueryOperations> motoPriceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'motoPrice');
    });
  }

  QueryBuilder<SurveyingLotIsar, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<SurveyingLotIsar, String?, QQueryOperations> notesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'notes');
    });
  }

  QueryBuilder<SurveyingLotIsar, String?, QQueryOperations> photoUrlProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'photoUrl');
    });
  }

  QueryBuilder<SurveyingLotIsar, String, QQueryOperations> sourceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'source');
    });
  }

  QueryBuilder<SurveyingLotIsar, String, QQueryOperations> statusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'status');
    });
  }

  QueryBuilder<SurveyingLotIsar, DateTime?, QQueryOperations>
      surveyedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'surveyedAt');
    });
  }

  QueryBuilder<SurveyingLotIsar, String, QQueryOperations> surveyorProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'surveyor');
    });
  }

  QueryBuilder<SurveyingLotIsar, int, QQueryOperations> totalSlotsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalSlots');
    });
  }

  QueryBuilder<SurveyingLotIsar, String, QQueryOperations>
      vehicleTypesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'vehicleTypes');
    });
  }
}
