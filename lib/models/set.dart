import 'package:json_annotation/json_annotation.dart';

part 'set.g.dart';

@JsonSerializable()
class SetCard {
  @JsonKey(name: "associatedCards")
  final List<dynamic>? associatedCards;
  @JsonKey(name: "associatedCardRefs")
  final List<String>? associatedCardRefs;
  @JsonKey(name: "assets")
  final List<Asset>? assets;
  @JsonKey(name: "regions")
  final List<String>? regions;
  @JsonKey(name: "regionRefs")
  final List<String>? regionRefs;
  @JsonKey(name: "attack")
  final int? attack;
  @JsonKey(name: "cost")
  final int? cost;
  @JsonKey(name: "health")
  final int? health;
  @JsonKey(name: "description")
  final String? description;
  @JsonKey(name: "descriptionRaw")
  final String? descriptionRaw;
  @JsonKey(name: "levelupDescription")
  final String? levelupDescription;
  @JsonKey(name: "levelupDescriptionRaw")
  final String? levelupDescriptionRaw;
  @JsonKey(name: "flavorText")
  final String? flavorText;
  @JsonKey(name: "artistName")
  final String? artistName;
  @JsonKey(name: "name")
  final String? name;
  @JsonKey(name: "cardCode")
  final String? cardCode;
  @JsonKey(name: "keywords")
  final List<String>? keywords;
  @JsonKey(name: "keywordRefs")
  final List<String>? keywordRefs;
  @JsonKey(name: "spellSpeed")
  final String? spellSpeed;
  @JsonKey(name: "spellSpeedRef")
  final String? spellSpeedRef;
  @JsonKey(name: "rarity")
  final String? rarity;
  @JsonKey(name: "rarityRef")
  final String? rarityRef;
  @JsonKey(name: "subtypes")
  final List<String>? subtypes;
  @JsonKey(name: "supertype")
  final String? supertype;
  @JsonKey(name: "type")
  final String? type;
  @JsonKey(name: "collectible")
  final bool? collectible;
  @JsonKey(name: "set")
  final String? deckSet;
  @JsonKey(name: "formats")
  final List<String>? formats;
  @JsonKey(name: "formatRefs")
  final List<String>? formatRefs;

  SetCard({
    this.associatedCards,
    this.associatedCardRefs,
    this.assets,
    this.regions,
    this.regionRefs,
    this.attack,
    this.cost,
    this.health,
    this.description,
    this.descriptionRaw,
    this.levelupDescription,
    this.levelupDescriptionRaw,
    this.flavorText,
    this.artistName,
    this.name,
    this.cardCode,
    this.keywords,
    this.keywordRefs,
    this.spellSpeed,
    this.spellSpeedRef,
    this.rarity,
    this.rarityRef,
    this.subtypes,
    this.supertype,
    this.type,
    this.collectible,
    this.deckSet,
    this.formats,
    this.formatRefs,
  });

  factory SetCard.fromJson(Map<String, dynamic> json) =>
      _$LorCardFromJson(json);

  Map<String, dynamic> toJson() => _$LorCardToJson(this);
}

@JsonSerializable()
class Asset {
  @JsonKey(name: "gameAbsolutePath")
  final String? gameAbsolutePath;
  @JsonKey(name: "fullAbsolutePath")
  final String? fullAbsolutePath;

  Asset({
    this.gameAbsolutePath,
    this.fullAbsolutePath,
  });

  factory Asset.fromJson(Map<String, dynamic> json) => _$AssetFromJson(json);

  Map<String, dynamic> toJson() => _$AssetToJson(this);
}
