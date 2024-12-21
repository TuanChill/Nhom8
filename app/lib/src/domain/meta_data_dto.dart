class MetaDataDto {
  final int page;
  final int pageSize;
  final int pageCount;
  final int total;

  MetaDataDto({
    required this.page,
    required this.pageSize,
    required this.pageCount,
    required this.total,
  });

  factory MetaDataDto.fromJson(Map<String, dynamic> json) {
    return MetaDataDto(
      page: json['page'],
      pageSize: json['pageSize'],
      pageCount: json['pageCount'],
      total: json['total'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'page': page,
      'pageSize': pageSize,
      'pageCount': pageCount,
      'total': total,
    };
  }
}
