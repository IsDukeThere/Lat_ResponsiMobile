class DataResponse {
  final List<DataDetail> dataDetail;

  DataResponse({required this.dataDetail});

  factory DataResponse.fromJson(Map<String, dynamic> json) {
    return DataResponse(
      dataDetail: List<DataDetail>.from(
        json['dataDetail'].map((x) => DataDetail.fromJson(x)),
      )
    );
  }

  Map<String, dynamic> toJson() => {
    "dataDetail": List<dynamic>.from(dataDetail.map((x) => x.toJson()))
  };
}

class DataDetail {
  final int head;
  final String character;
  final String amiiboSeries;
  final String gameSeries;
  final String image;
  final String name;
  final int tail;
  final String type;
  final Release release;

  DataDetail({
  required this.head,
  required this.character,
  required this.amiiboSeries,
  required this.gameSeries,
  required this.image,
  required this.name,
  required this.tail,
  required this.type,
  required this.release
  });

  factory DataDetail.fromJson(Map<String, dynamic> json) {
    return DataDetail(
      head: json ['head'], 
      character: json ['character'], 
      amiiboSeries: json ['amiiboSeries'], 
      gameSeries: json ['gameSeries'], 
      image: json ['image'], 
      name: json ['name'], 
      tail: json ['tail'], 
      type: json ['type'], 
      release: Release.fromJson(json['release']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "head": head,
      "character": character,
      "amiiboSeries": amiiboSeries,
      "gameSeries": gameSeries,
      "image": image,
      "name": name,
      "tail": tail,
      "type": type,
      "release": release.toJson(),
    };
  }
}

class Release {
    final String? au;
    final String? eu;
    final String? jp;
    final String? na;

    Release({this.au, this.eu, this.jp, this.na});

    factory Release.fromJson(Map<String, dynamic> json) {
      return Release(
        au: json['au'],
        eu: json['eu'],
        jp: json['jp'],
        na: json['na'],
      );
    }

    Map<String, dynamic> toJson() => {
      "au": au,
      "eu": eu,
      "jp": jp,
      "na": na,
    };
  }