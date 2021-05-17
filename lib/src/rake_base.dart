import 'package:rake/src/parse_num.dart';
import 'package:rake/src/smart_english.dart';

final RegExp _wordSplitter = RegExp(r'[^a-zA-Z0-9_\+\-/]');

final RegExp _sentenceDelimiter =
    RegExp('[.!?,;:\t\\\\"\\(\\)\\\'\u2019\u2013]|\\s\\-\\s');

// Note on nomenclature: Text > Sentence > Phrase = Keyword > Word

/// Split text into words
List<String> splitWords(String text) => text
    .split(_wordSplitter)
    .map((w) => w.trim().toLowerCase())
    .where((w) => w != '' && !isNum(w))
    .toList(growable: false);

/// Split text into sentences
List<String> splitSentences(String text) => text.split(_sentenceDelimiter);

/// Build stop word RegExp based on list of stop words
RegExp buildStopWordRegExp(List<String> stopWords) =>
    RegExp(stopWords.map((w) => r'\b' + w + r'(?![\w-])').join('|'),
        caseSensitive: false);

/// Split and collect phrases in sentences
List<String> splitPhrases(List<String> sentences, RegExp stopWords,
    {int minChars = 0}) {
  List<String> phrases = [];
  for (final sentence in sentences) {
    phrases.addAll(sentence
        .trim()
        .split(stopWords)
        .map((p) => p.trim().toLowerCase().replaceAll('\n', ''))
        .where((p) => p != '' && p.length >= minChars));
  }
  return phrases;
}

/// Score words in phrases
Map<String, double> calculateWordScores(List<String> phrases) {
  Map<String, int> wordFrequency = Map();
  Map<String, double> wordDegree = Map();
  for (final phrase in phrases) {
    final wordList = splitWords(phrase);
    final wordListCount = wordList.length;
    final wordListDegree = wordListCount - 1;
    for (final word in wordList) {
      wordFrequency.putIfAbsent(word, () => 0);
      wordFrequency[word] = wordFrequency[word]! + 1;
      wordDegree.putIfAbsent(word, () => 0);
      wordDegree[word] = wordDegree[word]! + wordListDegree;
    }
  }
  for (final word in wordFrequency.keys) {
    wordDegree[word] = wordDegree[word]! + wordFrequency[word]!;
  }

  Map<String, double> wordScore = Map();
  for (final word in wordFrequency.keys) {
    wordScore.putIfAbsent(word, () => 0);
    wordScore[word] = wordDegree[word]! / wordFrequency[word]!;
  }
  return wordScore;
}

Map<String, double> calculateKeywordScores(
    List<String> phrases, Map<String, double> wordScore,
    {int? minFrequency}) {
  Map<String, double> keywordCandidates = Map();
  late Map<String, int> frequencies;
  if (minFrequency != null) {
    frequencies = Map();
    phrases.forEach((phrase) =>
        frequencies.update(phrase, (v) => v + 1, ifAbsent: () => 1));
  }
  for (final phrase in phrases) {
    if (minFrequency != null && frequencies[phrase]! < minFrequency) continue;
    keywordCandidates.putIfAbsent(phrase, () => 0);
    final words = splitWords(phrase);
    double candidateScore = 0;
    for (final word in words) {
      candidateScore += wordScore[word]!;
    }
    keywordCandidates[phrase] = candidateScore;
  }
  return keywordCandidates;
}

class Rake {
  Rake({this.stopWords = smartEnglish})
      : _stopWordPattern = buildStopWordRegExp(stopWords);

  final List<String> stopWords;
  final RegExp _stopWordPattern;

  /// Extract keywords and sores found in a text
  Map<String, double> run(String text, {int? minChars, int? minFrequency}) {
    final List<String> sentences = splitSentences(text);
    final List<String> phrases =
        splitPhrases(sentences, _stopWordPattern, minChars: (minChars ?? 0));
    final Map<String, double> wordScores = calculateWordScores(phrases);
    return calculateKeywordScores(phrases, wordScores,
        minFrequency: minFrequency);
  }

  /// Extract a list of keywords, ordered by score
  List<String> rank(String text, {int? minChars, int? minFrequency}) {
    final keywordScores =
        run(text, minFrequency: minFrequency, minChars: minChars);
    final keywords = keywordScores.keys.toList();
    keywords.sort((a, b) =>
        a == b ? 0 : (keywordScores[a]! > keywordScores[b]! ? -1 : 1));
    return keywords;
  }
}
