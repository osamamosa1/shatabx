class ApiResponse {
  const ApiResponse({
    required this.raw,
    this.status,
    this.message,
    this.data,
  });

  final dynamic raw;
  final String? status;
  final String? message;
  final dynamic data;

  bool get isSuccess {
    final normalized = status?.toLowerCase();
    return normalized == null ||
        normalized == 'success' ||
        normalized == 'ok' ||
        normalized == 'true';
  }

  factory ApiResponse.from(dynamic raw) {
    if (raw is! Map) {
      return ApiResponse(raw: raw, data: raw);
    }
    final map = Map<String, dynamic>.from(raw);
    return ApiResponse(
      raw: raw,
      status: map['status']?.toString(),
      message: map['message']?.toString(),
      data: map.containsKey('data') ? map['data'] : map,
    );
  }

  Map<String, dynamic>? get dataMap {
    if (data is Map) return Map<String, dynamic>.from(data as Map);
    return null;
  }

  List<dynamic> get dataList {
    if (data is List) return data as List<dynamic>;
    return const [];
  }
}

String? readApiMessage(dynamic raw) {
  if (raw is Map) {
    final message = raw['message'];
    if (message != null && message.toString().trim().isNotEmpty) {
      return message.toString();
    }
    final errors = raw['errors'];
    if (errors is Map && errors.isNotEmpty) {
      final first = errors.values.first;
      if (first is List && first.isNotEmpty) return first.first.toString();
      return first.toString();
    }
  }
  return null;
}
