//
//  ViewController.swift
//  myResizer
//
//  Created by KAMAKURAKAZUHIRO on 2018/09/02.
//  Copyright © 2018年 KAMAKURAKAZUHIRO. All rights reserved.
//

import Cocoa
import RealmSwift

class ViewController: NSViewController, NSTextFieldDelegate {

    @IBOutlet weak var dragView: DragView!
    @IBOutlet weak var maxSizeTextField: NSTextField!
    @IBOutlet weak var imageNameTextField: NSTextField!

    // realm set
    let realm = try! Realm()
    var settingData = SettingData()
    var settingArray = try! Realm().objects(SettingData.self).sorted(byKeyPath: "id", ascending: false)
    
    //  let fromAppDelegate: AppDelegate = NSApplication.shared.delegate as! AppDelegate
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        maxSizeTextField.delegate = self
        imageNameTextField.delegate = self
        
        dragView.delegate = self
        
        //settingArray[0].maxSize = 100
        if settingArray.isEmpty {
            settingData.maxSize = 1000
            settingData.addFileName = "hogehoge2"
            try! realm.write {
                self.realm.add(self.settingData, update: true)
            }
        }
        maxSizeTextField.stringValue = settingArray[0].maxSize.description
        imageNameTextField.stringValue = settingArray[0].addFileName
        
    }
    
    override func controlTextDidChange(_ obj: Notification) {

      //  if imageNameTextField.stringValue != "" {
            try! realm.write {
                settingData.addFileName = imageNameTextField.stringValue
                self.realm.add(self.settingData, update: true)
            }
        
        if let n = NumberFormatter().number(from: maxSizeTextField.stringValue) {
            try! realm.write {
                settingData.maxSize = CGFloat(truncating: n)
                self.realm.add(self.settingData, update: true)
            }
        }
    }

}

extension ViewController: DragViewDelegate {
    func dragView(didDragFileWith imageURL: NSURL) {
        
    }
}
