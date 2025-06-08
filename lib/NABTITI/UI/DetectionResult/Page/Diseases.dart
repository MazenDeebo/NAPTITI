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
      //print("adlakjhcguiogfyifhggfyughcghjhhvjkiu");
    }
  }

  List<Detections>? _detections;
  List<Detections> get detections => _detections ?? [];
}

class Detections {
  Detections({
    String? diseaseNameArabic,
    String? description,
    List<String>? cause,
    List<String>? organicTreatmentPlan,
    List<String>? chemicalTreatmentPlan,

    String? diseaseName,
    String? descriptionEnglish,
    List<String>? causeEnglish,
    List<String>? organicTreatmentPlanEnglish,
    List<String>? chemicalTreatmentPlanEnglish,

  }) {
    _diseaseNameArabic = diseaseNameArabic;
    _description = description;
    _cause = cause;
    _organicTreatmentPlan = organicTreatmentPlan;
    _chemicalTreatmentPlan = chemicalTreatmentPlan;

    _diseaseName = diseaseName;
    _descriptionEnglish=descriptionEnglish;
    _causeEnglish=causeEnglish;
    _organicTreatmentPlanEnglish=organicTreatmentPlanEnglish;
    _chemicalTreatmentPlanEnglish=chemicalTreatmentPlanEnglish;
  }

  Detections.fromJson(dynamic json) {
    _description = json['Description'];
    _diseaseNameArabic = json['Disease Name Arabic'];
    _cause = List<String>.from(json['Cause'] ?? []);
    _organicTreatmentPlan = List<String>.from(json['Organic TreatmentPlan'] ?? []);
    _chemicalTreatmentPlan = List<String>.from(json['Chemical TreatmentPlan'] ?? []);

    _diseaseName = json['Disease Name'];
    _descriptionEnglish = json['Description English'];
    _causeEnglish = List<String>.from(json['Cause English'] ?? []);
    _organicTreatmentPlanEnglish = List<String>.from(json['Organic TreatmentPlan English'] ?? []);
    _chemicalTreatmentPlanEnglish = List<String>.from(json['Chemical TreatmentPlan English'] ?? []);
  }

  String? _diseaseNameArabic;
  String? _description;
  List<String>? _cause;
  List<String>? _organicTreatmentPlan;
  List<String>? _chemicalTreatmentPlan;

  String? _diseaseName;
  String? _descriptionEnglish;
  List<String>? _causeEnglish;
  List<String>? _organicTreatmentPlanEnglish;
  List<String>? _chemicalTreatmentPlanEnglish;

  String get diseaseNameArabic => _diseaseNameArabic ?? "";
  String get description => _description ?? "";
  String get cause => (_cause ?? []).join('\n');
  String get organicTreatmentPlan => (_organicTreatmentPlan ?? []).join('\n');
  String get chemicalTreatmentPlan => (_chemicalTreatmentPlan ?? []).join('\n');

  String get diseaseName => _diseaseName ?? "";
  String get descriptionEnglish => _descriptionEnglish ?? "";
  String get causeEnglish => (_causeEnglish ?? []).join('\n');
  String get organicTreatmentPlanEnglish => (_organicTreatmentPlanEnglish ?? []).join('\n');
  String get chemicalTreatmentPlanEnglish => (_chemicalTreatmentPlanEnglish ?? []).join('\n');
}
