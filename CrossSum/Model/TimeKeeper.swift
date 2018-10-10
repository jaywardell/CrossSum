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
    
    var timeRemaining : TimeInterval = 0
    
    enum State {
        case created
        case running
        case paused
        case finished
    }
    
    var state : State {
        guard let timer = self.timer else { return .created }
        
        if timer.isValid { return .running }
        return timeRemaining > TimeInterval(0) ? .paused : .finished
    }
    
    var hasStarted : Bool {
        return state != .created
    }
    
    var isPaused : Bool {
        return state == .paused
    }

    var isDone : Bool {
        return state == .finished
    }

    
    init(_ time:TimeInterval, presenter:TimeRemainingPresenter?, done:@escaping(TimeKeeper)->()) {
        self.totalTime = time
        self.presenter = presenter
        self.done = done
    }
    
    private var timer : Timer!
    private var lastTime : TimeInterval!
    func start() {
        assert(!hasStarted)
        
        presenter?.maxTime = totalTime
        presenter?.remainingTime = totalTime
        
        timeRemaining = totalTime

        _resume()
    }
    
    func stop() {
        assert(hasStarted && !isDone)
        
        timer.invalidate()
        timeRemaining = 0   // flag it as done
    }
    
    func pause() {
        assert(!isPaused)
        
        timer.invalidate()
    }
    
    func resume() {
        assert(isPaused)

        _resume()
    }
    
    private func _resume() {
        
        lastTime = Date().timeIntervalSinceReferenceDate
        timer = Timer.scheduledTimer(timeInterval: 1/30, target: self, selector: #selector(timerFired(_:)), userInfo: nil, repeats: true)
    }
    
    func dealloc() {
        stop()
    }
    
    @objc private func timerFired(_ timer:Timer) {
        
        let now = Date().timeIntervalSinceReferenceDate

        timeRemaining -= now - lastTime
        lastTime = now
        
        presenter?.remainingTime = timeRemaining
        
        if timeRemaining <= TimeInterval(0) {
            done(self)
            timer.invalidate()
        }
    }
}
