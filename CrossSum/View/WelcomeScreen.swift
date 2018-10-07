//
//  WelcomeScreen.swift
//  CrossSum
//
//  Created by Joseph Wardell on 10/2/18.
//  Copyright © 2018 Joseph Wardell. All rights reserved.
//

import UIKit

class WelcomeScreen: UIView {

    lazy var playButton : UIButton = {
        let out = UIButton(type: .system)
        out.setTitle("Play", for: .normal)
        return out
    }()
    
    lazy var highScoresView : UITableView = {
        let out = UITableView(frame: .zero, style: .grouped)
        return out
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        addPlayButton()
        addHighScoresView()
    }
    
    private func addPlayButton() {
        guard nil == playButton.superview else { return }
        
        addSubview(playButton)
        
//        playButton.backgroundColor = .orange
        playButton.constrain(to: [
            
            playButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            NSLayoutConstraint(item: playButton, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 34/21, constant: 0),
            
            playButton.widthAnchor.constraint(equalTo: widthAnchor, constant: 21/34),
            playButton.heightAnchor.constraint(equalTo: playButton.widthAnchor, constant: 21/34)
            ])
    }
    
    private func addHighScoresView() {
        
        let tableView = highScoresView
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        
        addSubview(tableView)
        
        tableView.constrain(to: [
            tableView.centerXAnchor.constraint(equalTo: centerXAnchor),
            tableView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 21/34),
            tableView.bottomAnchor.constraint(equalTo: playButton.topAnchor),
            NSLayoutConstraint(item: tableView, attribute: .height, relatedBy: .equal, toItem: playButton, attribute: .height, multiplier: 21/34, constant: 0)
            ])
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        backgroundColor = .black
    }
    
}
