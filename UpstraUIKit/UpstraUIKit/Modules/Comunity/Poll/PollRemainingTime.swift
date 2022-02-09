//
//  PollRemainingTime.swift
//  AmityUIKit
//
//  Created by Nishan Niraula on 9/13/21.
//  Copyright © 2021 Amity. All rights reserved.
//

import Foundation
import UIKit

class PollStatus {
    var statusInfo: String = AmityLocalizedStringSet.Poll.Option.openForVoting.localizedString
    
    init(closedInDate: Date) {
        computeRemainingTime(closedInDate: closedInDate)
    }
    
    private func computeRemainingTime(closedInDate: Date) {
        let currentDate = Date()
        
        if closedInDate > currentDate {
            let difference = Calendar.current.dateComponents([.day,.hour,.minute], from: currentDate, to: closedInDate)
            
            if let remainingDays = difference.day, remainingDays > 0 {
                statusInfo = RemainingTime.days(count: remainingDays).info
                return
            }
            
            if let remainingHours = difference.hour, remainingHours > 0 {
                statusInfo = RemainingTime.hours(count: remainingHours).info
                return
            }
            
            if let remainingMinutes = difference.minute, remainingMinutes > 0 {
                statusInfo = RemainingTime.minutes(count: remainingMinutes).info
                return
            } else {
                // We don't want to show remaining time in seconds. So we just show `1 minute`
                statusInfo = RemainingTime.minutes(count: 1).info
                return
            }
            
        } else {
            statusInfo = AmityLocalizedStringSet.Poll.Option.finalResult.localizedString
        }
    }
}

extension PollStatus {
    
    private enum RemainingTime {
        case days(count: Int)
        case hours(count: Int)
        case minutes(count: Int)
        
        private var baseInfo: String {
            switch self {
            case .days(let count):
                if count > 1 {
                    return AmityLocalizedStringSet.Poll.Option.pollEndDurationDays.localizedString
                } else {
                    return AmityLocalizedStringSet.Poll.Option.pollEndDurationDay.localizedString
                }
            case .hours(let count):
                if count > 1 {
                    return AmityLocalizedStringSet.Poll.Option.pollEndDurationHours.localizedString
                } else {
                    return AmityLocalizedStringSet.Poll.Option.pollEndDurationHour.localizedString
                }
            case .minutes(let count):
                if count > 1 {
                    return AmityLocalizedStringSet.Poll.Option.pollEndDurationMinutes.localizedString
                } else {
                    return AmityLocalizedStringSet.Poll.Option.pollEndDurationMinute.localizedString
                }
            }
        }
        
        var info: String {
            switch self {
            case .days(let remainingDays):
                let actualUnit = String.localizedStringWithFormat("\(remainingDays)")
                return String.localizedStringWithFormat(baseInfo, actualUnit)
                
            case .hours(let remainingHours):
              
                let actualUnit = String.localizedStringWithFormat("\(remainingHours)")
                return String.localizedStringWithFormat(baseInfo, actualUnit)
                
            case .minutes(let remainingMinutes):
                let actualUnit = String.localizedStringWithFormat("\(remainingMinutes)")
                return String.localizedStringWithFormat(baseInfo, actualUnit)
            }
        }
    }
}
