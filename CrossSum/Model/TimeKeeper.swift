//
//  TimeKeeper.swift
//  CrossSum
//
//  Created by Joseph Wardell on 10/5/18.
//  Copyright © 2018 Joseph Wardell. All rights reserved.
//

import Foundation

// TODO: make tests for this
final class TimeKeeper {
    
    let totalTime : TimeInterval
    
    private var presenter : TimeRemainingPresenter?
    
    var done : (TimeKeeper)->() = { _ in }
    
    init(_ time:TimeInterval, presenter:TimeRemainingPresenter?, done:@escaping(TimeKeeper)->()) {
        self.totalTime = time
        self.presenter = presenter
        self.done = done
    }
    
    private var timer : Timer!
    private var startTime : TimeInterval!
    func start() {
        
        presenter?.maxTime = totalTime
        presenter?.remainingTime = totalTime
        
        startTime = Date().timeIntervalSinceReferenceDate
        timer = Timer.scheduledTimer(timeInterval: 1/30, target: self, selector: #selector(timerFired(_:)), userInfo: nil, repeats: true)
    }
    
    func stop() {
        timer.invalidate()
    }
    
    func dealloc() {
        stop()
    }
    
    @objc private func timerFired(_ timer:Timer) {
        print("\(#function)")
        
        let now = Date().timeIntervalSinceReferenceDate
        let elapsed = now - startTime
        
        presenter?.remainingTime = totalTime - elapsed
        
        if totalTime - elapsed <= TimeInterval(0) {
            done(self)
            timer.invalidate()
        }
    }
    
}
