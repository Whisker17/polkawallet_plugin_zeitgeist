import 'package:flutter/material.dart';

const int SECONDS_OF_DAY = 24 * 60 * 60; // seconds of one day
const int SECONDS_OF_YEAR = 365 * 24 * 60 * 60; // seconds of one year

const node_list_zeitgeist = [
  {
    'name': 'Zeitgeist (via Airalab)',
    'ss58': 32,
    'endpoint': 'wss://kusama.rpc.zeitgeist.network',
  },
];

const MaterialColor zeitgeist_black = const MaterialColor(
  0xFF222222,
  const <int, Color>{
    50: const Color(0xFF555555),
    100: const Color(0xFF444444),
    200: const Color(0xFF444444),
    300: const Color(0xFF333333),
    400: const Color(0xFF333333),
    500: const Color(0xFF222222),
    600: const Color(0xFF111111),
    700: const Color(0xFF111111),
    800: const Color(0xFF000000),
    900: const Color(0xFF000000),
  },
);

const String genesis_hash_zeitgeist = '0x631ccc82a078481584041656af292834e1ae6daab61d2875b4dd0c14bb9b17bc';
