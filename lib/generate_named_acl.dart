import 'package:http/http.dart' as http;
import 'package:simple_logger/simple_logger.dart';

///
/// a thin wrapper of https://ispip.clang.cn/
///
class IpDatabase {
  final logger = SimpleLogger();

  // isp name and corresponding url for data
  final _ipDatabase = {
    'all_cn': 'https://ispip.clang.cn/all_cn_cidr.txt',
    'chinatelecom': 'https://ispip.clang.cn/chinatelecom_cidr.txt',
    'unicom_cnc': 'https://ispip.clang.cn/unicom_cnc_cidr.txt',
    'cmcc': 'https://ispip.clang.cn/cmcc_cidr.txt',
    'crtc': 'https://ispip.clang.cn/crtc_cidr.txt',
    'cernet': 'https://ispip.clang.cn/cernet_cidr.txt',
    'gwbn': 'https://ispip.clang.cn/gwbn_cidr.txt',
    'othernet': 'https://ispip.clang.cn/othernet_cidr.txt',
    'hk': 'https://ispip.clang.cn/hk_cidr.txt',
    'mo': 'https://ispip.clang.cn/mo_cidr.txt',
    'tw': 'https://ispip.clang.cn/tw_cidr.txt',
  };

  /// get a list of available name of cidr ip from https://ispip.clang.cn/.
  List<String> getAvailableName() {
    return _ipDatabase.keys.toList();
  }

  /// get a list of cidr ip of [name] from https://ispip.clang.cn/.
  Future<List<String>> getCidrIp({String name = 'all_cn'}) async {
    var urlString = _ipDatabase[name];
    logger.info('starting get ip data [$name}] from $urlString}');
    var response = await http.get(Uri.parse(urlString));
    if (response.statusCode != 200) {
      logger.info(
          'http get $urlString} failed with statusCode ${response.statusCode}');
    }
    return response.body.trim().split('\n').map((e) => e.trim()).toList();
  }
}
