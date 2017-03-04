//
//  Extentions.swift
//  VkMultiChat
//
//  Created by Александр Смоленский on 18.02.17.
//  Copyright © 2017 Александр Смоленский. All rights reserved.
//

import AsyncDisplayKit

extension NSAttributedString {
    
    static func forDialogTitle(text: String) -> NSAttributedString {
        
        let fontSize: CGFloat = Util.isIpad() ? 30 : 18
        let font = UIFont(name: "Avenir", size: fontSize)
        let attributes = [NSFontAttributeName : font]
        
        return NSAttributedString(string: text, attributes: attributes)
    }
    
    static func forMessagePreview(text: String) -> NSAttributedString {
        
        let fontSize: CGFloat = Util.isIpad() ? 26 : 15
        let font = UIFont(name: "Avenir-Light", size: fontSize)
        let attributes = [NSFontAttributeName : font, NSForegroundColorAttributeName : UIColor(white: 0.7, alpha: 1)]
        
        return NSAttributedString(string: text, attributes: attributes)
    }
    
    static func forFwdMessageTitle (text: String) -> NSAttributedString {
        let fontSize: CGFloat = Util.isIpad() ? 24 : 15
        let font = UIFont(name: "Avenir", size: fontSize)
        let attributes = [NSFontAttributeName : font]
        
        return NSAttributedString(string: text, attributes: attributes)
    }
    
    static func forDate(date: String) -> NSAttributedString {
        
        let fontSize: CGFloat = Util.isIpad() ? 20 : 12
        let font = UIFont(name: "Avenir-Light", size: fontSize)
        let attributes = [NSFontAttributeName : font, NSForegroundColorAttributeName : UIColor(white: 0.7, alpha: 1)]
        
        return NSAttributedString(string: date, attributes: attributes)
    }
    
}

extension Collection {
    func dictionary<K, V>(transform:(_ element: Iterator.Element) -> [K : V]) -> [K : V] {
        var dictionary = [K : V]()
        self.forEach { element in
            for (key, value) in transform(element) {
                dictionary[key] = value
            }
        }
        return dictionary
    }
}

extension Dictionary {
    mutating func addObjectsFromArray<C: Collection>(_ array: C, transform: (_ element: C.Iterator.Element) -> ([Key : Value])) {
        array.forEach { (element) in
            for (key, value) in transform(element) {
                self[key] = value
            }
        }
    }
}

extension Int {
    static prefix func - (x: Int) -> Int {
        let y = abs(x) * -1
        return y
    }
    static prefix func + (x: Int) -> Int {
        return abs(x)
    }
}


extension ASNetworkImageNode {
    static func createWith(size: CGFloat) -> ASNetworkImageNode {
        let img = ASNetworkImageNode()
        img.style.width = ASDimensionMakeWithPoints(size)
        img.style.height = ASDimensionMakeWithPoints(size)
        img.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
        img.clipsToBounds = true
        img.contentMode = .scaleAspectFill
        img.placeholderFadeDuration = 0.5
        img.cornerRadius = size / 2
        img.imageModificationBlock = { (image) -> UIImage in
            var modifiedImage: UIImage!
            let rect = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
            
            UIGraphicsBeginImageContextWithOptions(image.size, false, UIScreen.main.scale)
            
            UIBezierPath(roundedRect: rect, cornerRadius: size/2).addClip()
            
            image.draw(in: rect)
            modifiedImage = UIGraphicsGetImageFromCurrentImageContext()
            
            UIGraphicsEndImageContext()
            
            return modifiedImage
        }
        return img
    }
}
