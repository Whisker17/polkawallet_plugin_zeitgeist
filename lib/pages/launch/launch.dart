import 'package:flutter/material.dart';
import 'package:polkawallet_plugin_zeitgeist/polkawallet_plugin_zeitgeist.dart';
import 'package:polkawallet_sdk/api/api.dart';
import 'package:polkawallet_sdk/storage/types/keyPairData.dart';
import 'package:polkawallet_ui/components/txButton.dart';
import 'package:polkawallet_ui/components/v3/addressTextFormField.dart';
import 'package:polkawallet_ui/components/v3/back.dart';
import 'package:polkawallet_ui/components/v3/cupertinoSwitch.dart';

class LaunchPage extends StatefulWidget {
  static const String route = '/zeitgeist/launch';

  LaunchPage(this.plugin, {Key? key}) : super(key: key);

  final PluginZeitgeist plugin;

  @override
  State<LaunchPage> createState() => _LaunchPageState();
}

class _LaunchPageState extends State<LaunchPage> {
  KeyPairData? _account;
  bool _launchValue = false;
  bool _hasError = false;

  PolkawalletApi get api => widget.plugin.sdk.api;
  List<KeyPairData> get accounts {
    widget.plugin.keyring.setSS58(widget.plugin.basic.ss58);
    return widget.plugin.keyring.allWithContacts;
  }

  void setAccount(KeyPairData? account) {
    setState(() {
      _account = account;
      _hasError = false;
    });
  }

  void toggleLaunchValue(bool value) {
    setState(() {
      _launchValue = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Launch'),
        centerTitle: true,
        leading: BackBtn(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            AddressTextFormField(
              api,
              accounts,
              initialValue: _account,
              onChanged: setAccount,
              labelText: 'Address',
            ),
            const SizedBox(height: 16),
            ListTile(
              title: Text('Launch param'),
              trailing: CupertinoSwitch(
                value: _launchValue,
                onChanged: toggleLaunchValue,
              ),
            ),
            const SizedBox(height: 16),
            TxButton(
              getTxParams: () async {
                if (_account == null) {
                  setState(() {
                    _hasError = true;
                  });
                  return null;
                }
                return TxConfirmParams(
                  txTitle: 'Launch',
                  module: 'launch',
                  call: 'launch',
                  params: [
                    // params.robot
                    _account!.address,
                    // params.param
                    _launchValue
                        ? '0x0000000000000000000000000000000000000000000000000000000000000001'
                        : '0x0000000000000000000000000000000000000000000000000000000000000000',
                  ],
                );
              },
            ),
            const SizedBox(height: 16),
            if (_hasError)
              Text(
                'Address required',
                style: Theme.of(context)
                    .textTheme
                    .caption
                    ?.copyWith(color: Theme.of(context).errorColor),
              ),
          ],
        ),
      ),
    );
  }
}
