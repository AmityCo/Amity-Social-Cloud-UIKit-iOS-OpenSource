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
            case .days:
                return AmityLocalizedStringSet.Poll.Option.pollEndDurationDays.localizedString
            case .hours:
                return AmityLocalizedStringSet.Poll.Option.pollEndDurationHours.localizedString
            case .minutes:
                return AmityLocalizedStringSet.Poll.Option.pollEndDurationMinutes.localizedString
            }
        }
        
        var info: String {
            switch self {
            case .days(let remainingDays):
                let baseUnit = remainingDays > 1 ? AmityLocalizedStringSet.Unit.dayPlural.localizedString : AmityLocalizedStringSet.Unit.daySingular.localizedString
                
                let actualUnit = String.localizedStringWithFormat(baseUnit, "\(remainingDays)")
                return String.localizedStringWithFormat(baseInfo, actualUnit)
                
            case .hours(let remainingHours):
                let baseUnit = remainingHours > 1 ? AmityLocalizedStringSet.Unit.hourPlural.localizedString : AmityLocalizedStringSet.Unit.hourSingular.localizedString
                
                let actualUnit = String.localizedStringWithFormat(baseUnit, "\(remainingHours)")
                return String.localizedStringWithFormat(baseInfo, actualUnit)
                
            case .minutes(let remainingMinutes):
                let baseUnit = remainingMinutes > 1 ? AmityLocalizedStringSet.Unit.minutePlural.localizedString: AmityLocalizedStringSet.Unit.minuteSingular.localizedString
                
                let actualUnit = String.localizedStringWithFormat(baseUnit, "\(remainingMinutes)")
                return String.localizedStringWithFormat(baseInfo, actualUnit)
            }
        }
    }
}
