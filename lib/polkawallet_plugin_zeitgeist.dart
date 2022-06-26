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
          genesisHash: zeitgeist_genesis_hash,
          ss58: zeitgeist_ss58,
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
    return zeitgeist_node_list.map((e) => NetworkParams.fromJson(e)).toList();
  }

  late Keyring keyring;

  @override
  final Map<String, Widget> tokenIcons = {
    'ZTG': Image.asset(
        'packages/polkawallet_plugin_zeitgeist/assets/images/tokens/ZTG.png'),
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
      TxConfirmPage.route: (_) => TxConfirmPage(
          this,
          keyring,
          _service.getPassword as Future<String> Function(
              BuildContext, KeyPairData)),

      // staking pages

      // governance pages

      // prediction markets pages
    };
  }

  @override
  Future<String>? loadJSCode() => null;

  late PluginStore _store;
  late PluginApi _service;
  PluginStore get store => _store;
  PluginApi get service => _service;

  final StoreCache _cache;

  @override
  Future<void> onWillStart(Keyring keyring) async {
    await GetStorage.init(plugin_zeitgeist_storage_key);

    _store = PluginStore(_cache);

    try {
      loadBalances(keyring.current);

      _store.staking.loadCache(keyring.current.pubKey);
      _store.gov.clearState();
      _store.gov.loadCache();
      print('Zeitgeist plugin cache data loaded');
    } catch (err) {
      print(err);
      print('load Zeitgeist cache data failed');
    }

    _service = PluginApi(this, keyring);
  }

  @override
  Future<void> onAccountChanged(KeyPairData acc) async {
    _store.staking.loadAccountCache(acc.pubKey);
  }
}
