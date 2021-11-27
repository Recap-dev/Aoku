import 'package:google_maps_flutter/google_maps_flutter.dart';

class AoiSound {
  AoiSound({
    required this.title,
    required this.fileName,
    required this.location,
    required this.length,
    required this.city,
    required this.province,
  });

  final String title;
  final String fileName;
  final LatLng location;
  final int length;
  final String city;
  final String province;
}

List<AoiSound> aoiSounds = [
  AoiSound(
    title: '足助町シェアハウスのベランダ',
    fileName: 'asukecho.m4a',
    location: const LatLng(35.135616330301005, 137.31655937710295),
    length: 60,
    city: 'Toyota',
    province: 'Aichi',
  ),
  AoiSound(
    title: '古民家カフェの仕込み作業',
    fileName: 'kominka_cafe.m4a',
    location: const LatLng(35.135616330301005, 137.31655937710295),
    length: 30,
    city: 'Toyota',
    province: 'Aichi',
  ),
  AoiSound(
    title: '足助町シェアハウスのベランダの雨',
    fileName: 'kura_no_naka.m4a',
    location: const LatLng(35.135616330301005, 137.31655937710295),
    length: 15,
    city: 'Toyota',
    province: 'Aichi',
  ),
  AoiSound(
    title: 'シェアハウスリビングのリモートワーク作業音',
    fileName: 'share_house.m4a',
    location: const LatLng(35.135616330301005, 137.31655937710295),
    length: 5,
    city: 'Toyota',
    province: 'Aichi',
  ),
  AoiSound(
    title: '古民家カフェの朝',
    fileName: 'shikomi.m4a',
    location: const LatLng(35.135616330301005, 137.31655937710295),
    length: 15,
    city: 'Toyota',
    province: 'Aichi',
  ),
  AoiSound(
    title: '風の強い日、足助町シェアハウスのベランダ',
    fileName: 'windy-day.m4a',
    location: const LatLng(35.135616330301005, 137.31655937710295),
    length: 5,
    city: 'Toyota',
    province: 'Aichi',
  ),
  AoiSound(
    title: '古民家カフェの夕方仕込み開始',
    fileName: 'shikomi-short.m4a',
    location: const LatLng(35.135616330301005, 137.31655937710295),
    length: 5,
    city: 'Toyota',
    province: 'Aichi',
  ),
];
