import 'package:dio/dio.dart';

class NetworkErrorMapper {
  const NetworkErrorMapper._();

  static String toUserMessage(
    DioException error, {
    required String requestLabel,
  }) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return '$requestLabel 응답이 지연되고 있습니다. 서버 처리 시간이 길어지거나 네트워크 상태가 불안정할 수 있어요. 잠시 후 다시 시도해주세요.';
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        if (statusCode != null && statusCode >= 500) {
          return '$requestLabel 중 서버 내부 오류가 발생했습니다. 현재는 클라이언트보다 서버 응답 문제일 가능성이 큽니다.';
        }
        if (statusCode == 404) {
          return '$requestLabel API 경로를 찾지 못했습니다. 서버 라우트 주소를 확인해주세요.';
        }
        if (statusCode == 401 || statusCode == 403) {
          return '$requestLabel 권한이 없습니다. 인증 또는 서버 접근 정책을 확인해주세요.';
        }
        return '$requestLabel 요청이 정상적으로 처리되지 않았습니다. 서버 응답 형식과 상태 코드를 확인해주세요.';
      case DioExceptionType.connectionError:
      case DioExceptionType.unknown:
        return '$requestLabel 네트워크 연결에 실패했습니다. 웹이라면 CORS 또는 Mixed Content 설정, 앱이라면 네트워크 연결 상태를 확인해주세요.';
      case DioExceptionType.cancel:
        return '$requestLabel 요청이 취소되었습니다.';
      case DioExceptionType.badCertificate:
        return '$requestLabel 중 인증서 검증에 실패했습니다. HTTPS 설정을 확인해주세요.';
    }
  }
}
