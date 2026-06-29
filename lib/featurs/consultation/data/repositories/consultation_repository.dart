import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/services/dio_service.dart';
import '../models/consultation_model.dart';

class ConsultationRepository {
  final DioService _dioService = DioService();

  /// POST /consultations
  Future<ConsultationModel> createConsultation({
    required String consultationType,
    required String message,
  }) async {
    final formData = FormData.fromMap({
      'consultation_type': consultationType,
      'message': message,
    });
    final dio = _dioService.buildAuthorizedDio();
    final response = await dio.post('/consultations', data: formData);
    debugPrint('createConsultation ${response.statusCode}: ${response.data}');
    return ConsultationModel.fromJson(
      response.data['data'] as Map<String, dynamic>,
    );
  }

  /// GET /consultations
  Future<List<ConsultationModel>> getMyConsultations() async {
    final response = await _dioService.getData('/consultations');
    debugPrint('getMyConsultations ${response.statusCode}: ${response.data}');
    return _parseList(response.data);
  }

  /// GET /consultations/{id} — لجلب آخر حالة استشارة معينة (polling)
  Future<ConsultationModel> getConsultationById(int id) async {
    final response = await _dioService.getData('/consultations/$id');
    debugPrint('getConsultationById $id: ${response.data}');
    final raw = response.data;
    // قد يكون مباشرةً data أو داخل wrapper
    if (raw is Map && raw['data'] is Map) {
      return ConsultationModel.fromJson(raw['data'] as Map<String, dynamic>);
    }
    return ConsultationModel.fromJson(raw as Map<String, dynamic>);
  }

  // ── helper ──────────────────────────────────────────────────
  List<ConsultationModel> _parseList(dynamic raw) {
    List<dynamic> list;
    if (raw is Map) {
      final inner = raw['data'];
      if (inner is List) {
        list = inner;
      } else if (inner is Map && inner['data'] is List) {
        list = inner['data'] as List;
      } else {
        list = [];
      }
    } else if (raw is List) {
      list = raw;
    } else {
      list = [];
    }
    return list
        .map((e) => ConsultationModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
