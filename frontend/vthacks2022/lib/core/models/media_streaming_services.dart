enum MediaStreamingServices {
  netflix,
  hulu,
  amazonPrime,
  disney,
  hboMax,
  appleTV,
}

extension MediaStreamingServicesUI on MediaStreamingServices {
  static String displayName(MediaStreamingServices value) {
    return MediaStreamingServicesMap.valueMap[value] ?? "Error";
  }
}

extension MediaStreamingServicesMap on MediaStreamingServices {
  static const valueMap = {
    MediaStreamingServices.netflix: "Netflix",
    MediaStreamingServices.hulu: "Hulu",
    MediaStreamingServices.amazonPrime: "Prime Video",
    MediaStreamingServices.disney: "Disney+",
    MediaStreamingServices.hboMax: "HBO Max",
    MediaStreamingServices.appleTV: "Apple TV+",
  };

  String? get value => valueMap[this];

  static MediaStreamingServices fromString(String input) {
    final reverseValueMap = valueMap.map<String, MediaStreamingServices>(
        (key, value) => MapEntry(value, key));

    MediaStreamingServices? output = reverseValueMap[input];
    if (output == null) {
      throw 'Invalid String Input';
    }

    return output;
  }
}
