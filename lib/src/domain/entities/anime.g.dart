// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'anime.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetAnimeCollection on Isar {
  IsarCollection<Anime> get animes => this.collection();
}

const AnimeSchema = CollectionSchema(
  name: r'Anime',
  id: -2255851914829551581,
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
    r'imageUrl': PropertySchema(
      id: 4,
      name: r'imageUrl',
      type: IsarType.string,
    ),
    r'release': PropertySchema(
      id: 5,
      name: r'release',
      type: IsarType.string,
    ),
    r'type': PropertySchema(
      id: 6,
      name: r'type',
      type: IsarType.string,
    )
  },
  estimateSize: _animeEstimateSize,
  serialize: _animeSerialize,
  deserialize: _animeDeserialize,
  deserializeProp: _animeDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _animeGetId,
  getLinks: _animeGetLinks,
  attach: _animeAttach,
  version: '3.1.0+1',
);

int _animeEstimateSize(
  Anime object,
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

void _animeSerialize(
  Anime object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.animeTitle);
  writer.writeString(offsets[1], object.animeUrl);
  writer.writeString(offsets[2], object.chapterInfo);
  writer.writeString(offsets[3], object.chapterUrl);
  writer.writeString(offsets[4], object.imageUrl);
  writer.writeString(offsets[5], object.release);
  writer.writeString(offsets[6], object.type);
}

Anime _animeDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Anime(
    animeTitle: reader.readString(offsets[0]),
    animeUrl: reader.readString(offsets[1]),
    chapterInfo: reader.readStringOrNull(offsets[2]),
    chapterUrl: reader.readStringOrNull(offsets[3]),
    imageUrl: reader.readString(offsets[4]),
    release: reader.readStringOrNull(offsets[5]),
    type: reader.readStringOrNull(offsets[6]),
  );
  object.id = id;
  return object;
}

P _animeDeserializeProp<P>(
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
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _animeGetId(Anime object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _animeGetLinks(Anime object) {
  return [];
}

void _animeAttach(IsarCollection<dynamic> col, Id id, Anime object) {
  object.id = id;
}

extension AnimeQueryWhereSort on QueryBuilder<Anime, Anime, QWhere> {
  QueryBuilder<Anime, Anime, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension AnimeQueryWhere on QueryBuilder<Anime, Anime, QWhereClause> {
  QueryBuilder<Anime, Anime, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Anime, Anime, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<Anime, Anime, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Anime, Anime, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Anime, Anime, QAfterWhereClause> idBetween(
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

extension AnimeQueryFilter on QueryBuilder<Anime, Anime, QFilterCondition> {
  QueryBuilder<Anime, Anime, QAfterFilterCondition> animeTitleEqualTo(
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

  QueryBuilder<Anime, Anime, QAfterFilterCondition> animeTitleGreaterThan(
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

  QueryBuilder<Anime, Anime, QAfterFilterCondition> animeTitleLessThan(
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

  QueryBuilder<Anime, Anime, QAfterFilterCondition> animeTitleBetween(
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

  QueryBuilder<Anime, Anime, QAfterFilterCondition> animeTitleStartsWith(
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

  QueryBuilder<Anime, Anime, QAfterFilterCondition> animeTitleEndsWith(
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

  QueryBuilder<Anime, Anime, QAfterFilterCondition> animeTitleContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'animeTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Anime, Anime, QAfterFilterCondition> animeTitleMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'animeTitle',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Anime, Anime, QAfterFilterCondition> animeTitleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'animeTitle',
        value: '',
      ));
    });
  }

  QueryBuilder<Anime, Anime, QAfterFilterCondition> animeTitleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'animeTitle',
        value: '',
      ));
    });
  }

  QueryBuilder<Anime, Anime, QAfterFilterCondition> animeUrlEqualTo(
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

  QueryBuilder<Anime, Anime, QAfterFilterCondition> animeUrlGreaterThan(
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

  QueryBuilder<Anime, Anime, QAfterFilterCondition> animeUrlLessThan(
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

  QueryBuilder<Anime, Anime, QAfterFilterCondition> animeUrlBetween(
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

  QueryBuilder<Anime, Anime, QAfterFilterCondition> animeUrlStartsWith(
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

  QueryBuilder<Anime, Anime, QAfterFilterCondition> animeUrlEndsWith(
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

  QueryBuilder<Anime, Anime, QAfterFilterCondition> animeUrlContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'animeUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Anime, Anime, QAfterFilterCondition> animeUrlMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'animeUrl',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Anime, Anime, QAfterFilterCondition> animeUrlIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'animeUrl',
        value: '',
      ));
    });
  }

  QueryBuilder<Anime, Anime, QAfterFilterCondition> animeUrlIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'animeUrl',
        value: '',
      ));
    });
  }

  QueryBuilder<Anime, Anime, QAfterFilterCondition> chapterInfoIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'chapterInfo',
      ));
    });
  }

  QueryBuilder<Anime, Anime, QAfterFilterCondition> chapterInfoIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'chapterInfo',
      ));
    });
  }

  QueryBuilder<Anime, Anime, QAfterFilterCondition> chapterInfoEqualTo(
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

  QueryBuilder<Anime, Anime, QAfterFilterCondition> chapterInfoGreaterThan(
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

  QueryBuilder<Anime, Anime, QAfterFilterCondition> chapterInfoLessThan(
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

  QueryBuilder<Anime, Anime, QAfterFilterCondition> chapterInfoBetween(
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

  QueryBuilder<Anime, Anime, QAfterFilterCondition> chapterInfoStartsWith(
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

  QueryBuilder<Anime, Anime, QAfterFilterCondition> chapterInfoEndsWith(
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

  QueryBuilder<Anime, Anime, QAfterFilterCondition> chapterInfoContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'chapterInfo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Anime, Anime, QAfterFilterCondition> chapterInfoMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'chapterInfo',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Anime, Anime, QAfterFilterCondition> chapterInfoIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'chapterInfo',
        value: '',
      ));
    });
  }

  QueryBuilder<Anime, Anime, QAfterFilterCondition> chapterInfoIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'chapterInfo',
        value: '',
      ));
    });
  }

  QueryBuilder<Anime, Anime, QAfterFilterCondition> chapterUrlIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'chapterUrl',
      ));
    });
  }

  QueryBuilder<Anime, Anime, QAfterFilterCondition> chapterUrlIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'chapterUrl',
      ));
    });
  }

  QueryBuilder<Anime, Anime, QAfterFilterCondition> chapterUrlEqualTo(
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

  QueryBuilder<Anime, Anime, QAfterFilterCondition> chapterUrlGreaterThan(
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

  QueryBuilder<Anime, Anime, QAfterFilterCondition> chapterUrlLessThan(
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

  QueryBuilder<Anime, Anime, QAfterFilterCondition> chapterUrlBetween(
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

  QueryBuilder<Anime, Anime, QAfterFilterCondition> chapterUrlStartsWith(
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

  QueryBuilder<Anime, Anime, QAfterFilterCondition> chapterUrlEndsWith(
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

  QueryBuilder<Anime, Anime, QAfterFilterCondition> chapterUrlContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'chapterUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Anime, Anime, QAfterFilterCondition> chapterUrlMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'chapterUrl',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Anime, Anime, QAfterFilterCondition> chapterUrlIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'chapterUrl',
        value: '',
      ));
    });
  }

  QueryBuilder<Anime, Anime, QAfterFilterCondition> chapterUrlIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'chapterUrl',
        value: '',
      ));
    });
  }

  QueryBuilder<Anime, Anime, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Anime, Anime, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Anime, Anime, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Anime, Anime, QAfterFilterCondition> idBetween(
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

  QueryBuilder<Anime, Anime, QAfterFilterCondition> imageUrlEqualTo(
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

  QueryBuilder<Anime, Anime, QAfterFilterCondition> imageUrlGreaterThan(
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

  QueryBuilder<Anime, Anime, QAfterFilterCondition> imageUrlLessThan(
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

  QueryBuilder<Anime, Anime, QAfterFilterCondition> imageUrlBetween(
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

  QueryBuilder<Anime, Anime, QAfterFilterCondition> imageUrlStartsWith(
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

  QueryBuilder<Anime, Anime, QAfterFilterCondition> imageUrlEndsWith(
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

  QueryBuilder<Anime, Anime, QAfterFilterCondition> imageUrlContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'imageUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Anime, Anime, QAfterFilterCondition> imageUrlMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'imageUrl',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Anime, Anime, QAfterFilterCondition> imageUrlIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'imageUrl',
        value: '',
      ));
    });
  }

  QueryBuilder<Anime, Anime, QAfterFilterCondition> imageUrlIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'imageUrl',
        value: '',
      ));
    });
  }

  QueryBuilder<Anime, Anime, QAfterFilterCondition> releaseIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'release',
      ));
    });
  }

  QueryBuilder<Anime, Anime, QAfterFilterCondition> releaseIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'release',
      ));
    });
  }

  QueryBuilder<Anime, Anime, QAfterFilterCondition> releaseEqualTo(
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

  QueryBuilder<Anime, Anime, QAfterFilterCondition> releaseGreaterThan(
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

  QueryBuilder<Anime, Anime, QAfterFilterCondition> releaseLessThan(
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

  QueryBuilder<Anime, Anime, QAfterFilterCondition> releaseBetween(
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

  QueryBuilder<Anime, Anime, QAfterFilterCondition> releaseStartsWith(
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

  QueryBuilder<Anime, Anime, QAfterFilterCondition> releaseEndsWith(
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

  QueryBuilder<Anime, Anime, QAfterFilterCondition> releaseContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'release',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Anime, Anime, QAfterFilterCondition> releaseMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'release',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Anime, Anime, QAfterFilterCondition> releaseIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'release',
        value: '',
      ));
    });
  }

  QueryBuilder<Anime, Anime, QAfterFilterCondition> releaseIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'release',
        value: '',
      ));
    });
  }

  QueryBuilder<Anime, Anime, QAfterFilterCondition> typeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'type',
      ));
    });
  }

  QueryBuilder<Anime, Anime, QAfterFilterCondition> typeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'type',
      ));
    });
  }

  QueryBuilder<Anime, Anime, QAfterFilterCondition> typeEqualTo(
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

  QueryBuilder<Anime, Anime, QAfterFilterCondition> typeGreaterThan(
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

  QueryBuilder<Anime, Anime, QAfterFilterCondition> typeLessThan(
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

  QueryBuilder<Anime, Anime, QAfterFilterCondition> typeBetween(
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

  QueryBuilder<Anime, Anime, QAfterFilterCondition> typeStartsWith(
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

  QueryBuilder<Anime, Anime, QAfterFilterCondition> typeEndsWith(
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

  QueryBuilder<Anime, Anime, QAfterFilterCondition> typeContains(String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Anime, Anime, QAfterFilterCondition> typeMatches(String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'type',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Anime, Anime, QAfterFilterCondition> typeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'type',
        value: '',
      ));
    });
  }

  QueryBuilder<Anime, Anime, QAfterFilterCondition> typeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'type',
        value: '',
      ));
    });
  }
}

extension AnimeQueryObject on QueryBuilder<Anime, Anime, QFilterCondition> {}

extension AnimeQueryLinks on QueryBuilder<Anime, Anime, QFilterCondition> {}

extension AnimeQuerySortBy on QueryBuilder<Anime, Anime, QSortBy> {
  QueryBuilder<Anime, Anime, QAfterSortBy> sortByAnimeTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'animeTitle', Sort.asc);
    });
  }

  QueryBuilder<Anime, Anime, QAfterSortBy> sortByAnimeTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'animeTitle', Sort.desc);
    });
  }

  QueryBuilder<Anime, Anime, QAfterSortBy> sortByAnimeUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'animeUrl', Sort.asc);
    });
  }

  QueryBuilder<Anime, Anime, QAfterSortBy> sortByAnimeUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'animeUrl', Sort.desc);
    });
  }

  QueryBuilder<Anime, Anime, QAfterSortBy> sortByChapterInfo() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chapterInfo', Sort.asc);
    });
  }

  QueryBuilder<Anime, Anime, QAfterSortBy> sortByChapterInfoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chapterInfo', Sort.desc);
    });
  }

  QueryBuilder<Anime, Anime, QAfterSortBy> sortByChapterUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chapterUrl', Sort.asc);
    });
  }

  QueryBuilder<Anime, Anime, QAfterSortBy> sortByChapterUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chapterUrl', Sort.desc);
    });
  }

  QueryBuilder<Anime, Anime, QAfterSortBy> sortByImageUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imageUrl', Sort.asc);
    });
  }

  QueryBuilder<Anime, Anime, QAfterSortBy> sortByImageUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imageUrl', Sort.desc);
    });
  }

  QueryBuilder<Anime, Anime, QAfterSortBy> sortByRelease() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'release', Sort.asc);
    });
  }

  QueryBuilder<Anime, Anime, QAfterSortBy> sortByReleaseDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'release', Sort.desc);
    });
  }

  QueryBuilder<Anime, Anime, QAfterSortBy> sortByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<Anime, Anime, QAfterSortBy> sortByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }
}

extension AnimeQuerySortThenBy on QueryBuilder<Anime, Anime, QSortThenBy> {
  QueryBuilder<Anime, Anime, QAfterSortBy> thenByAnimeTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'animeTitle', Sort.asc);
    });
  }

  QueryBuilder<Anime, Anime, QAfterSortBy> thenByAnimeTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'animeTitle', Sort.desc);
    });
  }

  QueryBuilder<Anime, Anime, QAfterSortBy> thenByAnimeUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'animeUrl', Sort.asc);
    });
  }

  QueryBuilder<Anime, Anime, QAfterSortBy> thenByAnimeUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'animeUrl', Sort.desc);
    });
  }

  QueryBuilder<Anime, Anime, QAfterSortBy> thenByChapterInfo() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chapterInfo', Sort.asc);
    });
  }

  QueryBuilder<Anime, Anime, QAfterSortBy> thenByChapterInfoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chapterInfo', Sort.desc);
    });
  }

  QueryBuilder<Anime, Anime, QAfterSortBy> thenByChapterUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chapterUrl', Sort.asc);
    });
  }

  QueryBuilder<Anime, Anime, QAfterSortBy> thenByChapterUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chapterUrl', Sort.desc);
    });
  }

  QueryBuilder<Anime, Anime, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Anime, Anime, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Anime, Anime, QAfterSortBy> thenByImageUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imageUrl', Sort.asc);
    });
  }

  QueryBuilder<Anime, Anime, QAfterSortBy> thenByImageUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imageUrl', Sort.desc);
    });
  }

  QueryBuilder<Anime, Anime, QAfterSortBy> thenByRelease() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'release', Sort.asc);
    });
  }

  QueryBuilder<Anime, Anime, QAfterSortBy> thenByReleaseDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'release', Sort.desc);
    });
  }

  QueryBuilder<Anime, Anime, QAfterSortBy> thenByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<Anime, Anime, QAfterSortBy> thenByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }
}

extension AnimeQueryWhereDistinct on QueryBuilder<Anime, Anime, QDistinct> {
  QueryBuilder<Anime, Anime, QDistinct> distinctByAnimeTitle(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'animeTitle', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Anime, Anime, QDistinct> distinctByAnimeUrl(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'animeUrl', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Anime, Anime, QDistinct> distinctByChapterInfo(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'chapterInfo', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Anime, Anime, QDistinct> distinctByChapterUrl(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'chapterUrl', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Anime, Anime, QDistinct> distinctByImageUrl(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'imageUrl', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Anime, Anime, QDistinct> distinctByRelease(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'release', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Anime, Anime, QDistinct> distinctByType(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'type', caseSensitive: caseSensitive);
    });
  }
}

extension AnimeQueryProperty on QueryBuilder<Anime, Anime, QQueryProperty> {
  QueryBuilder<Anime, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Anime, String, QQueryOperations> animeTitleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'animeTitle');
    });
  }

  QueryBuilder<Anime, String, QQueryOperations> animeUrlProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'animeUrl');
    });
  }

  QueryBuilder<Anime, String?, QQueryOperations> chapterInfoProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'chapterInfo');
    });
  }

  QueryBuilder<Anime, String?, QQueryOperations> chapterUrlProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'chapterUrl');
    });
  }

  QueryBuilder<Anime, String, QQueryOperations> imageUrlProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'imageUrl');
    });
  }

  QueryBuilder<Anime, String?, QQueryOperations> releaseProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'release');
    });
  }

  QueryBuilder<Anime, String?, QQueryOperations> typeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'type');
    });
  }
}
