//
//  Collection+SpecialIteration.swift
//  Bouncy Bao Test Suite
//
//  Created by Joseph Wardell on 8/12/18.
//  Copyright © 2018 Joseph Wardell. All rights reserved.
//

extension Collection {
    
    public func forAll(_ callback:(Element)->Bool) -> Bool {
        for this in enumerated() {
            if !callback(this.element) {
                return false
            }
        }
        return true
    }
    
    public func forAny(_ callback:(Element)->Bool) -> Bool {
        for this in enumerated() {
            if callback(this.element) {
                return true
            }
        }
        return false
    }
    
    public func allTheSame<T:Equatable>(_ callback:(Element)->T) -> Bool {
        
        let results = map(callback)
        
        let d = results.dropFirst()
        for this in  d {
            if results.first != this {
                return false
            }
        }
        return true
    }
    
    /// processes the block passed in for each element. The block is expected to modify the array passed in based on what it encounters in the collection, returns an array of Output objects
    ///
    /// Ths method is very much like map() a generic combination of map() and filter()
    ///
    /// - Parameter block: a block which takes an Element and adds 0, 1 or more elements to the output array
    /// - Returns: an array of Output objects
    public func collect<Output>(_ block:(Element, inout [Output])->()) -> [Output] {
        
        var out = [Output]()
        forEach() { this in
            block(this, &out)
        }
        return out
    }
    
    func elementWithLowestResultOf<Result:Comparable>(_ callback:(Element)->(Result)) -> Element? {
        var lowest : Element?
        var lowestResult : Result!
        forEach { this in
            let result = callback(this)
            if nil == lowest || result < lowestResult {
                lowest = this
                lowestResult = result
            }
        }
        return lowest
    }
    
    func elementWithHighestResultOf<Result:Comparable>(_ callback:(Element)->(Result)) -> Element? {
        var lowest : Element?
        var lowestResult : Result!
        forEach { this in
            let result = callback(this)
            if nil == lowest || result > lowestResult {
                lowest = this
                lowestResult = result
            }
        }
        return lowest
    }


}
