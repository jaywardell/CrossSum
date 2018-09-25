//
//  Rational.swift
//  Swift Math
//
//  Created by Joseph Wardell on 5/21/16.
//  Copyright © 2016 Joseph Wardell. All rights reserved.
//

import Foundation


// a number that can be represented by a numerator and a denominator

// TODO: idk how this class deals with infinity, there are probably some issues

public struct Rational {
    
    public let numerator : Int
    public let denominator : Int
    
    public init(_ inNumerator:Int, _ inDenominator:Int=1) {
        denominator = inDenominator
        numerator = inNumerator
    }
    
    init(_ rational:Rational) {
        self.init(rational.numerator, rational.denominator)
    }
    
    public init?(_ string:String) {
        
        // TODO: It would be awesome to allow for initializing via mixed number strings (e.g. "1 1/2" would become Rational(3,2)
        
        let parts = string.split(separator: "/")
        if parts.count == 1,
            let n = parts.first?.trimmingCharacters(in: .whitespaces),
            let num = Int(n) {
            self.init(num, 1)
        }
        else if parts.count == 2,
            let n = parts.first?.trimmingCharacters(in: .whitespaces),
            let d = parts.last?.trimmingCharacters(in: .whitespaces),
            let num = Int(n),
            let den = Int(d) {
            self.init(num, den)
        }
        else {
            return nil
        }
    }
    
    /// builds a Rational value from the double value passed in
    ///
    /// - Parameter double: a double value, or nil if one could not be created
    /// Note 1: infinitely repeating decimals will equal their fractionally inited counterparts (e.g. Rational(1,3) != Rational(1.0/3)
    /// Note 2: returns nil for infinite values
    public init?(_ double:Double) {
        guard !double.isInfinite else { return nil }
        guard !double.isNaN else {
            // we can represent nan as 1/0
            self.init(1,0)
            return
        }
        
        // TODO: I'd like to be able to do this mathematically, but this works
        let s = String(double)
        let parts = s.split(separator: ".")
        let i = parts[0]
        let f = parts[1]

        // I don't think I need this check, but it's here in case I may one day
//        guard let w = Int(i),
//            let n = Int(f) else { return nil }

        // note: there's a fair amount of moving the negative sign around in the case of negative numbers, tread carefully
        let w = Int(i)!
        let n = Int(f)! * (w < 0 ? -1 : 1)  // negative numbers will need the numerator subtracted, not added, in the last step
        let sign = (w == 0 && double < 0.0) ? -1 : 1
        let d = Int(pow(Double(10), Double(f.count)))
        self.init(sign * (w*d+n), d)
    }
    
    public var isNan : Bool {
        return denominator == 0
    }
    
    public var decimalValue : Double {
        return Double(numerator)/Double(denominator)
    }
    
    public var integerPart : Int? {
        guard !isNan else { return nil }
        return numerator/denominator
    }
    
    public var fractionalPart : Rational? {
        guard !isNan else { return nil }
        let remainder = numerator % denominator
        return Rational(remainder, denominator)
    }
    
    public var abs : Rational {
        return self < 0 ? -self : self
    }
    
    public var rounded : Int? {
        guard let integerPart = integerPart,
            let fractionalPart = fractionalPart else { return nil }

        if self > 0 {
            return integerPart + (fractionalPart < 0.5 ? 0 : 1)
        }
        return integerPart - (fractionalPart.abs > 0.5 ? 1 : 0)
    }
    
    /// standardizes the Rational
    ///
    /// standardizes the Rational by
    /// * reducing it to simplest terms
    /// * moving any negative sign in the denominator to the numerator
    public var standardized : Rational {
        
        func gcf(_ l:Int, _ r:Int) -> Int {
            let l = Swift.abs(l)
            let r = Swift.abs(r)
            
            var out = 1
            var i = 2
            while i <= max(l/2, r/2) + 1 {
                if 0 == l%i && 0 == r%i {
                    out = i
                }
                i += 1
            }
            return out
        }
        
        let g = gcf(numerator, denominator)
        let num = numerator/g
        let den = denominator/g
        
        if den < 0 {
            return Rational(-num, -den)
        }
        return Rational(num, den)
    }
    
    // MARK:- Basic Operations

    func addedTo(_ addend:Rational) -> Rational {
        let num1 = numerator * addend.denominator
        let num2 = addend.numerator * denominator
        let den = denominator * addend.denominator
        return Rational(num1+num2,den)
    }

    func minus(_ subtrahend:Rational) -> Rational {
        let num1 = numerator * subtrahend.denominator
        let num2 = subtrahend.numerator * denominator
        let den = denominator * subtrahend.denominator
        return Rational(num1-num2,den)
    }

    func multipliedBy(_ factor:Rational) -> Rational {
        let newNumerator = numerator * factor.numerator
        let newDenominator = denominator * factor.denominator
        return  Rational(newNumerator, newDenominator)
    }

    func dividedBy(_ divisor:Rational) -> Rational {
        let newNumerator = numerator * divisor.denominator
        let newDenominator = denominator * divisor.numerator
        return  Rational(newNumerator, newDenominator)
    }
}

// MARK:-

public func + (lhs:Rational, rhs:Rational) -> Rational {
    return lhs.addedTo(rhs)
}
public func + (lhs:Rational, rhs:Int) -> Rational {
    return lhs.addedTo(Rational(rhs))
}
public func + (lhs:Int, rhs:Rational) -> Rational {
    return Rational(lhs).addedTo(Rational(rhs))
}

public func - (lhs:Rational, rhs:Rational) -> Rational {
    return lhs.minus(rhs)
}
public func - (lhs:Int, rhs:Rational) -> Rational {
    return Rational(lhs).minus(rhs)
}
public func - (lhs:Rational, rhs:Int) -> Rational {
    return lhs.minus(Rational(rhs))
}

public func * (lhs:Rational, rhs:Rational) -> Rational {
    return lhs.multipliedBy(rhs)
}
public func * (lhs:Rational, rhs:Int) -> Rational {
    return lhs.multipliedBy(Rational(rhs))
}
public func * (lhs:Int, rhs:Rational) -> Rational {
    return Rational(lhs).multipliedBy(rhs)
}

public func / (lhs:Rational, rhs:Rational) -> Rational {
    return lhs.dividedBy(rhs)
}
public func / (lhs:Int, rhs:Rational) -> Rational {
    return Rational(lhs).dividedBy(rhs)
}
public func / (lhs:Rational, rhs:Int) -> Rational {
    return lhs.dividedBy(Rational(rhs))
}

public prefix func -(value:Rational) -> Rational {
    return Rational(-value.numerator, value.denominator)
}

extension Rational : Equatable {}
public func ==(lhs: Rational, rhs: Rational) -> Bool {
    let lhsnum = lhs.numerator * rhs.denominator
    let rhsnum = rhs.numerator * lhs.denominator
    return lhsnum == rhsnum
}

// MARK:- Comparison
extension Rational : Comparable {
    public static func < (lhs: Rational, rhs: Rational) -> Bool {
        if lhs.denominator == rhs.denominator {
            return lhs.numerator < rhs.numerator
        }
        // having negative denominators can cause reversals of direction, so we must standardize before comparing
        let lhss = lhs.standardized
        let rhss = rhs.standardized
        return lhss.numerator * rhss.denominator < rhss.numerator * lhss.denominator
    }
}


// sadly, I need to overload every single comparison operator when comparing Rationals to Ints or Doubles

// compare to Int
public func < (lhs: Rational, rhs: Int) -> Bool {
    return lhs < Rational(rhs)
}
public func < (lhs: Int, rhs: Rational) -> Bool {
    return Rational(lhs) < rhs
}
public func <= (lhs: Rational, rhs: Int) -> Bool {
    return lhs <= Rational(rhs)
}
public func <= (lhs: Int, rhs: Rational) -> Bool {
    return Rational(lhs) <= rhs
}

public func > (lhs: Rational, rhs: Int) -> Bool {
    return lhs > Rational(rhs)
}
public func > (lhs: Int, rhs: Rational) -> Bool {
    return Rational(lhs) > rhs
}
public func >= (lhs: Rational, rhs: Int) -> Bool {
    return lhs >= Rational(rhs)
}
public func >= (lhs: Int, rhs: Rational) -> Bool {
    return Rational(lhs) >= rhs
}


// compare to Double
public func < (lhs: Rational, rhs: Double) -> Bool {
    return lhs < Rational(rhs)!
}
public func < (lhs: Double, rhs: Rational) -> Bool {
    return Rational(lhs)! < rhs
}
public func <= (lhs: Rational, rhs: Double) -> Bool {
    return lhs <= Rational(rhs)!
}
public func <= (lhs: Double, rhs: Rational) -> Bool {
    return Rational(lhs)! <= rhs
}

public func > (lhs: Rational, rhs: Double) -> Bool {
    return lhs > Rational(rhs)!
}
public func > (lhs: Double, rhs: Rational) -> Bool {
    return Rational(lhs)! > rhs
}
public func >= (lhs: Rational, rhs: Double) -> Bool {
    return lhs >= Rational(rhs)!
}
public func >= (lhs: Double, rhs: Rational) -> Bool {
    return Rational(lhs)! >= rhs
}

// MARK:- ExpressibleByIntegerLiteral

extension Rational : ExpressibleByIntegerLiteral {

    public typealias IntegerLiteralType = Int

    public init(integerLiteral value: Int) {
        self.init(value)
    }
}

// MARK:- ExpressibleByIntegerLiteral

extension Rational : ExpressibleByFloatLiteral {
    public typealias FloatLiteralType = Double
    
    public init(floatLiteral value: Double) {
        self.init(value)!
    }
}

// MARK:- ExpressibleByStringLiteral

extension Rational : ExpressibleByStringLiteral {
    public typealias StringLiteralType = String
    
    public init(stringLiteral:String) {
        self.init(stringLiteral)!
    }
}

// MARK:- CustomStringConvertible

extension Rational : CustomStringConvertible {
    public var description : String {
        let s = self.standardized
        
        guard let w = s.integerPart,
            let f = s.fractionalPart else {
                return isNan ?
                    "nan" : "unknown rational number \(numerator)/\(denominator)"
        }
        
        if w == 0 {
            if f.numerator != 0 {
                return "\(f.numerator)/\(f.denominator)"
            }
            else {
                return "0"
            }
        }
        let ff = f < 0 ? -f : f
        let fd = ff.description
        
        return "\(w)" + (fd != "0" ? " \(fd)" : "")
    }
}

// MARK:-

public extension Double {
    init(_ rational:Rational) {
        self = rational.decimalValue
    }
}

