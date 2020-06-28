# SwiftSyllables

[![Version](https://img.shields.io/cocoapods/v/SwiftSyllables.svg?style=flat)](http://cocoapods.org/pods/SwiftSyllables)
[![License](https://img.shields.io/cocoapods/l/SwiftSyllables.svg?style=flat)](http://cocoapods.org/pods/SwiftSyllables)
[![Platform](https://img.shields.io/cocoapods/p/SwiftSyllables.svg?style=flat)](http://cocoapods.org/pods/SwiftSyllables)

A lightweight syllable counter written in Swift.

⚠️ **To use with Swift 5.x please ensure you are using >= 0.1.6** ⚠️

⚠️ **To use with Swift 4.x please ensure you are using = 0.1.5** ⚠️

## Background

Syllable counting does not have a simple algorithmic solution so this framework takes a combination of dictionary lookups and heuristics, in two parts:

(1) Python's [Natural Language Toolkit](http://www.nltk.org/) includes a wide range of corpus for language processing. Python NLTK takes advantage of the [CMU Pronunciation Dictionary](http://www.speech.cs.cmu.edu/cgi-bin/cmudict) which contains pronounciation transcriptions for over 100,000 words. If the word is found within the pronunciation dictionary, the first valid pronunciation is used to find the number of syllables.

(2) If the word is not found within the pronunciation dictionary, SwiftSyllables defaults to a heuristic solution. We used a straightforward implementation of [Emre Aydin's heuristic syllable counting algorithm](http://eayd.in/?p=232).

The current most robust algorithmic solution to syllable counting is Frank Liang's [Stanford PhD dissertation](http://www.tug.org/docs/liang/) -- the implementation of the algorithm for this framework is not currently planned.

## Requirements

Uses Swift 5.0, run on Xcode 11+.

## Installation

SwiftSyllables is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "SwiftSyllables"
```

## Example

SwiftSyllables currently has one simple API for getting the syllable count from a string:

```
open class func getSyllables(_ string: String) -> Int
```

Simply import the framework and call the `getSyllables` method.

```
import SwiftSyllables

...

var syllables : Int = SwiftSyllables.getSyllables(string)
```

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Author

* **Vivian Qu** - [hello@vivqu.com](mailto:hello@vivqu.com)

## License

SwiftSyllables is available under the MIT license. See the LICENSE file for more info.

## Acknowledgments

* Python's [Natural Language Toolkit](http://www.nltk.org/)
* [CMU Pronunciation Dictionary](http://www.speech.cs.cmu.edu/cgi-bin/cmudict)
* [Emre Aydin's heuristic syllable counting algorithm](http://eayd.in/?p=232)
* Brandon Wood's ["Using Python and the NLTK to Find Haikus in the Public Twitter Stream"](http://h6o6.com/2013/03/using-python-and-the-nltk-to-find-haikus-in-the-public-twitter-stream/)
