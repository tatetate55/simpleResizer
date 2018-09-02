//
//  ViewController.swift
//  myResizer
//
//  Created by KAMAKURAKAZUHIRO on 2018/09/02.
//  Copyright © 2018年 KAMAKURAKAZUHIRO. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet weak var dragView: DragView!
    @IBOutlet weak var maxSizeTextField: NSTextField!
    @IBOutlet weak var imageNameTextField: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dragView.delegate = self
    }
}

extension ViewController: DragViewDelegate {
    func dragView(didDragFileWith imageURL: NSURL) {
    }
}
