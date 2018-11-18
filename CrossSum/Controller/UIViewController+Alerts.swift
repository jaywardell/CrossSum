//
//  UIViewController+Alerts.swift
//  Bouncy Pao
//
//  Created by Joseph Wardell on 7/22/18.
//  Copyright © 2018 Joseph Wardell. All rights reserved.
//

import UIKit

struct SimpleAlert {
    
    let title : String
    let message : String
    
    let okButtonName : String?

    fileprivate var defaultButtonNameForViewControll : String {
        return okButtonName ?? "OK"
    }
}

extension SimpleAlert {
    
    init(title:String, error:NSError) {
        self.init(title:title, message:error.localizedDescription, okButtonName:nil)
    }
}

struct SimplePromptAlert {
    let title : String
    let question : String
    
    let okButtonName : String?
    let cancelButtonName : String?

    fileprivate var defaultButtonNameForViewController : String {
        return okButtonName ?? "OK"
    }
    
    fileprivate var cancelButtonNameForViewController : String {
        return cancelButtonName ?? "Cancel"
    }
    
    init(_ title:String, _ question:String, okButtonName:String?=nil, cancelButtonName:String?=nil) {
        self.title = title
        self.question = question
        self.okButtonName = okButtonName
        self.cancelButtonName = cancelButtonName
    }
}

extension UIViewController {
    
    func presentAlert(_ alert:SimpleAlert, animated:Bool=true) {
        
        let alertVC = UIAlertController(title: alert.title, message: alert.message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: alert.defaultButtonNameForViewControll, style: .default, handler: nil))
        
        present(alertVC, animated: true, completion: nil)
    }

    func present(prompt alert:SimplePromptAlert, animated:Bool=true, defaultCompletion:@escaping ()->()) {
        
        let alertVC = UIAlertController(title: alert.title, message: alert.question, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: alert.defaultButtonNameForViewController, style: .default, handler: { _ in defaultCompletion() }))
        alertVC.addAction(UIAlertAction(title: alert.cancelButtonNameForViewController, style: .cancel, handler: nil))
        
        present(alertVC, animated: true, completion: nil)
    }

    func presentSheet(_ alert:SimpleAlert, animated:Bool=true) {
        
        let alertVC = UIAlertController(title: alert.title, message: alert.message, preferredStyle: .actionSheet)
        alertVC.addAction(UIAlertAction(title: alert.defaultButtonNameForViewControll, style: .default, handler: nil))
        
        present(alertVC, animated: true, completion: nil)
    }
    
    func presentSheet(prompt alert:SimplePromptAlert, animated:Bool=true, defaultCompletion:@escaping ()->()) {
        
        let alertVC = UIAlertController(title: alert.title, message: alert.question, preferredStyle: .actionSheet)
        alertVC.addAction(UIAlertAction(title: alert.defaultButtonNameForViewController, style: .default, handler: { _ in defaultCompletion() }))
        alertVC.addAction(UIAlertAction(title: alert.cancelButtonNameForViewController, style: .cancel, handler: nil))
        
        present(alertVC, animated: true, completion: nil)
    }
}
