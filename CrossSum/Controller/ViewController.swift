//
//  ViewController.swift
//  CrossSum
//
//  Created by Joseph Wardell on 9/24/18.
//  Copyright © 2018 Joseph Wardell. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var centeredLabel: CenteredLabel?
    @IBOutlet weak var statementLabel: StatementLabel?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view, typically from a nib.
        centeredLabel?.text = "hi"
//        centeredLabel.label.text = "hello"
//        statementLabel?.font = UIFont.systemFont(ofSize: 34)
        statementLabel?.statement = Statement("2-1", 5/2, Statement.greatherthan)
    }


}

