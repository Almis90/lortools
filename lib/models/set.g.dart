// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'set.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SetCard _$SetCardFromJson(Map<String, dynamic> json) => SetCard(
      associatedCards: json['associatedCards'] as List<dynamic>?,
      associatedCardRefs: (json['associatedCardRefs'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      assets: (json['assets'] as List<dynamic>?)
          ?.map((e) => Asset.fromJson(e as Map<String, dynamic>))
          .toList(),
      regions:
          (json['regions'] as List<dynamic>?)?.map((e) => e as String).toList(),
      regionRefs: (json['regionRefs'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      attack: json['attack'] as int?,
      cost: json['cost'] as int?,
      health: json['health'] as int?,
      description: json['description'] as String?,
      descriptionRaw: json['descriptionRaw'] as String?,
      levelupDescription: json['levelupDescription'] as String?,
      levelupDescriptionRaw: json['levelupDescriptionRaw'] as String?,
      flavorText: json['flavorText'] as String?,
      artistName: json['artistName'] as String?,
      name: json['name'] as String?,
      cardCode: json['cardCode'] as String?,
      keywords: (json['keywords'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      keywordRefs: (json['keywordRefs'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      spellSpeed: json['spellSpeed'] as String?,
      spellSpeedRef: json['spellSpeedRef'] as String?,
      rarity: json['rarity'] as String?,
      rarityRef: json['rarityRef'] as String?,
      subtypes: (json['subtypes'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      supertype: json['supertype'] as String?,
      type: json['type'] as String?,
      collectible: json['collectible'] as bool?,
      deckSet: json['set'] as String?,
      formats:
          (json['formats'] as List<dynamic>?)?.map((e) => e as String).toList(),
      formatRefs: (json['formatRefs'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$SetCardToJson(SetCard instance) => <String, dynamic>{
      'associatedCards': instance.associatedCards,
      'associatedCardRefs': instance.associatedCardRefs,
      'assets': instance.assets,
      'regions': instance.regions,
      'regionRefs': instance.regionRefs,
      'attack': instance.attack,
      'cost': instance.cost,
      'health': instance.health,
      'description': instance.description,
      'descriptionRaw': instance.descriptionRaw,
      'levelupDescription': instance.levelupDescription,
      'levelupDescriptionRaw': instance.levelupDescriptionRaw,
      'flavorText': instance.flavorText,
      'artistName': instance.artistName,
      'name': instance.name,
      'cardCode': instance.cardCode,
      'keywords': instance.keywords,
      'keywordRefs': instance.keywordRefs,
      'spellSpeed': instance.spellSpeed,
      'spellSpeedRef': instance.spellSpeedRef,
      'rarity': instance.rarity,
      'rarityRef': instance.rarityRef,
      'subtypes': instance.subtypes,
      'supertype': instance.supertype,
      'type': instance.type,
      'collectible': instance.collectible,
      'set': instance.deckSet,
      'formats': instance.formats,
      'formatRefs': instance.formatRefs,
    };

Asset _$AssetFromJson(Map<String, dynamic> json) => Asset(
      gameAbsolutePath: json['gameAbsolutePath'] as String?,
      fullAbsolutePath: json['fullAbsolutePath'] as String?,
    );

Map<String, dynamic> _$AssetToJson(Asset instance) => <String, dynamic>{
      'gameAbsolutePath': instance.gameAbsolutePath,
      'fullAbsolutePath': instance.fullAbsolutePath,
    };
