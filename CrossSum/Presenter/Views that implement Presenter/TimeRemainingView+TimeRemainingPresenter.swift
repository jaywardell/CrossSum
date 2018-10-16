//
//  TimeRemainingView+TimeRemainingPresenter.swift
//  CrossSum
//
//  Created by Joseph Wardell on 10/16/18.
//  Copyright © 2018 Joseph Wardell. All rights reserved.
//

import Foundation

extension TimeRemainingView : TimeRemainingPresenter {
    func present(totalTime: Double) {
        self.maxTime = totalTime
        self.remainingTime = totalTime
    }
    
    func present(remainingTime: Double) {
        self.remainingTime = remainingTime
    }
}
