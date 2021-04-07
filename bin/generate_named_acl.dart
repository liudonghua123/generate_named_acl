import 'package:generate_named_acl/generate_named_acl.dart';
import 'dart:io';

void main(List<String> arguments) async {
  var ipDatabase = IpDatabase();
  Future<String> getAclsByName(String name) async =>
      (await ipDatabase.getCidrIp(name: name))
          .map((item) => '$item;')
          .join('\n');
  var cernetAcls = await getAclsByName('cernet');
  var chinamobileAcls = await getAclsByName('chinatelecom');
  var unicomAcls = await getAclsByName('unicom_cnc');
  var chinanetAcls = await getAclsByName('cmcc');

  // the exists acl.conf template
  var aclContents = '''acl DATACENTER_ACL {
113.55.12.0/22;
};

acl VPN1_ACL {
113.55.104.0/23;
};

acl VPN2_ACL {
113.55.106.0/23;
};

acl INTRANET_ACL {
113.54.0.0/15;
202.202.0.0/15;
222.18.0.0/15;
10.0.0.0/8;
172.16.0.0/12;
192.168.0.0/16;
};

acl CERNET_ACL {
$cernetAcls
};

acl CHINAMOBILE_ACL {
$chinamobileAcls}
};

acl UNICOM_ACL {
$unicomAcls}
};

acl CHINANET_ACL {
$chinanetAcls}
};
''';
  var aclFile = File('acl.conf');
  print('start write ${aclFile.path} file...');
  await aclFile.writeAsString(aclContents);
  print('write ${aclFile.path} file successfully!');
}
