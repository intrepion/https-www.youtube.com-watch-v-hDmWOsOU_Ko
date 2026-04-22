import 'package:flutter/material.dart';

import '../model/prism_models.dart';

const defaultPrismFaceValuesByDimensions = <String, Map<PrismFaceId, Rect>>{
  '165x165x178': {
    PrismFaceId.keel: Rect.fromLTWH(0.0336, 0.0800, 0.2235, 0.3100),
    PrismFaceId.deck: Rect.fromLTWH(0.2561, 0.0800, 0.2235, 0.3100),
    PrismFaceId.starboard: Rect.fromLTWH(0.0336, 0.4100, 0.2235, 0.3300),
    PrismFaceId.stem: Rect.fromLTWH(0.2561, 0.4100, 0.2235, 0.3300),
    PrismFaceId.port: Rect.fromLTWH(0.4796, 0.4100, 0.2235, 0.3300),
    PrismFaceId.stern: Rect.fromLTWH(0.7027, 0.4100, 0.2235, 0.3300),
  },
  '165x165x270': {
    PrismFaceId.keel: Rect.fromLTWH(0.0065, 0.0641, 0.2369, 0.2730),
    PrismFaceId.deck: Rect.fromLTWH(0.2436, 0.0641, 0.2369, 0.2730),
    PrismFaceId.starboard: Rect.fromLTWH(0.0065, 0.3386, 0.2369, 0.4642),
    PrismFaceId.stem: Rect.fromLTWH(0.2436, 0.3386, 0.2369, 0.4642),
    PrismFaceId.port: Rect.fromLTWH(0.4824, 0.3386, 0.2369, 0.4642),
    PrismFaceId.stern: Rect.fromLTWH(0.7195, 0.3386, 0.2369, 0.4642),
  },
};

const prismFaceDropdownLabels = <PrismFaceId, String>{
  PrismFaceId.starboard: 'Starboard',
  PrismFaceId.stem: 'Stem',
  PrismFaceId.port: 'Port',
  PrismFaceId.stern: 'Stern',
  PrismFaceId.deck: 'Deck',
  PrismFaceId.keel: 'Keel',
};

const prismFaceOverlayColors = <PrismFaceId, Color>{
  PrismFaceId.starboard: Color(0xFF1565C0),
  PrismFaceId.stem: Color(0xFF2E7D32),
  PrismFaceId.port: Color(0xFFAD1457),
  PrismFaceId.stern: Color(0xFF6A1B9A),
  PrismFaceId.deck: Color(0xFFEF6C00),
  PrismFaceId.keel: Color(0xFF00838F),
};
