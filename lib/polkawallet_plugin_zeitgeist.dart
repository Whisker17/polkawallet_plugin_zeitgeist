library polkawallet_plugin_zeitgeist;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:polkawallet_plugin_zeitgeist/common/constants.dart';
import 'package:polkawallet_plugin_zeitgeist/pages/launch/launch.dart';
import 'package:polkawallet_plugin_zeitgeist/pages/meta_hub/meta_hub_panel.dart';
import 'package:polkawallet_plugin_zeitgeist/pages/read_datalog/read_datalog.dart';
import 'package:polkawallet_plugin_zeitgeist/pages/write_datalog/write_datalog.dart';
import 'package:polkawallet_sdk/api/types/networkParams.dart';
import 'package:polkawallet_sdk/plugin/homeNavItem.dart';
import 'package:polkawallet_sdk/plugin/index.dart';
import 'package:polkawallet_sdk/storage/keyring.dart';

class PluginZeitgeist extends PolkawalletPlugin {
  PluginZeitgeist()
      : basic = PluginBasicData(
          name: 'Zeitgeist',
          genesisHash: genesis_hash_zeitgeist,
          ss58: 32,
          primaryColor: zeitgeist_black,
          gradientColor: Color(0xFF2948d3),
          backgroundImage: AssetImage(
              'packages/polkawallet_plugin_zeitgeist/assets/images/public/bg_zeitgeist.png'),
          icon: Image.asset(
              'packages/polkawallet_plugin_zeitgeist/assets/images/public/zeitgeist.png'),
          iconDisabled: Image.asset(
              'packages/polkawallet_plugin_zeitgeist/assets/images/public/zeitgeist_gray.png'),
          jsCodeVersion: 31501,
          isTestNet: false,
          isXCMSupport: true,
        ),
        recoveryEnabled = true;

  @override
  final PluginBasicData basic;

  @override
  final bool recoveryEnabled;

  @override
  List<NetworkParams> get nodeList {
    return node_list_zeitgeist.map((e) => NetworkParams.fromJson(e)).toList();
  }

  late Keyring keyring;

  @override
  final Map<String, Widget> tokenIcons = {
    'XRT': Image.asset(
        'packages/polkawallet_plugin_zeitgeist/assets/images/tokens/XRT.png'),
  };

  @override
  List<HomeNavItem> getNavItems(BuildContext context, Keyring keyring) {
    return [
      HomeNavItem(
        text: basic.name!.toUpperCase(),
        icon: Container(),
        iconActive: Container(),
        isAdapter: true,
        content: MetaHubPanel(this),
      ),
    ];
  }

  @override
  Map<String, WidgetBuilder> getRoutes(Keyring keyring) {
    return {
      LaunchPage.route: (context) => LaunchPage(this),
      ReadDatalogPage.route: (context) => ReadDatalogPage(this),
      WriteDatalogPage.route: (context) => WriteDatalogPage(this),
    };
  }

  @override
  Future<String>? loadJSCode() => null;

  @override
  Future<void> onWillStart(Keyring keyring) async {
    try {
      loadBalances(keyring.current);
      print('zeitgeist plugin cache data loaded');
    } catch (err) {
      print(err);
      print('load zeitgeist cache data failed');
    }
    this.keyring = keyring;
  }
}
