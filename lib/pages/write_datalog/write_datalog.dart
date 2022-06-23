import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:polkawallet_plugin_zeitgeist/polkawallet_plugin_zeitgeist.dart';
import 'package:polkawallet_ui/components/txButton.dart';
import 'package:polkawallet_ui/components/v3/back.dart';

class WriteDatalogPage extends StatefulWidget {
  static const String route = '/zeitgeist/write_datalog';

  WriteDatalogPage(this.plugin, {Key? key}) : super(key: key);

  final PluginZeitgeist plugin;

  @override
  State<WriteDatalogPage> createState() => _WriteDatalogPageState();
}

class _WriteDatalogPageState extends State<WriteDatalogPage> {
  String _recordValue = '';
  bool hasError = false;

  String? get _errorValue => hasError ? 'Record is empty' : null;

  void onRecordChanged(String value) {
    _recordValue = value;
    validate();
  }

  void onFocusChanged(bool hasFocus) {
    if (!hasFocus) {
      validate();
    }
  }

  void validate() {
    setState(() {
      hasError = _recordValue.isEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Write datalog'),
        centerTitle: true,
        leading: BackBtn(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Focus(
          onFocusChange: onFocusChanged,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CupertinoTextField(
                placeholder: 'Record',
                onChanged: onRecordChanged,
              ),
              const SizedBox(height: 4),
              Text(
                _errorValue ?? '',
                style: Theme.of(context)
                    .textTheme
                    .caption
                    ?.copyWith(color: Theme.of(context).errorColor),
              ),
              const SizedBox(height: 16),
              TxButton(
                getTxParams: () async {
                  validate();
                  if (hasError) {
                    return null;
                  }
                  return TxConfirmParams(
                    txTitle: 'Datalog',
                    module: 'datalog',
                    call: 'record',
                    params: [_recordValue],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
