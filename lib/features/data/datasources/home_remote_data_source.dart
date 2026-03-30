import 'dart:convert';

import 'package:dio/dio.dart';

import '../models/home_item_model.dart';

abstract class HomeRemoteDataSource {
  Future<List<HomeItemModel>> getHomeItems();
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final Dio dio;

  HomeRemoteDataSourceImpl(this.dio);

  @override
  Future<List<HomeItemModel>> getHomeItems() async {
    // Task : 추후 API 완성되면 교체 예정
    // 목업 데이터 반환

    await Future<void>.delayed(const Duration(milliseconds: 300));

    final responseData = [
      {
        'id': 'love',
        'category': '연애',
        'title': '깻잎 논쟁, 이해할 수 있는가?',
        'iconKey': 'favorite',
        'isCustomInput': false,
      },
      {
        'id': 'economy',
        'category': '경제',
        'title': '기본소득 도입에 찬성하는가?',
        'iconKey': 'trending_up',
        'isCustomInput': false,
      },
      {
        'id': 'society',
        'category': '사회',
        'title': '초중고교 내 스마트폰 사용 금지, 찬성하는가?',
        'iconKey': 'phone_android',
        'isCustomInput': false,
      },
      {
        'id': 'law',
        'category': '법률',
        'title': '사형제도, 유지해야 하는가?',
        'iconKey': 'gavel',
        'isCustomInput': false,
      },
      {
        'id': 'education',
        'category': '교육',
        'title': '대학에서 출석제도가 필요한가?',
        'iconKey': 'school',
        'isCustomInput': false,
      },
      {
        'id': 'environment',
        'category': '환경',
        'title': '기후 변화 해결을 위해 원자력을 확대해야 하는가?',
        'iconKey': 'eco',
        'isCustomInput': false,
      },
      {
        'id': 'politics',
        'category': '정치',
        'title': '국회의원 특권 축소, 꼭 필요한가?',
        'iconKey': 'account_balance',
        'isCustomInput': false,
      },
      {
        'id': 'science',
        'category': '과학',
        'title': '인간의 화성 탐사, 실현 가능한가?',
        'iconKey': 'rocket_launch',
        'isCustomInput': false,
      },
      {
        'id': 'ai',
        'category': 'AI',
        'title': '인공지능 예술작품의 저작권을 인정해야 하는가?',
        'iconKey': 'psychology',
        'isCustomInput': false,
      },
      {
        'id': 'custom',
        'category': '직접 입력',
        'title': '원하는 주제가 없으신가요?',
        'iconKey': 'add',
        'isCustomInput': true,
      },
    ];

    return responseData.map((json) => HomeItemModel.fromJson(json)).toList();
  }
}
