import 'package:circuito_descobertas/features/checkin/data/qr_payload.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('parseQrPayload', () {
    test('devolve o ID de um QR do painel', () {
      expect(parseQrPayload('circuito-descobertas:estande:E03'), 'E03');
      expect(parseQrPayload('circuito-descobertas:estande:AB'), 'AB');
      expect(
        parseQrPayload('circuito-descobertas:estande:ABCDEFGHIJ12'),
        'ABCDEFGHIJ12',
      );
    });

    test('recusa texto fora do formato', () {
      expect(parseQrPayload(null), isNull);
      expect(parseQrPayload(''), isNull);
      expect(parseQrPayload('E03'), isNull);
      expect(parseQrPayload('https://exemplo.com'), isNull);
      expect(parseQrPayload('outro-app:estande:E03'), isNull);
      expect(parseQrPayload(' circuito-descobertas:estande:E03'), isNull);
    });

    test('recusa ID fora do padrão', () {
      expect(parseQrPayload('circuito-descobertas:estande:'), isNull);
      expect(parseQrPayload('circuito-descobertas:estande:E'), isNull);
      expect(parseQrPayload('circuito-descobertas:estande:e03'), isNull);
      expect(parseQrPayload('circuito-descobertas:estande:E-03'), isNull);
      expect(parseQrPayload('circuito-descobertas:estande:E03 '), isNull);
      expect(parseQrPayload('circuito-descobertas:estande:E03/x'), isNull);
      expect(
        parseQrPayload('circuito-descobertas:estande:ABCDEFGHIJ123'),
        isNull,
      );
    });
  });
}
