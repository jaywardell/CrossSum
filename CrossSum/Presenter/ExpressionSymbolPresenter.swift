//
//  ExpressionSymbolView.swift
//  CrossSum
//
//  Created by Joseph Wardell on 10/10/18.
//  Copyright © 2018 Joseph Wardell. All rights reserved.
//

import Foundation

protocol ExpressionSymbolPresenter {
    var symbolDataSource : ExpressionSymbolViewDataSource? { get set }
    func reloadSymbols(animated:Bool, _ completion:@escaping ()->())
}

// MARK:- 


protocol ExpressionSymbolViewDataSource {
    
    var rows : Int { get }
    var columns : Int { get }
    
    func symbol(at row:Int, _ column:Int) -> String
}

extension ExpressionSymbolViewDataSource {
    
    func stringForSymbols(between cell1:(Int, Int), and cell2:(Int, Int)) -> String {
        if cell1 == cell2 {
            return symbol(at: cell1.0, cell1.1)
        }
        
        let (r1, c1) = cell1
        let (r2, c2) = cell2
        
        let dr = r2 - r1
        let dc = c2 - c1
        let ddr = dr > 0 ? 1 : dr < 0 ? -1 : 0
        let ddc = dc > 0 ? 1 : dc < 0 ? -1 : 0
        
        var out = ""
        
        var c = (row:r1, column:c1)
        while c != (r2, c2) {
            
            out += symbol(at:c.row, c.column)
            
            c.row += ddr
            c.column += ddc
        }
        
        out += symbol(at: r2, c2)
        
        return out
    }
}
