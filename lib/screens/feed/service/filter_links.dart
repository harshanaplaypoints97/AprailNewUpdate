class FilterLinksService {
  List<String> filterLinks(String text) {
    List<String> links = [];
    RegExp exp = RegExp(r'(?:(?:https?|ftp):\/\/)?[\w/\-?=%.]+\.[\w/\-?=%.]+');
    Iterable<RegExpMatch> matches = exp.allMatches(text);

    for (var match in matches) {
      links.add(text.substring(match.start, match.end));
    }
    return links;
  }
}
