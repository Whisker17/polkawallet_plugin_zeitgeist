import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:polkawallet_plugin_zeitgeist/polkawallet_plugin_zeitgeist.dart';
import 'package:polkawallet_plugin_zeitgeist/store/staking/types/txData.dart';
import 'package:polkawallet_plugin_zeitgeist/utils/i18n/index.dart';
import 'package:polkawallet_sdk/storage/keyring.dart';
import 'package:polkawallet_sdk/utils/i18n.dart';
import 'package:polkawallet_ui/components/txDetail.dart';
import 'package:polkawallet_ui/utils/format.dart';

class RewardDetailPage extends StatelessWidget {
  RewardDetailPage(this.plugin, this.keyring);

  static final String route = '/staking/rewards';
  final PluginZeitgeist plugin;
  final Keyring keyring;

  @override
  Widget build(BuildContext context) {
    final dic = I18n.of(context)!.getDic(i18n_full_dic_zeitgeist, 'common')!;
    final dicStaking =
        I18n.of(context)!.getDic(i18n_full_dic_zeitgeist, 'staking')!;
    final decimals = plugin.networkState.tokenDecimals![0];
    final symbol = plugin.networkState.tokenSymbol![0];
    final TxRewardData detail =
        ModalRoute.of(context)!.settings.arguments as TxRewardData;

    return TxDetail(
      networkName: plugin.basic.name,
      success: true,
      action: detail.eventId,
      fee: '0',
      hash: detail.extrinsicHash,
      eventId: detail.eventIndex,
      infoItems: <TxDetailInfoItem>[
        TxDetailInfoItem(
            label: dicStaking['txs.event'], content: Text(detail.eventId!)),
        TxDetailInfoItem(
          label: dic['amount'],
          content: Text('${Fmt.balance(detail.amount!, decimals)} $symbol'),
        ),
      ],
      blockTime: Fmt.dateTime(
          DateTime.fromMillisecondsSinceEpoch(detail.blockTimestamp! * 1000)),
      blockNum: detail.blockNum,
    );
  }
}
