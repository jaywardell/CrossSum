//
//  ExpressionSelector.swift
//  CrossSum
//
//  Created by Joseph Wardell on 10/10/18.
//  Copyright © 2018 Joseph Wardell. All rights reserved.
//

import Foundation

protocol ExpressionSelector {
    var allowsDiagonalSelection : Bool { get set }
    var isSelecting : ((String)->())? { get set }
    var didSelect : ((String)->())? { get set }
    var canStartSelectionWith : (String?)->Bool { get set }
    
    func select(_ row:Int, _ column:Int, animated:Bool)
    func select(from row1:Int, _ column1:Int, to row2:Int, _ column2:Int, animated:Bool)
    func removeSelection(animated:Bool, completion:@escaping ()->())
    
    /// called just before we programmatically select
    // e.g. when showing a hint
    func prepareToSimulateSelection()
    func doneSimulatingSelection()
}
