//
//  ViewController.swift
//  myResizer
//
//  Created by KAMAKURAKAZUHIRO on 2018/09/02.
//  Copyright © 2018年 KAMAKURAKAZUHIRO. All rights reserved.
//

import Cocoa

class ViewController: NSViewController, NSTextFieldDelegate {

    @IBOutlet weak var dragView: DragView!
    @IBOutlet weak var maxSizeTextField: NSTextField!
    @IBOutlet weak var imageNameTextField: NSTextField!
    
    let fromAppDelegate: AppDelegate = NSApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        maxSizeTextField.delegate = self
        imageNameTextField.delegate = self
        
        dragView.delegate = self
    }
    
    override func controlTextDidChange(_ obj: Notification) {
        if imageNameTextField.stringValue != "" {
            fromAppDelegate.addName = imageNameTextField.stringValue
        }
        if let n = NumberFormatter().number(from: maxSizeTextField.stringValue) {
                 print(n)
            fromAppDelegate.maxSize = CGFloat(truncating: n)
        }
    }

}

extension ViewController: DragViewDelegate {
    func dragView(didDragFileWith imageURL: NSURL) {
        
    }
}
