import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AoiSound {
  AoiSound({
    required this.title,
    required this.fileName,
    required this.location,
    required this.length,
    required this.city,
    required this.province,
    required this.time,
  });

  final String title;
  final String fileName;
  final LatLng location;
  final int length;
  final String city;
  final String province;
  final TimeOfDay time;
}

List<AoiSound> soundsMaster = [
  AoiSound(
    title: '足助町シェアハウスのベランダ',
    fileName: 'asukecho.m4a',
    location: const LatLng(35.135616330301005, 137.31655937710295),
    length: 60,
    city: 'Toyota',
    province: 'Aichi',
    time: const TimeOfDay(hour: 22, minute: 23),
  ),
  AoiSound(
    title: '古民家カフェの仕込み作業',
    fileName: 'kominka_cafe.m4a',
    location: const LatLng(35.135616330301005, 137.31655937710295),
    length: 30,
    city: 'Toyota',
    province: 'Aichi',
    time: const TimeOfDay(hour: 7, minute: 11),
  ),
  AoiSound(
    title: '足助町シェアハウスのベランダの雨',
    fileName: 'kura_no_naka.m4a',
    location: const LatLng(35.135616330301005, 137.31655937710295),
    length: 15,
    city: 'Toyota',
    province: 'Aichi',
    time: const TimeOfDay(hour: 10, minute: 11),
  ),
  AoiSound(
    title: 'シェアハウスリビングのリモートワーク作業音',
    fileName: 'share_house.m4a',
    location: const LatLng(35.135616330301005, 137.31655937710295),
    length: 5,
    city: 'Toyota',
    province: 'Aichi',
    time: const TimeOfDay(hour: 14, minute: 23),
  ),
  AoiSound(
    title: '古民家カフェの朝',
    fileName: 'shikomi.m4a',
    location: const LatLng(35.135616330301005, 137.31655937710295),
    length: 15,
    city: 'Toyota',
    province: 'Aichi',
    time: const TimeOfDay(hour: 7, minute: 11),
  ),
  AoiSound(
    title: '風の強い日、足助町シェアハウスのベランダ',
    fileName: 'windy-day.m4a',
    location: const LatLng(35.135616330301005, 137.31655937710295),
    length: 5,
    city: 'Toyota',
    province: 'Aichi',
    time: const TimeOfDay(hour: 17, minute: 48),
  ),
  AoiSound(
    title: '古民家カフェの夕方仕込み開始',
    fileName: 'shikomi-short.m4a',
    location: const LatLng(35.135616330301005, 137.31655937710295),
    length: 5,
    city: 'Toyota',
    province: 'Aichi',
    time: const TimeOfDay(hour: 15, minute: 24),
  ),
  AoiSound(
    title: 'Hotel Noum Osaka - 天満橋駅',
    fileName: 'hotel_noum_osaka.m4a',
    location: const LatLng(34.69228878580445, 135.51461463336545),
    length: 5,
    city: 'Osaka',
    province: 'Osaka',
    time: const TimeOfDay(hour: 16, minute: 29),
  ),
  AoiSound(
    title: '名古屋駅、新幹線待ち',
    fileName: 'meieki_1_chome.m4a',
    location: const LatLng(35.16911658962842, 136.88429615364052),
    length: 15,
    city: 'Nagoya',
    province: 'Aichi',
    time: const TimeOfDay(hour: 15, minute: 47),
  ),
  AoiSound(
    title: '西大井駅から自宅まで',
    fileName: 'nishioi_1_chome.m4a',
    location: const LatLng(35.601787518499435, 139.72178198123265),
    length: 5,
    city: 'Shinagawa',
    province: 'Tokyo',
    time: const TimeOfDay(hour: 20, minute: 11),
  ),
];
