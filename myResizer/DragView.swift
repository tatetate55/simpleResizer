//
//  DragView.swift
//  myResizer
//
//  Created by KAMAKURAKAZUHIRO on 2018/09/02.
//  Copyright © 2018年 KAMAKURAKAZUHIRO. All rights reserved.
//

import Cocoa
import RealmSwift

protocol DragViewDelegate {
    func dragView(didDragFileWith URL: NSURL)
}

class DragView: NSView {
    
    var delegate: DragViewDelegate?
    let fromAppDelegate: AppDelegate = NSApplication.shared.delegate as! AppDelegate
    // realm set
    var settingData = SettingData()
    let realm = try! Realm()
    var settingArray = try! Realm().objects(SettingData.self).sorted(byKeyPath: "id", ascending: false)

    
    //1
    private var fileTypeIsOk = false
    private var acceptedFileExtensions = ["jpg","jpeg","png","heic"]
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
         registerForDraggedTypes([NSPasteboard.PasteboardType.fileURL])
    }
    
    //2
    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        fileTypeIsOk = checkExtension(drag: sender)
        return []
    }
    
    //3
    override func draggingUpdated(_ sender: NSDraggingInfo) -> NSDragOperation {
        return fileTypeIsOk ? .copy : []
    }
    
    //4
    override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
        guard let draggedFileURL = sender.draggedFileURL else {
            return false
        }
        
        if fileTypeIsOk {
            delegate?.dragView(didDragFileWith: draggedFileURL)
        }
        
        
        // 画像をドラッグ＆ドロップで読み込む例
        if let image = NSImage(pasteboard: sender.draggingPasteboard) {
            if  settingArray[0].maxSize > 0 || settingArray[0].addFileName  != "" {
                // ここで画像の処理を行う
                let newImage: NSImage? = resize(sourceImage:image, newMaxSize: settingArray[0].maxSize/2) //???TODO
                
                var extensionName = (draggedFileURL.absoluteString?.pathExtension)!
                if extensionName == "HEIC" { extensionName = "jpg" }
                let hoge = (draggedFileURL.deletingPathExtension?.lastPathComponent)! + settingArray[0].addFileName  + "." + extensionName
                let dirUrl = draggedFileURL.deletingLastPathComponent
                let destinationURL = dirUrl?.appendingPathComponent(hoge)
                if let extensionString = draggedFileURL.absoluteString?.pathExtension {
                    if extensionString == "jpg" || extensionString == "heic" {
                        if (newImage?.jpegWrite(to: destinationURL!, options: .atomicWrite))! {
                            //print("File saved")
                        }
                    } else {
                        if (newImage?.pngWrite(to: destinationURL!, options: .atomicWrite))! {
                            //print("File saved")
                        }
                        
                    }
                }

            }
        }
        
        
        return true
    }
    
    //5
    fileprivate func checkExtension(drag: NSDraggingInfo) -> Bool {
        guard let fileExtension = drag.draggedFileURL?.pathExtension?.lowercased() else {
            return false
        }
        
        return acceptedFileExtensions.contains(fileExtension)
    }
    
}

//6
extension NSDraggingInfo {
    var draggedFileURL: NSURL? {
        //let filenames = draggingPasteboard().propertyList(forType: NSPasteboard.PasteboardType.fileURL) as? [String]
        let filenames = draggingPasteboard.propertyList(forType: NSPasteboard.PasteboardType(rawValue: "NSFilenamesPboardType")) as? [String]
        let path = filenames?.first
        
        return path.map(NSURL.init)
    }
}


extension DragView { //後でファイルバラす
    func resize(sourceImage: NSImage, newMaxSize: CGFloat) -> NSImage? {
        var newSize:CGSize
        if sourceImage.size.height > sourceImage.size.width {
            let newHieght = newMaxSize
            let newWidth = sourceImage.size.width / (sourceImage.size.height / newMaxSize)
            newSize = CGSize(width: newWidth, height: newHieght)
        } else {
            let newHieght = sourceImage.size.height / (sourceImage.size.width / newMaxSize)
            let newWidth = newMaxSize
            newSize = CGSize(width: newWidth, height: newHieght)
        }
        if !sourceImage.isValid {
            return nil
        }
        
        let newImage = NSImage(size: newSize)
        newImage.lockFocus()
        
        sourceImage.size = newSize
        
        NSGraphicsContext.current?.imageInterpolation = .medium
        sourceImage.draw(at: NSPoint.zero, from: CGRect(x: 0,y: 0, width: newSize.width, height: newSize.height), operation: NSCompositingOperation.copy, fraction: 1.0)
        newImage.unlockFocus()
        
        return newImage
    }
    

    
}

extension NSImage {
    var jpegData: Data? {
        guard let tiffRepresentation = tiffRepresentation, let bitmapImage = NSBitmapImageRep(data: tiffRepresentation) else { return nil }
        return bitmapImage.representation(using: .jpeg, properties: [:])
    }
    
    func jpegWrite(to url: URL, options: Data.WritingOptions = .atomic) -> Bool {
        do {
            try jpegData?.write(to: url, options: options)
            return true
        } catch {
            print(error)
            return false
        }
    }
    
    var pngData: Data? {
        guard let tiffRepresentation = tiffRepresentation, let bitmapImage = NSBitmapImageRep(data: tiffRepresentation) else { return nil }
        return bitmapImage.representation(using: .png, properties: [:])
    }
    
    func pngWrite(to url: URL, options: Data.WritingOptions = .atomic) -> Bool {
        do {
            try pngData?.write(to: url, options: options)
            return true
        } catch {
            print(error)
            return false
        }
    }
    
}

