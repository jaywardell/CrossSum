//
//  ViewController.swift
//  CrossSum
//
//  Created by Joseph Wardell on 9/24/18.
//  Copyright © 2018 Joseph Wardell. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

//        print("constraints: \(centeredLabel.constraints)")
//        let width = centeredLabel.constraints.filter {
//            $0.firstAnchor == centeredLabel.widthAnchor ||
//                $0.secondAnchor == centeredLabel.widthAnchor
//        }
//        let height = centeredLabel.constraints.filter {
//            $0.firstAnchor == centeredLabel.heightAnchor ||
//                $0.secondAnchor == centeredLabel.heightAnchor
//        }
//        NSLayoutConstraint.deactivate(width + height)
//        print("width anchors: \(width)")
    }
    
    @IBOutlet weak var centeredLabel: CenteredLabel?
    @IBOutlet weak var statementLabel: StatementLabel?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view, typically from a nib.
        centeredLabel?.text = "hi"
//        centeredLabel.label.text = "hello"
        
//        statementLabel.statement = Statement(nil, 5)
    }


}

