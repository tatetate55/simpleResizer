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
    var settingData = SettingData()
    
    let fromAppDelegate: AppDelegate = NSApplication.shared.delegate as! AppDelegate
    
    // Realmインスタンスを取得する
    let realm = try! Realm()  // ←追加
    
    // DB内のタスクが格納されるリスト
    // 以降内容をアップデートするとリスト内は自動的に更新される。
    var settingArray = try! Realm().objects(SettingData.self).sorted(byKeyPath: "id", ascending: false)  // ←追加
    
    override func viewDidLoad() {
        super.viewDidLoad()
        maxSizeTextField.delegate = self
        imageNameTextField.delegate = self
        
        dragView.delegate = self

        //settingArray[0].maxSize = 100
        
        maxSizeTextField.placeholderString = settingArray[0].maxSize.description
        imageNameTextField.placeholderString = settingArray[0].addFileName
        
    }
    
    override func controlTextDidChange(_ obj: Notification) {

        if imageNameTextField.stringValue != "" {
            fromAppDelegate.addName = imageNameTextField.stringValue

            try! realm.write {
                settingData.addFileName = fromAppDelegate.addName
                self.realm.add(self.settingData, update: true)
            }

        }
        if let n = NumberFormatter().number(from: maxSizeTextField.stringValue) {
            try! realm.write {
                settingData.maxSize = CGFloat(truncating: n)
                self.realm.add(self.settingData, update: true)
            }
            fromAppDelegate.maxSize = CGFloat(truncating: n)
        }
    }

}

extension ViewController: DragViewDelegate {
    func dragView(didDragFileWith imageURL: NSURL) {
        
    }
}
