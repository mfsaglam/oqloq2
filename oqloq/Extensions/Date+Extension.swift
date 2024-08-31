//
//  Date+Extension.swift
//  oqloq
//
//  Created by Fatih Sağlam on 31.08.2024.
//

import Foundation

extension Date {
    static var thirteenOClock: Date {
        return Calendar.current.date(bySettingHour: 13, minute: 0, second: 0, of: Date())!
    }
    
    static var twentyOneOClock: Date {
        return Calendar.current.date(bySettingHour: 21, minute: 0, second: 0, of: Date())!
    }
    
    func formattedTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: self)
    }
}
