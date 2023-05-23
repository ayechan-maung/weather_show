

class SearchResults {
  int? id;
  String? name;
  String? region;
  String? country;
  double? lat;
  double? lon;
  String? url;

  SearchResults(
      {this.id,
        this.name,
        this.region,
        this.country,
        this.lat,
        this.lon,
        this.url});

  SearchResults.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    region = json['region'];
    country = json['country'];
    lat = json['lat'];
    lon = json['lon'];
    url = json['url'];
  }
}
