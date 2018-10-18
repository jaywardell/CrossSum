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
    
    enum Geometry : Int {
        case square
        case horizontal
        case vertical
    }
    
    // TODO: make inspectable wrapper
    var geometry : Geometry = .square {
        didSet {
            updateTiles()
        }
    }
    
    @IBInspectable var geometryAsInt : Int {
        get {
            return geometry.rawValue
        }
        set {
            geometry = Geometry(rawValue: abs(newValue) % 3)!
        }
    }
    
    // NOTE: ignored when geometry is vertical
    @IBInspectable var leftToRight : Bool = true {
        didSet {
            updateTiles()
        }
    }
    
    // NOTE: ignored when geometry is horizontal
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
    
    private var calculatedHorizontalFirst : Bool {
        switch geometry {
        case .square:
            return horizontalFirst
        case .horizontal:
            return true
        case .vertical:
            return false
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
        let dimension = tilesPer(for: maxItems)
        
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
    
    private func calcualteTileWidth(for tilesPer:Int) -> CGFloat {
        switch geometry {
        case .square, .horizontal:
            return bounds.width/CGFloat(tilesPer)
        case .vertical:
            return bounds.width
        }
    }
    
    private func calculateTileHeight(for tilesPer:Int) -> CGFloat {
        switch geometry {
        case .square, .vertical:
            return bounds.height/CGFloat(tilesPer)
        case .horizontal:
            return bounds.height
        }
    }
    
    private func rect(for tile:Int, _ tilesPer:Int) -> CGRect {
        let column = calculatedHorizontalFirst ? tile%tilesPer : tile/tilesPer
        let row = calculatedHorizontalFirst ? tile/tilesPer : tile%tilesPer
        
        let tileWidth = calcualteTileWidth(for: tilesPer)
        let tileHeight = calculateTileHeight(for:tilesPer)
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
    
    private func tilesPer(for totalItemCount:Int) -> Int {
        switch geometry {
        case .square:
            return smallestPerfectSquareGreaterThanOrEqualTo(totalItemCount)
        case .horizontal, .vertical:
            return totalItemCount
        }
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
