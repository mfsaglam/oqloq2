//
//  Date+Extension.swift
//  oqloq
//
//  Created by Fatih Sağlam on 31.08.2024.
//

import Foundation

extension Date {
    func formattedTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: self)
    }
}
