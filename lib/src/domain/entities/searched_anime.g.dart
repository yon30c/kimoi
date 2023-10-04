// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'searched_anime.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetSearchedAnimeCollection on Isar {
  IsarCollection<SearchedAnime> get searchedAnimes => this.collection();
}

const SearchedAnimeSchema = CollectionSchema(
  name: r'SearchedAnime',
  id: -7118626214394943234,
  properties: {
    r'animeTitle': PropertySchema(
      id: 0,
      name: r'animeTitle',
      type: IsarType.string,
    ),
    r'animeUrl': PropertySchema(
      id: 1,
      name: r'animeUrl',
      type: IsarType.string,
    ),
    r'chapterInfo': PropertySchema(
      id: 2,
      name: r'chapterInfo',
      type: IsarType.string,
    ),
    r'chapterUrl': PropertySchema(
      id: 3,
      name: r'chapterUrl',
      type: IsarType.string,
    ),
    r'date': PropertySchema(
      id: 4,
      name: r'date',
      type: IsarType.dateTime,
    ),
    r'imageUrl': PropertySchema(
      id: 5,
      name: r'imageUrl',
      type: IsarType.string,
    ),
    r'release': PropertySchema(
      id: 6,
      name: r'release',
      type: IsarType.string,
    ),
    r'type': PropertySchema(
      id: 7,
      name: r'type',
      type: IsarType.string,
    )
  },
  estimateSize: _searchedAnimeEstimateSize,
  serialize: _searchedAnimeSerialize,
  deserialize: _searchedAnimeDeserialize,
  deserializeProp: _searchedAnimeDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _searchedAnimeGetId,
  getLinks: _searchedAnimeGetLinks,
  attach: _searchedAnimeAttach,
  version: '3.1.0+1',
);

int _searchedAnimeEstimateSize(
  SearchedAnime object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.animeTitle.length * 3;
  bytesCount += 3 + object.animeUrl.length * 3;
  {
    final value = object.chapterInfo;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.chapterUrl;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.imageUrl.length * 3;
  {
    final value = object.release;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.type;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _searchedAnimeSerialize(
  SearchedAnime object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.animeTitle);
  writer.writeString(offsets[1], object.animeUrl);
  writer.writeString(offsets[2], object.chapterInfo);
  writer.writeString(offsets[3], object.chapterUrl);
  writer.writeDateTime(offsets[4], object.date);
  writer.writeString(offsets[5], object.imageUrl);
  writer.writeString(offsets[6], object.release);
  writer.writeString(offsets[7], object.type);
}

SearchedAnime _searchedAnimeDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = SearchedAnime(
    animeTitle: reader.readString(offsets[0]),
    animeUrl: reader.readString(offsets[1]),
    chapterInfo: reader.readStringOrNull(offsets[2]),
    chapterUrl: reader.readStringOrNull(offsets[3]),
    date: reader.readDateTimeOrNull(offsets[4]),
    imageUrl: reader.readString(offsets[5]),
    release: reader.readStringOrNull(offsets[6]),
    type: reader.readStringOrNull(offsets[7]),
  );
  object.id = id;
  return object;
}

P _searchedAnimeDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    case 7:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _searchedAnimeGetId(SearchedAnime object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _searchedAnimeGetLinks(SearchedAnime object) {
  return [];
}

void _searchedAnimeAttach(
    IsarCollection<dynamic> col, Id id, SearchedAnime object) {
  object.id = id;
}

extension SearchedAnimeQueryWhereSort
    on QueryBuilder<SearchedAnime, SearchedAnime, QWhere> {
  QueryBuilder<SearchedAnime, SearchedAnime, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension SearchedAnimeQueryWhere
    on QueryBuilder<SearchedAnime, SearchedAnime, QWhereClause> {
  QueryBuilder<SearchedAnime, SearchedAnime, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<SearchedAnime, SearchedAnime, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<SearchedAnime, SearchedAnime, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<SearchedAnime, SearchedAnime, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<SearchedAnime, SearchedAnime, QAfterWhereClause> idBetween(
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

extension SearchedAnimeQueryFilter
    on QueryBuilder<SearchedAnime, SearchedAnime, QFilterCondition> {
  QueryBuilder<SearchedAnime, SearchedAnime, QAfterFilterCondition>
      animeTitleEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'animeTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SearchedAnime, SearchedAnime, QAfterFilterCondition>
      animeTitleGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'animeTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SearchedAnime, SearchedAnime, QAfterFilterCondition>
      animeTitleLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'animeTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SearchedAnime, SearchedAnime, QAfterFilterCondition>
      animeTitleBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'animeTitle',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SearchedAnime, SearchedAnime, QAfterFilterCondition>
      animeTitleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'animeTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SearchedAnime, SearchedAnime, QAfterFilterCondition>
      animeTitleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'animeTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SearchedAnime, SearchedAnime, QAfterFilterCondition>
      animeTitleContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'animeTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SearchedAnime, SearchedAnime, QAfterFilterCondition>
      animeTitleMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'animeTitle',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SearchedAnime, SearchedAnime, QAfterFilterCondition>
      animeTitleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'animeTitle',
        value: '',
      ));
    });
  }

  QueryBuilder<SearchedAnime, SearchedAnime, QAfterFilterCondition>
      animeTitleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'animeTitle',
        value: '',
      ));
    });
  }

  QueryBuilder<SearchedAnime, SearchedAnime, QAfterFilterCondition>
      animeUrlEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'animeUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SearchedAnime, SearchedAnime, QAfterFilterCondition>
      animeUrlGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'animeUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SearchedAnime, SearchedAnime, QAfterFilterCondition>
      animeUrlLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'animeUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SearchedAnime, SearchedAnime, QAfterFilterCondition>
      animeUrlBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'animeUrl',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SearchedAnime, SearchedAnime, QAfterFilterCondition>
      animeUrlStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'animeUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SearchedAnime, SearchedAnime, QAfterFilterCondition>
      animeUrlEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'animeUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SearchedAnime, SearchedAnime, QAfterFilterCondition>
      animeUrlContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'animeUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SearchedAnime, SearchedAnime, QAfterFilterCondition>
      animeUrlMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'animeUrl',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SearchedAnime, SearchedAnime, QAfterFilterCondition>
      animeUrlIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'animeUrl',
        value: '',
      ));
    });
  }

  QueryBuilder<SearchedAnime, SearchedAnime, QAfterFilterCondition>
      animeUrlIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'animeUrl',
        value: '',
      ));
    });
  }

  QueryBuilder<SearchedAnime, SearchedAnime, QAfterFilterCondition>
      chapterInfoIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'chapterInfo',
      ));
    });
  }

  QueryBuilder<SearchedAnime, SearchedAnime, QAfterFilterCondition>
      chapterInfoIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'chapterInfo',
      ));
    });
  }

  QueryBuilder<SearchedAnime, SearchedAnime, QAfterFilterCondition>
      chapterInfoEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'chapterInfo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SearchedAnime, SearchedAnime, QAfterFilterCondition>
      chapterInfoGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'chapterInfo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SearchedAnime, SearchedAnime, QAfterFilterCondition>
      chapterInfoLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'chapterInfo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SearchedAnime, SearchedAnime, QAfterFilterCondition>
      chapterInfoBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'chapterInfo',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SearchedAnime, SearchedAnime, QAfterFilterCondition>
      chapterInfoStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'chapterInfo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SearchedAnime, SearchedAnime, QAfterFilterCondition>
      chapterInfoEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'chapterInfo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SearchedAnime, SearchedAnime, QAfterFilterCondition>
      chapterInfoContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'chapterInfo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SearchedAnime, SearchedAnime, QAfterFilterCondition>
      chapterInfoMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'chapterInfo',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SearchedAnime, SearchedAnime, QAfterFilterCondition>
      chapterInfoIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'chapterInfo',
        value: '',
      ));
    });
  }

  QueryBuilder<SearchedAnime, SearchedAnime, QAfterFilterCondition>
      chapterInfoIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'chapterInfo',
        value: '',
      ));
    });
  }

  QueryBuilder<SearchedAnime, SearchedAnime, QAfterFilterCondition>
      chapterUrlIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'chapterUrl',
      ));
    });
  }

  QueryBuilder<SearchedAnime, SearchedAnime, QAfterFilterCondition>
      chapterUrlIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'chapterUrl',
      ));
    });
  }

  QueryBuilder<SearchedAnime, SearchedAnime, QAfterFilterCondition>
      chapterUrlEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'chapterUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SearchedAnime, SearchedAnime, QAfterFilterCondition>
      chapterUrlGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'chapterUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SearchedAnime, SearchedAnime, QAfterFilterCondition>
      chapterUrlLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'chapterUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SearchedAnime, SearchedAnime, QAfterFilterCondition>
      chapterUrlBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'chapterUrl',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SearchedAnime, SearchedAnime, QAfterFilterCondition>
      chapterUrlStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'chapterUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SearchedAnime, SearchedAnime, QAfterFilterCondition>
      chapterUrlEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'chapterUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SearchedAnime, SearchedAnime, QAfterFilterCondition>
      chapterUrlContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'chapterUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SearchedAnime, SearchedAnime, QAfterFilterCondition>
      chapterUrlMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'chapterUrl',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SearchedAnime, SearchedAnime, QAfterFilterCondition>
      chapterUrlIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'chapterUrl',
        value: '',
      ));
    });
  }

  QueryBuilder<SearchedAnime, SearchedAnime, QAfterFilterCondition>
      chapterUrlIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'chapterUrl',
        value: '',
      ));
    });
  }

  QueryBuilder<SearchedAnime, SearchedAnime, QAfterFilterCondition>
      dateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'date',
      ));
    });
  }

  QueryBuilder<SearchedAnime, SearchedAnime, QAfterFilterCondition>
      dateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'date',
      ));
    });
  }

  QueryBuilder<SearchedAnime, SearchedAnime, QAfterFilterCondition> dateEqualTo(
      DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<SearchedAnime, SearchedAnime, QAfterFilterCondition>
      dateGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<SearchedAnime, SearchedAnime, QAfterFilterCondition>
      dateLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<SearchedAnime, SearchedAnime, QAfterFilterCondition> dateBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'date',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SearchedAnime, SearchedAnime, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<SearchedAnime, SearchedAnime, QAfterFilterCondition>
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

  QueryBuilder<SearchedAnime, SearchedAnime, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<SearchedAnime, SearchedAnime, QAfterFilterCondition> idBetween(
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

  QueryBuilder<SearchedAnime, SearchedAnime, QAfterFilterCondition>
      imageUrlEqualTo(
    String value, {
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

  QueryBuilder<SearchedAnime, SearchedAnime, QAfterFilterCondition>
      imageUrlGreaterThan(
    String value, {
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

  QueryBuilder<SearchedAnime, SearchedAnime, QAfterFilterCondition>
      imageUrlLessThan(
    String value, {
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

  QueryBuilder<SearchedAnime, SearchedAnime, QAfterFilterCondition>
      imageUrlBetween(
    String lower,
    String upper, {
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

  QueryBuilder<SearchedAnime, SearchedAnime, QAfterFilterCondition>
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

  QueryBuilder<SearchedAnime, SearchedAnime, QAfterFilterCondition>
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

  QueryBuilder<SearchedAnime, SearchedAnime, QAfterFilterCondition>
      imageUrlContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'imageUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SearchedAnime, SearchedAnime, QAfterFilterCondition>
      imageUrlMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'imageUrl',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SearchedAnime, SearchedAnime, QAfterFilterCondition>
      imageUrlIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'imageUrl',
        value: '',
      ));
    });
  }

  QueryBuilder<SearchedAnime, SearchedAnime, QAfterFilterCondition>
      imageUrlIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'imageUrl',
        value: '',
      ));
    });
  }

  QueryBuilder<SearchedAnime, SearchedAnime, QAfterFilterCondition>
      releaseIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'release',
      ));
    });
  }

  QueryBuilder<SearchedAnime, SearchedAnime, QAfterFilterCondition>
      releaseIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'release',
      ));
    });
  }

  QueryBuilder<SearchedAnime, SearchedAnime, QAfterFilterCondition>
      releaseEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'release',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SearchedAnime, SearchedAnime, QAfterFilterCondition>
      releaseGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'release',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SearchedAnime, SearchedAnime, QAfterFilterCondition>
      releaseLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'release',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SearchedAnime, SearchedAnime, QAfterFilterCondition>
      releaseBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'release',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SearchedAnime, SearchedAnime, QAfterFilterCondition>
      releaseStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'release',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SearchedAnime, SearchedAnime, QAfterFilterCondition>
      releaseEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'release',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SearchedAnime, SearchedAnime, QAfterFilterCondition>
      releaseContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'release',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SearchedAnime, SearchedAnime, QAfterFilterCondition>
      releaseMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'release',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SearchedAnime, SearchedAnime, QAfterFilterCondition>
      releaseIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'release',
        value: '',
      ));
    });
  }

  QueryBuilder<SearchedAnime, SearchedAnime, QAfterFilterCondition>
      releaseIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'release',
        value: '',
      ));
    });
  }

  QueryBuilder<SearchedAnime, SearchedAnime, QAfterFilterCondition>
      typeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'type',
      ));
    });
  }

  QueryBuilder<SearchedAnime, SearchedAnime, QAfterFilterCondition>
      typeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'type',
      ));
    });
  }

  QueryBuilder<SearchedAnime, SearchedAnime, QAfterFilterCondition> typeEqualTo(
    String? value, {
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

  QueryBuilder<SearchedAnime, SearchedAnime, QAfterFilterCondition>
      typeGreaterThan(
    String? value, {
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

  QueryBuilder<SearchedAnime, SearchedAnime, QAfterFilterCondition>
      typeLessThan(
    String? value, {
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

  QueryBuilder<SearchedAnime, SearchedAnime, QAfterFilterCondition> typeBetween(
    String? lower,
    String? upper, {
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

  QueryBuilder<SearchedAnime, SearchedAnime, QAfterFilterCondition>
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

  QueryBuilder<SearchedAnime, SearchedAnime, QAfterFilterCondition>
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

  QueryBuilder<SearchedAnime, SearchedAnime, QAfterFilterCondition>
      typeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SearchedAnime, SearchedAnime, QAfterFilterCondition> typeMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'type',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SearchedAnime, SearchedAnime, QAfterFilterCondition>
      typeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'type',
        value: '',
      ));
    });
  }

  QueryBuilder<SearchedAnime, SearchedAnime, QAfterFilterCondition>
      typeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'type',
        value: '',
      ));
    });
  }
}

extension SearchedAnimeQueryObject
    on QueryBuilder<SearchedAnime, SearchedAnime, QFilterCondition> {}

extension SearchedAnimeQueryLinks
    on QueryBuilder<SearchedAnime, SearchedAnime, QFilterCondition> {}

extension SearchedAnimeQuerySortBy
    on QueryBuilder<SearchedAnime, SearchedAnime, QSortBy> {
  QueryBuilder<SearchedAnime, SearchedAnime, QAfterSortBy> sortByAnimeTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'animeTitle', Sort.asc);
    });
  }

  QueryBuilder<SearchedAnime, SearchedAnime, QAfterSortBy>
      sortByAnimeTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'animeTitle', Sort.desc);
    });
  }

  QueryBuilder<SearchedAnime, SearchedAnime, QAfterSortBy> sortByAnimeUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'animeUrl', Sort.asc);
    });
  }

  QueryBuilder<SearchedAnime, SearchedAnime, QAfterSortBy>
      sortByAnimeUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'animeUrl', Sort.desc);
    });
  }

  QueryBuilder<SearchedAnime, SearchedAnime, QAfterSortBy> sortByChapterInfo() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chapterInfo', Sort.asc);
    });
  }

  QueryBuilder<SearchedAnime, SearchedAnime, QAfterSortBy>
      sortByChapterInfoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chapterInfo', Sort.desc);
    });
  }

  QueryBuilder<SearchedAnime, SearchedAnime, QAfterSortBy> sortByChapterUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chapterUrl', Sort.asc);
    });
  }

  QueryBuilder<SearchedAnime, SearchedAnime, QAfterSortBy>
      sortByChapterUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chapterUrl', Sort.desc);
    });
  }

  QueryBuilder<SearchedAnime, SearchedAnime, QAfterSortBy> sortByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<SearchedAnime, SearchedAnime, QAfterSortBy> sortByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<SearchedAnime, SearchedAnime, QAfterSortBy> sortByImageUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imageUrl', Sort.asc);
    });
  }

  QueryBuilder<SearchedAnime, SearchedAnime, QAfterSortBy>
      sortByImageUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imageUrl', Sort.desc);
    });
  }

  QueryBuilder<SearchedAnime, SearchedAnime, QAfterSortBy> sortByRelease() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'release', Sort.asc);
    });
  }

  QueryBuilder<SearchedAnime, SearchedAnime, QAfterSortBy> sortByReleaseDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'release', Sort.desc);
    });
  }

  QueryBuilder<SearchedAnime, SearchedAnime, QAfterSortBy> sortByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<SearchedAnime, SearchedAnime, QAfterSortBy> sortByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }
}

extension SearchedAnimeQuerySortThenBy
    on QueryBuilder<SearchedAnime, SearchedAnime, QSortThenBy> {
  QueryBuilder<SearchedAnime, SearchedAnime, QAfterSortBy> thenByAnimeTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'animeTitle', Sort.asc);
    });
  }

  QueryBuilder<SearchedAnime, SearchedAnime, QAfterSortBy>
      thenByAnimeTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'animeTitle', Sort.desc);
    });
  }

  QueryBuilder<SearchedAnime, SearchedAnime, QAfterSortBy> thenByAnimeUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'animeUrl', Sort.asc);
    });
  }

  QueryBuilder<SearchedAnime, SearchedAnime, QAfterSortBy>
      thenByAnimeUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'animeUrl', Sort.desc);
    });
  }

  QueryBuilder<SearchedAnime, SearchedAnime, QAfterSortBy> thenByChapterInfo() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chapterInfo', Sort.asc);
    });
  }

  QueryBuilder<SearchedAnime, SearchedAnime, QAfterSortBy>
      thenByChapterInfoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chapterInfo', Sort.desc);
    });
  }

  QueryBuilder<SearchedAnime, SearchedAnime, QAfterSortBy> thenByChapterUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chapterUrl', Sort.asc);
    });
  }

  QueryBuilder<SearchedAnime, SearchedAnime, QAfterSortBy>
      thenByChapterUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chapterUrl', Sort.desc);
    });
  }

  QueryBuilder<SearchedAnime, SearchedAnime, QAfterSortBy> thenByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<SearchedAnime, SearchedAnime, QAfterSortBy> thenByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<SearchedAnime, SearchedAnime, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<SearchedAnime, SearchedAnime, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<SearchedAnime, SearchedAnime, QAfterSortBy> thenByImageUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imageUrl', Sort.asc);
    });
  }

  QueryBuilder<SearchedAnime, SearchedAnime, QAfterSortBy>
      thenByImageUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imageUrl', Sort.desc);
    });
  }

  QueryBuilder<SearchedAnime, SearchedAnime, QAfterSortBy> thenByRelease() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'release', Sort.asc);
    });
  }

  QueryBuilder<SearchedAnime, SearchedAnime, QAfterSortBy> thenByReleaseDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'release', Sort.desc);
    });
  }

  QueryBuilder<SearchedAnime, SearchedAnime, QAfterSortBy> thenByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<SearchedAnime, SearchedAnime, QAfterSortBy> thenByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }
}

extension SearchedAnimeQueryWhereDistinct
    on QueryBuilder<SearchedAnime, SearchedAnime, QDistinct> {
  QueryBuilder<SearchedAnime, SearchedAnime, QDistinct> distinctByAnimeTitle(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'animeTitle', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SearchedAnime, SearchedAnime, QDistinct> distinctByAnimeUrl(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'animeUrl', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SearchedAnime, SearchedAnime, QDistinct> distinctByChapterInfo(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'chapterInfo', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SearchedAnime, SearchedAnime, QDistinct> distinctByChapterUrl(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'chapterUrl', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SearchedAnime, SearchedAnime, QDistinct> distinctByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'date');
    });
  }

  QueryBuilder<SearchedAnime, SearchedAnime, QDistinct> distinctByImageUrl(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'imageUrl', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SearchedAnime, SearchedAnime, QDistinct> distinctByRelease(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'release', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SearchedAnime, SearchedAnime, QDistinct> distinctByType(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'type', caseSensitive: caseSensitive);
    });
  }
}

extension SearchedAnimeQueryProperty
    on QueryBuilder<SearchedAnime, SearchedAnime, QQueryProperty> {
  QueryBuilder<SearchedAnime, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<SearchedAnime, String, QQueryOperations> animeTitleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'animeTitle');
    });
  }

  QueryBuilder<SearchedAnime, String, QQueryOperations> animeUrlProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'animeUrl');
    });
  }

  QueryBuilder<SearchedAnime, String?, QQueryOperations> chapterInfoProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'chapterInfo');
    });
  }

  QueryBuilder<SearchedAnime, String?, QQueryOperations> chapterUrlProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'chapterUrl');
    });
  }

  QueryBuilder<SearchedAnime, DateTime?, QQueryOperations> dateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'date');
    });
  }

  QueryBuilder<SearchedAnime, String, QQueryOperations> imageUrlProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'imageUrl');
    });
  }

  QueryBuilder<SearchedAnime, String?, QQueryOperations> releaseProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'release');
    });
  }

  QueryBuilder<SearchedAnime, String?, QQueryOperations> typeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'type');
    });
  }
}
