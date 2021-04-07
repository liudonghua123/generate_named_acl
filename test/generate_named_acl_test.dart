import 'package:generate_named_acl/generate_named_acl.dart';
import 'package:test/test.dart';

void main() {
  test('getCidrIp', () async {
    var ipDatabase = IpDatabase();
    var ips = await ipDatabase.getCidrIp();
    expect(ips.isEmpty, false);
  });
}
