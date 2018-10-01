//
//  ThreadSafe.swift
//  CrossSum
//
//  Created by Joseph Wardell on 10/1/18.
//  Copyright © 2018 Joseph Wardell. All rights reserved.
//
// inspired by, and mostly taken from, talk.objc.io episode on concurrentMap: https://talk.objc.io/episodes/S01E90-concurrent-map

import Foundation

final class ThreadSafe<Value> {

    private var _value : Value
    private let queue = DispatchQueue(label: "ThreadSafe" + UUID().description)

    init(_ value:Value) {
        self._value = value
    }
    
    var value : Value {
        var out : Value!
        queue.sync {
            out = _value
        }
        return out
    }
    
    func atomically(_ transform:(inout Value)->()) {
        queue.sync {
            transform(&self._value)
        }
    }
}
