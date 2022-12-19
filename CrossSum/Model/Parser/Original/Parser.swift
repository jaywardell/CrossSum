//
//  Parser.swift
//  ExpressionParser_iOS
//
//  Created by Joseph Wardell on 9/16/18.
//  Copyright © 2018 Joseph Wardell. All rights reserved.
//

import Foundation


public struct Parser<A> {
    public typealias Stream = String.SubSequence
    public let parse: (Stream) -> (A, Stream)?
}

public extension Parser {
    
    // TODO: var repeat, uses a function to repeatedly call self and calculate a result until the parser fails
    
    /// returns a parser that will parse the entire string
    /// so if there's a remaining string after the parser is finished,
    /// then it will return nil
    var complete: Parser<A> {
        return Parser<A> { stream in
            let r = self.parse(stream)
            guard r?.1.count == 0  else { return nil }
            return r
        }
    }
    
    var ignored: Parser<String?> {
        return Parser<String?> { stream in
            let r = self.parse(stream)
            let s : String? = nil
            return (s, r?.1) as? (String?, Parser.Stream)
        }
    }
    
    
    var many: Parser<[A]> {
        return Parser<[A]> { stream in
            var result: [A] = []
            var remainder = stream
            while let (element, newRemainder) = self.parse(remainder) {
                result.append(element)
                remainder = newRemainder
            }
            return (result, remainder)
        }
    }
    
    func map<T>(_ transform: @escaping (A)->(T)) -> Parser<T> {
        return Parser<T> { stream in
            guard let (result, remainder) = self.parse(stream) else { return nil }
            return (transform(result), remainder)
        }
    }
    
    func followed<B>(by other: Parser<B>) -> Parser<(A, B)> {
        return Parser<(A,B)> { input in
            guard let (result1, remainder1) = self.parse(input) else { return nil }
            guard let (result2, remainder2) = other.parse(remainder1) else { return nil }
            return ((result1, result2), remainder2)
        }
    }
    
    func optional(_ parser:Parser<A>) -> Parser<A> {
        return Parser<A> { stream in
            
            if let p = parser.parse(stream) {
                return p
            }
            return self.parse(stream) 
        }
    }

    static func repeatableInfix(_ term:Parser<A>, _ op:Parser<Character>, operation:@escaping (A, Character, A)->A) -> Parser<A> {
        
        return Parser<A> { stream in

            // parse the first term
            var o : A?
            var r : Parser.Stream
            guard let p = term.parse(stream) else { return nil }

            o = p.0
            r = p.1
            
            // repeatedly parse operator + term until we've exhausted the string
            while nil != o && r.count != 0 {
                guard let (c, rr) = op.parse(r) else { return (o!, r) }
                guard let (t, rrr) = term.parse(rr) else { return (o!, r) }

                o = operation(o!, c, t)
                r = rrr
            }
            
            guard let out = o else { return nil }
            return (out, "")

        }
    }
    
    var trimmingWhitespace : Parser<A> {
        
        return Parser<A> { stream in
            guard let (_, r) = Parser<Character>.ignoredWhitespace.parse(stream) else { return nil }
            
            guard let (string, r2) = self.parse(r) else { return nil }
            let (_, r3) = Parser<Character>.ignoredWhitespace.parse(r2)!
            return (string, r3)
        }
        
    }

}
