class RetrieveResult {
  final String diaDiem;
  final String moTa;
  final List<String> keywords;

  RetrieveResult(
      {required this.diaDiem, required this.moTa, required this.keywords});

  factory RetrieveResult.fromJson(Map<String, dynamic> json) {
    return RetrieveResult(
      diaDiem: json['Địa điểm'] ?? '',
      moTa: json['Mô tả'] ?? '',
      keywords:
          json['Keywords'] != null ? List<String>.from(json['Keywords']) : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Địa điểm': diaDiem,
      'Mô tả': moTa,
      'Keywords': keywords,
    };
  }
}
