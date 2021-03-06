import 'package:flutter/material.dart';

const int SECONDS_OF_DAY = 24 * 60 * 60; // seconds of one day
const int SECONDS_OF_YEAR = 365 * 24 * 60 * 60; // seconds of one year

const zeitgeist_node_list = [
  {
    'name': 'Zeitgeist (via Zeitgeist PM)',
    'ss58': zeitgeist_ss58,
    'endpoint': 'wss://rpc-0.zeitgeist.pm',
  },
  {
    'name': 'Zeitgeist (via Dwellir)',
    'ss58': zeitgeist_ss58,
    'endpoint': 'wss://zeitgeist-rpc.dwellir.com',
  },
  {
    'name': 'Zeitgeist (via OnFinality)',
    'ss58': zeitgeist_ss58,
    'endpoint': 'wss://zeitgeist.api.onfinality.io/public-ws',
  },
];

const home_nav_items = ['staking'];

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

const String zeitgeist_genesis_hash =
    '0x1bf2a2ecb4a868de66ea8610f2ce7c8c43706561b6476031315f6640fe38e060';
const String network_name_zeitgeist = 'zeitgeist';
const int zeitgeist_ss58 = 73;
