
//
//  File.swift
//  CrossSum
//
//  Created by Joseph Wardell on 10/16/18.
//  Copyright © 2018 Joseph Wardell. All rights reserved.
//

import Foundation

extension TallyView : IntegerPresenter {
    func present(integer: Int) {
        if integer - self.tally == 1 {
            incrementTally(animated: true)
        }
        else if integer - self.tally == -1 {
            decrementTally(animated: true)
        }
        else {
            self.tally = integer
        }
    }
}
