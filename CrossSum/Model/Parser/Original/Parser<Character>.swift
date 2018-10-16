//
//  Parser<Character>.swift
//  ExpressionParser_iOS
//
//  Created by Joseph Wardell on 9/16/18.
//  Copyright © 2018 Joseph Wardell. All rights reserved.
//

import Foundation

extension Parser where A == Character {
    private static func character(condition: @escaping (Character) -> Bool) -> Parser<Character> {
        return Parser() { stream in
            guard let character = stream.first, condition(character) else { return nil }
            return (character, stream.dropFirst())
        }
    }
        
    private static func character(_ characters:[Character]) -> Parser<Character> {
        return Parser<Character>.character() {
            characters.contains($0)
        }
    }
    
    static func character(in string:String) -> Parser<Character> {
        return character(Array(string))
    }


    static let whitespace = Parser.character()
    { $0.unicodeScalars.contains(where: CharacterSet.whitespaces.contains) }.many

    static let ignoredWhitespace = Parser.character()
    { $0.unicodeScalars.contains(where: CharacterSet.whitespaces.contains) }.many.ignored

    static let digit = Parser.character()
    { $0.unicodeScalars.contains(where: CharacterSet.decimalDigits.contains) }

    static var digits = digit.many.trimmingWhitespace.map {
        $0.count > 0 ? String($0) : nil
    }    
    
    static var pos_negDigits : Parser<String> {
        return Parser<String> { stream in
            let neg = character(in:"-").parse(stream)
            let remainder =  neg?.1 ?? stream
            guard let d = digits.parse(remainder),
            let dd = d.0 else { return nil }
            
            let prefix = neg?.0 != nil ? "\(neg!.0)" : ""
            return (prefix + dd, d.1)
        }
    }
    
    func string(length:Int?=nil) -> Parser<String> {
        return Parser<String> { stream in
            
            var characters = [Character]()
            var str = stream
            while let r = self.parse(str) {
                characters.append(r.0)
                str = r.1
                if let length = length,
                    characters.count >= length {
                    break
                }
            }
            return (String(characters), str)
        }
    }
    
}
