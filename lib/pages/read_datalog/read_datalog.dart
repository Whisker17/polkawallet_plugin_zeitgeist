import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:polkawallet_plugin_zeitgeist/common/models/datalog_index.dart';
import 'package:polkawallet_plugin_zeitgeist/common/models/datalog_item.dart';
import 'package:polkawallet_plugin_zeitgeist/polkawallet_plugin_zeitgeist.dart';
import 'package:polkawallet_sdk/api/api.dart';
import 'package:polkawallet_sdk/storage/types/keyPairData.dart';
import 'package:polkawallet_ui/components/v3/addressTextFormField.dart';
import 'package:polkawallet_ui/components/v3/back.dart';

class ReadDatalogPage extends StatefulWidget {
  static const String route = '/zeitgeist/read_datalog';

  ReadDatalogPage(this.plugin, {Key? key}) : super(key: key);

  final PluginZeitgeist plugin;

  @override
  State<ReadDatalogPage> createState() => _ReadDatalogPageState();
}

class _ReadDatalogPageState extends State<ReadDatalogPage> {
  KeyPairData? _selectedAccount;

  DatalogIndex? indexes;
  DatalogItem? datalogData;

  bool isLoading = false;
  bool hasIndexesError = false;
  bool hasDatalogDataError = false;

  PolkawalletApi get api => widget.plugin.sdk.api;
  List<KeyPairData> get accounts {
    widget.plugin.keyring.setSS58(widget.plugin.basic.ss58);
    return widget.plugin.keyring.allWithContacts;
  }

  String get indexesError => hasIndexesError ? 'Can\'t load indexes' : '';
  String get datalogDataError =>
      hasDatalogDataError ? 'Can\'t load datalog record' : '';

  void setLoading(bool value) {
    setState(() {
      isLoading = value;
    });
  }

  Future<void> onAccountChanged(KeyPairData? keyPairData) async {
    _selectedAccount = keyPairData;
    indexes = null;
    hasIndexesError = false;
    setState(() {});
    if (_selectedAccount == null) return;
    setLoading(true);
    try {
      await readIndexes(_selectedAccount!).timeout(Duration(seconds: 10));
    } catch (_) {
      setState(() {
        hasIndexesError = true;
      });
    }
    setLoading(false);
  }

  Future<void> onSelectedIndexChanged(String value) async {
    final index = int.tryParse(value);
    if (index == null || _selectedAccount == null) return;
    hasDatalogDataError = false;
    setLoading(true);
    try {
      await loadDatalogData(_selectedAccount!, index)
          .timeout(Duration(seconds: 10));
    } catch (e) {
      setState(() {
        hasDatalogDataError = true;
      });
    }
    setLoading(false);
  }

  Future<void> readIndexes(KeyPairData keyPairData) async {
    final address = keyPairData.address;
    final indexInRing = await api.service.webView!.evalJavascript(
      'api.query.datalog.datalogIndex("$address")',
    );
    indexes = DatalogIndex.fromJson(indexInRing);
    setState(() {});
  }

  Future<void> loadDatalogData(KeyPairData account, int index) async {
    final dynamic datalogItem = await api.service.webView!.evalJavascript(
      'api.query.datalog.datalogItem(["${account.address}",$index])',
    );
    datalogData = DatalogItem.fromJson(datalogItem);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Read datalog'),
        centerTitle: true,
        leading: BackBtn(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Opacity(
              opacity: isLoading ? 1.0 : 0.0,
              child: LinearProgressIndicator(),
            ),
            const SizedBox(height: 8),
            AddressTextFormField(
              api,
              accounts,
              initialValue: _selectedAccount,
              onChanged: onAccountChanged,
              labelText: 'Address',
            ),
            AnimatedCrossFade(
              crossFadeState: indexes == null
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
              duration: Duration(milliseconds: 400),
              firstChild: Column(
                children: [
                  const SizedBox(height: 4),
                  Text(
                    indexesError,
                    style: Theme.of(context)
                        .textTheme
                        .caption
                        ?.copyWith(color: Theme.of(context).errorColor),
                  ),
                ],
              ),
              secondChild: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  if (indexes != null) ...[
                    Text('Start index: ${indexes!.start}'),
                    const SizedBox(height: 8),
                    Text('End index: ${indexes!.end}'),
                  ],
                  const SizedBox(height: 16),
                  CupertinoTextField(
                    placeholder: 'Index',
                    onChanged: onSelectedIndexChanged,
                  ),
                  if (datalogData == null) ...[
                    const SizedBox(height: 4),
                    Text(
                      datalogDataError,
                      style: Theme.of(context)
                          .textTheme
                          .caption
                          ?.copyWith(color: Theme.of(context).errorColor),
                    ),
                  ],
                  const SizedBox(height: 16),
                  if (datalogData != null)
                    Text(
                      JsonEncoder.withIndent('  ')
                          .convert(datalogData!.jsonData),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
