import 'prism_models.dart';

const prismImageAssetPaths = <String>[
  'assets/scentsy-box-165x165x178-ewok.png',
  'assets/scentsy-box-165x165x178-elsa.png',
  'assets/scentsy-box-165x165x270-cinderella.png',
  'assets/scentsy-box-165x165x270-santa-stitch.png',
];

final prismImageOptions = prismImageAssetPaths
    .map(PrismImageOption.fromAssetPath)
    .toList(growable: false);
