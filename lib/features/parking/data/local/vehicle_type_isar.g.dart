// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehicle_type_isar.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetVehicleTypeIsarCollection on Isar {
  IsarCollection<VehicleTypeIsar> get vehicleTypeIsars => this.collection();
}

const VehicleTypeIsarSchema = CollectionSchema(
  name: r'VehicleTypeIsar',
  id: 2824997530063042757,
  properties: {
    r'availableSlots': PropertySchema(
      id: 0,
      name: r'availableSlots',
      type: IsarType.long,
    ),
    r'cachedAt': PropertySchema(
      id: 1,
      name: r'cachedAt',
      type: IsarType.dateTime,
    ),
    r'lotId': PropertySchema(
      id: 2,
      name: r'lotId',
      type: IsarType.string,
    ),
    r'monthlyAmount': PropertySchema(
      id: 3,
      name: r'monthlyAmount',
      type: IsarType.long,
    ),
    r'priceAmount': PropertySchema(
      id: 4,
      name: r'priceAmount',
      type: IsarType.long,
    ),
    r'pricingModel': PropertySchema(
      id: 5,
      name: r'pricingModel',
      type: IsarType.string,
    ),
    r'totalSlots': PropertySchema(
      id: 6,
      name: r'totalSlots',
      type: IsarType.long,
    ),
    r'type': PropertySchema(
      id: 7,
      name: r'type',
      type: IsarType.string,
    ),
    r'typeId': PropertySchema(
      id: 8,
      name: r'typeId',
      type: IsarType.string,
    ),
    r'updatedAt': PropertySchema(
      id: 9,
      name: r'updatedAt',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _vehicleTypeIsarEstimateSize,
  serialize: _vehicleTypeIsarSerialize,
  deserialize: _vehicleTypeIsarDeserialize,
  deserializeProp: _vehicleTypeIsarDeserializeProp,
  idName: r'id',
  indexes: {
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
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _vehicleTypeIsarGetId,
  getLinks: _vehicleTypeIsarGetLinks,
  attach: _vehicleTypeIsarAttach,
  version: '3.1.0+1',
);

int _vehicleTypeIsarEstimateSize(
  VehicleTypeIsar object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.lotId.length * 3;
  bytesCount += 3 + object.pricingModel.length * 3;
  bytesCount += 3 + object.type.length * 3;
  bytesCount += 3 + object.typeId.length * 3;
  return bytesCount;
}

void _vehicleTypeIsarSerialize(
  VehicleTypeIsar object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.availableSlots);
  writer.writeDateTime(offsets[1], object.cachedAt);
  writer.writeString(offsets[2], object.lotId);
  writer.writeLong(offsets[3], object.monthlyAmount);
  writer.writeLong(offsets[4], object.priceAmount);
  writer.writeString(offsets[5], object.pricingModel);
  writer.writeLong(offsets[6], object.totalSlots);
  writer.writeString(offsets[7], object.type);
  writer.writeString(offsets[8], object.typeId);
  writer.writeDateTime(offsets[9], object.updatedAt);
}

VehicleTypeIsar _vehicleTypeIsarDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = VehicleTypeIsar();
  object.availableSlots = reader.readLong(offsets[0]);
  object.cachedAt = reader.readDateTime(offsets[1]);
  object.id = id;
  object.lotId = reader.readString(offsets[2]);
  object.monthlyAmount = reader.readLongOrNull(offsets[3]);
  object.priceAmount = reader.readLong(offsets[4]);
  object.pricingModel = reader.readString(offsets[5]);
  object.totalSlots = reader.readLong(offsets[6]);
  object.type = reader.readString(offsets[7]);
  object.typeId = reader.readString(offsets[8]);
  object.updatedAt = reader.readDateTime(offsets[9]);
  return object;
}

P _vehicleTypeIsarDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readLongOrNull(offset)) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readLong(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    case 8:
      return (reader.readString(offset)) as P;
    case 9:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _vehicleTypeIsarGetId(VehicleTypeIsar object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _vehicleTypeIsarGetLinks(VehicleTypeIsar object) {
  return [];
}

void _vehicleTypeIsarAttach(
    IsarCollection<dynamic> col, Id id, VehicleTypeIsar object) {
  object.id = id;
}

extension VehicleTypeIsarQueryWhereSort
    on QueryBuilder<VehicleTypeIsar, VehicleTypeIsar, QWhere> {
  QueryBuilder<VehicleTypeIsar, VehicleTypeIsar, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension VehicleTypeIsarQueryWhere
    on QueryBuilder<VehicleTypeIsar, VehicleTypeIsar, QWhereClause> {
  QueryBuilder<VehicleTypeIsar, VehicleTypeIsar, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<VehicleTypeIsar, VehicleTypeIsar, QAfterWhereClause>
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

  QueryBuilder<VehicleTypeIsar, VehicleTypeIsar, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<VehicleTypeIsar, VehicleTypeIsar, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<VehicleTypeIsar, VehicleTypeIsar, QAfterWhereClause> idBetween(
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

  QueryBuilder<VehicleTypeIsar, VehicleTypeIsar, QAfterWhereClause>
      lotIdEqualTo(String lotId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'lotId',
        value: [lotId],
      ));
    });
  }

  QueryBuilder<VehicleTypeIsar, VehicleTypeIsar, QAfterWhereClause>
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

extension VehicleTypeIsarQueryFilter
    on QueryBuilder<VehicleTypeIsar, VehicleTypeIsar, QFilterCondition> {
  QueryBuilder<VehicleTypeIsar, VehicleTypeIsar, QAfterFilterCondition>
      availableSlotsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'availableSlots',
        value: value,
      ));
    });
  }

  QueryBuilder<VehicleTypeIsar, VehicleTypeIsar, QAfterFilterCondition>
      availableSlotsGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'availableSlots',
        value: value,
      ));
    });
  }

  QueryBuilder<VehicleTypeIsar, VehicleTypeIsar, QAfterFilterCondition>
      availableSlotsLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'availableSlots',
        value: value,
      ));
    });
  }

  QueryBuilder<VehicleTypeIsar, VehicleTypeIsar, QAfterFilterCondition>
      availableSlotsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'availableSlots',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<VehicleTypeIsar, VehicleTypeIsar, QAfterFilterCondition>
      cachedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cachedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<VehicleTypeIsar, VehicleTypeIsar, QAfterFilterCondition>
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

  QueryBuilder<VehicleTypeIsar, VehicleTypeIsar, QAfterFilterCondition>
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

  QueryBuilder<VehicleTypeIsar, VehicleTypeIsar, QAfterFilterCondition>
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

  QueryBuilder<VehicleTypeIsar, VehicleTypeIsar, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<VehicleTypeIsar, VehicleTypeIsar, QAfterFilterCondition>
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

  QueryBuilder<VehicleTypeIsar, VehicleTypeIsar, QAfterFilterCondition>
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

  QueryBuilder<VehicleTypeIsar, VehicleTypeIsar, QAfterFilterCondition>
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

  QueryBuilder<VehicleTypeIsar, VehicleTypeIsar, QAfterFilterCondition>
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

  QueryBuilder<VehicleTypeIsar, VehicleTypeIsar, QAfterFilterCondition>
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

  QueryBuilder<VehicleTypeIsar, VehicleTypeIsar, QAfterFilterCondition>
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

  QueryBuilder<VehicleTypeIsar, VehicleTypeIsar, QAfterFilterCondition>
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

  QueryBuilder<VehicleTypeIsar, VehicleTypeIsar, QAfterFilterCondition>
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

  QueryBuilder<VehicleTypeIsar, VehicleTypeIsar, QAfterFilterCondition>
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

  QueryBuilder<VehicleTypeIsar, VehicleTypeIsar, QAfterFilterCondition>
      lotIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'lotId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VehicleTypeIsar, VehicleTypeIsar, QAfterFilterCondition>
      lotIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'lotId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VehicleTypeIsar, VehicleTypeIsar, QAfterFilterCondition>
      lotIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lotId',
        value: '',
      ));
    });
  }

  QueryBuilder<VehicleTypeIsar, VehicleTypeIsar, QAfterFilterCondition>
      lotIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'lotId',
        value: '',
      ));
    });
  }

  QueryBuilder<VehicleTypeIsar, VehicleTypeIsar, QAfterFilterCondition>
      monthlyAmountIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'monthlyAmount',
      ));
    });
  }

  QueryBuilder<VehicleTypeIsar, VehicleTypeIsar, QAfterFilterCondition>
      monthlyAmountIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'monthlyAmount',
      ));
    });
  }

  QueryBuilder<VehicleTypeIsar, VehicleTypeIsar, QAfterFilterCondition>
      monthlyAmountEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'monthlyAmount',
        value: value,
      ));
    });
  }

  QueryBuilder<VehicleTypeIsar, VehicleTypeIsar, QAfterFilterCondition>
      monthlyAmountGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'monthlyAmount',
        value: value,
      ));
    });
  }

  QueryBuilder<VehicleTypeIsar, VehicleTypeIsar, QAfterFilterCondition>
      monthlyAmountLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'monthlyAmount',
        value: value,
      ));
    });
  }

  QueryBuilder<VehicleTypeIsar, VehicleTypeIsar, QAfterFilterCondition>
      monthlyAmountBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'monthlyAmount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<VehicleTypeIsar, VehicleTypeIsar, QAfterFilterCondition>
      priceAmountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'priceAmount',
        value: value,
      ));
    });
  }

  QueryBuilder<VehicleTypeIsar, VehicleTypeIsar, QAfterFilterCondition>
      priceAmountGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'priceAmount',
        value: value,
      ));
    });
  }

  QueryBuilder<VehicleTypeIsar, VehicleTypeIsar, QAfterFilterCondition>
      priceAmountLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'priceAmount',
        value: value,
      ));
    });
  }

  QueryBuilder<VehicleTypeIsar, VehicleTypeIsar, QAfterFilterCondition>
      priceAmountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'priceAmount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<VehicleTypeIsar, VehicleTypeIsar, QAfterFilterCondition>
      pricingModelEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'pricingModel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VehicleTypeIsar, VehicleTypeIsar, QAfterFilterCondition>
      pricingModelGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'pricingModel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VehicleTypeIsar, VehicleTypeIsar, QAfterFilterCondition>
      pricingModelLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'pricingModel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VehicleTypeIsar, VehicleTypeIsar, QAfterFilterCondition>
      pricingModelBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'pricingModel',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VehicleTypeIsar, VehicleTypeIsar, QAfterFilterCondition>
      pricingModelStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'pricingModel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VehicleTypeIsar, VehicleTypeIsar, QAfterFilterCondition>
      pricingModelEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'pricingModel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VehicleTypeIsar, VehicleTypeIsar, QAfterFilterCondition>
      pricingModelContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'pricingModel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VehicleTypeIsar, VehicleTypeIsar, QAfterFilterCondition>
      pricingModelMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'pricingModel',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VehicleTypeIsar, VehicleTypeIsar, QAfterFilterCondition>
      pricingModelIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'pricingModel',
        value: '',
      ));
    });
  }

  QueryBuilder<VehicleTypeIsar, VehicleTypeIsar, QAfterFilterCondition>
      pricingModelIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'pricingModel',
        value: '',
      ));
    });
  }

  QueryBuilder<VehicleTypeIsar, VehicleTypeIsar, QAfterFilterCondition>
      totalSlotsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalSlots',
        value: value,
      ));
    });
  }

  QueryBuilder<VehicleTypeIsar, VehicleTypeIsar, QAfterFilterCondition>
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

  QueryBuilder<VehicleTypeIsar, VehicleTypeIsar, QAfterFilterCondition>
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

  QueryBuilder<VehicleTypeIsar, VehicleTypeIsar, QAfterFilterCondition>
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

  QueryBuilder<VehicleTypeIsar, VehicleTypeIsar, QAfterFilterCondition>
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

  QueryBuilder<VehicleTypeIsar, VehicleTypeIsar, QAfterFilterCondition>
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

  QueryBuilder<VehicleTypeIsar, VehicleTypeIsar, QAfterFilterCondition>
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

  QueryBuilder<VehicleTypeIsar, VehicleTypeIsar, QAfterFilterCondition>
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

  QueryBuilder<VehicleTypeIsar, VehicleTypeIsar, QAfterFilterCondition>
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

  QueryBuilder<VehicleTypeIsar, VehicleTypeIsar, QAfterFilterCondition>
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

  QueryBuilder<VehicleTypeIsar, VehicleTypeIsar, QAfterFilterCondition>
      typeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VehicleTypeIsar, VehicleTypeIsar, QAfterFilterCondition>
      typeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'type',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VehicleTypeIsar, VehicleTypeIsar, QAfterFilterCondition>
      typeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'type',
        value: '',
      ));
    });
  }

  QueryBuilder<VehicleTypeIsar, VehicleTypeIsar, QAfterFilterCondition>
      typeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'type',
        value: '',
      ));
    });
  }

  QueryBuilder<VehicleTypeIsar, VehicleTypeIsar, QAfterFilterCondition>
      typeIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'typeId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VehicleTypeIsar, VehicleTypeIsar, QAfterFilterCondition>
      typeIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'typeId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VehicleTypeIsar, VehicleTypeIsar, QAfterFilterCondition>
      typeIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'typeId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VehicleTypeIsar, VehicleTypeIsar, QAfterFilterCondition>
      typeIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'typeId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VehicleTypeIsar, VehicleTypeIsar, QAfterFilterCondition>
      typeIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'typeId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VehicleTypeIsar, VehicleTypeIsar, QAfterFilterCondition>
      typeIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'typeId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VehicleTypeIsar, VehicleTypeIsar, QAfterFilterCondition>
      typeIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'typeId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VehicleTypeIsar, VehicleTypeIsar, QAfterFilterCondition>
      typeIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'typeId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VehicleTypeIsar, VehicleTypeIsar, QAfterFilterCondition>
      typeIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'typeId',
        value: '',
      ));
    });
  }

  QueryBuilder<VehicleTypeIsar, VehicleTypeIsar, QAfterFilterCondition>
      typeIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'typeId',
        value: '',
      ));
    });
  }

  QueryBuilder<VehicleTypeIsar, VehicleTypeIsar, QAfterFilterCondition>
      updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<VehicleTypeIsar, VehicleTypeIsar, QAfterFilterCondition>
      updatedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<VehicleTypeIsar, VehicleTypeIsar, QAfterFilterCondition>
      updatedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<VehicleTypeIsar, VehicleTypeIsar, QAfterFilterCondition>
      updatedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'updatedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension VehicleTypeIsarQueryObject
    on QueryBuilder<VehicleTypeIsar, VehicleTypeIsar, QFilterCondition> {}

extension VehicleTypeIsarQueryLinks
    on QueryBuilder<VehicleTypeIsar, VehicleTypeIsar, QFilterCondition> {}

extension VehicleTypeIsarQuerySortBy
    on QueryBuilder<VehicleTypeIsar, VehicleTypeIsar, QSortBy> {
  QueryBuilder<VehicleTypeIsar, VehicleTypeIsar, QAfterSortBy>
      sortByAvailableSlots() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'availableSlots', Sort.asc);
    });
  }

  QueryBuilder<VehicleTypeIsar, VehicleTypeIsar, QAfterSortBy>
      sortByAvailableSlotsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'availableSlots', Sort.desc);
    });
  }

  QueryBuilder<VehicleTypeIsar, VehicleTypeIsar, QAfterSortBy>
      sortByCachedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cachedAt', Sort.asc);
    });
  }

  QueryBuilder<VehicleTypeIsar, VehicleTypeIsar, QAfterSortBy>
      sortByCachedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cachedAt', Sort.desc);
    });
  }

  QueryBuilder<VehicleTypeIsar, VehicleTypeIsar, QAfterSortBy> sortByLotId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lotId', Sort.asc);
    });
  }

  QueryBuilder<VehicleTypeIsar, VehicleTypeIsar, QAfterSortBy>
      sortByLotIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lotId', Sort.desc);
    });
  }

  QueryBuilder<VehicleTypeIsar, VehicleTypeIsar, QAfterSortBy>
      sortByMonthlyAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'monthlyAmount', Sort.asc);
    });
  }

  QueryBuilder<VehicleTypeIsar, VehicleTypeIsar, QAfterSortBy>
      sortByMonthlyAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'monthlyAmount', Sort.desc);
    });
  }

  QueryBuilder<VehicleTypeIsar, VehicleTypeIsar, QAfterSortBy>
      sortByPriceAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'priceAmount', Sort.asc);
    });
  }

  QueryBuilder<VehicleTypeIsar, VehicleTypeIsar, QAfterSortBy>
      sortByPriceAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'priceAmount', Sort.desc);
    });
  }

  QueryBuilder<VehicleTypeIsar, VehicleTypeIsar, QAfterSortBy>
      sortByPricingModel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pricingModel', Sort.asc);
    });
  }

  QueryBuilder<VehicleTypeIsar, VehicleTypeIsar, QAfterSortBy>
      sortByPricingModelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pricingModel', Sort.desc);
    });
  }

  QueryBuilder<VehicleTypeIsar, VehicleTypeIsar, QAfterSortBy>
      sortByTotalSlots() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalSlots', Sort.asc);
    });
  }

  QueryBuilder<VehicleTypeIsar, VehicleTypeIsar, QAfterSortBy>
      sortByTotalSlotsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalSlots', Sort.desc);
    });
  }

  QueryBuilder<VehicleTypeIsar, VehicleTypeIsar, QAfterSortBy> sortByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<VehicleTypeIsar, VehicleTypeIsar, QAfterSortBy>
      sortByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }

  QueryBuilder<VehicleTypeIsar, VehicleTypeIsar, QAfterSortBy> sortByTypeId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'typeId', Sort.asc);
    });
  }

  QueryBuilder<VehicleTypeIsar, VehicleTypeIsar, QAfterSortBy>
      sortByTypeIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'typeId', Sort.desc);
    });
  }

  QueryBuilder<VehicleTypeIsar, VehicleTypeIsar, QAfterSortBy>
      sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<VehicleTypeIsar, VehicleTypeIsar, QAfterSortBy>
      sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension VehicleTypeIsarQuerySortThenBy
    on QueryBuilder<VehicleTypeIsar, VehicleTypeIsar, QSortThenBy> {
  QueryBuilder<VehicleTypeIsar, VehicleTypeIsar, QAfterSortBy>
      thenByAvailableSlots() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'availableSlots', Sort.asc);
    });
  }

  QueryBuilder<VehicleTypeIsar, VehicleTypeIsar, QAfterSortBy>
      thenByAvailableSlotsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'availableSlots', Sort.desc);
    });
  }

  QueryBuilder<VehicleTypeIsar, VehicleTypeIsar, QAfterSortBy>
      thenByCachedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cachedAt', Sort.asc);
    });
  }

  QueryBuilder<VehicleTypeIsar, VehicleTypeIsar, QAfterSortBy>
      thenByCachedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cachedAt', Sort.desc);
    });
  }

  QueryBuilder<VehicleTypeIsar, VehicleTypeIsar, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<VehicleTypeIsar, VehicleTypeIsar, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<VehicleTypeIsar, VehicleTypeIsar, QAfterSortBy> thenByLotId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lotId', Sort.asc);
    });
  }

  QueryBuilder<VehicleTypeIsar, VehicleTypeIsar, QAfterSortBy>
      thenByLotIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lotId', Sort.desc);
    });
  }

  QueryBuilder<VehicleTypeIsar, VehicleTypeIsar, QAfterSortBy>
      thenByMonthlyAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'monthlyAmount', Sort.asc);
    });
  }

  QueryBuilder<VehicleTypeIsar, VehicleTypeIsar, QAfterSortBy>
      thenByMonthlyAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'monthlyAmount', Sort.desc);
    });
  }

  QueryBuilder<VehicleTypeIsar, VehicleTypeIsar, QAfterSortBy>
      thenByPriceAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'priceAmount', Sort.asc);
    });
  }

  QueryBuilder<VehicleTypeIsar, VehicleTypeIsar, QAfterSortBy>
      thenByPriceAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'priceAmount', Sort.desc);
    });
  }

  QueryBuilder<VehicleTypeIsar, VehicleTypeIsar, QAfterSortBy>
      thenByPricingModel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pricingModel', Sort.asc);
    });
  }

  QueryBuilder<VehicleTypeIsar, VehicleTypeIsar, QAfterSortBy>
      thenByPricingModelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pricingModel', Sort.desc);
    });
  }

  QueryBuilder<VehicleTypeIsar, VehicleTypeIsar, QAfterSortBy>
      thenByTotalSlots() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalSlots', Sort.asc);
    });
  }

  QueryBuilder<VehicleTypeIsar, VehicleTypeIsar, QAfterSortBy>
      thenByTotalSlotsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalSlots', Sort.desc);
    });
  }

  QueryBuilder<VehicleTypeIsar, VehicleTypeIsar, QAfterSortBy> thenByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<VehicleTypeIsar, VehicleTypeIsar, QAfterSortBy>
      thenByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }

  QueryBuilder<VehicleTypeIsar, VehicleTypeIsar, QAfterSortBy> thenByTypeId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'typeId', Sort.asc);
    });
  }

  QueryBuilder<VehicleTypeIsar, VehicleTypeIsar, QAfterSortBy>
      thenByTypeIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'typeId', Sort.desc);
    });
  }

  QueryBuilder<VehicleTypeIsar, VehicleTypeIsar, QAfterSortBy>
      thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<VehicleTypeIsar, VehicleTypeIsar, QAfterSortBy>
      thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension VehicleTypeIsarQueryWhereDistinct
    on QueryBuilder<VehicleTypeIsar, VehicleTypeIsar, QDistinct> {
  QueryBuilder<VehicleTypeIsar, VehicleTypeIsar, QDistinct>
      distinctByAvailableSlots() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'availableSlots');
    });
  }

  QueryBuilder<VehicleTypeIsar, VehicleTypeIsar, QDistinct>
      distinctByCachedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'cachedAt');
    });
  }

  QueryBuilder<VehicleTypeIsar, VehicleTypeIsar, QDistinct> distinctByLotId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lotId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<VehicleTypeIsar, VehicleTypeIsar, QDistinct>
      distinctByMonthlyAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'monthlyAmount');
    });
  }

  QueryBuilder<VehicleTypeIsar, VehicleTypeIsar, QDistinct>
      distinctByPriceAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'priceAmount');
    });
  }

  QueryBuilder<VehicleTypeIsar, VehicleTypeIsar, QDistinct>
      distinctByPricingModel({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'pricingModel', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<VehicleTypeIsar, VehicleTypeIsar, QDistinct>
      distinctByTotalSlots() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalSlots');
    });
  }

  QueryBuilder<VehicleTypeIsar, VehicleTypeIsar, QDistinct> distinctByType(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'type', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<VehicleTypeIsar, VehicleTypeIsar, QDistinct> distinctByTypeId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'typeId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<VehicleTypeIsar, VehicleTypeIsar, QDistinct>
      distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }
}

extension VehicleTypeIsarQueryProperty
    on QueryBuilder<VehicleTypeIsar, VehicleTypeIsar, QQueryProperty> {
  QueryBuilder<VehicleTypeIsar, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<VehicleTypeIsar, int, QQueryOperations>
      availableSlotsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'availableSlots');
    });
  }

  QueryBuilder<VehicleTypeIsar, DateTime, QQueryOperations> cachedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'cachedAt');
    });
  }

  QueryBuilder<VehicleTypeIsar, String, QQueryOperations> lotIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lotId');
    });
  }

  QueryBuilder<VehicleTypeIsar, int?, QQueryOperations>
      monthlyAmountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'monthlyAmount');
    });
  }

  QueryBuilder<VehicleTypeIsar, int, QQueryOperations> priceAmountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'priceAmount');
    });
  }

  QueryBuilder<VehicleTypeIsar, String, QQueryOperations>
      pricingModelProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'pricingModel');
    });
  }

  QueryBuilder<VehicleTypeIsar, int, QQueryOperations> totalSlotsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalSlots');
    });
  }

  QueryBuilder<VehicleTypeIsar, String, QQueryOperations> typeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'type');
    });
  }

  QueryBuilder<VehicleTypeIsar, String, QQueryOperations> typeIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'typeId');
    });
  }

  QueryBuilder<VehicleTypeIsar, DateTime, QQueryOperations>
      updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }
}
