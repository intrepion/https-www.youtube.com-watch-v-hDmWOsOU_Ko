import 'package:flutter/material.dart';

const defaultPrismFaceValuesByDimensions = <String, Map<String, Rect>>{
  '165x165x178': {
    'keel': Rect.fromLTWH(0.0336, 0.0800, 0.2235, 0.3100),
    'deck': Rect.fromLTWH(0.2561, 0.0800, 0.2235, 0.3100),
    'starboard': Rect.fromLTWH(0.0336, 0.4100, 0.2235, 0.3300),
    'stem': Rect.fromLTWH(0.2561, 0.4100, 0.2235, 0.3300),
    'port': Rect.fromLTWH(0.4796, 0.4100, 0.2235, 0.3300),
    'stern': Rect.fromLTWH(0.7027, 0.4100, 0.2235, 0.3300),
  },
  '165x165x270': {
    'keel': Rect.fromLTWH(0.0065, 0.0641, 0.2369, 0.2730),
    'deck': Rect.fromLTWH(0.2436, 0.0641, 0.2369, 0.2730),
    'starboard': Rect.fromLTWH(0.0065, 0.3386, 0.2369, 0.4642),
    'stem': Rect.fromLTWH(0.2436, 0.3386, 0.2369, 0.4642),
    'port': Rect.fromLTWH(0.4824, 0.3386, 0.2369, 0.4642),
    'stern': Rect.fromLTWH(0.7195, 0.3386, 0.2369, 0.4642),
  },
};

const prismFaceDropdownLabels = <String, String>{
  'starboard': 'Starboard',
  'stem': 'Stem',
  'port': 'Port',
  'stern': 'Stern',
  'deck': 'Deck',
  'keel': 'Keel',
};

const prismFaceOverlayColors = <String, Color>{
  'starboard': Color(0xFF1565C0),
  'stem': Color(0xFF2E7D32),
  'port': Color(0xFFAD1457),
  'stern': Color(0xFF6A1B9A),
  'deck': Color(0xFFEF6C00),
  'keel': Color(0xFF00838F),
};
