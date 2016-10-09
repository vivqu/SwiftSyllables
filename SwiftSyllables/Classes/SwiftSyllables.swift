//
//  SwiftSyllables.swift
//  SwiftSyllables
//
//  Created by Vivian Qu on 7/30/16.
//
//

import Foundation

open class SwiftSyllables {
    private static let fileName : String = "cmudict"
    private static let resourcePath = mainBundle.path(forResource: fileName, ofType: nil)
    internal static var mainBundle : Bundle = Bundle.main

    // Static variable for syllable dictionary
    static var syllableDict : [String: Int] = [String: Int]()

    /*
     *  Use NSLinguisticTagger to tag valid words
     */
    fileprivate class func validWords(_ text: String, scheme: String) -> [String] {
        let options = UInt(NSLinguisticTagger.Options.omitWhitespace.rawValue | NSLinguisticTagger.Options.omitPunctuation.rawValue | NSLinguisticTagger.Options.omitOther.rawValue)
        let taggerOptions : NSLinguisticTagger.Options = NSLinguisticTagger.Options(rawValue: options)
        let tagger = NSLinguisticTagger(tagSchemes: NSLinguisticTagger.availableTagSchemes(forLanguage: "en"),
            options: Int(options))
        tagger.string = text

        var validWords: [String] = []
        tagger.enumerateTags(in: NSMakeRange(0, text.characters.count), scheme:scheme, options: taggerOptions) {
            tag, tokenRange, _, _ in let string = (text as NSString).substring(with: tokenRange)
            if tag == "Word" {
                if let firstChar = string.characters.first {
                    if firstChar != "\'" {
                        // Exclude words that start with an apostraphe
                        validWords.append(string)
                    }
                }
            }
        }
        return validWords
    }

    /*
     *  Read syllable dictionary from the bundle
     */
    fileprivate class func configureSyllableDict() -> [String : Int]? {
        if self.syllableDict.count == 0 {
            // Read pronunciation dictionary from bundle
            guard let path = resourcePath else { return nil }
            let data : NSMutableData? = NSMutableData.init(contentsOfFile: path)
            if let foundData = data {
                let unarchiver : NSKeyedUnarchiver = NSKeyedUnarchiver.init(forReadingWith: foundData as Data)
                let dict : Any? = unarchiver.decodeObject(forKey: "cmudict")
                unarchiver.finishDecoding()
                if let processedDict = dict as? [String : Int] {
                    self.syllableDict = processedDict
                }
            }

        }
        return self.syllableDict
    }

    /*
     *  Public methods
     */
    open class func getSyllables(_ string: String) -> Int {
        guard let syllableDict = self.configureSyllableDict() else { return 0 }

        // Tokenize the string and read from the corpus
        var countSyllables = 0
        let taggedWords : [String] = self.validWords(string, scheme: NSLinguisticTagSchemeTokenType)
        for word : String in taggedWords {
            let upperCase = word.uppercased()
            if let syllables = syllableDict[upperCase] {
                countSyllables += syllables
            } else {
                // Fall back to heuristic algorithm
                countSyllables += SwiftSyllablesHeuristic.getSyllablesForWord(word)
            }
        }
        return countSyllables
    }
}
