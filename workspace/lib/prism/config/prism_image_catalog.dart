import '../model/prism_models.dart';

const prismImageAssetPaths = <String>[
  'assets/scentsy-box-165x165x178-ewok.webp',
  'assets/scentsy-box-165x165x178-elsa.webp',
  'assets/scentsy-box-165x165x270-cinderella.webp',
  'assets/scentsy-box-165x165x270-santa-stitch.webp',
];

final prismImageOptions = prismImageAssetPaths
    .map(PrismImageOption.fromAssetPath)
    .toList(growable: false);
