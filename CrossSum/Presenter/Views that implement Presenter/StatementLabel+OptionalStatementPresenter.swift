//
//  StatementLabel+OptionalStatementPresenter.swift
//  CrossSum
//
//  Created by Joseph Wardell on 10/16/18.
//  Copyright © 2018 Joseph Wardell. All rights reserved.
//

import Foundation

extension StatementLabel : OptionalStatementPresenter {
    
    func present(statement: Statement?) {
        self.statement = statement
    }
}
