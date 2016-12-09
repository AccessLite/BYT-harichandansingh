//
//  String+Extension.swift
//  Boarding Pass
//
//  Created by Harichandan Singh on 12/9/16.
//  Copyright © 2016 Harichandan Singh. All rights reserved.
//

import Foundation

extension String {
    func filterFoulWords() -> String {
        var words = self.components(separatedBy: " ")
        for (index, word) in words.enumerated() {
            let filteredWord = word.replacingOccurrences(of: word, with: filter(word), options: .caseInsensitive, range: nil)
            words[index] = filteredWord
        }
        return words.joined(separator: " ")
    }
    
    private func filter(_ word: String) -> String {
        let wordsToBeFiltered: Set<String> = ["fuck", "bitch", "ass", "dick", "pussy", "shit", "twat", "cunt", "cock"]
        let vowels: Set<Character> = ["a", "e", "i", "o", "u"]
        
        for foulWord in wordsToBeFiltered where word.lowercased().contains(foulWord){
            for char in word.lowercased().characters {
                if vowels.contains(char) {
                    return word.replacingOccurrences(of: String(char), with: "*", options: .caseInsensitive, range: nil)
                }
            }
        }
        return word
    }
    
}
