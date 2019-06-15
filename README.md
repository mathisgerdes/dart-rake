[![Build Status](https://travis-ci.com/mathisgerdes/dart-rake.svg?branch=master)](https://travis-ci.com/mathisgerdes/dart-rake)
# RAKE
Implementation of the *Rapid Automatic Keyword Extraction algorithm* (RAKE)

Broadly based on the python implementation at
[github.com/fabianvf/python-rake](https://github.com/fabianvf/python-rake)

Based on
Rose, S. , Engel, D. , Cramer, N. and Cowley, W. (2010).
*Automatic Keyword Extraction from Individual Documents*.
In Text Mining (eds M. W. Berry and J. Kogan).
[doi:10.1002/9780470689646.ch1](https://doi.org/10.1002/9780470689646.ch1)

## Usage

A simple usage example:

```dart
import 'package:rake/rake.dart';

main() {
  final rake = Rake();
  // only keywords with length >= 5
  // and at least two occurrences
  print(rake.rank('this large world', minChars: 5, minFrequency: 2));
}
```
