// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'decks.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Decks _$DecksFromJson(Map<String, dynamic> json) => Decks(
      stats: json['stats'] == null
          ? null
          : DeckStats.fromJson(json['stats'] as Map<String, dynamic>),
      info: json['info'] == null
          ? null
          : DecksInfo.fromJson(json['info'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DecksToJson(Decks instance) => <String, dynamic>{
      'stats': instance.stats,
      'info': instance.info,
    };

DecksInfo _$DecksInfoFromJson(Map<String, dynamic> json) => DecksInfo(
      three: json['three'] == null
          ? null
          : DecksInfoServers.fromJson(json['three'] as Map<String, dynamic>),
      seven: json['seven'] == null
          ? null
          : DecksInfoServers.fromJson(json['seven'] as Map<String, dynamic>),
      patch: json['patch'] == null
          ? null
          : DecksInfoServers.fromJson(json['patch'] as Map<String, dynamic>),
      lastUpdate: json['lastUpdate'] as int?,
    );

Map<String, dynamic> _$DecksInfoToJson(DecksInfo instance) => <String, dynamic>{
      'three': instance.three,
      'seven': instance.seven,
      'patch': instance.patch,
      'lastUpdate': instance.lastUpdate,
    };

DecksInfoServers _$DecksInfoServersFromJson(Map<String, dynamic> json) =>
    DecksInfoServers(
      americas: json['americas'] == null
          ? null
          : DecksInfoServer.fromJson(json['americas'] as Map<String, dynamic>),
      europe: json['europe'] == null
          ? null
          : DecksInfoServer.fromJson(json['europe'] as Map<String, dynamic>),
      sea: json['sea'] == null
          ? null
          : DecksInfoServer.fromJson(json['sea'] as Map<String, dynamic>),
      everyone: json['everyone'] == null
          ? null
          : DecksInfoServer.fromJson(json['everyone'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DecksInfoServersToJson(DecksInfoServers instance) =>
    <String, dynamic>{
      'americas': instance.americas,
      'europe': instance.europe,
      'sea': instance.sea,
      'everyone': instance.everyone,
    };

DecksInfoServer _$DecksInfoServerFromJson(Map<String, dynamic> json) =>
    DecksInfoServer(
      info: json['info'] == null
          ? null
          : DecksInfoServerInfo.fromJson(json['info'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DecksInfoServerToJson(DecksInfoServer instance) =>
    <String, dynamic>{
      'info': instance.info,
    };

DecksInfoServerInfo _$DecksInfoServerInfoFromJson(Map<String, dynamic> json) =>
    DecksInfoServerInfo(
      totalMatches: (json['totalMatches'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$DecksInfoServerInfoToJson(
        DecksInfoServerInfo instance) =>
    <String, dynamic>{
      'totalMatches': instance.totalMatches,
    };

DeckStats _$DeckStatsFromJson(Map<String, dynamic> json) => DeckStats(
      patch: json['patch'] == null
          ? null
          : DeckStatsServers.fromJson(json['patch'] as Map<String, dynamic>),
      seven: json['seven'] == null
          ? null
          : DeckStatsServers.fromJson(json['seven'] as Map<String, dynamic>),
      three: json['three'] == null
          ? null
          : DeckStatsServers.fromJson(json['three'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DeckStatsToJson(DeckStats instance) => <String, dynamic>{
      'patch': instance.patch,
      'seven': instance.seven,
      'three': instance.three,
    };

DeckStatsServers _$DeckStatsServersFromJson(Map<String, dynamic> json) =>
    DeckStatsServers(
      americas: (json['americas'] as List<dynamic>?)
          ?.map((e) => DeckStatsServer.fromJson(e as Map<String, dynamic>))
          .toList(),
      europe: (json['europe'] as List<dynamic>?)
          ?.map((e) => DeckStatsServer.fromJson(e as Map<String, dynamic>))
          .toList(),
      sea: (json['sea'] as List<dynamic>?)
          ?.map((e) => DeckStatsServer.fromJson(e as Map<String, dynamic>))
          .toList(),
      everyone: (json['everyone'] as List<dynamic>?)
          ?.map((e) => DeckStatsServer.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DeckStatsServersToJson(DeckStatsServers instance) =>
    <String, dynamic>{
      'americas': instance.americas,
      'europe': instance.europe,
      'sea': instance.sea,
      'everyone': instance.everyone,
    };

DeckStatsServer _$DeckStatsServerFromJson(Map<String, dynamic> json) =>
    DeckStatsServer(
      archetype: json['archetype'] as String?,
      assets: json['assets'] == null
          ? null
          : DeckStatsServerAssets.fromJson(
              json['assets'] as Map<String, dynamic>),
      totalMatches: json['total_matches'] as int?,
      playrate: (json['playrate'] as num?)?.toDouble(),
      winrate: (json['winrate'] as num?)?.toDouble(),
      bestDecks: json['best_decks'] as String?,
      slug: json['slug'] as String?,
      guide: json['guide'] as String?,
    );

Map<String, dynamic> _$DeckStatsServerToJson(DeckStatsServer instance) =>
    <String, dynamic>{
      'archetype': instance.archetype,
      'assets': instance.assets,
      'total_matches': instance.totalMatches,
      'playrate': instance.playrate,
      'winrate': instance.winrate,
      'best_decks': instance.bestDecks,
      'slug': instance.slug,
      'guide': instance.guide,
    };

DeckStatsServerAssets _$DeckStatsServerAssetsFromJson(
        Map<String, dynamic> json) =>
    DeckStatsServerAssets(
      regions:
          (json['regions'] as List<dynamic>?)?.map((e) => e as String).toList(),
      champions: (json['champions'] as List<dynamic>?)
          ?.map((e) => (e as List<dynamic>).map((e) => e as String).toList())
          .toList(),
    );

Map<String, dynamic> _$DeckStatsServerAssetsToJson(
        DeckStatsServerAssets instance) =>
    <String, dynamic>{
      'regions': instance.regions,
      'champions': instance.champions,
    };
