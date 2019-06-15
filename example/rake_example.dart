import 'package:rake/rake.dart';

final exampleText =
"""Compatibility of systems of linear constraints over the set of 
natural numbers. Criteria of compatibility of a system of linear 
Diophantine equations, strict inequations, and nonstrict inequations 
are considered. Upper bounds for components of a minimal set of solutions 
and algorithms of construction of minimal generating sets of solutions for 
all types of systems are given. These criteria and the corresponding 
algorithms for constructing a minimal supporting set of solutions can be 
used in solving all the considered types of systems and systems 
of mixed types.""";

main() {
  final rake = Rake();
  // only keywords with length >= 5
  // and at least two occurrences
  print(rake.rank('this large world', minChars: 5, minFrequency: 2));
}
