class DetectionResult {
  DetectionResult({List<Detections>? detections}) {
    _detections = detections;
  }

  DetectionResult.fromJson(dynamic json) {
    if (json['detections'] != null) {
      _detections = [];
      json['detections'].forEach((v) {
        _detections?.add(Detections.fromJson(v));
      });
    }
    else{
      //when no leafs detected
      // _detections=[];
      // _detections?.add(null);
      print("adlakjhcguiogfyifhggfyughcghjhhvjkiu");
    }
  }

  List<Detections>? _detections;
  List<Detections> get detections => _detections ?? [];
}

class Detections {
  Detections({
    String? diseaseName,
    String? description,
    String? diseaseNameArabic,
    List<String>? cause,
    List<String>? organicTreatmentPlan,
    List<String>? chemicalTreatmentPlan,
  }) {
    _diseaseName = diseaseName;
    _description = description;
    _diseaseNameArabic = diseaseNameArabic;
    _cause = cause;
    _organicTreatmentPlan = organicTreatmentPlan;
    _chemicalTreatmentPlan = chemicalTreatmentPlan;
  }

  Detections.fromJson(dynamic json) {
    _description = json['Description'];
    _diseaseName = json['Disease Name'];
    _diseaseNameArabic = json['Disease Name Arabic'];
    _cause = List<String>.from(json['Cause'] ?? []);
    _organicTreatmentPlan = List<String>.from(json['Organic TreatmentPlan'] ?? []);
    _chemicalTreatmentPlan = List<String>.from(json['Chemical TreatmentPlan'] ?? []);
  }

  String? _diseaseName;
  String? _description;
  String? _diseaseNameArabic;
  List<String>? _cause;
  List<String>? _organicTreatmentPlan;
  List<String>? _chemicalTreatmentPlan;

  String get diseaseName => _diseaseName ?? "";
  String get description => _description ?? "";
  String get diseaseNameArabic => _diseaseNameArabic ?? "";
  String get cause => (_cause ?? []).join('\n');
  String get organicTreatmentPlan => (_organicTreatmentPlan ?? []).join('\n');
  String get chemicalTreatmentPlan => (_chemicalTreatmentPlan ?? []).join('\n');
}
