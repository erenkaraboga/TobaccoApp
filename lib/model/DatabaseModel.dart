class LeafModel {
  int? leafId;
  String? name;
  List<LeafDetails>? leafDetails;

  LeafModel({this.leafId, this.name, this.leafDetails});

  LeafModel.fromJson(Map<String, dynamic> json) {
    leafId = json['leafId'];
    name = json['name'];
    if (json['leafDetails'] != null) {
      leafDetails = <LeafDetails>[];
      json['leafDetails'].forEach((v) {
        leafDetails!.add(new LeafDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['leafId'] = this.leafId;
    data['name'] = this.name;
    if (this.leafDetails != null) {
      data['leafDetails'] = this.leafDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LeafDetails {
  int? leafDetailId;
  String? url;
  int? cct;
  String? time;
  int? leafId;

  LeafDetails({this.leafDetailId, this.url, this.cct, this.time, this.leafId});

  LeafDetails.fromJson(Map<String, dynamic> json) {
    leafDetailId = json['leafDetailId'];
    url = json['url'];
    cct = json['cct'];
    time = json['time'];
    leafId = json['leafId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['leafDetailId'] = this.leafDetailId;
    data['url'] = this.url;
    data['cct'] = this.cct;
    data['time'] = this.time;
    data['leafId'] = this.leafId;
    return data;
  }
}