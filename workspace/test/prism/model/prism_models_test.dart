import 'package:flutter_test/flutter_test.dart';
import 'package:hello_world/prism/model/prism_models.dart';

void main() {
  group('PrismImageOption.fromAssetPath', () {
    test('parses dimensions, name, and extension', () {
      final option = PrismImageOption.fromAssetPath(
        'assets/scentsy-box-165x165x178-ewok.webp',
      );

      expect(option.dimensions, const PrismDimensions(width: 165, depth: 165, height: 178));
      expect(option.name, 'ewok');
      expect(option.extension, 'webp');
      expect(option.label, 'Ewok (165x165x178)');
    });

    test('rejects malformed asset names with a clear error', () {
      expect(
        () => PrismImageOption.fromAssetPath('assets/not-a-box-name.png'),
        throwsA(
          isA<ArgumentError>().having(
            (error) => error.message,
            'message',
            contains('Expected assets/scentsy-box-WxDxH-name.ext'),
          ),
        ),
      );
    });

    test('rejects empty asset name segments', () {
      expect(
        () => PrismImageOption.fromAssetPath(
          'assets/scentsy-box-165x165x178-santa--stitch.png',
        ),
        throwsA(
          isA<ArgumentError>().having(
            (error) => error.message,
            'message',
            contains('Asset name segments must not be empty'),
          ),
        ),
      );
    });
  });

  group('PrismFaceId.tryParse', () {
    test('returns matching face id when known', () {
      expect(PrismFaceId.tryParse('stem'), PrismFaceId.stem);
    });

    test('returns null when unknown', () {
      expect(PrismFaceId.tryParse('unknown-face'), isNull);
    });
  });
}
