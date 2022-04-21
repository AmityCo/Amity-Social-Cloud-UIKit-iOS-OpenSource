//
//  AmityDateFormatter.swift
//  AmityUIKit
//
//  Created by Sarawoot Khunsri on 16/11/2563 BE.
//  Copyright © 2563 Amity. All rights reserved.
//

import UIKit

private extension Date {
    var message: String {
        if daysFromNow > 1 {
            return ""
        }
        
        if isInYesterday {
            return "Yesterday"
        }

        return "Today"
    }
    
    var isToday: Bool {
        return daysFromNow == 0
    }
}


struct AmityDateFormatter {
    private init() { }
    private static var calendar: Calendar = {
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale(identifier: "en_US")
        return calendar
    }()
    
    struct Chat {
        private static var dateFormatter: DateFormatter = {
            let dateFormatter = DateFormatter()
            dateFormatter.calendar = calendar
            return dateFormatter
        }()
        
        static func getDate(date: Date) -> String {
            dateFormatter.dateStyle = .short
            dateFormatter.timeStyle = .short
            dateFormatter.dateFormat = "M/dd/yy, hh:mm a"
            let dateString = dateFormatter.string(from: date)
            guard let _date = dateFormatter.date(from: dateString) else { return "" }
            dateFormatter.dateFormat = _date.isToday ? "h:mm a" : "dd/MM/yy"
            return dateFormatter.string(from: _date)
        }
    }
    
    struct Message {
        private static var dateFormatter: DateFormatter = {
            let dateFormatter = DateFormatter()
            dateFormatter.calendar = calendar
            return dateFormatter
        }()
        
        static func getDate(date: Date) -> String {
            dateFormatter.dateStyle = .short
            dateFormatter.timeStyle = .none
            dateFormatter.dateFormat = "M/dd/yy"
            let dateString = dateFormatter.string(from: date)
            guard let _date = dateFormatter.date(from: dateString) else { return "" }
            if _date.message == "" {
                dateFormatter.dateFormat = "MMMM dd, yyyy"
                return dateFormatter.string(from: _date)
            }
            return _date.message
        }
        
        static func getTime(date: Date) -> String {
            dateFormatter.dateStyle = .none
            dateFormatter.timeStyle = .short
            dateFormatter.dateFormat = "h:mm a"
            return dateFormatter.string(from: date)
        }
    }
    
}
