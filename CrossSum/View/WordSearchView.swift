//
//  WordSearchView.swift
//  Word Search
//
//  Created by Joseph Wardell on 9/11/18.
//  Copyright © 2018 Joseph Wardell. All rights reserved.
//

import UIKit

//protocol WordSearchViewDelegate {
//    func isSelecting(_ string:String)
//    func didSelect(_ string:String)
//}

protocol WordSearchDataSource {
    
    var rows : Int { get }
    var columns : Int { get }
    
    func symbol(at row:Int, _ column:Int) -> String
}

extension WordSearchDataSource {
    
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

// MARK:-

/// presents a square word search grid
@IBDesignable class WordSearchView: UIView {
    
    var contentView : UIView { return rowsStackView! }
    
    var choiceFont : UIFont {
        return labels.first!.font
    }
    
    var textColor : UIColor = .black {
        didSet {
            labels.forEach { label in
                label.textColor = textColor
            }
        }
    }
    
    var textFont : UIFont = UIFont.systemFont(ofSize: 24) {
        didSet {
            labels.forEach { label in
                label.font = textFont
            }
        }
    }
    
    var dataSource : WordSearchDataSource?
    
    public func reloadSymbols() {
        
        updateLayout()
        updateLetters()
        setNeedsLayout()
    }
    
    
    var allowsDiagonalSelection = true
    
    var isSelecting : ((String)->())?
    var didSelect : ((String)->())?
    var isValidSelection : (Int, Int, String?)->Bool = { _, _, _ in return true }

    private var rowsStackView: UIStackView?
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        updateLayout()
        
        addGestureRecognizer(pan)
    }
    
    
    private lazy var pan = UIPanGestureRecognizer(target: self, action: #selector(didPan(_:)))
    private var selectionStartLabel : UILabel?
    private var selectionEndLabel : UILabel?
    private var _isValidSelection = false
    @objc private func didPan(_ gestureRecognizer:UIPanGestureRecognizer) {
        switch pan.state {
        case .began:
            if let closestLabel = closestLabel(to: gestureRecognizer.location(in: self)) {
                guard let c = coordinates(of: closestLabel) else {
                    _isValidSelection = false
                    return
                }
                _isValidSelection = isValidSelection(c.row, c.column, closestLabel.text)
                if _isValidSelection {
                    selectLabel(closestLabel)
                    selectionStartLabel = closestLabel
                }
            }
        case .changed:
            if let closestLabel = closestLabel(to: gestureRecognizer.location(in: self)),
                let firstSelectionLabel = selectionStartLabel,
                _isValidSelection {
                selectLabels(between: firstSelectionLabel, and: closestLabel)
                selectionEndLabel = closestLabel
            }
        case .ended:
            if let startLabel = selectionStartLabel,
                let endLabel = selectionEndLabel,
                _isValidSelection {
                endSelection(between: startLabel, and: endLabel, andReport: true)
            }
        case .cancelled, .failed:
            if let startLabel = selectionStartLabel,
                let endLabel = selectionEndLabel,
                _isValidSelection {
                endSelection(between: startLabel, and: endLabel, andReport: false)
            }

        case .possible:
            break

        }
    }
    
    // MARK:- Selection

    private var selectionLayer : CALayer?
    
    func removeSelection() {
        
        if let layer = selectionLayer {
            layer.removeFromSuperlayer()
        }
    }
    
    func showSelection(over label:UILabel) {
        removeSelection()
        
        let newLayer = CALayer()
        newLayer.backgroundColor = UIColor.orange.withAlphaComponent(0.2).cgColor
        
        newLayer.frame = convert(label.bounds, from: label)
        newLayer.cornerRadius = newLayer.frame.height/2
        newLayer.masksToBounds = true
        
        layer.addSublayer(newLayer)
        selectionLayer = newLayer
    }
    
    func showSelection(from label1:UILabel, to label2:UILabel) {

        removeSelection()
        
        let newLayer = CALayer()
        newLayer.backgroundColor = UIColor.orange.withAlphaComponent(0.2).cgColor

        var frame = label1.bounds// convert(label1.bounds, from: label1)
        
        let l1center = convert(label1.center, from:label1.superview)
        let l2center = convert(label2.center, from:label2.superview)
        frame.size.width += l1center.distance(from: convert(label2.center, from:label2.superview))
        newLayer.frame = frame

        let halfHeight = label1.frame.height/2
        
        // massage angle to be between 0 and 2π
        var angle = l1center.angle(with: l2center)
        while angle < 0 {
            angle += 2 * .pi
        }
        while angle > 2 * .pi {
            angle -= 2 * .pi
        }
        
        // the *10 and convert to Int allows for minor shifts in the center of labels causing slightly different angles
        switch Int(angle * 10) {
        case 0,
             Int(10.0 * 1 * .pi/4),
             Int(10.0 * 2 * .pi/4),
             Int(10.0 * 3 * .pi/4),
             Int(10.0 * 4 * .pi/4),
             Int(10.0 * 5 * .pi/4),
             Int(10.0 * 6 * .pi/4),
             Int(10.0 * 7 * .pi/4),
             Int(10.0 * 8 * .pi/4):
                break
        default:
            print("illegitimate angle: \(angle)")
            return
        }
        
        let d = l2center - l1center
        let center = l1center + d * 0.5

        newLayer.frame.origin = center - CGVector(dx: frame.width/2, dy: frame.height/2)
        
        var tr = CATransform3DIdentity;
        tr = CATransform3DRotate(tr, angle, 0.0, 0.0, 1.0);
        newLayer.transform = tr
        
        newLayer.cornerRadius = halfHeight
        newLayer.masksToBounds = true
        
        layer.addSublayer(newLayer)
        selectionLayer = newLayer
    }
    
    func reportSelectionChanged(_ label1:UILabel, to label2:UILabel?=nil) {
        guard let label2 = label2 else {
            
            if let string = label1.text {
                isSelecting?(string)
            }
            return
        }
        
        let selectedString = stringForLabels(between: label1, and: label2)
        isSelecting?(selectedString)
    }
    
    func reportSelectionEnded(_ label1:UILabel, to label2:UILabel) {

        let selectedString = stringForLabels(between: label1, and: label2)
        didSelect?(selectedString)
    }
    
    private func selectLabel(_ label:UILabel) {
        showSelection(over: label)
        reportSelectionChanged(label)
    }

    // NOTE: it's okay if label1 and label2 are the same, we can handle that case
    private func selectLabels(between label1:UILabel, and label2:UILabel) {

        guard selectionIsValid(between: label1, and: label2) else {
            if let layer = selectionLayer {
                layer.backgroundColor = UIColor.clear.cgColor
                layer.borderColor = UIColor.orange.withAlphaComponent(0.2).cgColor
                layer.borderWidth = 2
            }
            return
        }
        
        showSelection(from: label1, to: label2)
        reportSelectionChanged(label1, to: label2)
    }

    private func selectionIsValid(between label1:UILabel, and label2:UILabel) -> Bool {
        
        let (r1, c1) = coordinates(of: label1)!
        let (r2, c2) = coordinates(of: label2)!
        
        let dr = r2 - r1
        let dc = c2 - c1
        
        // we only care about horizontal, vertical and diagonal selections
        // ignore all others
        if abs(dr) != abs(dc) && dr != 0 && dc != 0 {
            // TODO: flag something to indicate a non-valid selection (diagonal, not at 45° angle)
            return false
        }
        
        if !allowsDiagonalSelection && (r1 != r2 && c1 != c2) {
            return false
        }
        
        return true
    }
    
    private func endSelection(between label1:UILabel, and label2:UILabel, andReport report:Bool) {
        
        defer {
            
            removeSelection()
            selectionStartLabel = nil
            selectionEndLabel = nil
       }
        
        guard selectionIsValid(between: label1, and: label2) else { return }
        
        if report {
            reportSelectionEnded(label1, to: label2)
        }
        
    }
    
    private func stringForLabels(between label1:UILabel, and label2:UILabel) -> String {
        let (r1, c1) = coordinates(of: label1)!
        let (r2, c2) = coordinates(of: label2)!

        return dataSource?.stringForSymbols(between: (r1, c1), and: (r2, c2)) ?? ""
   }
    
    // MARK:-

    private func updateLetters() {
        guard let dataSource = dataSource else { return }
        
        for row in 0..<dataSource.rows {
            for column in 0..<dataSource.columns {
                let l = label(at: row, column)
                l.text = dataSource.symbol(at: row, column)
            }
        }
    }
        
    private func label(at row:Int, _ column:Int) -> UILabel {
        let rowView = rowsStackView!.arrangedSubviews[row] as! UIStackView
        return rowView.arrangedSubviews[column] as! UILabel
    }
    
    private func coordinates(of label:UILabel) -> (row:Int, column:Int)? {
        guard let index = labels.index(of: label),
        let dataSource = dataSource else { return nil }
        
        return (row:index/dataSource.columns, column:index%dataSource.columns)
    }
    
    private var labels : [UILabel] {
        return rowsStackView?.arrangedSubviews.reduce([]) {
            $0 + ($1 as! UIStackView).arrangedSubviews
            } as! [UILabel]
    }
    
    private func closestLabel(to point:CGPoint) -> UILabel? {
        
        let closest = labels.elementWithLowestResultOf {
            abs(convert($0.center, from: $0.superview).distanceSquared(from: point))
        }

        return closest
    }
    
    private var spacing : CGFloat {
        return labels[0].center.distance(from: labels[1].center)
    }
    
    // MARK:- Layout

    private func updateLayout() {
        guard let dataSource = dataSource else { return }
        
        let rowViews = (0..<dataSource.rows).map() { _ in
            createRowView(width: dataSource.columns)
        }
        
        rowsStackView = createRowsStackView(for: rowViews)
    }
    
    private func createRowsStackView(for rowViews:[UIStackView]) -> UIStackView {
        rowsStackView?.removeFromSuperview()
        
        let out = UIStackView(arrangedSubviews: rowViews)

        out.axis = .vertical
        out.distribution = .fillEqually
        
        addSubview(out)

        out.constrainToPositionInSuperview(.middle, .center)
        out.constrainToLimitSize(of: self, widthMultiplier: 29/34, heightMultiplier: 29/34)
        out.constrainToMeetOrExceedSize(of: self, widthMultiplier: 13/34, heightMultiplier: 13/34)
        out.constrainToAspectRatio(1)
        
        return out
    }
    
    private func createRowView(width:Int) -> UIStackView {
        
        let labels : [UILabel] = (0..<width).map() { _ in
            let out = ProportionalLabel()
            out.text = "0"
            out.textAlignment = .center
            out.textColor = textColor
            return out
        }
        let out = UIStackView(arrangedSubviews: labels)
        out.distribution = .fillEqually
        out.axis = .horizontal
        return out
    }
    
}


// MARK:-

private class ProportionalLabel : UILabel {

    override func layoutSubviews() {
        super.layoutSubviews()
        
        font = font.withSize(floor(frame.height * 21/34))
    }
}