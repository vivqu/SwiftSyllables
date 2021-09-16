//
//  SwiftSyllablesHeuristic.swift
//  SwiftSyllables
//
//  Created by Vivian Qu on 7/31/16.
//
//

import Foundation

private class SwiftSyllablesHeuristicExceptions {
    static let addSyllables : [String] = ["serious", "crucial", "brilliant", "peepee"]
    static let deleteSyllables: [String] = ["fortunately", "unfortunately"]
    static let coPrefixSingleSyllables: [String] = [
        "cool", "coach", "coat", "coal",
        "count", "coin", "coarse", "coup",
        "coif", "cook", "coign", "coiffe",
        "coof", "court"]
    static let coPrefixDoubleSyllables: [String] = ["coapt", "coed", "coinci"]
    static let prePrefixSingleSyllables: [String] = ["preach"]
    static let leEndings: [String] = ["whole", "mobile", "pole", "male",
                                      "female", "hale", "pale", "tale",
                                      "sale", "aisle", "whale", "while"]
    static let negativeWords: [String] = ["doesn't", "isn't", "shouldn't", "couldn't","wouldn't"]
}

class SwiftSyllablesHeuristic {
    static let vowels: [Character] = ["a", "e", "i", "o", "u"]
    
    /*
     *  Private method to check if the char is a vowel.
     */
    fileprivate class func isVowel(_ char: Character) -> Bool {
        return vowels.contains(char)
    }
    
    fileprivate class func applyRegex(_ string: String, pattern: String) -> Int {
        let regex: NSRegularExpression = try! NSRegularExpression(pattern: pattern,
                                                                  options: [.caseInsensitive])
        return regex.numberOfMatches(in: string,
                                     options: NSRegularExpression.MatchingOptions.reportCompletion,
                                     range: NSMakeRange(0, string.count))
    }
    
    fileprivate class func rangeForIndex(_ string: String, index: Int) -> String.Index? {
        if (abs(index) >= string.count) {
            return nil
        }
        var beginIndex: String.Index = string.startIndex
        if (index < 0) {
            beginIndex = string.endIndex
        }
        return string.index(beginIndex, offsetBy: index)
    }
    
    fileprivate class func substringToIndex(_ string: String, index: Int) -> String? {
        if (abs(index) >= string.count) {
            return nil
        }
        if let index = rangeForIndex(string, index: index) {
            return String(string[..<index])
        }
        return nil
    }
    
    class func getSyllablesForWord(_ word: String) -> Int {
        let baseWord: String = word.lowercased()
        var syllables: Int = 0
        var discardedSyllables: Int = 0
        
        let numDoubleVowels: Int = applyRegex(baseWord, pattern: "[eaoui][eaoui]")
        
        // (1) if letters < 3, return 1
        let stringLength = baseWord.count
        if stringLength < 3 { return stringLength > 0 ? 1 : 0 }
        
        // (2) if letters don't end with ["ted", "tes", "ses", "ied", "ies"], then
        //     discard "es" and "ed" at the end.
        let last2CharsSubstring: String? = substringToIndex(baseWord, index: -2)
        let last3CharsSubstring: String? = substringToIndex(baseWord, index: -3)
        
        if let last2CharsSubstring = substringToIndex(baseWord, index: -2) {
            if last2CharsSubstring == "es" || last2CharsSubstring == "ed" {
                // Check # of vowels. If there is only 1 vowel or 1 set of consecutive
                // vowels, then discard.
                
                let numConsecutiveVowels = applyRegex(baseWord, pattern: "[eaoui][^eaoui]")
                if numDoubleVowels > 1 || numConsecutiveVowels > 1 {
                    if let substring = last3CharsSubstring {
                        let discardedEndings = ["ted", "tes", "ses", "ied", "ies"]
                        discardedSyllables += discardedEndings.contains(substring) ? 0 : 1;
                    }
                }
            }
        }
        
        // (3) Discard trailing "e", except where ending is "le"
        guard let lastChar = baseWord.last else { return 0 }
        if lastChar == "e" && last2CharsSubstring != "le" {
            discardedSyllables += 1
        } else if SwiftSyllablesHeuristicExceptions.leEndings.contains(baseWord) {
            discardedSyllables += 1
        }
        
        // (4) Check if consecutive vowels exists (triplets or pairs) and count them as one.
        let numTripleVowels: Int = applyRegex(baseWord, pattern: "[eaoui][eaoui][eaoui]")
        discardedSyllables += numDoubleVowels + numTripleVowels
        
        
        // (5) Count remaining vowels in word
        let totalNumVowels: Int = applyRegex(baseWord, pattern: "[eaoui]")
        
        // (6) Add one if starts with "mc"
        let first2Substring = substringToIndex(baseWord, index: 2)
        if first2Substring == "mc" { syllables += 1 }
        
        // (7) Add one if ends with "y" but is not surrounded by vowel
        if lastChar == "y", let last2CharsIndex = rangeForIndex(baseWord, index: -2) {
            syllables += isVowel(baseWord[last2CharsIndex]) ? 0 : 1;
        }
        
        // (8) Add one if "y" is surrounded by non-vowels and is not in the last word.
        for i in 1..<(stringLength-1) {
            guard let checkIndex = rangeForIndex(baseWord, index: i) else { break }
            if (isVowel(baseWord[checkIndex]) == false) { continue }
            let nextIndex = baseWord.index(checkIndex, offsetBy: 1)
            if baseWord[nextIndex] == "y" {
                // Check following index
                if (nextIndex.utf16Offset(in: baseWord) == stringLength - 1) {
                    break
                }
                let finalIndex = baseWord.index(nextIndex, offsetBy: 1)
                syllables += isVowel(baseWord[finalIndex]) ? 1 : 0
            }
        }
        
        // (9) If starts with "tri-" or "bi-" and is followed by a vowel, add one.
        guard let first2CharsIndex = rangeForIndex(baseWord, index: 1) else { return 1 }
        guard let first2CharsSubstring = substringToIndex(baseWord, index: 2) else { return 1 }
        let first3CharsIndex : String.Index? = baseWord.index(first2CharsIndex, offsetBy: 1)
        if first3CharsIndex != nil && (first2CharsSubstring == "bi" || String(baseWord[..<first3CharsIndex!]) == "tri") {
            syllables += isVowel(baseWord[first3CharsIndex!]) ? 1 : 0
        }
        
        // (10) If ends with "-ian", should be counted as two syllables, except for "-tian" and "-cian"
        if last3CharsSubstring == "ian" && baseWord.count >= 4 {
            if let index = rangeForIndex(baseWord, index: -4) {
                let fourthLastCharacter = baseWord[index]
                syllables += (fourthLastCharacter == "c" || fourthLastCharacter == "t") ? 0 : 1
            }
        }
        
        
        
        // (11) If starts with "co-" and is followed by a vowel,
        //      check if exists in the double syllable dictionary.
        //      If not, check if in single dictionary and act accordingly.
        if first2CharsSubstring == "co" {
            if let first3CharsIndex = rangeForIndex(baseWord, index: 2) {
                if isVowel(baseWord[first3CharsIndex]) {
                    if let first6CharsSubstring = substringToIndex(baseWord, index: 6) {
                        syllables += first6CharsSubstring == "preach" ? 0 : 1
                    }
                }
            }
        }
        
        // (13) check for "-n't" and cross match with dictionary to add syllable.
        if last3CharsSubstring == "n't" && SwiftSyllablesHeuristicExceptions.negativeWords.contains(baseWord) {
            syllables += 1
        }
        
        // (14) Handling the exceptional words.
        if SwiftSyllablesHeuristicExceptions.deleteSyllables.contains(baseWord) {
            discardedSyllables += 1
        }
        
        if SwiftSyllablesHeuristicExceptions.addSyllables.contains(baseWord) {
            syllables += 1
        }
        
        let finalSyllables = totalNumVowels - discardedSyllables + syllables
        return finalSyllables > 0 ? finalSyllables : 1 // Return at least one syllable
    }
}

