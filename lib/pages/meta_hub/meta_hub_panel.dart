import 'package:flutter/cupertino.dart';
import 'package:polkawallet_plugin_zeitgeist/pages/launch/launch.dart';
import 'package:polkawallet_plugin_zeitgeist/pages/read_datalog/read_datalog.dart';
import 'package:polkawallet_plugin_zeitgeist/pages/write_datalog/write_datalog.dart';
import 'package:polkawallet_plugin_zeitgeist/polkawallet_plugin_zeitgeist.dart';
import 'package:polkawallet_ui/components/v3/plugin/pluginItemCard.dart';

class MetaHubPanel extends StatelessWidget {
  MetaHubPanel(this.plugin);

  final PluginZeitgeist plugin;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          child: PluginItemCard(
            margin: EdgeInsets.only(bottom: 16),
            title: 'Launch',
            describe: 'launch function',
          ),
          onTap: () => Navigator.of(context).pushNamed(LaunchPage.route),
        ),
        GestureDetector(
          child: PluginItemCard(
            margin: EdgeInsets.only(bottom: 16),
            title: 'Write datalog',
            describe: 'Write datalog record',
          ),
          onTap: () => Navigator.of(context).pushNamed(WriteDatalogPage.route),
        ),
        GestureDetector(
          child: PluginItemCard(
            margin: EdgeInsets.only(bottom: 16),
            title: 'Read datalog',
            describe: 'Read datalog record',
          ),
          onTap: () => Navigator.of(context).pushNamed(ReadDatalogPage.route),
        ),
      ],
    );
  }
}
