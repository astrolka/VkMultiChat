//
//  Util.swift
//  VkMultiChat
//
//  Created by Александр Смоленский on 17.02.17.
//  Copyright © 2017 Александр Смоленский. All rights reserved.
//

import UIKit

class Util {
    static func isIpad () -> Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }
    
    static func formatedDateForMessages(interval: Int) -> String {
        
        let date = Date(timeIntervalSince1970: TimeInterval(interval))
        let currentDate = Date()
        let dateComponents = componentsFrom(date: date)
        let currentDateComponents = componentsFrom(date: currentDate)
        
        var formattedDate: String!
        
        let identicalYear = currentDateComponents.year == dateComponents.year
        let identicalMonth = currentDateComponents.month == dateComponents.month
        let identicalDay = currentDateComponents.day == dateComponents.day
        
        let formatter = DateFormatter()
        
        if identicalYear && identicalMonth && identicalDay {
            formatter.dateFormat = "HH:mm"
            formattedDate = formatter.string(from: date)
        } else if identicalYear && identicalMonth && currentDateComponents.day! - dateComponents.day! == 1 {
            formattedDate = "Вчера"
        } else if identicalYear {
            formatter.dateFormat = "dd MMM"
            formattedDate = formatter.string(from: date)
        } else {
            formatter.dateFormat = "dd.MM.yy"
            formattedDate = formatter.string(from: date)
        }
        
        return formattedDate
    }
    
    static func screenWidth() -> CGFloat {
        return UIScreen.main.bounds.width
    }
    
    static func screenHeight() -> CGFloat {
        return UIScreen.main.bounds.height
    }
    
    //MARK: Private Methods
    
    private static func componentsFrom(date: Date) -> DateComponents {
        let calendar = Calendar(identifier: .gregorian)
        return calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date)
    }
}

