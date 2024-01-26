import 'package:json_annotation/json_annotation.dart';

part 'decks.g.dart';

@JsonSerializable()
class Decks {
  final DeckStats? stats;
  final DecksInfo? info;

  Decks({this.stats, this.info});

  factory Decks.fromJson(Map<String, dynamic> json) => _$DecksFromJson(json);
  Map<String, dynamic> toJson() => _$DecksToJson(this);

  Decks copyWith({DeckStats? stats, DecksInfo? info}) {
    return Decks(stats: stats ?? this.stats, info: info ?? this.info);
  }

  Decks clone() {
    return Decks(
      stats: stats?.clone(),
      info: info?.clone(),
    );
  }
}

@JsonSerializable()
class DecksInfo {
  final DecksInfoServers? three;
  final DecksInfoServers? seven;
  final DecksInfoServers? patch;
  final int? lastUpdate;

  DecksInfo({this.three, this.seven, this.patch, this.lastUpdate});

  factory DecksInfo.fromJson(Map<String, dynamic> json) =>
      _$DecksInfoFromJson(json);
  Map<String, dynamic> toJson() => _$DecksInfoToJson(this);

  DecksInfo copyWith(
      {DecksInfoServers? three,
      DecksInfoServers? seven,
      DecksInfoServers? patch,
      int? lastUpdate}) {
    return DecksInfo(
        three: three ?? this.three,
        seven: seven ?? this.seven,
        patch: patch ?? this.patch,
        lastUpdate: lastUpdate ?? this.lastUpdate);
  }

  DecksInfo clone() {
    return DecksInfo(
      three: three?.clone(),
      seven: seven?.clone(),
      patch: patch?.clone(),
      lastUpdate: lastUpdate,
    );
  }
}

@JsonSerializable()
class DecksInfoServers {
  final DecksInfoServer? americas;
  final DecksInfoServer? europe;
  final DecksInfoServer? sea;
  final DecksInfoServer? everyone;

  DecksInfoServers({this.americas, this.europe, this.sea, this.everyone});

  factory DecksInfoServers.fromJson(Map<String, dynamic> json) =>
      _$DecksInfoServersFromJson(json);
  Map<String, dynamic> toJson() => _$DecksInfoServersToJson(this);

  DecksInfoServers copyWith(
      {DecksInfoServer? americas,
      DecksInfoServer? europe,
      DecksInfoServer? sea,
      DecksInfoServer? everyone}) {
    return DecksInfoServers(
        americas: americas ?? this.americas,
        europe: europe ?? this.europe,
        sea: sea ?? this.sea,
        everyone: everyone ?? this.everyone);
  }

  DecksInfoServers clone() {
    return DecksInfoServers(
      americas: americas?.clone(),
      europe: europe?.clone(),
      sea: sea?.clone(),
      everyone: everyone?.clone(),
    );
  }
}

@JsonSerializable()
class DecksInfoServer {
  final DecksInfoServerInfo? info;

  DecksInfoServer({this.info});

  factory DecksInfoServer.fromJson(Map<String, dynamic> json) =>
      _$DecksInfoServerFromJson(json);
  Map<String, dynamic> toJson() => _$DecksInfoServerToJson(this);

  DecksInfoServer copyWith({DecksInfoServerInfo? info}) {
    return DecksInfoServer(info: info ?? this.info);
  }

  DecksInfoServer clone() {
    return DecksInfoServer(
      info: info?.clone(),
    );
  }
}

@JsonSerializable()
class DecksInfoServerInfo {
  final double? totalMatches;

  DecksInfoServerInfo({this.totalMatches});

  factory DecksInfoServerInfo.fromJson(Map<String, dynamic> json) =>
      _$DecksInfoServerInfoFromJson(json);
  Map<String, dynamic> toJson() => _$DecksInfoServerInfoToJson(this);

  DecksInfoServerInfo copyWith({double? totalMatches}) {
    return DecksInfoServerInfo(totalMatches: totalMatches ?? this.totalMatches);
  }

  DecksInfoServerInfo clone() {
    return DecksInfoServerInfo(
      totalMatches: totalMatches,
    );
  }
}

@JsonSerializable()
class DeckStats {
  final DeckStatsServers? patch;
  final DeckStatsServers? seven;
  final DeckStatsServers? three;

  DeckStats({this.patch, this.seven, this.three});

  factory DeckStats.fromJson(Map<String, dynamic> json) =>
      _$DeckStatsFromJson(json);
  Map<String, dynamic> toJson() => _$DeckStatsToJson(this);

  DeckStats copyWith(
      {DeckStatsServers? patch,
      DeckStatsServers? seven,
      DeckStatsServers? three}) {
    return DeckStats(
        patch: patch ?? this.patch,
        seven: seven ?? this.seven,
        three: three ?? this.three);
  }

  DeckStats clone() {
    return DeckStats(
      patch: patch?.clone(),
      seven: seven?.clone(),
      three: three?.clone(),
    );
  }
}

@JsonSerializable()
class DeckStatsServers {
  final List<DeckStatsServer>? americas;
  final List<DeckStatsServer>? europe;
  final List<DeckStatsServer>? sea;
  final List<DeckStatsServer>? everyone;

  DeckStatsServers({this.americas, this.europe, this.sea, this.everyone});

  factory DeckStatsServers.fromJson(Map<String, dynamic> json) =>
      _$DeckStatsServersFromJson(json);
  Map<String, dynamic> toJson() => _$DeckStatsServersToJson(this);

  DeckStatsServers copyWith(
      {List<DeckStatsServer>? americas,
      List<DeckStatsServer>? europe,
      List<DeckStatsServer>? sea,
      List<DeckStatsServer>? everyone}) {
    return DeckStatsServers(
        americas: americas ?? this.americas,
        europe: europe ?? this.europe,
        sea: sea ?? this.sea,
        everyone: everyone ?? this.everyone);
  }

  DeckStatsServers clone() {
    return DeckStatsServers(
      americas: americas?.map((x) => x.clone()).toList(),
      europe: europe?.map((x) => x.clone()).toList(),
      sea: sea?.map((x) => x.clone()).toList(),
      everyone: everyone?.map((x) => x.clone()).toList(),
    );
  }
}

@JsonSerializable()
class DeckStatsServer {
  final String? archetype;
  final DeckStatsServerAssets? assets;
  @JsonKey(name: 'total_matches')
  final int? totalMatches;
  final double? playrate;
  final double? winrate;
  @JsonKey(name: 'best_decks')
  final String? bestDecks;
  final String? slug;
  final String? guide;

  DeckStatsServer(
      {this.archetype,
      this.assets,
      this.totalMatches,
      this.playrate,
      this.winrate,
      this.bestDecks,
      this.slug,
      this.guide});

  factory DeckStatsServer.fromJson(Map<String, dynamic> json) =>
      _$DeckStatsServerFromJson(json);
  Map<String, dynamic> toJson() => _$DeckStatsServerToJson(this);

  DeckStatsServer copyWith(
      {String? archetype,
      DeckStatsServerAssets? assets,
      int? totalMatches,
      double? playrate,
      double? winrate,
      String? bestDecks,
      String? slug,
      String? guide}) {
    return DeckStatsServer(
        archetype: archetype ?? this.archetype,
        assets: assets ?? this.assets,
        totalMatches: totalMatches ?? this.totalMatches,
        playrate: playrate ?? this.playrate,
        winrate: winrate ?? this.winrate,
        bestDecks: bestDecks ?? this.bestDecks,
        slug: slug ?? this.slug,
        guide: guide ?? this.guide);
  }

  DeckStatsServer clone() {
    return DeckStatsServer(
      archetype: archetype,
      assets: assets?.clone(),
      totalMatches: totalMatches,
      playrate: playrate,
      winrate: winrate,
      bestDecks: bestDecks,
      slug: slug,
      guide: guide,
    );
  }
}

@JsonSerializable()
class DeckStatsServerAssets {
  final List<String>? regions;
  final List<List<String>>? champions;

  DeckStatsServerAssets({this.regions, this.champions});

  factory DeckStatsServerAssets.fromJson(Map<String, dynamic> json) =>
      _$DeckStatsServerAssetsFromJson(json);
  Map<String, dynamic> toJson() => _$DeckStatsServerAssetsToJson(this);

  DeckStatsServerAssets copyWith(
      {List<String>? regions, List<List<String>>? champions}) {
    return DeckStatsServerAssets(
        regions: regions ?? this.regions,
        champions: champions ?? this.champions);
  }

  DeckStatsServerAssets clone() {
    return DeckStatsServerAssets(
      regions: regions != null ? List<String>.from(regions!) : null,
      champions: champions != null
          ? List<List<String>>.from(champions!.map((x) => List<String>.from(x)))
          : null,
    );
  }
}
