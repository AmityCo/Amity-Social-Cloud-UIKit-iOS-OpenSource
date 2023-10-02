//
//  Date+Extension.swift
//  AmityUIKit
//
//  Created by Sarawoot Khunsri on 30/8/2563 BE.
//  Copyright © 2563 Amity. All rights reserved.
//

import UIKit

extension Date {
    var yearsFromNow: Int {
        return Calendar.current.dateComponents([.year], from: self, to: Date()).year!
    }
    var monthsFromNow: Int {
        return Calendar.current.dateComponents([.month], from: self, to: Date()).month!
    }
    var weeksFromNow: Int {
        return Calendar.current.dateComponents([.weekOfYear], from: self, to: Date()).weekOfYear!
    }
    var daysFromNow: Int {
        return Calendar.current.dateComponents([.day], from: self, to: Date()).day!
    }
    var isInYesterday: Bool {
        return Calendar.current.isDateInYesterday(self)
    }
    var hoursFromNow: Int {
        return Calendar.current.dateComponents([.hour], from: self, to: Date()).hour!
    }
    var minutesFromNow: Int {
        return Calendar.current.dateComponents([.minute], from: self, to: Date()).minute!
    }
    var secondsFromNow: Int {
        return Calendar.current.dateComponents([.second], from: self, to: Date()).second!
    }
    var relativeTime: String {
        if yearsFromNow > 0 {
            return "\(yearsFromNow) year" + (yearsFromNow > 1 ? "s" : "") + " ago"
        }
        if monthsFromNow > 0 {
            return "\(monthsFromNow) month" + (monthsFromNow > 1 ? "s" : "") + " ago"
        }
        if weeksFromNow > 0 {
            return "\(weeksFromNow) week" + (weeksFromNow > 1 ? "s" : "") + " ago"
        }
        if isInYesterday {
            return "Yesterday"
        }
        if daysFromNow > 0 {
            return "\(daysFromNow) day" + (daysFromNow > 1 ? "s" : "") + " ago"
        }
        if hoursFromNow > 0 {
            return "\(hoursFromNow) hour" + (hoursFromNow > 1 ? "s" : "") + " ago"
        }
        if minutesFromNow > 0 {
            return "\(minutesFromNow) minute" + (minutesFromNow > 1 ? "s" : "") + " ago"
        }
        return "Just now"
    }
}
