// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_settings_isar.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetAppSettingsIsarCollection on Isar {
  IsarCollection<AppSettingsIsar> get appSettingsIsars => this.collection();
}

const AppSettingsIsarSchema = CollectionSchema(
  name: r'AppSettingsIsar',
  id: 977423823482933500,
  properties: {
    r'preferredVehicleFilter': PropertySchema(
      id: 0,
      name: r'preferredVehicleFilter',
      type: IsarType.string,
    ),
    r'privacyConsentAccepted': PropertySchema(
      id: 1,
      name: r'privacyConsentAccepted',
      type: IsarType.bool,
    ),
    r'privacyConsentAt': PropertySchema(
      id: 2,
      name: r'privacyConsentAt',
      type: IsarType.dateTime,
    ),
    r'surveyingCacheSchemaVersion': PropertySchema(
      id: 3,
      name: r'surveyingCacheSchemaVersion',
      type: IsarType.long,
    ),
    r'watchlistNotificationsEnabled': PropertySchema(
      id: 4,
      name: r'watchlistNotificationsEnabled',
      type: IsarType.bool,
    )
  },
  estimateSize: _appSettingsIsarEstimateSize,
  serialize: _appSettingsIsarSerialize,
  deserialize: _appSettingsIsarDeserialize,
  deserializeProp: _appSettingsIsarDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _appSettingsIsarGetId,
  getLinks: _appSettingsIsarGetLinks,
  attach: _appSettingsIsarAttach,
  version: '3.1.0+1',
);

int _appSettingsIsarEstimateSize(
  AppSettingsIsar object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.preferredVehicleFilter.length * 3;
  return bytesCount;
}

void _appSettingsIsarSerialize(
  AppSettingsIsar object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.preferredVehicleFilter);
  writer.writeBool(offsets[1], object.privacyConsentAccepted);
  writer.writeDateTime(offsets[2], object.privacyConsentAt);
  writer.writeLong(offsets[3], object.surveyingCacheSchemaVersion);
  writer.writeBool(offsets[4], object.watchlistNotificationsEnabled);
}

AppSettingsIsar _appSettingsIsarDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = AppSettingsIsar();
  object.id = id;
  object.preferredVehicleFilter = reader.readString(offsets[0]);
  object.privacyConsentAccepted = reader.readBool(offsets[1]);
  object.privacyConsentAt = reader.readDateTimeOrNull(offsets[2]);
  object.surveyingCacheSchemaVersion = reader.readLong(offsets[3]);
  object.watchlistNotificationsEnabled = reader.readBool(offsets[4]);
  return object;
}

P _appSettingsIsarDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readBool(offset)) as P;
    case 2:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readBool(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _appSettingsIsarGetId(AppSettingsIsar object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _appSettingsIsarGetLinks(AppSettingsIsar object) {
  return [];
}

void _appSettingsIsarAttach(
    IsarCollection<dynamic> col, Id id, AppSettingsIsar object) {
  object.id = id;
}

extension AppSettingsIsarQueryWhereSort
    on QueryBuilder<AppSettingsIsar, AppSettingsIsar, QWhere> {
  QueryBuilder<AppSettingsIsar, AppSettingsIsar, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension AppSettingsIsarQueryWhere
    on QueryBuilder<AppSettingsIsar, AppSettingsIsar, QWhereClause> {
  QueryBuilder<AppSettingsIsar, AppSettingsIsar, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<AppSettingsIsar, AppSettingsIsar, QAfterWhereClause>
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

  QueryBuilder<AppSettingsIsar, AppSettingsIsar, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<AppSettingsIsar, AppSettingsIsar, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<AppSettingsIsar, AppSettingsIsar, QAfterWhereClause> idBetween(
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
}

extension AppSettingsIsarQueryFilter
    on QueryBuilder<AppSettingsIsar, AppSettingsIsar, QFilterCondition> {
  QueryBuilder<AppSettingsIsar, AppSettingsIsar, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<AppSettingsIsar, AppSettingsIsar, QAfterFilterCondition>
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

  QueryBuilder<AppSettingsIsar, AppSettingsIsar, QAfterFilterCondition>
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

  QueryBuilder<AppSettingsIsar, AppSettingsIsar, QAfterFilterCondition>
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

  QueryBuilder<AppSettingsIsar, AppSettingsIsar, QAfterFilterCondition>
      preferredVehicleFilterEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'preferredVehicleFilter',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppSettingsIsar, AppSettingsIsar, QAfterFilterCondition>
      preferredVehicleFilterGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'preferredVehicleFilter',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppSettingsIsar, AppSettingsIsar, QAfterFilterCondition>
      preferredVehicleFilterLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'preferredVehicleFilter',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppSettingsIsar, AppSettingsIsar, QAfterFilterCondition>
      preferredVehicleFilterBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'preferredVehicleFilter',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppSettingsIsar, AppSettingsIsar, QAfterFilterCondition>
      preferredVehicleFilterStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'preferredVehicleFilter',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppSettingsIsar, AppSettingsIsar, QAfterFilterCondition>
      preferredVehicleFilterEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'preferredVehicleFilter',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppSettingsIsar, AppSettingsIsar, QAfterFilterCondition>
      preferredVehicleFilterContains(String value,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'preferredVehicleFilter',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppSettingsIsar, AppSettingsIsar, QAfterFilterCondition>
      preferredVehicleFilterMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'preferredVehicleFilter',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppSettingsIsar, AppSettingsIsar, QAfterFilterCondition>
      preferredVehicleFilterIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'preferredVehicleFilter',
        value: '',
      ));
    });
  }

  QueryBuilder<AppSettingsIsar, AppSettingsIsar, QAfterFilterCondition>
      preferredVehicleFilterIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'preferredVehicleFilter',
        value: '',
      ));
    });
  }

  QueryBuilder<AppSettingsIsar, AppSettingsIsar, QAfterFilterCondition>
      privacyConsentAcceptedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'privacyConsentAccepted',
        value: value,
      ));
    });
  }

  QueryBuilder<AppSettingsIsar, AppSettingsIsar, QAfterFilterCondition>
      privacyConsentAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'privacyConsentAt',
      ));
    });
  }

  QueryBuilder<AppSettingsIsar, AppSettingsIsar, QAfterFilterCondition>
      privacyConsentAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'privacyConsentAt',
      ));
    });
  }

  QueryBuilder<AppSettingsIsar, AppSettingsIsar, QAfterFilterCondition>
      privacyConsentAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'privacyConsentAt',
        value: value,
      ));
    });
  }

  QueryBuilder<AppSettingsIsar, AppSettingsIsar, QAfterFilterCondition>
      privacyConsentAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'privacyConsentAt',
        value: value,
      ));
    });
  }

  QueryBuilder<AppSettingsIsar, AppSettingsIsar, QAfterFilterCondition>
      privacyConsentAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'privacyConsentAt',
        value: value,
      ));
    });
  }

  QueryBuilder<AppSettingsIsar, AppSettingsIsar, QAfterFilterCondition>
      privacyConsentAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'privacyConsentAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AppSettingsIsar, AppSettingsIsar, QAfterFilterCondition>
      surveyingCacheSchemaVersionEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'surveyingCacheSchemaVersion',
        value: value,
      ));
    });
  }

  QueryBuilder<AppSettingsIsar, AppSettingsIsar, QAfterFilterCondition>
      surveyingCacheSchemaVersionGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'surveyingCacheSchemaVersion',
        value: value,
      ));
    });
  }

  QueryBuilder<AppSettingsIsar, AppSettingsIsar, QAfterFilterCondition>
      surveyingCacheSchemaVersionLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'surveyingCacheSchemaVersion',
        value: value,
      ));
    });
  }

  QueryBuilder<AppSettingsIsar, AppSettingsIsar, QAfterFilterCondition>
      surveyingCacheSchemaVersionBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'surveyingCacheSchemaVersion',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AppSettingsIsar, AppSettingsIsar, QAfterFilterCondition>
      watchlistNotificationsEnabledEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'watchlistNotificationsEnabled',
        value: value,
      ));
    });
  }
}

extension AppSettingsIsarQueryObject
    on QueryBuilder<AppSettingsIsar, AppSettingsIsar, QFilterCondition> {}

extension AppSettingsIsarQueryLinks
    on QueryBuilder<AppSettingsIsar, AppSettingsIsar, QFilterCondition> {}

extension AppSettingsIsarQuerySortBy
    on QueryBuilder<AppSettingsIsar, AppSettingsIsar, QSortBy> {
  QueryBuilder<AppSettingsIsar, AppSettingsIsar, QAfterSortBy>
      sortByPreferredVehicleFilter() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'preferredVehicleFilter', Sort.asc);
    });
  }

  QueryBuilder<AppSettingsIsar, AppSettingsIsar, QAfterSortBy>
      sortByPreferredVehicleFilterDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'preferredVehicleFilter', Sort.desc);
    });
  }

  QueryBuilder<AppSettingsIsar, AppSettingsIsar, QAfterSortBy>
      sortByPrivacyConsentAccepted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'privacyConsentAccepted', Sort.asc);
    });
  }

  QueryBuilder<AppSettingsIsar, AppSettingsIsar, QAfterSortBy>
      sortByPrivacyConsentAcceptedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'privacyConsentAccepted', Sort.desc);
    });
  }

  QueryBuilder<AppSettingsIsar, AppSettingsIsar, QAfterSortBy>
      sortByPrivacyConsentAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'privacyConsentAt', Sort.asc);
    });
  }

  QueryBuilder<AppSettingsIsar, AppSettingsIsar, QAfterSortBy>
      sortByPrivacyConsentAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'privacyConsentAt', Sort.desc);
    });
  }

  QueryBuilder<AppSettingsIsar, AppSettingsIsar, QAfterSortBy>
      sortBySurveyingCacheSchemaVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'surveyingCacheSchemaVersion', Sort.asc);
    });
  }

  QueryBuilder<AppSettingsIsar, AppSettingsIsar, QAfterSortBy>
      sortBySurveyingCacheSchemaVersionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'surveyingCacheSchemaVersion', Sort.desc);
    });
  }

  QueryBuilder<AppSettingsIsar, AppSettingsIsar, QAfterSortBy>
      sortByWatchlistNotificationsEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'watchlistNotificationsEnabled', Sort.asc);
    });
  }

  QueryBuilder<AppSettingsIsar, AppSettingsIsar, QAfterSortBy>
      sortByWatchlistNotificationsEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'watchlistNotificationsEnabled', Sort.desc);
    });
  }
}

extension AppSettingsIsarQuerySortThenBy
    on QueryBuilder<AppSettingsIsar, AppSettingsIsar, QSortThenBy> {
  QueryBuilder<AppSettingsIsar, AppSettingsIsar, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<AppSettingsIsar, AppSettingsIsar, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<AppSettingsIsar, AppSettingsIsar, QAfterSortBy>
      thenByPreferredVehicleFilter() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'preferredVehicleFilter', Sort.asc);
    });
  }

  QueryBuilder<AppSettingsIsar, AppSettingsIsar, QAfterSortBy>
      thenByPreferredVehicleFilterDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'preferredVehicleFilter', Sort.desc);
    });
  }

  QueryBuilder<AppSettingsIsar, AppSettingsIsar, QAfterSortBy>
      thenByPrivacyConsentAccepted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'privacyConsentAccepted', Sort.asc);
    });
  }

  QueryBuilder<AppSettingsIsar, AppSettingsIsar, QAfterSortBy>
      thenByPrivacyConsentAcceptedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'privacyConsentAccepted', Sort.desc);
    });
  }

  QueryBuilder<AppSettingsIsar, AppSettingsIsar, QAfterSortBy>
      thenByPrivacyConsentAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'privacyConsentAt', Sort.asc);
    });
  }

  QueryBuilder<AppSettingsIsar, AppSettingsIsar, QAfterSortBy>
      thenByPrivacyConsentAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'privacyConsentAt', Sort.desc);
    });
  }

  QueryBuilder<AppSettingsIsar, AppSettingsIsar, QAfterSortBy>
      thenBySurveyingCacheSchemaVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'surveyingCacheSchemaVersion', Sort.asc);
    });
  }

  QueryBuilder<AppSettingsIsar, AppSettingsIsar, QAfterSortBy>
      thenBySurveyingCacheSchemaVersionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'surveyingCacheSchemaVersion', Sort.desc);
    });
  }

  QueryBuilder<AppSettingsIsar, AppSettingsIsar, QAfterSortBy>
      thenByWatchlistNotificationsEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'watchlistNotificationsEnabled', Sort.asc);
    });
  }

  QueryBuilder<AppSettingsIsar, AppSettingsIsar, QAfterSortBy>
      thenByWatchlistNotificationsEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'watchlistNotificationsEnabled', Sort.desc);
    });
  }
}

extension AppSettingsIsarQueryWhereDistinct
    on QueryBuilder<AppSettingsIsar, AppSettingsIsar, QDistinct> {
  QueryBuilder<AppSettingsIsar, AppSettingsIsar, QDistinct>
      distinctByPreferredVehicleFilter({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'preferredVehicleFilter',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AppSettingsIsar, AppSettingsIsar, QDistinct>
      distinctByPrivacyConsentAccepted() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'privacyConsentAccepted');
    });
  }

  QueryBuilder<AppSettingsIsar, AppSettingsIsar, QDistinct>
      distinctByPrivacyConsentAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'privacyConsentAt');
    });
  }

  QueryBuilder<AppSettingsIsar, AppSettingsIsar, QDistinct>
      distinctBySurveyingCacheSchemaVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'surveyingCacheSchemaVersion');
    });
  }

  QueryBuilder<AppSettingsIsar, AppSettingsIsar, QDistinct>
      distinctByWatchlistNotificationsEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'watchlistNotificationsEnabled');
    });
  }
}

extension AppSettingsIsarQueryProperty
    on QueryBuilder<AppSettingsIsar, AppSettingsIsar, QQueryProperty> {
  QueryBuilder<AppSettingsIsar, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<AppSettingsIsar, String, QQueryOperations>
      preferredVehicleFilterProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'preferredVehicleFilter');
    });
  }

  QueryBuilder<AppSettingsIsar, bool, QQueryOperations>
      privacyConsentAcceptedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'privacyConsentAccepted');
    });
  }

  QueryBuilder<AppSettingsIsar, DateTime?, QQueryOperations>
      privacyConsentAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'privacyConsentAt');
    });
  }

  QueryBuilder<AppSettingsIsar, int, QQueryOperations>
      surveyingCacheSchemaVersionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'surveyingCacheSchemaVersion');
    });
  }

  QueryBuilder<AppSettingsIsar, bool, QQueryOperations>
      watchlistNotificationsEnabledProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'watchlistNotificationsEnabled');
    });
  }
}
