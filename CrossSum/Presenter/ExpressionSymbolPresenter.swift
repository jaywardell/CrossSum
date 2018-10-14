//
//  ExpressionSymbolView.swift
//  CrossSum
//
//  Created by Joseph Wardell on 10/10/18.
//  Copyright © 2018 Joseph Wardell. All rights reserved.
//

import Foundation

protocol ExpressionSymbolPresenter {
    // NOTE: these two methods are meant to be called from the present() method in the extension below
    // your implementation should implement them, but you should not call them
    var symbolDataSource : ExpressionSymbolViewDataSource? { get set }
    func presentSymbols(animated:Bool, _ completion:@escaping ()->())
}

extension ExpressionSymbolPresenter {
    
    /// The method your model objects want to call
    /// sets symbolDataSource and also calls presentSymbols
    /// This method lets this presenter act as much as possible like other presenters, with a single preset(...) method
    ///
    /// - Parameters:
    ///   - dataSource: an object of type ExpressionSymbolViewDataSource
    ///   - animated: whether to animate the transition
    ///   - completion: a closure to be called when the transition has completed
    mutating func present(_ dataSource:ExpressionSymbolViewDataSource, animated:Bool, _ completion:@escaping ()->()) {
        self.symbolDataSource = dataSource
        presentSymbols(animated: animated, completion)
    }
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
