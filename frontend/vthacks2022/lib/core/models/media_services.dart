enum MediaServices {
  netflix,
  hulu,
  amazonPrime,
  disney,
  hboMax,
  appleTV,
}

extension MediaServicesMap on MediaServices {
  static const valueMap = {
    MediaServices.netflix: "Netflix",
    MediaServices.hulu: "Hulu",
    MediaServices.amazonPrime: "Prime Video",
    MediaServices.disney: "Disney+",
    MediaServices.hboMax: "HBO Max",
    MediaServices.appleTV: "Apple TV+",
  };

  String? get value => valueMap[this];

  static MediaServices fromString(String input) {
    final reverseValueMap = valueMap
        .map<String, MediaServices>((key, value) => MapEntry(value, key));

    MediaServices? output = reverseValueMap[input];
    if (output == null) {
      throw 'Invalid String Input';
    }

    return output;
  }
}
