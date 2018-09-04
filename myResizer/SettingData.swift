//
//  SettingData.swift
//  myResizer
//
//  Created by KAMAKURAKAZUHIRO on 2018/09/04.
//  Copyright © 2018年 KAMAKURAKAZUHIRO. All rights reserved.
//

import Foundation
import RealmSwift

class SettingData: Object {
    // dynamic修飾子を付けないとあかん、なぜかは説明を読んでも説明に見がわからんので、今のところおまじない
    // 管理用 ID。プライマリーキー
    @objc dynamic var id = 0
    @objc dynamic var maxSize: CGFloat = 100 //size
    @objc dynamic var addFileName = "a"
    @objc dynamic var maxDataSize = 10000
    @objc dynamic var copyright = "cc"
    
    /**
     id をプライマリーキーとして設定
     */
    override static func primaryKey() -> String? {
        return "id"
    }
}
