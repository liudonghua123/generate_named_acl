import 'dart:io';
import 'package:generate_named_acl/generate_named_acl.dart';
import 'package:mustache_template/mustache_template.dart';
import 'package:simple_logger/simple_logger.dart';
import 'package:args/args.dart';

var logger = SimpleLogger();
void main(List<String> args) async {
  // parse args
  var parser = ArgParser();
  parser.addOption('template', abbr: 't', defaultsTo: 'acl.conf.template');
  parser.addOption('output', abbr: 'o', defaultsTo: 'acl.conf');
  parser.addFlag('overwrite', defaultsTo: true);
  var argResults = parser.parse(args);
  var templatePath = argResults['template'];
  var outputPath = argResults['output'];
  var overwrite = argResults['overwrite'];

  // check template
  if (!File(templatePath).existsSync()) {
    logger.severe('template $templatePath not found!');
    exit(-1);
  }

  // prepare template
  var source = await File(templatePath).readAsString();
  var template = Template(source, name: outputPath, htmlEscapeValues: false);
  var aclFile = File(outputPath);

  // check overwrite and output file exists
  if (overwrite) {
    logger.warning('overwrite is on!!!');
  }
  if (aclFile.existsSync() && !overwrite) {
    logger.info(
        'aclFile $aclFile exists and overwrite mode is off, skip writing...');
    exit(0);
  }

  // prepare data for template
  var ipDatabase = IpDatabase();
  var cernetAcls = await ipDatabase.getCidrIp(name: 'cernet');
  var chinamobileAcls = await ipDatabase.getCidrIp(name: 'chinatelecom');
  var unicomAcls = await ipDatabase.getCidrIp(name: 'unicom_cnc');
  var chinanetAcls = await ipDatabase.getCidrIp(name: 'cmcc');
  var data = {
    'cernetAcls': cernetAcls,
    'chinamobileAcls': chinamobileAcls,
    'unicomAcls': unicomAcls,
    'chinanetAcls': chinanetAcls,
  };

  // start writing outputs
  logger.info('start write ${aclFile.path} file...');
  var output = template.renderString(data);
  await aclFile.writeAsString(output);
  logger.info('write ${aclFile.path} file successfully!');
}
