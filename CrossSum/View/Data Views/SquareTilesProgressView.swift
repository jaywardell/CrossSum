//
//  SquareTilesProgressView.swift
//  SquareTilesProgressViewTests
//
//  Created by Joseph Wardell on 10/14/18.
//  Copyright © 2018 Joseph Wardell. All rights reserved.
//

import UIKit

@IBDesignable class SquareTilesProgressView: UIView {

    @IBInspectable var maxItems : Int = 0 {
        didSet {
            updateTiles()
        }
    }
    
    var _completed : Int = 0
    @IBInspectable var completedItems : Int {
        get {
            return _completed
        }
        set {
            setCompletedItems(newValue)
        }
    }

    @IBInspectable var leftToRight : Bool = true {
        didSet {
            updateTiles()
        }
    }
    
    @IBInspectable var topToBottom : Bool = true {
        didSet {
            updateTiles()
        }
    }

    @IBInspectable var horizontalFirst : Bool = true {
        didSet {
            updateTiles()
        }
    }
    
    func setCompletedItems(_ items:Int) {
        guard items >= 0 && items <= maxItems else { return }
        _completed = items
        for (i, tile) in tiles.enumerated() {
            configure(tile: tile, at: i)
        }
    }
    
    private var tiles = [CAShapeLayer]()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        updateTiles()
    }
    
    private func updateTiles() {
        let dimension = smallestPerfectSquareGreaterThanOrEqualTo(maxItems)
        
        tiles.forEach() { tile in
            tile.removeFromSuperlayer()
        }
        tiles.removeAll()
        

        for i in 0..<maxItems {
            let newLayer = CAShapeLayer()
            let path = UIBezierPath(rect: rect(for: i, dimension))
            newLayer.path = path.cgPath
            
            configure(tile: newLayer, at: i)
            
            tiles.append(newLayer)
            layer.addSublayer(newLayer)
        }
    }
    
    private func configure(tile:CAShapeLayer, at index:Int) {
        tile.fillColor = index < completedItems ? tintColor.cgColor : UIColor.clear.cgColor
        tile.strokeColor = tintColor.cgColor
    }
    
    private func rect(for tile:Int, _ tilesPer:Int) -> CGRect {
        let column = horizontalFirst ? tile%tilesPer : tile/tilesPer
        let row = horizontalFirst ? tile/tilesPer : tile%tilesPer
        
        let tileWidth = bounds.width/CGFloat(tilesPer)
        let tileHeight = bounds.height/CGFloat(tilesPer)
        let smallestDimension = min(tileHeight, tileWidth)

        let x = leftToRight ?
            bounds.minX + tileWidth * CGFloat(column) :
            bounds.maxX - (tileWidth * CGFloat(column + 1))
        
        let y = topToBottom ?
            bounds.minY + tileHeight * CGFloat(row) :
            bounds.maxY - (tileHeight * CGFloat(row + 1))
        
        return CGRect(x: x,
                      y: y,
                      width: tileWidth,
                      height: tileHeight)
            .insetBy(dx: smallestDimension * 3.0/34, dy: smallestDimension * 3.0/34)
    }
}



/// returns the first number that, when squared, is larger that the number passed in
func smallestPerfectSquareGreaterThanOrEqualTo(_ number:Int) -> Int {
        
    var i = 0
    while i*i < number {
        i += 1
    }
    return i
}


