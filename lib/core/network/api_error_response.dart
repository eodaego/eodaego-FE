/// 백엔드 공통 에러 응답 모델
///
/// 백엔드의 모든 에러 응답은 이 형식을 따릅니다:
/// ```json
/// {
///   "errorCode": "NICKNAME_ALREADY_EXISTS",
///   "errorMessage": "이미 사용 중인 닉네임입니다.",
///   "fieldErrors": [
///     { "field": "socialType", "reason": "널이어서는 안됩니다" }
///   ]
/// }
/// ```
///
/// 명세: `docs/api-docs.json`의 `components.schemas.ErrorResponse`.
/// OpenAPI에 `required` 선언이 없으므로 모든 필드를 nullable로 둔다.
class ApiErrorResponse {
  /// 에러 코드 (SCREAMING_SNAKE_CASE). 클라이언트는 이 값으로 분기한다.
  final String? errorCode;

  /// 사용자에게 표시 가능한 에러 메시지.
  ///
  /// 백엔드가 한국어로 고정 반환하므로 **로깅 용도로만** 사용한다.
  /// 사용자 노출은 항상 `AppException.messageKey` 경유.
  final String? errorMessage;

  /// 요청 바디 검증(Bean Validation) 실패 시에만 포함되는 필드별 오류 목록.
  ///
  /// 검증 실패가 아닌 에러(인증 실패 등)에서는 응답에 포함되지 않는다.
  /// 디버깅 로그 전용.
  final List<FieldErrorDetail>? fieldErrors;

  const ApiErrorResponse({this.errorCode, this.errorMessage, this.fieldErrors});

  /// 응답 데이터에서 안전하게 파싱 시도
  ///
  /// 에러 응답 형식이 아니면 null을 반환한다.
  static ApiErrorResponse? tryParse(dynamic data) {
    if (data is! Map<String, dynamic>) return null;

    // errorCode 또는 errorMessage 중 하나라도 있으면 에러 응답으로 판단
    if (data['errorCode'] == null && data['errorMessage'] == null) {
      return null;
    }

    final rawFieldErrors = data['fieldErrors'];
    return ApiErrorResponse(
      errorCode: data['errorCode'] as String?,
      errorMessage: data['errorMessage'] as String?,
      fieldErrors: rawFieldErrors is List
          ? rawFieldErrors
                .whereType<Map<String, dynamic>>()
                .map(FieldErrorDetail.fromJson)
                .toList()
          : null,
    );
  }

  @override
  String toString() {
    final fields = fieldErrors?.map((e) => e.toString()).join(', ');
    return '$errorCode | $errorMessage'
        '${fields != null && fields.isNotEmpty ? ' | fields: [$fields]' : ''}';
  }
}

/// 요청 바디 검증 실패 시 필드별 상세
class FieldErrorDetail {
  /// 검증에 실패한 요청 필드명 (예: `socialType`)
  final String? field;

  /// 검증 실패 사유 (예: `널이어서는 안됩니다`)
  final String? reason;

  const FieldErrorDetail({this.field, this.reason});

  factory FieldErrorDetail.fromJson(Map<String, dynamic> json) {
    return FieldErrorDetail(
      field: json['field'] as String?,
      reason: json['reason'] as String?,
    );
  }

  @override
  String toString() => '$field: $reason';
}
